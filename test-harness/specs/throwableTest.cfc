/**
* My xUnit Test
*/
import deploy.model.throwable;
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
		
	}

	// executes after every test case
	function teardown( currentMethod ){
		
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function throwableThrewTest(){
		var throwable = new throwable("I am throwing a message");
		
		expect(throwable.threw()).toBeTrue();

		expect(function(){
			throwable.get();
		}).toThrow(message="I am throwing a message");

		expect(function(){
			throwable.reThrow();
		}).toThrow(message="I am throwing a message");
	}

	function throwableValidValueTest(){
		var throwable = new throwable(value="foo");
		expect(throwable.threw()).toBeFalse();
		
		expect(function(){
			throwable.reThrow();
		}).toThrow(message="Value was valid, cannot rethrow. Check for existence of threw before rethrowing");

		expect(throwable.get()).toBe("foo");
	}

	function uncheckedThrowableTest(){
		var throwable = new throwable("I am throwing a message");
		// throwable.get();
		expect(function(){
			throwable.get();
		}).toThrow(message="You must handle and check all throwables with the threw() function before getting the value")
	}



	
	
}
