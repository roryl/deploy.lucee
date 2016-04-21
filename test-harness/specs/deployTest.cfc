/**
* My xUnit Test
*/
import deploy.model.semver;
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

	function getAppByIdTest(){
		transaction {
			var deploy = new ormTest().createDeploy();
			entitySave(deploy);
			var app = deploy.createApp("sampleapp", "sampleapp.com", "sample");
			entitySave(app);
			transaction action="commit";
		}

		// writeDump(app.getId());
		var getApp = deploy.getAppById(app.getId());
		expect(getApp).toBeInstanceOf("optional");
		expect(getApp.get() === app).toBeTrue();

		var tryApp = deploy.getAppById(2);
		expect(tryApp.exists()).toBeFalse();

	}

	
	
}
