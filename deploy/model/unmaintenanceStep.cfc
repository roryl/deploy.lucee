component persistent="true" extends="migrationStep" discriminatorValue="maintenance" {

	public boolean function run(){		
		var balancer = this.getMigration().getApp().getBalancer();
		balancer.disableMaintenance();
		return true;
	}

}