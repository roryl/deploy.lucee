/**
 * Throwable adds type hinting for functions which may throw errors and
 * should inform the caller of being handled
 */
component {

	public function init(required string message="", value){

		variables.message = arguments.message;
		variables.callerChecked = false;

		if(structKeyExists(arguments,"value")){
			variables.value = arguments.value;
			variables.threw = false;
		} else {
			variables.threw = true;
			variables.message = arguments.message;
		}		
	}

	public boolean function threw(){
		variables.callerChecked = true;
		return variables.threw;
	}

	private boolean function callerChecked(){
		return variables.callerChecked;
	}

	public function get(){

		if(!this.callerChecked()){
			throw("You must handle and check all throwables with the threw() function before getting the value");
		}

		if(this.threw()){
			reThrow();
		} else {
			return variables.value;
		}
	}

	public function reThrow(){
		if(! this.threw()){
			throw("Value was valid, cannot rethrow. Check for existence with threw() before rethrowing");
		} else {
			throw(variables.message);					
		}
	}

	public function orRethrow(){
		if(this.threw()){
			this.reThrow();
		} else {
			return get();
		}
	}

	public function getMessage(){
		return variables.message;
	}

}