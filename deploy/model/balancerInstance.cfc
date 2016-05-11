component persistent="true" extends="deploy.model.instance" table="instance" discriminatorValue="balancer" {

	property name="isPrimary" type="boolean" default="false";
	property name="balancerInstance" fieldtype="many-to-one" cfc="balancer" fkcolumn="balancer_instance_id" inverse="true";

	public function isPrimary(){
		return variables.isPrimary;
	}

}