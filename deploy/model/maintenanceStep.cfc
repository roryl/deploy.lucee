component persistent="true" extends="migrationStep" discriminatorValue="maintenance" {

	public boolean function run(){		
		var balancer = this.getMigration().getApp().getBalancer();
		balancer.enableMaintenance();
		return true;
	}

}