/**
* My xUnit Test
*/
import deploy.model.semver;
component extends="testbox.system.baseSpec"{
	
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
	}

	// executes before every test case
	function setup( currentMethod ){
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
		app.createBalancer({});
		return app;
	}

	function getProviderTest(){
		transaction {
			var app = createApp();			
			expect(app.getProviderImplemented()).toBeInstanceOf("provider");
			transaction action="rollback";
		}
		// writeDump(app);
		// abort;
		// ORMFlush();
		// // writeDump(app);
		// writeDump(app.getCurrentVersion());
		// abort;
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
			var version2 = entityNew("version", {semver: new semver("0.0.1")});
			entitySave(version2);
			app.createImage("my image", {});

			var instanceThrowable = app.createInstance();
			if(!instanceThrowable.threw()){
				var instance = instanceThrowable.get();
			} else {
				instanceThrowable.rethrow();
			}

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

			transaction action="rollback";
		}

	}

	function createBalancerTest(){
		transaction {
			var app = createApp();
			var balancer = app.createBalancer({});
			expect(balancer).toBeInstanceOf("balancer");
			expect(balancer.isStopped()).toBeTrue();
			transaction action="rollback";
		}
		return balancer;
	}

	function createInstanceTest(){

		transaction {
			var app = createApp();
			app.createImage("my image", {})
			var instanceThrowable = app.createInstance();
			if(!instanceThrowable.threw()){
				instance = instanceThrowable.get();
			}
			var balancer = app.createBalancer({});
			expect(instance).toBeInstanceOf("instance");
			expect(balancer.hasInstance(instance)).toBeFalse();	
			expect(app.getCurrentVersion().getInstances()[1] === instance).toBeTrue();
			transaction action="rollback";			
		}
		return Instance;
	}

	function createImageTest(){
		transaction {
			var app = createApp();
			var image = app.createImage("My Name", {"os":"centos", "size":"512gb", "region":"nyc1"});
			var images = app.getImages();
			// writeDump(app.getImages());
			expect(arrayLen(images)).toBe(1);
			expect(arrayLen(images[1].getImageSettings())).toBe(3);
			expect(app.getDefaultImage() === images[1]).toBeTrue();	
			transaction action="rollback";
		}

		return image;
	}

	function createDefaultImageTest(){

		transaction {
			var app = createApp();
			var image = app.createImage("My Name", {"os":"centos", "size":"512gb", "region":"nyc1"});
			var image = app.createImage("My Name 2", {"os":"centos", "size":"512gb", "region":"nyc1"});

			var images = app.getImages();
			// writeDump(app.getImages());
			expect(arrayLen(images)).toBe(2);
			expect(arrayLen(images[1].getImageSettings())).toBe(3);
			expect(app.getDefaultImage() === images[1]).toBeTrue();	
			expect(app.getDefaultImage() === images[2]).toBeFalse();
			transaction action="rollback";
		}		
	}

	function createVersionTest(){
		transaction {
			var Deploy = new ormTest().createDeployWithApp();
			var App = Deploy.getApps()[1];
			var semver = new semver("1.0.0");
			var newVersion = App.createVersion(semver, {});
			expect(arrayLen(App.getVersions())).toBe(2);						
			expect(newVersion.threw()).toBeFalse();
			transaction action="commit";			
		}
	}

	function createVersionThrowForSameVersionTest(){
		transaction {
			var Deploy = new ormTest().createDeployWithApp();
			var App = Deploy.getApps()[1];
			var semver = new semver("0.0.0");
			var newVersion = App.createVersion(semver, {});
			expect(arrayLen(App.getVersions())).toBe(1);						
			expect(newVersion.threw()).toBeTrue();
			expect(newVersion.getMessage()).toBe("Could not add the version because it was identical with the latest version which was 0.0.0");
			transaction action="commit";			
		}
	}

	function createVersionThrowForLaterVersionTest(){
		transaction {
			var Deploy = new ormTest().createDeployWithApp();
			var App = Deploy.getApps()[1];
			var semver = new semver("2.0.0");
			var newVersion = App.createVersion(semver, {});
			expect(arrayLen(App.getVersions())).toBe(2);
			ORMFlush();					

			var newestSemver = new semver("1.0.0");
			var newestVersion = App.createVersion(newestSemver, {});
			expect(newestVersion.threw()).toBeTrue();
			expect(newestVersion.getMessage()).toBe("Could not add the version because the latest version is after this one, the latest version was 2.0.0");
			transaction action="commit";
		}
	}

	function getInactiveInstancesTest(){

		transaction {

			var Deploy = new ormTest().createDeployWithAppAndImageAndBalancer();
			var App = Deploy.getApps()[1];
			var Balancer = App.getBalancer();
			var Instance = App.createInstance().orRethrow();
			var Instance2 = App.createInstance().orRethrow();
			var Instance3 = App.createInstance().orRethrow();

			Balancer.addInstance(Instance);
			Instance.setBalancer(Balancer);

			var inactiveInstances = App.getInactiveInstances();
			expect(arrayLen(inactiveInstances)).toBe(2);
			expect(arrayLen(app.getInstances())).toBe(3);

			transaction action="rollback";

		}


	}
	
	
}
