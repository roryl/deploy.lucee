component persistent="true" table="deploy" discriminatorColumn="deploy_type" {

	property name="id" fieldtype="id" generator="native";
	property name="name";
	property name="apps" fieldtype="one-to-many" cfc="app" fkcolumn="deploy_id" singularname="app";

	public app function createApp(required string name,
							  required string domainName,
							  required string provider){

		var app = entityNew("app", {
			name:arguments.name,
			domainName:arguments.domainName,
			provider:arguments.provider,			
		});
		entitySave(app);
		this.addApp(app);
		app.setDeploy(this);

		var semver = new semver("0.0.0");
		var initialVersion = entityNew("version", {semver:semver});
		entitySave(initialVersion);
		initialVersion.setApp(app);
		app.addVersion(initialVersion);
		app.setCurrentVersion(initialVersion);		
		return app;		
	}

	public Optional function getAppById(required numeric id){
		return new Optional(entityLoad("app",{id:arguments.id, deploy:this},true));
	}

}