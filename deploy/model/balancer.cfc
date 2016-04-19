component persistent="true" table="instance" discriminatorValue="balancer" extends="instance" {
	property name="id" fieldtype="id" generator="native";
	property name="status" default="stopped"; 
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

	public function enableMaintenance(){
		variables.status = "mainteance";
	}

	public boolean function isInMaintenance(){
		return variables.status IS "maintenance";
	}

	public function disableMainteance(){
		variables.status = "active";
	}

	public function start(){
		variables.status = "active";
	}

	public boolean function isActive(){
		return variables.status IS "started";
	}

	public function stop(){
		variables.status = "stopped";
	}

	public boolean function isStopped(){
		return variables.status IS "stopped";
	}

}