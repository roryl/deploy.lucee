component persistent="true" extends="migrationStep" discriminatorValue="newvm" {

	property name="originalInstance" fieldtype="one-to-one" cfc="instance" fkcolumn="original_instance_id";
	property name="newInstance" fieldtype="one-to-one" cfc="instance" fkcolumn="new_instance_id";
	
	public boolean function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		var provider = App.getProvider();
		var Version = Migration.getVersionTo();

		var Instance = App.createInstance(Version);
		this.setNewInstance(instance);
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