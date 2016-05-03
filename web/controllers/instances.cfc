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

	public void function create( rc ) {
      
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
				"message":"The image did not exist"
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
	
}
