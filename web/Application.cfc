component extends="zero" {	
	
	/*
	Zero only have a couple of configurable options. listed below. The rest of the confirugation
	is via overrides of FW/1 in the zero.cfc. You can specify any FW/1 settings you deem necessary.	
	 */	
	variables.zero = {
		/*
		Whether controllers should allow null responses. In Zero, it expects controllers
		to return the response that is passed onto the view.
		 */
		throwOnNullControllerResult = true,

		/*
		Whether the arguments on the controller are checked and only those specific keys
		passed to it. In Zero, the entire RC scope is not passed around. Only the specific keys 
		that the controller is looking for is passed to it. This allows the internals
		of the controller to more easily work with what it expects, instead of a huge
		struct of data which changing elements may have side effects.
		 */
		argumentCheckedControllers = true
	}

	/*
	For your reference, thesea are the fw/1 settings which are overrideen by Zero.

	variables.framework = {
		reloadApplicationOnEveryRequest = true, //These setting causes endless strife for new users, because it caches controller data when they do not expect it. 
		defaultItem = "list" //Reset the default method from 'default' to 'list', to support our resource routes. List is more common for what the default method does
	} 
	
	//Change the names of the controller routes to match CRUD. After all, these map to CRUD actions,
	//I find changing the names is confusing to new users
	variables.framework.resourceRouteTemplates = [
	  { method = 'list', httpMethods = [ '$GET' ] },
	  { method = 'new', httpMethods = [ '$GET', '$POST' ], routeSuffix = '/new' },
	  { method = 'create', httpMethods = [ '$POST' ] },
	  { method = 'read', httpMethods = [ '$GET' ], includeId = true },
	  { method = 'update', httpMethods = [ '$PUT','$PATCH', '$POST' ], includeId = true },
	  { method = 'delete', httpMethods = [ '$DELETE' ], includeId = true }
	];
	 */

	this.customTagPaths = expandPath("vendor/handlebars.lucee");
	currentDirectory = getDirectoryFromPath(getCurrentTemplatePath());	
	this.mappings["/deploy"] = expandPath(currentDirectory & '../deploy');
	this.mappings["/web"] = expandPath(currentDirectory & '../web');

	this.datasources["deploy_app"] = {
		  class: 'org.gjt.mm.mysql.Driver'
		, connectionString: 'jdbc:mysql://192.168.33.10:3306/deploy_app?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=false&allowMultiQueries=true'
		, username: 'deploy'
		, password: "123456"
	};

	this.datasource = "deploy_app";
	this.ormsettings={cfclocation=["/deploy/model"],useDBforMapping=false,dbcreate="update"};
	this.ormsettings.savemapping = false;
	this.ormsettings.logsql="true";
	this.ormsettings.flushAtRequestEnd = false;
	this.ormsettings.autoManageSession=false;
	this.ormenabled = true;
	this.ormsettings.dialect = "MySQLwithInnoDB";

	this.sessionManagement = true;
	this.sessionStorage = "cookie";

	this.clientManagement = true;
	this.clientStorage = "cookie";

	// variables.framework.routes = [
	// 	{ "$RESOURCES" = { resources = "apps"} },
	// ]

	variables.framework.routes.prepend({ "$RESOURCES" = { resources = "images", nested="version_settings"} });
	variables.framework.routes.prepend({ "$RESOURCES" = { resources = "apps", nested="instances"} });
	variables.framework.routes.append({'$POST/images/:id/deploy*' = '/images/deploy/id/:id' });
	variables.framework.routes.append({'$GET/images/:id/deploy*' = '/images/deploy/id/:id' });	
	variables.framework.routes.append({'$POST/balancers/:id/deploy*' = '/balancers/deploy/id/:id' });	

	/**
	 * Used to manipulate request variables before they are passed to controllers.
	 * @param  {struct} rc All of the URL and FORM variable put into one structure. RC is a reference to request.context
	 * @return {Struct}    The result of the RC is then passed onto the controller for this call
	 */
	public struct function request( rc ){	
		if(structKeyExists(url,"ormreload")){
			ORMReload();
		}
		getDeploy();

		// app = getDeploy().getAppById(1).get();
		// versions = app.getVersions();
		// writeDump(versions);
		// abort;
		return rc;
	}

	public function getDeploy(){

		variables.deploy = entityLoad("deploy", {name:"deploy"}, true);
		if(isNull(variables.deploy)){
			transaction {
				variables.deploy = entityNew("deploy", {name:"deploy"});
				entitySave(variables.deploy);
				transaction action="commit";
			}
		}
		return variables.deploy;
	}

	/**
	 * Called after controller execution and before the view. Here you 
	 * can make any additional changes if necessary to inject more values
	 * for the view.
	 * 
	 * @rc  {struct} rc the request of the request context and 
	 * @result  {any} the result of the call to the controller
	 * @return {any}    The modified result to be used by the view
	 */
	public any function result( result ){				
		return result;
	}

	/**
	 * Receives the final respons that is going to be returned to the client. This is the HTML
	 * or text encoded JSON that will be returned. This function can be used to 
	 * manipulate optionally manipulate the final text response
	 *
	 * 
	 * @param  {string} string response  the final output to be returned.
	 * @return {string} Must return a string for the response to complete;
	 */
	public string function response( string response){		
		return response;		
	}

	function onError(){
		writeDump(arguments);

	}

}
