/**
* My xUnit Test
*/
import deploy.model.semver;
import deploy.providers.digitalocean.do;
import deploy.providers.digitalocean.provider;
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
		variables.do = new do("9377fa8739d2e4e486bf5cc44362936818ae4c78346d211c2d8fa08e82716c54");
	}

	// executes after every test case
	function teardown( currentMethod ){
		//Close the ORM session on each test so that a new session is created on the next test
		ORMGetSession().close();
	}

	function getSecureKeys(){
		return {
			authorization:fileRead("do.key")
		}
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function basicRequestTest(){

		
		// var result = do.listDroplets();
		
		// writeDump(result);

	}

	function listDistributionImagesTest(){
		// var result = do.listDistributionImages();
		// writeDump(result);
	}

	function createDropletTest(){

		// var result = do.createDroplet(name:"mytestdroplet", region:"nyc1", size:"512mb", image:"centos-7-2-x64");
		// writeDump(result);
	}

	function getDropletTest(){

		// var result = do.getDroplet(id=15143339)
		// writeDump(result);
	}

	function providerGetInstanceTest(){
		// var result = new provider().getInstance(15143339);
		// writeDump(result);
	}

	function destroyDropletTest(){
		// var result = do.createDroplet(name:"mytestdroplet", region:"nyc1", size:"512mb", image:"centos-7-2-x64");
		// var id = result.droplet.id;
		// var destroy = do.destroyDroplet(id);
		// writeDump(destroy);
	}

	function deployBalancerTest(){
		// var Provider = new provider(getSecureKeys());
		// var options = {
		// 	region:"nyc1",
		// 	size:"512mb"
		// }
		// var result = Provider.deployLoadBalancer("test-balancer-#createUUID()#", options);
		// writeDump(result);
	}
	
	
}
