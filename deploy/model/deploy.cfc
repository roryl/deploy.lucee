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

	public Optional function getImageById(required numeric id){
		var Image = entityLoad("image",{id:id}, true);
		if(isNull(image)){
			return new Optional();
		} else {
			if(image.getApp().getDeploy() === this){
				return new Optional(Image);
			} else {
				return new Optional();
			}
		}		
	}

	public Optional function getBalancerById(required numeric id){
		var Balancer = entityLoad("balancer",{id:id}, true);
		if(isNull(balancer)){
			return new Optional();
		} else {
			if(balancer.getApp().getDeploy() === this){
				return new Optional(Balancer);
			} else {
				return new Optional();
			}
		}		
	}

	public Optional function getInstanceById(required numeric id){
		var Instance = entityLoad("instance", {id:id}, true);
		if(isNull(Instance)){
			return new Optional();
		} else {
			if(Instance.getApp().getDeploy() === this){
				return new Optional(Instance);
			} else {
				return new Optional();
			}
		}
	}

	public Throwable function deleteInstance(required instance Instance){

		var Instance = arguments.instance;
		if(Instance.hasBalancer()){
			return new throwable("Cannot delete an instance which is actively being balanced. You must remove it from the load balancer first");
		} else {
			entityDelete(Instance);
			return new throwable(value=true);
		}
	}

	public Optional function getProviderImplementedByName(required string name){

		var name = arguments.name;
		var file = "/deploy/providers/#name#/provider.cfc";
		if(fileExists(file)){
			return new optional(createObject("deploy.providers.#name#.provider").init());
		} else {
			return new optional();
		}
	}

}