component persistent="true" table="version"{
	property name="id" fieldtype="id" generator="native";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="migrationFrom" fieldtype="one-to-one" cfc="migration" mappedby="versionFrom";
}