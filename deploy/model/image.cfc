component persistent="true" table="image" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name='baseScript' type='string' sqltype='text';
	property name='versionScript' type='string' sqltype='text';	
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="instanceTests" fieldtype="one-to-many" cfc="instance" fkcolumn="instance_test_image_id" singularname="instanceTest";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="instance_image_id" singularname="instance";
	property name="imageSettings" fieldtype="one-to-many" cfc="imageSetting" fkcolumn="image_id" singularname="imageSetting";
	property name="versionSettings" fieldtype="one-to-many" cfc="versionSetting" fkcolumn="image_id" singularname="versionSetting";	
	property name="snapshots" fieldtype="one-to-many" cfc="image" fkcolumn="snapshot_image_id" singularname="snapshot";
	property name="baseImage" fieldtype="many-to-one" cfc="image" fkcolumn="snapshot_image_id" inverse="true";

	public struct function getSettingsAsStruct(){
		var ImageSettings = this.getImageSettings();
		var out = {}
		if(!isNull(ImageSettings)){
			for(var setting in ImageSettings){
				out[setting.getKey()] = setting.getValue();
			}			
		}
		return out;
	}

	public boolean function putImageSettingKeyValue(required string key, required string value){

		var key = arguments.key;
		var value = arguments.value;

		var ImageSetting = entityLoad("imageSetting", {image:this, key:key, value:value}, true);
		if(isNull(ImageSetting)){
			var ImageSetting = entityNew("imageSetting", {image:this, key:key, value:value});
			entitySave(ImageSetting);
			this.addImageSetting(ImageSetting);
			ImageSetting.setImage(this);
		}
		return true;
	}

	public Optional function getImageSettingValueByKey(required string key){
		var key = arguments.key;
		var ImageSetting = entityLoad("ImageSetting", {image:this, key:key}, true);
		if(isNull(ImageSetting)){
			return new Optional();
		} else {
			return new Optional(ImageSetting.getValue());
		}
	}


	public boolean function putAllSettingsKeyValues(required struct settings){
		var settings = arguments.settings;		
		for(var setting in settings){
			this.putImageSettingKeyValue(key=setting, value=settings[setting]);
		}
		return true;
	}

	public versionSetting function putVersionSetting(required string key, required string value, required string default){

		var key = arguments.key;
		var value = arguments.value;
		var default = arguments.default;

		var VersionSetting = entityLoad("versionSetting", {image:this, key:key}, true);
		if(isNull(VersionSetting)){
			var VersionSetting = entityNew("versionSetting");
			entitySave(VersionSetting);
			this.addVersionSetting(VersionSetting);
			VersionSetting.setImage(this);
		}
		versionSetting.setKey(key);
		versionSetting.setValue(value);
		versionSetting.setDefault(default);
		return versionSetting;
	}

	public Optional function getVersionSettingById(required numeric id){
		return new Optional(entityLoad("versionSetting", {image:this, id:id}, true));
	}

	public boolean function hasBaseScript(){
		if(trim(this.getBaseScript()).len() GT 0){
			return true;
		} else {
			return false;
		}
	}

	public Throwable function createInstanceTest(){

		var Image = this;
		var Provider = this.getApp().getProviderImplemented();
		var imageName = this.getName();
		var InstanceThrowable = this.getApp().createInstance(image=this);

		if(InstanceThrowable.threw()){
			return new throwable(InstanceThrowable.getMessage());
		} else {
			TestInstance = InstanceThrowable.get();
		}
		// TestInstance = entityNew("instance");
		// entitySave(TestInstance);

		var testId = TestInstance.getId();
		var finalInstanceName = "#imageName#_#testId#";
		var ProviderMessage = Provider.createInstance(finalInstanceName, Image.getSettingsAsStruct());

		if(providerMessage.isSuccess()){
			this.addInstanceTest(TestInstance);
			TestInstance.setImageTest(this);

			var data = providerMessage.getData();
			TestInstance.setInstanceId(data.instanceId);		
			TestInstance.setName(data.name);
			TestInstance.setHost(data.host);
			TestInstance.setVcpus(data.vcpus);
			TestInstance.setMemory(data.memory);
			TestInstance.setDisk(data.disk);
			TestInstance.setStatus("running");
			return new throwable(value=TestInstance);
		} else {
			throw("Not yet implemented. Need to handle provider messages");
		}
	}

	/*
	Note: Return type cannot be image, because that is a reserved data type (image) in Lucee
	 */
	public function createSnapshot(){

		var Snapshot = entityNew("image");
		entitySave(Snapshot);
		var App = this.getApp();
		var Provider = App.getProviderImplemented();

		var tempName = lcase(createUUID());
		var ProviderMessage = Provider.createInstance(tempName, this.getSettingsAsStruct());

		if(ProviderMessage.isSuccess()){
			
		} else {
			
		}

		// var Provider = this.getApp().getProviderImplemented();
		var Settings = this.getSettingsAsStruct();
		for(var key in settings){
			Snapshot.putImageSettingKeyValue(key, settings[key]);
		}

		Snapshot.setVersionScript(this.getVersionScript());
		Snapshot.setName(this.getName());
		Snapshot.setApp(App);
		App.addImage(Snapshot);
		this.addSnapshot(Snapshot);
		Snapshot.setBaseImage(this);
		return Snapshot;
	}

	public boolean function isSnapshot(){

		var baseImage = this.getBaseImage();
		if(isNull(baseImage)){
			return false;
		} else {
			return true;
		}

	}




}