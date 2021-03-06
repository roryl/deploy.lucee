/**
* My xUnit Test
*/
import deploy.model.semver;
component extends=""{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all test cases
	function beforeTests(){
		// if(structKeyExists(url,"h2")){			
		// 	query name="drop"{
		// 		echo("DROP ALL OBJECTS;");
		// 	}			
		// } else {
		// 	query name="drop"{ 
		// 		echo("use deploy; ");
		// 		echo("drop database deploy; ");
		// 		echo("create database deploy; ");
		// 		echo("use deploy; ");
		// 	}		
		// }

		// ORMReload();				
	}

	// executes after all test cases
	function afterTests(){
		// ORMGetSession().close();
	}

	// executes before every test case
	function setup( currentMethod ){
		
		// ORMGetSession().close();
	}

	// executes after every test case
	function teardown( currentMethod ){
		//Close the ORM session on each test so that a new session is created on the next test
		// ORMGetSession().close();
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	/****** UTILITY METHODS *********************************/
	function createDeploy(){
		var deploy = entityNew("deploy", {name:"Letsflycheaper"});
		entitySave(deploy);
		return deploy;
	}

	function createApp(){
		var app = entityNew("app", {name:"Letsflycheaper", domainName:"www.letsflycheaper.com", provider:"sample"});
		entitySave(app);
		return app;
	}

	function createInstance(){
		var entity = entityNew("instance", {instanceId:"123456", host:"1.2.3.4"});
		entitySave(entity);
		return entity;
	}

	function createBalancer(){
		var entity = entityNew("balancer");
		entitySave(entity);
		return entity;
	}

	function createVersion(){
		var entity = entityNew("version", {semver:new semver("0.0.0")});
		entitySave(entity);
		return entity;
	}

	function createMigration(){
		var entity = entityNew("migration");
		entitySave(entity);
		return entity;
	}

	function createMigrationStep(){
		var entity = entityNew("migrationStep");
		entitySave(entity);
		return entity;
	}

	function createMaintenanceStep(){
		var entity = entityNew("maintenanceStep");
		entitySave(entity);
		return entity;
	}

	function createmodelMigrationStep(){
		var entity = entityNew("modelMigrationStep");
		entitySave(entity);
		return entity;
	}

	function createnewVMStep(){
		var entity = entityNew("newVMStep");
		entitySave(entity);
		return entity;
	}

	function createImage(){
		var entity = entityNew("image");
		entitySave(entity);
		return entity;
	}

	function createImageSetting(){
		var entity = entityNew("imageSetting");
		entitySave(entity);		
		return entity;
	}

	function createBalancerSetting(){
		var entity = entityNew("balancerSetting");
		entitySave(entity);		
		return entity;
	}

	function createVersionSetting(){
		var entity = entityNew("versionSetting");
		entitySave(entity);		
		return entity;
	}

	/****** TEST FIXURES **************************************/

	function createDeployWithApp(){
		var deploy = createDeploy();
		entitySave(deploy);
		var app = deploy.createApp("testName", "domain.com", "sample");
		// deploy.addApp(app);
		// app.setDeploy(deploy);
		ORMFlush();
		// test = deploy.getAppById(app.getId());
		// writeDump(test.exists());
		// abort;
		return deploy;
	}

	function createDeployWithAppWithImage(){
		var deploy = createDeployWithApp();
		var app = deploy.getApps()[1];
		app.createImage("my image", {});
		ORMFlush();
		return deploy;
	}

	function createDeployWithAppAndImageAndBalancer(){
		var deploy = createDeployWithAppWithImage();
		var app = deploy.getApps()[1];
		var balancer = app.createBalancer({});		
		ORMFlush();
		return deploy;
	}

	function createDeployWithAppAndImageAndBalancerAndInstancesNotBalanced(){
		var deploy = createDeployWithAppAndImageAndBalancer();
		var app = deploy.getApps()[1];
		app.createInstance();
		app.createInstance();
		ORMFlush();
		return deploy;
	}


	/***** SINGLE ENTYT TESTS ********************************/

	function genericEntity(entityName){

		if(!structKeyExists(variables,"create#entityName#")){
			throw("You must create a function to generate this sample entity of the name create#entityName#");
		}

		transaction {
			var entity = evaluate('create#entityName#()');
			entitySave(entity);
			// ORMFlush();
			// expect(arrayLen(entityLoad("#entityName#"))).toBe(1);
			transaction action="rollback";
		}
	}

	// function createDeployTest(){		
	// 	genericEntity("deploy");
	// }

	function createAppTest(){		
		genericEntity("app");
	}

	function createInstanceTest(){
		genericEntity("instance");
	}

	function createBalancerTest(){
		genericEntity("balancer");
	}

	function createVersionTest(){
		genericEntity("version");
	}

	function createMigrationTest(){
		genericEntity("migration");
	}

	function createMigrationStepTest(){
		genericEntity("migrationStep");
	}

	function createMaintenanceStepTest(){
		genericEntity("maintenanceStep");
	}

	function createModelMigrationStepTest(){
		genericEntity("ModelMigrationStep");
	}

	function createnewVMStepTest(){
		genericEntity("newVMStep");
	}

	function createImageTest(){
		genericEntity("image");
	}

	function createImageSettingTest(){
		genericEntity("imageSetting");
	}

	function createBalancerSettingTest(){
		genericEntity("balancerSetting");
	}

	function createVersionSettingTest(){		
		genericEntity("versionsetting");		
	}
	
	/***** RELATIONSHIP TESTS *******************************/

	/**
	 * Takes any one-to-many relationship and checks the relation from both ends (thus)
	 * this works for many-to-one tests too
	 * @param  {Component} one  The one side of the relation
	 * @param  {Component} many The many side of the relation
	 * @return {void}      
	 */
	void function genericOneToMany(required one, required many, required plural="s"){

		transaction {
			"#one#" = evaluate("create#one#()");
			entitySave(getVariable(one));
			"#many#" = evaluate("create#many#()");
			evaluate("#one#.add#many#(getVariable('#many#'))");
			evaluate("#many#.set#one#(getVariable('#one#'))");
			entitySave(getVariable(many));
			// ORMFlush();

			left = getVariable(one);
			// entityReload(left);
			right = evaluate("left.get#many##plural#()");
			// entityReload(right);
			expect(right).toHaveLength(1);
			evaluate("expect(right[1].get#one#()).toBe(getVariable(one))");
			transaction action="rollback";			
		}
	}

	/**
	 * Takes any one-to-one relationship and tries to set the relation from both ends
	 * @param  {Component} required left          The entity on one end of the relation
	 * @param  {Compoennt} required right         The entiyt on the other end of the relation
	 * @return {void}
	 */
	void function genericOneToOne(required left, required right){
		savecontent variable="code"{
			echo("			
			transaction {
				#left# = create#left#();
				#right# = create#right#();
				#left#.set#right#(#right#);
				#right#.set#left#(#left#);
				expect(#left#.get#right#()).toBe(#right#);
				expect(#right#.get#left#()).toBe(#left#);			
				transaction action='rollback';
			}
			");			
		}
		fileWrite("executecode.cfm", "<cfscript>#code#</cfscript>");
		include template="executecode.cfm";
	}	

	function deployAppRelationTest(){
		genericOneToMany("deploy", "app");		
	}

	function appInstanceRelationTest(){
		genericOneToMany("app", "instance");		
	}

	function appBalancerRelationTest(){
		genericOneToOne("app", "balancer");
	}

	function balancerInstanceRelationTest(){
		genericOneToMany("balancer", "instance");
	}

	function appVersionRelationTest(){
		genericOneToMany("app", "version");
	}

	function appMigrationRelationTest(){
		genericOneToMany("app", "migration");
	}

	function migrationInstanceRelationTest(){
		genericOneToMany("migration", "instance");
	}

	function instanceVersionRelationTest(){
		genericOneToMany("version", "instance");
	}

	function migrationMigrationStepRelationTest(){
		genericOneToMany("migration", "migrationStep");
	}

	function appImageRelationTest(){
		genericOneToMany("app", "image");
	}

	function imageImageSettingRelationTest(){
		genericOneToMany("image", "imageSetting");
	}	

	function versionVersionSettingRelationTest(){
		genericOneToMany("version", "versionSetting");
	}
	
}
