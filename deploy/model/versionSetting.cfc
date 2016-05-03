component persistent="true" table="version_setting" {
	property name="id" fieldtype="id" generator="native";
	property name="key";
	property name="value";
	property name="default";		
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="version" fieldtype="many-to-one" cfc="version" fkcolumn="version_id" inverse="true";
}