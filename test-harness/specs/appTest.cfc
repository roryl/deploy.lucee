/**
* My xUnit Test
*/
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
	
	function createMigrationNoVersionsTest(){
		var app = new ormTest().createApp();
		var version = new ormTest().createVersion();
		migrationThrowable = app.createMigration(version);
		expect(migrationThrowable.threw()).toBeTrue();
		expect(migrationThrowable.getMessage()).toBe("No versions to migrate to. Please add a version");
	}

	function createMigrationWithVersionsTest(){

		var app = new ormTest().createApp();
		var version = new ormTest().createVersion();
		var version2 = new ormTest().createVersion();
		app.addVersion(version);
		app.addVersion(version2);
		version.setApp(app);
		version2.setApp(app);

		var MigrationThrowable = app.createMigration(version2);		
		
		expect(MigrationThrowable.threw()).toBeFalse();
		var Migration = MigrationThrowable.get();
		expect(Migration).toBeInstanceOf("migration");
		expect(Migration.getApp()).notToBeNull();
		expect(Migration.getApp()).toBeInstanceOf("app");
	}

	
	
}
