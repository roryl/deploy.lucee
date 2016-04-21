component accessors="true" {
	property name="name";
	property name="domain_name";
	property name="provider";
	property name="step";
	property name="submit";
	property name="balancer";
	property name="instance";

	variables.errors = [];

	public function populate(required struct params){

		var params = arguments.params
		for(var key in params){
			evaluate("this.set#Key#(params[key])");
		}

	}

	public function addError(message){
		variables.errors.append(message);
	}

	public function getErrors(){
		return variables.errors;
	}

	public boolean function isValid(){
		if(getErrors().len() GT 0){
			return false;
		} else {
			return true;			
		}
	}

	public function setName(required name){
		if(name == ""){
			addError("Name cannot be empty");
		}
	}

	public function setDomain_Name(required domain_name){
		if(listLen(domain_name,".") LT 2){
			addError("That is not a valid domain");
		}
	}
}