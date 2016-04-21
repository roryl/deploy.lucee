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

	function getProviderTest(){
		transaction {
			var app = createApp();			
			transaction action="commit";
		}
		// writeDump(app);
		// abort;
		ORMFlush();
		// // writeDump(app);
		// writeDump(app.getCurrentVersion());
		// abort;
		expect(app.getProviderImplemented()).toBeInstanceOf("provider");
	}

	function createMigrationWrongVersionsTest(){
		var app = createApp();
		var version = new ormTest().createVersion();
		var version2 = entityNew("version", {semver: new semver("0.0.1")});
		app.addVersion(version);
		migrationThrowable = app.createMigration(version2);
		expect(migrationThrowable.threw()).toBeTrue();
		expect(migrationThrowable.getMessage()).toBe("This app does not have this version. Add the version before migrating to it");
		// writeDump(migrationThrowable.get());
	}

	function createMigrationNoVersionsTest(){
		var app = createApp();		
		var version = new ormTest().createVersion();
		migrationThrowable = app.createMigration(version);
		expect(migrationThrowable.threw()).toBeTrue();
		expect(migrationThrowable.getMessage()).toBe("No versions to migrate to. Please add a version");
	}

	function createMigrationMissingVersionsTest(){
		var app = createApp();		
		var version = new ormTest().createVersion();
		migrationThrowable = app.createMigration(version);
		expect(migrationThrowable.threw()).toBeTrue();
		expect(migrationThrowable.getMessage()).toBe("No versions to migrate to. Please add a version");
	}

	function createMigrationWithVersionsTest(){

		transaction {
			var app = createApp();		
			var version = new ormTest().createVersion();
			var version2 = entityNew("version", {semver: new semver("0.0.1")})
			entitySave(version2);
			var instance = app.createInstance();
			entitySave(instance);
			app.getBalancer().addInstance(instance);
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

			expect(arrayLen(Migration.getMigrationSteps())).toBe(5);

			transaction action="commit";
		}

	}

	function createBalancerTest(){
		transaction {
			var app = createApp();
			var balancer = app.createBalancer();
			expect(balancer).toBeInstanceOf("balancer");
			expect(balancer.isStopped()).toBeTrue();
			transaction action="commit";
		}
	}

	function createInstanceTest(){

		transaction {
			var app = createApp();
			var instance = app.createInstance();
			var balancer = app.createBalancer();
			expect(instance).toBeInstanceOf("instance");
			expect(balancer.hasInstance(instance)).toBeFalse();	
			transaction action="commit";			
		}

	}

	function createImageTest(){
		transaction {
			var app = createApp();
			var image = app.createImage("My Name", {"os":"centos", "size":"512gb", "region":"nyc1"});
			transaction action="commit";
		}

		var images = app.getImages();
		// writeDump(app.getImages());
		expect(arrayLen(images)).toBe(1);
		expect(arrayLen(images[1].getImageSettings())).toBe(3);
		expect(app.getDefaultImage() === images[1]).toBeTrue();		
	}

	function createDefaultImageTest(){

		transaction {
			var app = createApp();
			var image = app.createImage("My Name", {"os":"centos", "size":"512gb", "region":"nyc1"});
			var image = app.createImage("My Name 2", {"os":"centos", "size":"512gb", "region":"nyc1"});
			transaction action="commit";
		}

		var images = app.getImages();
		// writeDump(app.getImages());
		expect(arrayLen(images)).toBe(2);
		expect(arrayLen(images[1].getImageSettings())).toBe(3);
		expect(app.getDefaultImage() === images[1]).toBeTrue();	
		expect(app.getDefaultImage() === images[2]).toBeFalse();
		
	}



	
	
}
