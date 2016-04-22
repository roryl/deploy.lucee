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
	
	function getSettingsAsStructTest(){
		var Image = new ormTest().createImage();
		var Setting = new ormTest().createImageSetting();
		var Setting1 = new ormTest().createImageSetting();
		image.addImageSetting(setting);
		image.addImageSetting(setting1);
		var settings = image.getSettingsAsStruct();
		expect(isStruct(settings)).toBeTrue();
	}

	
	
}
