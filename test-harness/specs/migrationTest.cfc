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

		transaction {
			var app = createApp();
			entitySave(app);
			var balancer = app.createBalancer();
			var instance = app.createInstance();
			balancer.addInstance(instance);
			balancer.start();			
		}

	}

	// executes after every test case
	function teardown( currentMethod ){
		//Close the ORM session on each test so that a new session is created on the next test
		ORMGetSession().close();
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function createApp(){
		return new ormTest().createDeploy().createApp("sampleapp", "sampleapp.com", "sample");
	}

	function loadApp(){
		return entityLoad("app", {name:"sampleapp"}, true);
	}

	function majorInitialTest(){		

		/*
		 * Put up maintenance page
		 * Perform Model Migration
		 * Spin up VMs and smoke test against model
		 * swap the new vm with a vm from the load balancer		 * 
		 * Remove maintenance page
		 */

		transaction {

			var app = loadApp();
			var version = entityNew("version", {semver:new semver("1.0.0")});
			entitySave(version);
			app.addVersion(version);
			var migrationThrowable = app.createMigration(version);

			if(migrationThrowable.threw()){
				migration.reThrow();
			} else {
				migration = migrationThrowable.get();
				expect(migration.getVersionChange().isMajor()).toBeTrue();
				migration.run();									
			}
			transaction action="commit";			

			for(step in migration.getMigrationSteps()){
				expect(step.getStatus()).toBe("success");
			}

			expect(arrayLen(Migration.getMigrationSteps())).toBe(5);
			expect(app.getBalancer().isActive()).toBeTrue();

		}

	}

	
	
}
