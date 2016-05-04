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
		if(structKeyExists(url,"h2")){			
			query name="drop"{
				echo("DROP ALL OBJECTS;");
			}			
		} else {
			query name="drop"{ 
				echo("use deploy; ");
				echo("drop database deploy; ");
				echo("create database deploy; ");
				echo("use deploy; ");
			}		
		}	
		ORMReload();
	}

	// executes after every test case
	function teardown( currentMethod ){
		//Close the ORM session on each test so that a new session is created on the next test
		ORMGetSession().close();
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function getSettingsAsStructTest(){
		var Image = new ormTest().createImage();
		var Setting = new ormTest().createImageSetting();
		var Setting1 = new ormTest().createImageSetting();
		image.addImageSetting(setting);
		image.addImageSetting(setting1);
		var settings = image.getSettingsAsStruct();
		expect(isStruct(settings)).toBeTrue();
	}

	/*
	Should return an empty struct if there are no settings
	 */
	function getSettingsAsStructNullTest(){
		var Image = new ormTest().createImage();
		var settings = image.getSettingsAsStruct();
		expect(isStruct(settings)).toBeTrue();
		expect(settings.isEmpty()).toBeTrue();
	}

	function hasBaseScriptTest(){
		var Image = new ormTest().createImage();
		expect(Image.hasBaseScript()).toBeFalse();
		Image.setBaseScript("Test");
		expect(Image.hasBaseScript()).toBeTrue();
	}

	function putImageSettingTest(){

		transaction {
			var Image = new ormTest().createImage();
			Image.putImageSettingKeyValue("size", "512mb");
			transaction action="commit";			
		}
		expect(image.hasImageSetting()).toBeTrue();
		expect(image.getImageSettings()[1].getKey()).toBe("size");
		expect(image.getImageSettings()[1].getValue()).toBe("512mb");
		expect(image.getImageSettingValueByKey("size")).toBeInstanceOf("Optional");
		expect(image.getImageSettingValueByKey("size").get()).toBe("512mb");
	}

	function createInstanceTest(){

		transaction {
			var app = new appTest().createApp();
			var Image = app.createImage("test", {os:"centOS", size:"512mb", region:"nyc1"});
			var InstanceThrowable = Image.createInstanceTest();
			transaction action="commit";
		}

		expect(InstanceThrowable.threw()).toBeFalse();		
		expect(arrayLen(Image.getInstanceTests())).toBe(1);
		expect(InstanceThrowable.get().getImageTest() === Image).toBeTrue();
	}

	function createSnapshotTest(){

		transaction {
			var App = new appTest().createApp();
			Image = App.createImage("my image", {"size":"512mb"});
			var Snapshot = Image.createSnapshot();
			transaction action="commit";
		}
		
		expect(Snapshot.getBaseImage() === Image).toBeTrue();
		expect(Snapshot.isSnapshot()).toBeTrue();
		expect(Image.isSnapshot()).toBeFalse();		

	}

	function createVersionSettingTest(){

		transaction {
			var image = new appTest().createImageTest();
			var versionSetting = image.putVersionSetting("foo","bar","");
			transaction action="commit";
		}

		expect(arrayLen(image.getVersionSettings())).toBe(1);
		return versionSetting;
	}

	function createVersionSettingByIdTest(){
		
		versionSetting = createVersionSettingTest();
		versionSettingOptional = versionSetting.getImage().getVersionSettingById(versionSetting.getId());
		expect(versionSettingOptional).toBeInstanceOf("Optional");
		expect(versionSettingOptional.get() === versionSetting).toBeTrue();		

	}

	
	
}
