import deploy.model.providerMessage;
component {

	/*
	SSH tools: https://github.com/hierynomus/sshj
	https://github.com/hierynomus/sshj
	Adding Hosts http://stackoverflow.com/questions/10922292/struggling-with-sshj-example-exec-could-not-verify-ssh-rsa-host-key-with
	 */
	
	public function init(required string balancerHost, required string password){
		variables.balancerHost = arguments.balancerHost;
		variables.password = arguments.password;
	}

	public providerMessage function addInstance(required string host){

		var scriptPath = getDirectoryFromPAth(getCurrentTemplatePath());		
		var scriptPath = scriptPath & "scripts/run.sh";
		
		if(fileExists("runerror")){fileDelete("runerror")};
		if(fileExists("runout")){fileDelete("runout")};

		command = "#scriptPath# balancer #variables.password# #variables.balancerHost# a #host#";	
		// writeDump(command);
		// abort;
		try {
			execute name="#command#" errorfile="runerror" outputfile="runout" timeout="10" errorvariable="errorout";			
		} catch(any e){			
			throw(e);			
		}

		var providerMessage = new providerMessage(argumentCollection={
			success:true,
			data:"",
			originalResponse:""
		})
		return providerMessage;
	}

	public providerMessage function removeInstance(required string host){

		var scriptPath = getDirectoryFromPAth(getCurrentTemplatePath());		
		var scriptPath = scriptPath & "scripts/run.sh";
		
		if(fileExists("runerror")){fileDelete("runerror")};
		if(fileExists("runout")){fileDelete("runout")};

		command = "#scriptPath# balancer #variables.password# #variables.balancerHost# r #host#";	
		// writeDump(command);
		// abort;
		try {
			execute name="#command#" errorfile="runerror" outputfile="runout" timeout="10" errorvariable="errorout";			
		} catch(any e){			
			throw(e);			
		}

		var providerMessage = new providerMessage(argumentCollection={
			success:true,
			data:"",
			originalResponse:""
		})
		return providerMessage;
	}

	public function enableMaintenance(){
		return callStackGet();
	}

	public boolean function isInMaintenance(){
		return true;
	}

	public function disableMainteance(){
		return true;
	}

	public function start(){
		return true;
	}

	public boolean function isActive(){
		return true;
	}

	public function stop(){
		return true;
	}

	public boolean function isStopped(){
		return true;
	}

}