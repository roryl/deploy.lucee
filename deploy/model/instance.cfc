component persistent="true" table="instance" discriminatorColumn="instance_type" {
	property name="id" fieldtype="id" generator="native";
	property name="instanceId";
	property name="name";
	property name="host";
	property name="memory";
	property name="vcpus";
	property name="disk";
	property name="status" default="stopped";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="balancer" fieldtype="many-to-one" cfc="balancer" fkcolumn="balancer_id" inverse="true";	
	property name="version" fieldtype="many-to-one" cfc="version" fkcolumn="version_id" inverse="true";
	property name="migration" fieldtype="many-to-one" cfc="migration" fkcolumn="migration_id" inverse="true";
	property name="image" fieldtype="many-to-one" cfc="image" fkcolumn="instance_image_id" inverse="true";
	property name="imageTest" fieldtype="many-to-one" cfc="image" fkcolumn="instance_test_image_id" inverse="true";

	public function smokeTest(){
		return true;
	}

}