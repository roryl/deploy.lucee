component persistent="true" table="instance" discriminatorColumn="instance_type" {
	property name="id" fieldtype="id" generator="native";
	property name="instanceId";
	property name="host";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="balancer" fieldtype="many-to-one" cfc="balancer" fkcolumn="balancer_id" inverse="true";
	property name="version" fieldtype="many-to-one" cfc="version" fkcolumn="version_id" inverse="true";
}