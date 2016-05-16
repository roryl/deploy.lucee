component persistent="true" table="app" discriminatorColumn="app_type" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="domainName";
	property name="provider";
	property name="status" persistent="false";
	property name="deploy" fieldtype="many-to-one" cfc="deploy" fkcolumn="deploy_id" inverse="true";	
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="app_instance_id" singularname="instance";
	property name="inactiveInstances" persistent="false" setter="false";
	property name="balancer" fieldtype="one-to-one" cfc="balancer" fkcolumn="app_balancer_id";	
	property name="versions" fieldtype="one-to-many" cfc="version" fkcolumn="app_version_id" singularname="version";	
	property name="currentVersion" fieldtype="one-to-one" cfc="version" fkcolumn="current_version_id";
	property name="migrations" fieldtype="one-to-many" cfc="migration" fkcolumn="app_id" singularname="migration";
	property name="images" fieldtype="one-to-many" cfc="image" fkcolumn="app_id" singularname="image";
	property name="defaultImage" fieldtype="one-to-one" cfc="image" fkcolumn="default_image_id";
	property name="secureKeys" fieldtype="one-to-many" cfc="secureKey" fkcolumn="app_id" singularname="secureKey";

 	/**
 	 * Creates a migration plan from the current version to the future version selected
 	 * @param  {VersionTo} required Version       VersionTo The version that you want to migrate the app to
 	 * @return {Throwable}          [description]
 	 */
	public Throwable function createMigration(required Version VersionTo){
		var versionTo = arguments.versionTo;
		var versions = this.getVersions();

		if(isNull(versions) OR arrayLen(versions) LT 2){
			return new throwable("No versions to migrate to. Please add a version");
		} else {

			if(!this.hasVersion(versionTo)){
				return new throwable("This app does not have this version. Add the version before migrating to it");
			}

			var migration = entityNew("migration");
			entitySave(migration);

			var versionFrom = this.getCurrentVersion();
			migration.setVersionFrom(versionFrom);			
			migration.setVersionTo(versionTo);
			migration.setApp(this);
			this.addMigration(migration);

			if(AppIsAtZero()){
				populateMajorMigration(migration);
			} else if(versionFrom.getSemver().diff(versionTo.getSemver()).isMajor()){
				populateMajorMigration(migration);
			} else if(versionFrom.getSemver().diff(versionTo.getSemver()).isMinor()){
				populateMinorMigration(migration);
			} else if(versionFrom.getSemver().diff(versionTo.getSemver()).isPatch()){
				populatePatchMigration(migration);
			}

			return new throwable(value=migration);
		}
	}

	public Balancer function createBalancer(required struct settings){
		var balancer = entityNew("balancer");
		var settings = arguments.settings;
		entitySave(balancer);
		this.setBalancer(balancer);
		balancer.setApp(this);
		balancer.putAllSettingsKeyValues(arguments.settings);
		return balancer;
	}

	public function getStatus(){
		if(appIsAtZero()){
			return "unprovisioned";
		}
	}

	public array function getInactiveInstances(){		

		var AllInstances = this.getInstances();

		var out = [];
		if(isNull(AllInstances)){
			return out;
		}

		if(isNull(this.getBalancer())){
			return AllInstances;
		}

		var BalancedInstances = this.getBalancer().getInstances();

		for(var instance in allInstances){
			if(this.getBalancer().hasBalancerInstance(instance) OR this.getBalancer().hasInstance(instance) OR instance.hasImageTest()){
				continue;
			} else {
				out.append(instance);
			}
		}

		// var AllInstances.removeAll(BalancedInstances);
		return out;
	}

	public function getLatestVersion(){
		var version = ORMExecuteQuery("select v from version v join v.app a where a.id = #this.getId()# order by v.id desc limit 1", true);
		return version;
	}

	public Throwable function createInstance(version=this.getCurrentVersion(), image=this.getDefaultImage()){

		var version = arguments.version;
		var provider = this.getProviderImplemented();
		var Image = arguments.image;

		if(isNull(Image)){
			return new throwable("This app did not have a default image set or an image was not passed in, cannot create an instance without an image");
		}

		var name = "#this.getName()#-#Image.getName()#-#createUUID()#";
		var name = replaceNoCase(name, " ", "-", "all");

		var baseScript = Image.getBaseScript() ?: "";
		var versionSettings = Image.getVersionSettings() ?: [];
		
		for(var setting IN versionSettings){
			baseScript = replaceNoCase(baseScript, "{{#setting.getkey()#}}", setting.getValue(), "all");
		}

		var providerMessage = provider.createInstance(name, Image.getSettingsAsStruct(), baseScript);

		if(providerMessage.isSuccess()){			
			var instance = entityNew("instance", {version:version});
			this.addInstance(instance);
			instance.setApp(this);
			entitySave(instance);
			instance.setVersion(version);
			version.addInstance(instance);

			var data = providerMessage.getData();
			instance.setInstanceId(data.instanceId);		
			instance.setName(data.name);
			instance.setHost(data.host);
			instance.setVcpus(data.vcpus);
			instance.setMemory(data.memory);
			instance.setDisk(data.disk);
			instance.setStatus(data.status);
			return new throwable(value=instance);
		} else {
			throw("Not yet implemented. Need to handle provider messages");
		}
	}	

	public function createImage(required string name, required struct settings){

		var settings = arguments.settings;
		var Provider = this.getProviderImplemented();
		var settingsValid = Provider.validateSettings(settings);
		if(settingsValid){
			// writeDump(settings);

			var image = entityNew("image", {name:name});
			entitySave(image);
			for(var setting in settings){
				var key = setting;
				var value = settings[key];
				var imageSetting = entityNew("imageSetting", {key:key, value:value});
				entitySave(imageSetting);
				image.addImageSetting(imageSetting);
				imageSetting.setImage(image);
			}

		}

		this.addImage(image);
		image.setApp(this);

		if(isNull(this.getDefaultImage())){
			this.setDefaultImage(image);
		}

		return image;
	}

	public Throwable function createVersion(required semver semver, required struct versionSettings){

		var LatestSemver = this.getLatestVersion().getSemver();

		if(LatestSemver.equals(semver)){
			return new throwable("Could not add the version because it was identical with the latest version which was #LatestSemver.toString()#");
		}

		if(LatestSemver.isAfter(semver)){
			return new throwable("Could not add the version because the latest version is after this one, the latest version was #LatestSemver.toString()#");
		}

		var Version = entityNew("version", {semver:semver});
		entitySave(Version);
		this.addVersion(Version);
		Version.setApp(this);		
		for(setting in versionSettings){
			var VersionSetting = entityNew("versionSetting", {key:setting, value:versionSettings[setting]});
			entitySave(VersionSetting);
			Version.addVersionSetting(VersionSetting);
			VersionSetting.setVersion(Version);
		}
		return new throwable(value=Version);
	}

	private string function getSecretKey(){
		if(!fileExists("encrypt.key")){
			var key = generateSecretKey("AES");
			fileWrite("encrypt.key", key);
		} 
		return fileRead("encrypt.key");
	}

	private function encryptSecureKey(required string value, required string salt){

		var key = getSecretKey();
		var encrypted = encrypt(string=value, key=key, algorithm="AES", IVorSalt=salt);
		return encrypted;
	}

	private function decryptSecureKey(required string value, required string salt){
		var key = getSecretKey();
		var decrypted = decrypt(encrypted_string=value, key=key, algorithm="AES", IVorSalt=salt);
		return decrypted;
	}

	public struct function getSecureKeysAsStruct(){
		var SecureKeys = this.getSecureKeys();
		var out = {}
		if(!isNull(SecureKeys)){
			for(var setting in SecureKeys){
				var value = getSecureKeyValueByKey(setting.getKey());
				if(value.exists()){
					out[setting.getKey()] = value.get();					
				}
			}			
		}
		return out;
	}

	public boolean function putSecureKeyKeyValue(required string key, required string value){

		var key = arguments.key;
		var value = arguments.value;

		var SecureKey = entityLoad("SecureKey", {app:this, key:key}, true);
		if(isNull(SecureKey)){
			var salt = createUUID();
			var encrypted = encryptSecureKey(value, salt);
			var SecureKey = entityNew("SecureKey", {app:this, key:key, value:encrypted, salt:salt});
			entitySave(SecureKey);
			this.addSecureKey(SecureKey);
			SecureKey.setApp(this);
		}
		return true;
	}

	public Optional function getSecureKeyValueByKey(required string key){
		var key = arguments.key;
		var SecureKey = entityLoad("SecureKey", {app:this, key:key}, true);
		if(isNull(SecureKey)){
			return new Optional();
		} else {
			var value = decryptSecureKey(SecureKey.getValue(), SecureKey.getSalt());			
			return new Optional(value);
		}
	}

	public boolean function putAllSettingsKeyValues(required struct settings){
		var settings = arguments.settings;		
		for(var setting in settings){
			this.putSecureKeyKeyValue(key=setting, value=settings[setting]);
		}
		return true;
	}

	public function appIsAtZero(){
		var version = this.getCurrentVersion();
		var semver = version.getSemver();
		return semver.isZero();
	}

	public Provider function getProviderImplemented(){		
		var secureKeys = getSecureKeysAsStruct();
		var ProviderOptional = this.getDeploy().getProviderImplementedByName(this.getProvider(), secureKeys);
		return ProviderOptional.get();
	}

	public function populateMajorMigration(required migration Migration){

		/**
		 * Put up maintenance page
		 * Perform Model Migration
		 * Spin up VMs and smoke test against model
		 * Remove existing VMs from load balancer
		 * Add new VMs to load balance
		 * Remove maintenance page
		 */
		var migration = arguments.migration;
		var step = entityNew("maintenanceStep", {migration:migration});
		entitySave(step);
		migration.addMigrationStep(step);

		var step2 = entityNew("modelMigrationStep", {migration:migration});
		entitySave(step2);
		migration.addMigrationStep(step2);

		addVMStepsForEachVM(Migration);

		var step5 = entityNew("unmaintenanceStep", {migration:migration});
		entitySave(step5);
		migration.addMigrationStep(step5);
	}

	public function addVMStepsForEachVM(required migration Migration){
		
		var Migration = arguments.migration;
		var currentInstances = this.getBalancer().getInstances();

		if(isNull(currentInstances)){
			throw("error, nothing to migrate");
		}

		for(var instance in currentInstances){
			
			var newvmStep = entityNew("newvmStep", {migration:migration, originalInstance:instance});
			entitySave(newvmStep);
			migration.addMigrationStep(newvmStep);

			var swapvmStep = entityNew("swapvmStep", {migration:migration, newvmstep:newvmStep});
			entitySave(swapvmStep);
			migration.addMigrationStep(swapvmStep);
			// ORMFlush();
		}			
	}

	public function populateMinorMigration(required migration Migration){

		/*
		*   		MINOR
		*   			Perform Model Migration and smoke test a VM   			
		*   			Spin up new VM and run smoke test
		*   			swap VM with one in the load balancer
		*   			
		*/
		var migration = arguments.migration;
		var step2 = entityNew("modelMigrationStep", {migration:migration});
		entitySave(step2);
		migration.addMigrationStep(step2);

		addVMStepsForEachVM(Migration);
	}

	public function populatePatchMigration(required migration Migration){

		/*
			PATCH
	    		Spin up new VM and run smoke test
	    		switch old&new vm
		 */
		addVMStepsForEachVM(Migration);

	}
}