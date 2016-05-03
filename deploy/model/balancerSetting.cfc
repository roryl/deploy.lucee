component persistent="true" table="balancer_setting" {
	property name="id" fieldtype="id" generator="native";
	property name="key";
	property name="value";
	property name="balancer" fieldtype="many-to-one" cfc="balancer" fkcolumn="balancer_id" inverse="true";
}