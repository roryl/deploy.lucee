component persistent="true" extends="migrationStep" discriminatorValue="model_migration" {

	public function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		//Execute Model Update
		var instances = App.getInstances();
		var instanceCount = arrayLen(instances);
		var randId = randRange(1, instanceCount);
		var smokeSucceeds = instances[randId].smokeTest();
		if(smokeSucceeds){
			return true;
		} else {
			//Perform rollback
			return false;
		}

	}

}