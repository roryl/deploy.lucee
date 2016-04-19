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

	this.ORMRemoveInstance = this.removeInstance;
	this.removeInstance = this._removeInstance;

	public void function _addInstance(required Instance instance){
		ORMAddInstance(arguments.instance);
	}

	public void function _removeInstance(required Instance instance){
		ORMARemoveInstance(arguments.instance);
	}

	public function getOneRunningInstanceNotInMigration(required migration Migration){
		var Migration = arguments.migration;
		var instances = this.getInstances();
		var instances.removeAll(Migration.getInstances());
		return instances[1];
	}

	public function enableMaintenance(){
		variables.status = "mainteance";
	}

	public boolean function isInMaintenance(){
		return variables.status IS "maintenance";
	}

	public function disableMaintenance(){
		variables.status = "active";
	}

	public function start(){
		variables.status = "active";
	}

	public boolean function isActive(){
		return variables.status IS "active";
	}

	public function stop(){
		variables.status = "stopped";
	}

	public boolean function isStopped(){
		return variables.status IS "stopped";
	}

}