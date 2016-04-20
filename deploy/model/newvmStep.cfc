component persistent="true" extends="migrationStep" discriminatorValue="newvm" {

	property name="instance" fieldtype="one-to-one" cfc="instance" fkcolumn="instance_id";
	
	public boolean function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		var provider = App.getProvider();
		var Version = Migration.getVersionTo();

		var Instance = App.createInstance(Version);
		this.setInstance(instance);
		Migration.addInstance(instance);
		instance.setMigration(Migration);
		var smokeResult = instance.smokeTest();
		if(smokeResult){
			return true;
		} else {
			return false;
		}		
	}
}