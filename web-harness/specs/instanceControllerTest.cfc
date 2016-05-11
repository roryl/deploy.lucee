/**
* My xUnit Test
*/
import deploy.model.semver;
import test-harness.specs.ormTest;
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
		var appcfc = new web.Application();

		transaction {

			var deploy = new ormTest().createDeployWithAppAndImageAndBalancer();		
			appcfc.getDeploy = function(){
				return deploy;
			}

			var app = deploy.getAppById(1).elseThrow("could not load the app 1");
			// writeDump(app.exists());

			var instances = new web.controllers.instances(appcfc);
			var result = instances.create(apps_id:app.getId());

			expect(result.success).toBeTrue();
			expect(result.message).toBe("The instance was successfully created");
			expect(result.instance).toBeStruct();	
			
			expect(arrayLen(app.getBalancer().getInstances())).toBe(1);
			expect(app.getBalancer().getInstances()[1].getId() == result.instance.id).toBeTrue();
			transaction action="rollback";
		}
		
	}

	
	
}
