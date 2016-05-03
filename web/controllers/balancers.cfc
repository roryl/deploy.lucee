component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public void function list( rc ) {
      
	}

	public void function create( required numeric apps_id ) {

	}

	public void function read( rc ) {
      
	}

	public void function update( rc ) {
      
	}

	public void function delete( rc ) {
      
	}

	public struct function deploy( required numeric id ){

		var Deploy = variables.fw.getDeploy();
		var Balancer = Deploy.getBalancerById(id).elseThrow();
		if(Balancer.isDeployed()){
			return {
				"success":false,
				"message":"Cannot deploy a balancer which has already been deployed"
			}
		} else {

			transaction {
				var DeployedThrowable = Balancer.deploy();

				if(DeployedThrowable.threw()){
					transaction action="rollback";
					return {
						"success":"false",
						"message":DeployedThrowable.getMessage()
					}
				} else {					
					if(DeployedThrowable.get() IS true){
						transaction action="commit";
						return {
							"success":true,
							"message":"The load balancer was successfully deployed"
						}
					} 
				}
								
			}

		}

	}
	
}
