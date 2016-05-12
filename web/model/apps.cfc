component accessors="true" {
	property name="name";
	property name="domain_name";
	property name="provider" default="sample";
	property name="current_step_submitted";
	property name="submit";
	property name="balancer";
	property name="image_name";
	property name="image";
	property name="secure_key";

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

	public function setSecure_Key(required struct secure_key){
		variables.secure_key = secure_key;
		if(structKeyExists(variables,"current_step_submitted") AND variables.current_step_submitted == "secure_keys"){
			for(var key in secure_key){
				variables.secure_key[key] = encryptSecureKey(variables.secure_key[key]);				
			}
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

	public function getSecureKeysDecrypted(){
		var keys = variables.secure_key;
		out = {}
		for(var key in keys){
			out[key] = decryptSecureKey(keys[key]);
		}
		return out;
	}

	public array function getSecureKeyOptions(){
		var Provider = getProviderImplemented().get();
		var keys = Provider.getSecureKeys();
		var secureKeys = this.getSecure_Key();
		for(key in keys){
			if(structKeyExists(secureKeys, key.id)){
				key.value = secureKeys[key.id];
			}
		}				
		return keys;
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

	private string function getSecretKey(){
		if(!fileExists("encrypt.key")){
			var key = generateSecretKey("AES");
			fileWrite("encrypt.key", key);
		} 
		return fileRead("encrypt.key");
	}

	private function encryptSecureKey(required string value){

		var key = getSecretKey();
		var encrypted = encrypt(string=value, key=key, algorithm="AES", encoding="base64");
		return encrypted;
	}

	private function decryptSecureKey(required string value){
		var key = getSecretKey();
		var decrypted = decrypt(encrypted_string=value, key=key, algorithm="AES", encoding="base64");		
		return decrypted;
	}
}