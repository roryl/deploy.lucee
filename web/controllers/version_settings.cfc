import web.vendor.serializer.serializer;
component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public struct function list( images_id ) {
    	
    	var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(images_id).elseThrow("Could not load the app id #images_id#");

    	var out = {
    		"success":true,
    		"data": new serializer().serializeEntity(Image, {versionSettings:{}})
    	}
    	// writeDump(app);
    	// abort;
    	return out;
	}

	public struct function create( required numeric images_id,
								 required string key,
								 required string value,
								 required string default) {

      	var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(images_id).elseThrow("Could not load the app id #images_id#");

    	transaction {
    		var versionSetting = Image.putVersionSetting(key, value, default);    	
    		transaction action="commit";
    	}

    	var out = {
    		"success":true,
    		"data": new serializer().serializeEntity(versionSetting),    		
    	}    	
    	return out;
	}	

	public struct function read( required numeric images_id,
								required numeric id ) {
      
		var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(images_id).elseThrow("Could not load the app id #images_id#");
    	var versionSetting = App.getVersionSettingById(id).elseThrow();

    	var out = {
    		"success":true,
    		"data": new serializer().serializeEntity(Image, {version_settings:{}}),
    		"view_state":{
    			"new":true,    			
    			"version_setting":new serializer().serializeEntity(versionSetting)
    		}
    	}
    	variables.fw.setView('version_settings.list');
    	return out;
	}

	public struct function update( 	required numeric images_id,
									required numeric id) {

    	var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(images_id).elseThrow("Could not load the app id #images_id#");
    	
    	transaction {
    		var versionSetting = App.putVersionSetting(key, value, default);    	
    		transaction action="commit";
    	}

    	var out = {
    		"success":true,
    		"data": new serializer().serializeEntity(versionSetting),    		
    	}    	

    	variables.fw.setView('version_settings.list');
    	return out;
	}

	public void function delete( rc ) {
      
	}

	public struct function new( images_id ){

		var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(images_id).elseThrow("Could not load the app id #images_id#");

    	var out = {
    		"success":true,
    		"data": new serializer().serializeEntity(Image, {versionSettings:{}}),
    		"view_state":{
    			"new":true
    		}
    	}
    	variables.fw.setView('version_settings.list');
    	return out;
	}
	
}
