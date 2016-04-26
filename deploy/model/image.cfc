component persistent="true" table="image" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name='baseScript' type='string' sqltype='text';
	property name='versionScript' type='string' sqltype='text';	
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="imageSettings" fieldtype="one-to-many" cfc="imageSetting" fkcolumn="image_id" singularname="imageSetting";
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

	public boolean function hasBaseScript(){
		if(trim(this.getBaseScript()).len() GT 0){
			return true;
		} else {
			return false;
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