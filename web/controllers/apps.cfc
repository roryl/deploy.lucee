import web.vendor.serializer.serializer;
component accessors="true" {    
	
	public any function init( fw ) {	
		// writeDump(request);	
		variables.fw = fw;
		return this;
	}

	public function new(){
		return {}
	}

	private function serializeApp(required app){

		var app = arguments.app;
		var out = new serializer().serializeEntity(app, {currentVersion:{semver:{}}});
		return out;
	}
	
	public struct function list() {
    	var Deploy = variables.fw.getDeploy();
    	// writeDump(Deploy);

    	result = {
    		success:"true",
    		data:serializeApp(Deploy.getApps() ?: [])
    	}
    	return result;
	}

	public struct function create( required name,
								   required domain_name,
								   required provider="sample",
								   goto_success = "/index.cfm") {
		

		var Deploy = variables.fw.getDeploy();
		transaction {
			var app = Deploy.createApp(name, domain_name, provider);
			entitySave(app);
			transaction action="commit";			
		}
		// abort;

		var data = {
			success:true,
			goto:goto_success,
			data:new serializer().serializeEntity(app)
		}      
		return data;
	}

	public struct function read( required id ) {
    	
    	var Deploy = variables.fw.getDeploy();
    	var app = Deploy.getAppById(id);
    	if(app.exists()){
    		// writeDump(app.get().getCurrentVersion().getSemver());
    		// abort;
    		result = {
    			"success":"true",
    			"data":serializeApp(app.get())
    		}
    	} else {
    		result = {
    			success:false,
    			message:"The app with that id was not found"
    		}
    	}
    	return result;
	}

	public void function update( rc ) {
      
	}

	public void function delete( rc ) {
      
	}
	
}
