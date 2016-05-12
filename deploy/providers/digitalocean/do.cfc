component {

	public function init(required string authorizationToken){

		variables.authorizationToken = arguments.authorizationToken;

	}

	public function listDroplets(){
		var data = doHTTPCall(resource="https://api.digitalocean.com/v2/droplets");
		return deserializeJson(data.fileContent);
	}

	public function createDroplet(required string name, required string region, required string size, required string image, string user_data){
		var data = doHTTPCall(resource="https://api.digitalocean.com/v2/droplets", method="POST", body=serializeJson(arguments));
		return deserializeJson(data.fileContent);
	}

	public function destroyDroplet(required id){
		var data = doHTTPCall(resource="https://api.digitalocean.com/v2/droplets/#arguments.id#", method="DELETE");
		if(data.status_code == 204){
			return true;
		} else {
			return data;
		}		
	}

	public function listDistributionImages(){
		var data = doHTTPCall(resource="https://api.digitalocean.com/v2/images?type=distribution");
		return deserializeJson(data.fileContent);	
	}

	public function getDroplet(id){
		var data = doHTTPCall(resource="https://api.digitalocean.com/v2/droplets/#id#");
		return deserializeJson(data.fileContent);
	}

	private function doHTTPCall(required string resource, method="GET", string body, struct formFields, struct params){
		
		var uri = arguments.resource;
		writeLog(file="digitalocean", text=serializeJson(arguments));		

		if(!isNull(arguments.params))
		{
			var i = 1;
			for(local.key in arguments.params){
				if(i == 1){
					local.uri = local.uri & "?";
				}else {
					local.uri = local.uri & "&";
				}
				local.uri = local.uri & "#key#=#arguments.params[key]#";
				i++;
			}
		}
		
		http url="#local.uri#" method="#arguments.method#" {

			httpparam name="Content-Type" value="application/json" type="header";
			httpparam name="Authorization" value="Bearer #variables.authorizationToken#" type="header";

			if(!isNull(arguments.body))
			{
				httpparam type="body" value="#arguments.body#";
			}

			if(!isNull(arguments.formFields))
			{
				for(key in arguments.formFields){
					httpparam type="formField" name="#key#" value="#arguments.formFields[key]#";
				}
			}			

		};

		return cfhttp;
	}	



}