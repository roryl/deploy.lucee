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
		
	}

	// executes after every test case
	function teardown( currentMethod ){
		
	}

/*********************************** TEST CASES BELOW ***********************************/
	
	function semverTest(){
		var semver = new deploy.model.semver("1.1.0");
		expect(semver).toBeInstanceOf("semver");
	}

	function invalidSemverTest(){		
		try {
			new deploy.model.semver("1");
		} catch(any e){
			expect(e.message).toBe("Invalid semver. Must have three sections x.x.x");
		}		
	}

	function semverPartTest(){
		var semver = new deploy.model.semver("1.1.0");
		expect(semver.getMajor()).toBe("1");
		expect(semver.getMinor()).toBe("1");
		expect(semver.getPatch()).toBe("0");
	}

	function semverEqualsTest(){

		var semver = new deploy.model.semver("1.1.0");
		var semver2 = new deploy.model.semver("1.1.0");
		var semver3 = new deploy.model.semver("1.1.1");

		expect(semver.equals(semver2)).toBeTrue();
		expect(semver.equals(semver3)).toBeFalse();

	}

	function semverCompareTest(){
		var semver = new deploy.model.semver("1.1.0");
		var semver2 = new deploy.model.semver("1.2.1");
		var semver3 = new deploy.model.semver("1.2.1");

		expect(semver.isBefore(semver2)).toBeTrue();
		expect(semver2.isBefore(semver3)).toBeFalse();
		
		expect(semver2.isAfter(semver)).toBeTrue();
		expect(semver3.isAfter(semver2)).toBeFalse();
	}

	function semverDiffTest(){
		var semver = new deploy.model.semver("1.1.0");
		var semver2 = new deploy.model.semver("1.2.1");
		var semver3 = new deploy.model.semver("1.2.1");

		expect(semver.diff(semver2).equals(new semver("0.1.0"))).toBeTrue();
		expect(semver2.diff(semver).equals(new semver("0.1.0"))).toBeTrue();
	}

	function semverTypeTest(){
		expect(new semver("1.0.0").isMajor()).toBeTrue();
		expect(new semver("0.1.0").isMinor()).toBeTrue();
		expect(new semver("0.0.1").isPatch()).toBeTrue();	
	}
	
}
