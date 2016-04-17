component persistent="true" table="app" discriminatorColumn="app_type" {
	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="domainName";
	property name="deploy" fieldtype="many-to-one" cfc="deploy" fkcolumn="deploy_id" inverse="true";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="app_instance_id" singularname="instance";
	property name="balancer" fieldtype="one-to-one" cfc="balancer" fkcolumn="app_balancer_id";
	property name="versions" fieldtype="one-to-many" cfc="version" fkcolumn="app_id" singularname="version";	
	property name="currentVersion" fieldtype="one-to-one" cfc="version" fkcolumn="current_version_id";
	property name="migrations" fieldtype="one-to-many" cfc="migration" fkcolumn="app_id" singularname="migration";
 
 	/**
 	 * Creates a migration plan from the current version to the future version selected
 	 * @param  {VersionTo} required Version       VersionTo The version that you want to migrate the app to
 	 * @return {Throwable}          [description]
 	 */
	public Throwable function createMigration(required Version VersionTo){
		var versionTo = arguments.versionTo;
		var versions = this.getVersions();

		if(isNull(versions) OR arrayLen(versions) LT 2){
			return new throwable("No versions to migrate to. Please add a version");
		} else {
			var migration = entityNew("migration");

			if(!appIsAtFirstVersion()){
				migration.setVersionFrom(this.getCurrentVersion());				
			}
			
			migration.setVersionTo(versionTo);
			migration.setApp(this);
			this.addMigration(migration);
			return new throwable(value=migration);
		}
	}

	public function appIsAtFirstVersion(){
		return isNull(this.getCurrentVersion());
	}
}