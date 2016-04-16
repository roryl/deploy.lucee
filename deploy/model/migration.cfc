component persistent="true" table="migration" {
	property name="id" fieldtype="id" generator="native";
	property name="versionFrom" fieldtype="one-to-one" cfc="version" fkcolun="version_from_id";

}