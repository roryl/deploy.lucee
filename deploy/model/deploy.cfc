component persistent="true" table="deploy" discriminatorColumn="deploy_type" {

	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="apps" fieldtype="one-to-many" cfc="app" fkcolumn="deploy_id" singularname="app";

}