component persistent="true" table="instance" discriminatorValue="balancer" extends="instance" {
	property name="id" fieldtype="id" generator="native";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="balancer_id" singularname="instance";

	/*
	Override builtin ORM functions while maintaingin their 
	original functionality
	 */
	this.ORMAddInstance = this.addInstance;
	this.addInstance = this._addInstance;

	public void function _addInstance(required Instance instance){

		ORMAddInstance(arguments.instance);

	}
}