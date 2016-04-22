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

	public struct function read( required numeric id ) {
    	
    	var Deploy = variables.fw.getDeploy();
    	var Image = Deploy.getImageById(id);
    	
    	if(!Image.exists()){
    		throw("Image not found");
    	} else {

    		Image = Image.get();
    		var App = Image.getApp();
    		var Images = new web.model.images(app);
    		
    		// writeDump(Image.getSettingsAsStruct());
    		Images.populate({name:image.getName(), image:Image.getSettingsAsStruct()})
    		// writeDump(Images.getImageOptions());

	    	var out = {
	    		success:true,
	    		data:{
	    			name:image.getName(),
	    			image_options:Images.getImageOptions()
	    		}
	    	}
	    	return out;
    		
    	}

	}

	public void function update( rc ) {
      
	}

	public void function delete( rc ) {
      
	}
	
}
