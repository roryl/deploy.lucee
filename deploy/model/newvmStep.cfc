component persistent="true" extends="migrationStep" discriminatorValue="newvm" {

	property name="originalInstance" fieldtype="one-to-one" cfc="instance" fkcolumn="original_instance_id";
	property name="newInstance" fieldtype="one-to-one" cfc="instance" fkcolumn="new_instance_id";
	
	public boolean function run(){

		var Migration = this.getMigration();
		var App = Migration.getApp();
		var provider = App.getProviderImplemented();
		var Version = Migration.getVersionTo();

		var InstanceThrowable = App.createInstance(Version);
		if(InstanceThrowable.threw()){
			InstanceThrowable.rethrow();
		} else {
			var Instance = InstanceThrowable.get();	
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
}