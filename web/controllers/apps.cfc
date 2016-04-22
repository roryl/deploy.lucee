import web.vendor.serializer.serializer;
import web.model.apps;
component accessors="true" {    
	
	public any function init( fw ) {	
		// writeDump(request);	
		variables.fw = fw;
		return this;
	}

	public function new(name="",
						domain_name="",
						provider="",
						step="0",
						balancer,
						submit=false,
						image_name,
						image=[],
						back=false){

		var submit = arguments.submit;
		var back = arguments.back;
		var step = arguments.step;
		structDelete(arguments,"step");
		structDelete(arguments,"submit");
		structDelete(arguments,"back");

		var Deploy = variables.fw.getDeploy();

		if(back){
			step = step - 2;
		}


		// writeDump(form);
		// writeDump(arguments);
		// abort;
		// 
		if(step == "0"){
			var out = {
				success:true,
				data:{
					next_step:"/index.cfm/apps/new##balancer",
					step:"1",
					step_1:true			
				}
			}	
		}
		else if(step == "1"){
			var apps = new web.model.apps(Deploy);
			apps.populate(arguments);
			if(apps.isValid()){			
				var out = {
					success:true,
					data:{
						balancer_options:apps.getBalancerOptions(),
						image_options:apps.getImageOptions(),
						next_step:"/index.cfm/apps/new##instance",
						step_1_complete:true,
						step:"2",
						step_2:true			
					}
				}		
				// writeDump(out);	
			} else {
				var out = {
					success:false,
					data:{
						step:"1",
						step_1:true,
						errors:apps.getErrors()
					}
				}
			}			
		} else if(step == "2"){
			var apps = new web.model.apps(Deploy);
			apps.populate(arguments);
			// writeDump(apps);
			if(apps.isValid()){		
				
				var out = {
					success:true,
					data:{
						balancer_options:apps.getBalancerOptions(),
						image_options:apps.getImageOptions(),						
						next_step:"/index.cfm/apps/new##review",
						step:"3",
						step_1_complete:true,
						step_2_complete:true,
						step_3:true			
					}
				}	
				// writeDump(out);
				// writeDump(form);
			} else {
				var out = {
					success:false,
					data:{
						step:"2",
						step_2:true,
						errors:apps.getErrors()
					}
				}
			}
		} else if(step == "3"){
			var apps = new web.model.apps(Deploy);
			apps.populate(arguments);
			// writeDump(apps);
			// abort;
			if(apps.isValid()){
				var out = {
					success:true,
					data:{
						balancer_options:apps.getBalancerOptions(),
						image_options:apps.getImageOptions(),	
						next_step:"/index.cfm/apps",						
						step:"4",
						step_1_complete:true,
						step_2_complete:true,
						step_3_complete:true,
						step_4:true			
					}
				}	
			} else {
				var out = {
					success:false,
					data:{
						step:"3",
						step_3:true,
						errors:apps.getErrors()
					}
				}
			}
		} else if(step == "4"){
			// writeDump(form);
			// abort;
			// forward
			// template="/index.cfm/apps" ;
		}
		else {
			var out = {
					success:false,
					message:"Invalid request"
				}	
			return out;
		}

		for(var key in arguments){
			out.data[key] = arguments[key];
		}

		// writeDump(out);

		return out;
	}

	private function serializeApp(required app){

		var app = arguments.app;
		var out = new serializer().serializeEntity(app, {
			currentVersion:{
				semver:{

				}
			},
			versions:{semver:{}},
			defaultImage:{
				imageSettings:{}
			}
		});
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
								   image_name,
								   image={},
								   goto_success = "/index.cfm",
								   back=false) {
		
		// writeDump(arguments);
		// abort;
		var Deploy = variables.fw.getDeploy();
		transaction {
			var app = Deploy.createApp(name, domain_name, provider);
			entitySave(app);
			transaction action="commit";			
		}

		if(!image.isEmpty()){
			transaction {
				app.createImage(image_name, image)
				transaction action="commit";				
			}
		}		

		var data = {
			success:true,
			goto:"/index.cfm/apps/#app.getId()#",
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
