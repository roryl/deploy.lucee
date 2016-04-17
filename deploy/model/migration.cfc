component persistent="true" table="migration" {
	property name="id" fieldtype="id" generator="native";
	property name="versionFrom" fieldtype="one-to-one" cfc="version" fkcolun="version_from_id";
	property name="versionTo" fieldtype="one-to-one" cfc="version" fkcolun="version_to_id";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
}