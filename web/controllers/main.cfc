component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public struct function list( rc ) {
		
		var apps = new apps(variables.fw).list();
		return apps;
	}

	// public function new(tryme){		
	// 	return {data:"true"}
	// }
	
}
