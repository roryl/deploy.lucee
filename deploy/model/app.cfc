component persistent="true" table="app" discriminatorColumn="app_type" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="domainName";
	property name="deploy" fieldtype="many-to-one" cfc="deploy" fkcolumn="deploy_id" inverse="true";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="app_instance_id" singularname="instance";
	property name="balancer" fieldtype="one-to-one" cfc="balancer" fkcolumn="app_balancer_id";
	property name="versions" fieldtype="one-to-many" cfc="version" fkcolumn="app_id" singularname="version";
	property name="currentVersion" fieldtype="one-to-one" cfc="version" fkcolumn="current_version_id";
 
	public Migration function createMigration(required Version VersionTo){

	}
}