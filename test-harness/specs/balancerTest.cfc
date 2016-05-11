/**
* My xUnit Test
*/
import deploy.model.semver;
component extends=""{
	
/*********************************** LIFE CYCLE Methods ***********************************/

	// executes before all test cases
	function beforeTests(){
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
	
	function getSettingsAsStructTest(){
		var Balancer = new ormTest().createBalancer();
		var Setting = new ormTest().createBalancerSetting();
		var Setting1 = new ormTest().createBalancerSetting();
		balancer.addBalancerSetting(setting);
		balancer.addBalancerSetting(setting1);
		var settings = balancer.getSettingsAsStruct();
		expect(isStruct(settings)).toBeTrue();
	}

	/*
	Should return an empty struct if there are no settings
	 */
	function getSettingsAsStructNullTest(){
		var Balancer = new ormTest().createBalancer();
		var settings = balancer.getSettingsAsStruct();
		expect(isStruct(settings)).toBeTrue();
		expect(settings.isEmpty()).toBeTrue();
	}	

	function putBalancerSettingTest(){

		transaction {
			var Balancer = new ormTest().createBalancer();
			Balancer.putBalancerSettingKeyValue("size", "512mb");
			transaction action="commit";			
		}
		expect(balancer.hasBalancerSetting()).toBeTrue();
		expect(balancer.getBalancerSettings()[1].getKey()).toBe("size");
		expect(balancer.getBalancerSettings()[1].getValue()).toBe("512mb");
		expect(balancer.getBalancerSettingValueByKey("size")).toBeInstanceOf("Optional");
		expect(balancer.getBalancerSettingValueByKey("size").get()).toBe("512mb");
	}

	function deployTest(){

		var Balancer = new appTest().createBalancerTest();
		DeployedThrowable = Balancer.deploy();
		expect(DeployedThrowable.threw()).toBeFalse();
		expect(Balancer.isDeployed()).toBeTrue();

		var Instances = Balancer.getBalancerInstances();
		expect(arrayLen(instances)).toBe(2);		
		expect(instances[1].isPrimary()).toBeTrue();
	}
	
}
