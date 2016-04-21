/**
* My xUnit Test
*/
import deploy.model.semver;
import web.Application;
import web.controllers*
component extends=""{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all test cases
	function beforeTests(){
				
	}

	// executes after all test cases
	function afterTests(){
	}

	// executes before every test case
	function setup( currentMethod ){
		query name="drop"{ 
			echo("use deploy; ");
			echo("drop database deploy; ");
			echo("create database deploy; ");
			echo("use deploy; ");
		}		
		ORMReload();

	}

	// executes after every test case
	function teardown( currentMethod ){
		//Close the ORM session on each test so that a new session is created on the next test
		ORMGetSession().close();
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function createApp(){
		var app = new ormTest().createDeploy().createApp("sampleapp", "sampleapp.com", "sample");
		entitySave(app)
		app.createBalancer();
		return app;
	}

	function createTest(){
		var app = new web.Application();
		var apps = new web.controllers.apps(app);
		var result = apps.create(name:"testapp",domain_name:"testapp.com",provider:"sample");
		expect(result.success).toBeTrue();
		expect(result.data.name).toBe("testapp");
		expect(result.data.domain_name).toBe("testapp.com");
		expect(result.data.provider).toBe("sample");
		return result;
	}

	function readTest(){

		var result = createTest();
		var app = new web.Application();
		var apps = new web.controllers.apps(app);
		result = apps.read(result.data.id);
	}

	function listTest(){

		var app = new web.Application();
		var apps = new web.controllers.apps(app);
		var result = apps.create(name:"testapp",domain_name:"testapp.com",provider:"sample");
		var result = apps.create(name:"testapp",domain_name:"testapp.com",provider:"sample");
		// abort;
		var result = apps.list();
		// writeDump(result);
		expect(arrayLen(result.data)).toBe(2);

	}

	

	
	
}
