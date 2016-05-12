component persistent="true" {
	property name="id" fieldtype="id" generator="native";
	property name="key";
	property name="value";
	property name="salt";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
}