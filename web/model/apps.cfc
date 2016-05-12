component accessors="true" {
	property name="name";
	property name="domain_name";
	property name="provider" default="sample";
	property name="step";
	property name="submit";
	property name="balancer";
	property name="image_name";
	property name="image";

	variables.errors = [];

	public function init(required deploy Deploy){
		variables.deploy = arguments.deploy;
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

	public function setDomain_Name(required domain_name){
		if(listLen(domain_name,".") LT 2){
			addError("That is not a valid domain");
		}
	}

	public function getProviders(){
		var out = [
			{name:"sample"},
			{name:"digitalocean"}
		];
		for(var provider in out){		
			if(variables.provider == provider.name){
				provider.selected = true;
			}
		}
		return out;
	}

	public function setProvider(provider){

		var provider = arguments.provider;
		var ProviderOptional = variables.deploy.getProviderImplementedByName(provider);
		if(!ProviderOptional.exists()){
			addError("That is not a valid provider. Please check your result and try again");
		} else {
			variables.provider = provider;
		}

	}

	public function getProviderImplemented(){
		return  variables.deploy.getProviderImplementedByName(this.getProvider());
	}

	public function getBalancerOptions(){
		var options = getProviderImplemented().get().getBalancerOptions();
		// writeDump(options);
		// writeDump(this.getBalancer());
		// abort;
		//Decorate options with the selected value, this is for the view
		
		for(var option in options){

			if(structKeyExists(this.getBalancer(),option.id)){

				for(var values in option.options){

					if(this.getBalancer()[option.id] == values.id){
						values.selected = true;
					}
				}

				
			}
		}
			
		return options;
	}

	public function getImageOptions(){

		var options = getProviderImplemented().get().getImageOptions();
		
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