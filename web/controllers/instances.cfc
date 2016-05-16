import web.vendor.serializer.serializer;
component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		// writeDump(request.context);
		// abort;
		return this;
	}
	
	public void function list( rc ) {
      
	}

	public struct function create( required apps_id,
								   boolean add_to_balancer=true ) {
    	var Deploy = variables.fw.getDeploy();
    	var App = Deploy.getAppById(apps_id).elseThrow("Could not load the app id #apps_id#");
    	
    	transaction {
    		var InstanceThrowable = App.createInstance();
    		if(InstanceThrowable.threw()){
    			transaction action="rollback";
    			InstanceThrowable.reThrow();
    		} else {

    			if(add_to_balancer){
	    			var Balancer = App.getBalancer();
	    			var Instance = InstanceThrowable.get();
	    			Balancer.addInstance(Instance);
	    			Instance.setBalancer(Balancer);
    			}

    			transaction action="commit";
    			var out = {
    				"success":true,
    				"message":"The instance was successfully created",
    				"instance":new serializer().serializeEntity(InstanceThrowable.get())
    			}
    		}    		
    	}
    	return out;
	}

	public void function read( rc ) {
      
	}

	public void function update( rc ) {
      
	}

	public struct function delete( id ) {
		// sleep(1000);
		var Deploy = variables.fw.getDeploy();
		var InstanceOptional = Deploy.getInstanceById(id);
		if(!InstanceOptional.exists()){
			return out = {
				"success":false,
				"message":"The instance did not exist"
			}
		} else {

			transaction {
				Deploy.deleteInstance(InstanceOptional.get()).orRethrow();
				transaction action="commit";
			}

			return out = {
				"success":true,
				"message":"The instance was successfully deleted"
			}
		}      
	}

	public struct function unbalance( id ){

		var Deploy = variables.fw.getDeploy();
		var Instance = Deploy.getInstanceById(id).elseThrow("Could not load the instance ID");
		var Balancer = Instance.getBalancer();
		
		if(isNull(Balancer)){
			throw("Instance is not currently being balanced. Can only unablanace balanced instances");
		} else {
			transaction {
				Balancer.removeInstance(Instance);
				transaction action="commit";
			}
			var out = {
				"success":true,
				"message":"The instance was successully removed from the balancer",
				"data":{
					"instance":new serializer().serializeEntity(Instance)
				}
			}
			return out;
		}
	}

	public struct function balance( id ){

		var Deploy = variables.fw.getDeploy();
		var Instance = Deploy.getInstanceById(id).elseThrow("Could not load the instance ID");
		Instance.refresh();
		if(Instance.getStatus() == "new"){
			throw("Could not balance the instance because it is new. Wait for the instance to be active and healthy");
		}

		var Balancer = Instance.getBalancer();
		
		if(isNull(Balancer)){
			var Balancer = Instance.getApp().getBalancer();
			transaction {
				Balancer.addInstance(Instance);
				transaction action="commit";
			}
			var out = {
				"success":true,
				"message":"The instance was successully added to the balancer",
				"data":{
					"instance":new serializer().serializeEntity(Instance)
				}
			}
			return out;
		} else {
			throw("Instance is currently being balanced. Can only balance unbalanced instances");
		}
	}

	public struct function refresh( id ){

		var Deploy = variables.fw.getDeploy();
		var Instance = Deploy.getInstanceById(id).elseThrow("Could not load the instance ID");
		transaction {
			Instance.refresh();
			transaction action="commit";			
		}
		var out = {
			"success":true,
			"message":"The instance was successfulyl refreshed",
			"data":{
				"instance":new serializer().serializeEntity(Instance)
			}
		}
		return out;
	}
	
}
