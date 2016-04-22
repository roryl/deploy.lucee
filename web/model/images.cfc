component accessors="true" {
	property name="name";	
	property name="submit";	
	property name="image";

	variables.errors = [];

	public function init(required app app){
		variables.app = arguments.app;
	}

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

	public function getProviderImplemented(){
		return  variables.app.getProviderImplemented();
	}

	public function getBalancerOptions(){
		var options = getProviderImplemented().getBalancerOptions();

		//Decorate options with the selected value, this is for the view
		if(!this.getBalancer() == ""){
			for(var option in options){
				if(option.id == this.getBalancer()){
					option.selected = true;
				}
			}
		}	
		return options;
	}

	public function getImageOptions(){

		var options = getProviderImplemented().getImageOptions();
		
		//Decorate options with values that have been selected
		for(var option in options){
			// writeDump(option);
			if(structKeyExists(this.getImage(),option.id)){
				for(var values in option.options){
					if(this.getImage()[option.id] == values.id){
						values.selected = true;
					}
				}
			}
			// abort;
		}

		return options;
	}
}