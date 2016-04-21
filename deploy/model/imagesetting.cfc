component persistent="true" table="image_setting" {
	property name="id" fieldtype="id" generator="native";
	property name="key";
	property name="value";
	property name="image" fieldtype="many-to-one" cfc="image" fkcolumn="image_id" inverse="true";

}