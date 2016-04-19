component persistent="true" table="app" discriminatorColumn="app_type" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="domainName";
	property name="provider";
	property name="deploy" fieldtype="many-to-one" cfc="deploy" fkcolumn="deploy_id" inverse="true";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="app_instance_id" singularname="instance";
	property name="balancer" fieldtype="one-to-one" cfc="balancer" fkcolumn="app_balancer_id";	
	property name="versions" fieldtype="one-to-many" cfc="version" fkcolumn="app_id" singularname="version";	
	property name="currentVersion" fieldtype="one-to-one" cfc="version" fkcolumn="current_version_id";
	property name="migrations" fieldtype="one-to-many" cfc="migration" fkcolumn="app_id" singularname="migration";

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
			} else if(versionFrom.diff(versionTo).isMajor()){
				populateMajorMigration(migration);
			} else if(versionFrom.diff(versionTo).isMinor()){
				populateMinorMigration(migration);
			} else if(versionFrom.diff(versionTo).isPatch()){
				populatePatchMigration(migration);
			}

			return new throwable(value=migration);
		}
	}

	public function createBalancer(){
		var balancer = entityNew("balancer");
		entitySave(balancer);
		this.setBalancer(balancer);
		return balancer;
	}

	public function createInstance(version=this.getCurrentVersion()){

		var version = arguments.version;
		var provider = this.getProvider();
		var providerMessage = provider.createInstance();
		
		if(providerMessage.isSuccess()){			
			var instance = entityNew("instance", {version:version});
			instance.setApp(this);
			entitySave(instance);

			var data = providerMessage.getData();			
			instance.setName(data.name);
			instance.setHost(data.host);
			instance.setVcpus(data.vcpus);
			instance.setMemory(data.memory);
			instance.setDisk(data.disk);
		}

		return instance;
	}

	public function appIsAtZero(){
		var version = this.getCurrentVersion();
		var semver = version.getSemver();
		return semver.isZero();
	}

	public function getProvider(){
		return createObject("deploy.providers.#variables.provider#.provider").init();
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

		var step3 = entityNew("newvmStep", {migration:migration});
		entitySave(step3);
		migration.addMigrationStep(step3);

		var step4 = entityNew("swapvmStep", {migration:migration});
		entitySave(step4);
		migration.addMigrationStep(step4);

		var step5 = entityNew("unmaintenanceStep", {migration:migration});
		entitySave(step5);
		migration.addMigrationStep(step5);
	}

	public function populateMinorMigration(required migration Migration){

	}

	public function populatePatchMigration(required migration Migration){

	}
}