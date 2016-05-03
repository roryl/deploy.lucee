component persistent="true" extends="deploy.model.instance" table="instance" discriminatorValue="balancer" {

	property name="isPrimary" type="boolean" default="false";

	public function isPrimary(){
		return variables.isPrimary;
	}

}