component persistent="true" table="image" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="imageSettings" fieldtype="one-to-many" cfc="imageSetting" fkcolumn="image_id" singularname="imageSetting";

	public struct function getSettingsAsStruct(){
		var ImageSettings = this.getImageSettings();
		var out = {}
		for(var setting in ImageSettings){
			out[setting.getKey()] = setting.getValue();
		}
		return out;
	}
}