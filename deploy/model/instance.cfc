component persistent="true" table="instance" discriminatorColumn="instance_type" {
	property name="id" fieldtype="id" generator="native";
	property name="instanceId";
	property name="name";
	property name="host";
	property name="memory";
	property name="vcpus";
	property name="disk";
	property name="status" default="new";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_instance_id" inverse="true";
	property name="balancer" fieldtype="many-to-one" cfc="balancer" fkcolumn="balancer_id" inverse="true";	
	property name="version" fieldtype="many-to-one" cfc="version" fkcolumn="version_id" inverse="true";
	property name="migration" fieldtype="many-to-one" cfc="migration" fkcolumn="migration_id" inverse="true";
	property name="image" fieldtype="many-to-one" cfc="image" fkcolumn="instance_image_id" inverse="true";
	property name="imageTest" fieldtype="many-to-one" cfc="image" fkcolumn="instance_test_image_id" inverse="true";

	public function smokeTest(){
		return true;
	}

	public Instance function refresh(){
		var Provider = this.getApp().getProviderImplemented();
		ProviderMessage = Provider.getInstance(this.getInstanceId());		
		if(providerMessage.isSuccess()){
			var data = providerMessage.getData();
			this.setName(data.name);
			this.setHost(data.host);
			this.setVcpus(data.vcpus);
			this.setMemory(data.memory);
			this.setDisk(data.disk);
			this.setStatus(data.status);
		} else {
			throw("Error getting the instance");
			writeDump(providerMessage.getOriginalResponse());
		}
		return this;
	}

}