component persistent="true" extends="migrationStep" discriminatorValue="swapvm" {

	public function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		var Balancer = App.getBalancer();
		var balancerInstances = Balancer.getInstances();
		var migrationInstances = Migration.getInstances();

		outer: for(var balancerInstance in balancerInstances){

			for(var migrationInstance in migrationInstances){
				if(migrationInstance.getId() == balancerInstance.getId()){
					continue outer;
				} else {
					var InstanceToSwapFrom = balancerInstance;
					var InstanceToSwapTo = migrationInstance;
					break outer;
				}
			}
		}

		balancer.addInstance(InstanceToSwapTo);
		balancer.removeInstance(InstanceToSwapFrom);
		Migration.addRemovedInstance(InstanceToSwapFrom);
		return true;
	}

}