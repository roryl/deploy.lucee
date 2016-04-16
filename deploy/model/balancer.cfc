component persistent="true" table="instance" discriminatorValue="balancer" extends="instance" {
	property name="id" fieldtype="id" generator="native";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="balancer_id" singularname="instance";
}