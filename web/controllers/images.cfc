import web.vendor.serializer.serializer;
import web.model.images;
component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}
	
	public void function list( rc ) {
      
	}

	public void function create( rc ) {
      
	}

	public struct function read( required numeric id,
								 deployed_response={}
								 ) {   	        

    	var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(id);
    	
    	if(!Image.exists()){
    		throw("Image not found");
    	} else {

    		Image = Image.get();
    		var App = Image.getApp();
    		var Images = new web.model.images(app);
    		
    		// writeDump(Image.getSettingsAsStruct());
    		// writeDump(Image);
    		// abort;
    		Images.populate({name:image.getName(), image_settings:Image.getSettingsAsStruct()})
    		// writeDump(Images.getImageOptions());

	    	var out = {
	    		"success":true,
	    		"data":{
	    			"image":new serializer().serializeEntity(Image, {app:{},instanceTests:{}}),
	    			"image_options":Images.getImageOptions(),
	    			"base_script":Image.getBaseScript(),
                    "deployed_response":deployed_response,                    
	    		}
	    	}
	    	return out;    		
    	}
	}

	public struct function update( required numeric id,
								 required struct image_settings,
								 required string base_script,
								 required string name ) {
    	// writeDump(arguments);
    	// abort;
        writeLog(file="deploy", text="update #now()#");
    	var Deploy = variables.fw.getDeploy();    

    	var ImageOptional = Deploy.getImageById(id);
    	if(!ImageOptional.exists()){
    		throw("Image not found");
    	} else {
		    var Image = ImageOptional.get();
    		var App = Image.getApp();

    		var ImagesForm = new web.model.images(app);    		
    		ImagesForm.populate(arguments);
    		// writeDump(ImagesForm.getImage());
    		// abort;

    		if(!ImagesForm.isValid()){
    			throw("the form submission was not valid");
			} else {
	    		transaction {
		    		Image.setName(ImagesForm.getName());
		    		Image.putAllSettingsKeyValues(ImagesForm.getImage_settings());
		    		Image.setBaseScript(trim(base_script));
	    			transaction action="commit";
	    		}
			}
    	}

    	var out = {
    		"success":true,
    		"data":{
    			"id":image.getId(),
    			"name":imagesForm.getName(),
    			"image_options":ImagesForm.getImageOptions()
    		}
    	}
    	// variables.fw.redirect("/index.cfm/images/#Image.getId()#");
    	return out;
	}

	public void function delete( rc ) {
      
	}

	public struct function deploy( required numeric id ){
		
		var Deploy = variables.fw.getDeploy();
		var ImageOptional = Deploy.getImageById(id);
		if(!ImageOptional.exists()){
    		throw("Image not found");
    	} else {
    		var Image = ImageOptional.get();
            transaction {
        		var InstanceThrowable = Image.createInstanceTest();
                if(InstanceThrowable.threw()){
                    transaction action="rollback";
                    InstanceThrowable.rethrow();
                } else {
                    transaction action="commit";
                    out = {
                        "action":"deploy",
                        "success":true,
                        "message":"The test instance was successfully created",
                        "data":new serializer().serializeEntity(InstanceThrowable.get())
                    };
                    return out;         
                }              
            }    		
    	}
	}
	
}
