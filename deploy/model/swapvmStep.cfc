component persistent="true" extends="migrationStep" discriminatorValue="swapvm" {

	property name="newvmStep" fieldtype="one-to-one" cfc="newvmStep" fkcolumn="newvm_step_id";

	public function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		var Balancer = App.getBalancer();
		// var balancerInstances = Balancer.getInstances();
		// var migrationInstances = Migration.getInstances();

		// outer: for(var balancerInstance in balancerInstances){

		// 	for(var migrationInstance in migrationInstances){
		// 		if(migrationInstance.getId() == balancerInstance.getId()){
		// 			continue outer;
		// 		} else {
		// 			var InstanceToSwapFrom = balancerInstance;
		// 			var InstanceToSwapTo = migrationInstance;
		// 			break outer;
		// 		}
		// 	}
		// }

		balancer.addInstance(this.getNewvmStep().getNewInstance());
		balancer.removeInstance(this.getNewvmStep().getOriginalInstance());
		Migration.addRemovedInstance(this.getNewvmStep().getOriginalInstance());
		return true;
	}

}