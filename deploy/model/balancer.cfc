component persistent="true" table="balancer" {
	property name="id" fieldtype="id" generator="native";
	property name="status" default="stopped";
	property name="deployed" type="boolean" default="false";
	property name="app" fieldtype="one-to-one" cfc="app" mappedby="balancer";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="balancer_id" singularname="instance";
	property name="balancerInstances" fieldtype="one-to-many" cfc="balancerInstance" fkcolumn="balancer_instance_id" singularname="balancerInstance";
	property name="balancerSettings" fieldtype="one-to-many" cfc="balancerSetting" fkcolumn="balancer_id" singularname="balancerSetting";

	/*
	Override builtin ORM functions while maintaingin their 
	original functionality
	 */
	public function init(){
		this.ORMAddInstance = this.addInstance;
		this.addInstance = this._addInstance;

		this.ORMRemoveInstance = this.removeInstance;
		this.removeInstance = this._removeInstance;
	}

	public function getProviderBalancer(){
		var provider = this.getApp().getProviderImplemented();
		var primaryBalancer = this.getPrimaryBalancer();
		var App = this.getApp();
		var host = PrimaryBalancer.getHost();
		var password = app.getSecureKeyValueByKey("balancer_password").elseThrow("Could not load the password, this should not have happened");
		return provider.getBalancer(host, password);
	}

	public function getPrimaryBalancer(){
		var balancers = this.getBalancerInstances();
		for(var balancer in balancers){
			if(balancer.isPrimary()){
				return balancer;
			}
		}
		throw("Could not find any primary balancer, this was in error");
	}

	public Throwable function deploy(){

		var Provider = this.getApp().getProviderImplemented();

		var name = this.getApp().getName();
		name = replaceNoCase(name, " ", "-", "all");
		name = name & "-balancer";

		var ProviderMessage = Provider.deployLoadBalancer(name, this.getSettingsAsStruct());
		if(ProviderMessage.isSuccess()){

			var instances = ProviderMessage.getData().instances;
			var password = ProviderMessage.getData().password;

			var App = this.getApp();
			App.putSecureKeyKeyValue("balancer_password", password);

			if(!isArray(instances)){
				return new throwable("Provider did not return an array, we expected an array of instances");
			}

			for(var data in instances){
				var instance = entityNew("balancerInstance");
				this.addBalancerInstance(instance);
				instance.setBalancerInstance(this);
				entitySave(instance);

				instance.setInstanceId(data.instanceId);		
				instance.setName(data.name);
				instance.setHost(data.host);
				instance.setVcpus(data.vcpus);
				instance.setMemory(data.memory);
				instance.setDisk(data.disk);
				instance.setStatus(data.status);
				App.addInstance(instance);
				instance.setApp(App);
			}

			//Set the first instance as primary
			this.getBalancerInstances()[1].setIsPrimary(true);

			this.setDeployed(true);
			return new throwable(value=true);

		} else {
			throw("not yet implemented, need to handle provider message failures")
		}
	}

	public void function _addInstance(required Instance instance){
		var providerMessage = getProviderBalancer().addInstance(arguments.instance.getHost());

		if(providerMessage.isSuccess()){
			this.ORMAddInstance(arguments.instance);
			arguments.instance.setBalancer(this);			
		} else {
			throw("Error adding instance to the balancer. The error was: #providerMessage.getData()#");
		}
	}

	public void function _removeInstance(required Instance instance){
		var providerMessage = getProviderBalancer().removeInstance(arguments.instance.getHost());
		if(providerMessage.isSuccess()){
			this.ORMRemoveInstance(arguments.instance);
			arguments.instance.setBalancer(JavaCast( "null", 0 ));		
		} else {
			throw("Error removing instance from the balancer. The error was: #providerMessage.getData()#");
		}		
	}

	public function getOneRunningInstanceNotInMigration(required migration Migration){
		var Migration = arguments.migration;
		var instances = this.getInstances();
		var instances.removeAll(Migration.getInstances());
		return instances[1];
	}

	public function enableMaintenance(){
		variables.status = "mainteance";
	}

	public boolean function isInMaintenance(){
		return variables.status IS "maintenance";
	}

	public function disableMaintenance(){
		variables.status = "active";
	}

	public function start(){
		variables.status = "active";
	}

	public boolean function isActive(){
		return variables.status IS "active";
	}

	public function stop(){
		variables.status = "stopped";
	}

	public boolean function isStopped(){
		return variables.status IS "stopped";
	}

	public boolean function isDeployed(){
		return variables.deployed;
	}

	public struct function getSettingsAsStruct(){
		var BalancerSettings = this.getBalancerSettings();
		var out = {}
		if(!isNull(BalancerSettings)){
			for(var setting in BalancerSettings){
				out[setting.getKey()] = setting.getValue();
			}			
		}
		return out;
	}

	public boolean function putBalancerSettingKeyValue(required string key, required string value){

		var key = arguments.key;
		var value = arguments.value;

		var BalancerSetting = entityLoad("balancerSetting", {balancer:this, key:key, value:value}, true);
		if(isNull(BalancerSetting)){
			var BalancerSetting = entityNew("balancerSetting", {balancer:this, key:key, value:value});
			entitySave(BalancerSetting);
			this.addBalancerSetting(BalancerSetting);
			BalancerSetting.setBalancer(this);
		}
		return true;
	}

	public Optional function getBalancerSettingValueByKey(required string key){
		var key = arguments.key;
		var BalancerSetting = entityLoad("BalancerSetting", {balancer:this, key:key}, true);
		if(isNull(BalancerSetting)){
			return new Optional();
		} else {
			return new Optional(BalancerSetting.getValue());
		}
	}


	public boolean function putAllSettingsKeyValues(required struct settings){
		var settings = arguments.settings;		
		for(var setting in settings){
			this.putBalancerSettingKeyValue(key=setting, value=settings[setting]);
		}
		return true;
	}

}