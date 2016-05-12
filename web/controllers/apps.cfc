import web.vendor.serializer.serializer;
import web.model.apps;
component accessors="true" {    
	
	public any function init( fw ) {	
		// writeDump(request);	
		variables.fw = fw;
		return this;
	}

	private function serializeApps(required array apps){
		var out = [];
		for(var app in apps){
			out.append(serializeApp(app));
		}
		return out;
	}

	private function serializeApp(required app app){

		var app = arguments.app;
		// writeDump(app.getBalancer());
		// abort;
		var out = new serializer().serializeEntity(app, {
			currentVersion:{
				semver:{

				}
			},
			versions:{semver:{}},
			defaultImage:{
				imageSettings:{}
			},
			balancer:{
				balancerInstances:{},
				instances:{
					version:{
						semver:{}
					}
				}
			},
			instances:{},			
		});
		out.inactive_instances = new serializer().serializeEntity(app.getInactiveInstances(), {
			version:{
				semver:{}
			}
		})
		return out;
	}



	public function new(name="",
						domain_name="",
						provider="",
						current_step_submitted="none",
						balancer={},
						submit=false,
						struct secure_key={},
						image_name,
						image={},
						back=false){
		// writeDump(arguments);
		// abort;
		var submit = arguments.submit;
		var back = arguments.back;
		var current_step_submitted = arguments.current_step_submitted;
		structDelete(arguments,"step");
		structDelete(arguments,"submit");
		structDelete(arguments,"back");

		var Deploy = variables.fw.getDeploy();

		/*
		The order of forms that we want to display to the user
		 */		
		steps = [
			"none",
			"select_provider",
			"secure_keys",
			"select_balancer",
			"configure_image",
			"review_finalize"
		];

		if(back){
			var order = steps.findNoCase(current_step_submitted);
			order = order -2;
			current_step_submitted = steps[order];			
		}

		var apps = new web.model.apps(Deploy);
		apps.populate(arguments);

		"select_provider" = {
			providers:apps.getProviders(),		
			next_step:"/index.cfm/apps/new##securekeys",			
			current_step:"select_provider",				
			select_provider:{
				show:true
			}
		}

		"secure_keys" = {
			secure_keys_options:apps.getSecureKeyOptions(),
			providers:apps.getProviders(),
			next_step:"/index.cfm/apps/new##balancer",						
			current_step:"secure_keys",							
			select_provider:{complete:true},
			secure_keys:{show:true}	
		}

		"select_balancer" = {
			secure_keys_options:apps.getSecureKeyOptions(),
			providers:apps.getProviders(),
			balancer_options:apps.getBalancerOptions(),
			image_options:apps.getImageOptions(),
			next_step:"/index.cfm/apps/new##instance",						
			current_step:"select_balancer",							
			select_provider:{complete:true},
			secure_keys:{complete:true},
			select_balancer:{show:true}	
		}

		"configure_image" = {
			secure_keys_options:apps.getSecureKeyOptions(),
			providers:apps.getProviders(),
			balancer_options:apps.getBalancerOptions(),
			image_options:apps.getImageOptions(),						
			next_step:"/index.cfm/apps/new##review",
			current_step:"configure_image",							
			select_provider:{complete:true},
			secure_keys:{complete:true},
			select_balancer:{complete:true},
			configure_image:{show:true}
		}

		"review_finalize" = {
			secure_keys_options:apps.getSecureKeyOptions(),
			providers:apps.getProviders(),
			balancer_options:apps.getBalancerOptions(),
			image_options:apps.getImageOptions(),	
			next_step:"/index.cfm/apps",						
			current_step:"review_finalize",						
			select_provider:{complete:true},
			secure_keys:{complete:true},
			select_balancer:{complete:true},
			configure_image:{complete:true},
			review_finalize:{show:true}
		}

		var out = {}

		if(current_step_submitted == "none"){			
			out.success=true;
			out.data=select_provider			
		}

		if(current_step_submitted == "select_provider"){
			if(apps.isValid()){
				out.success=true;
				out.data=secure_keys
			} else {
				out.success=false;
				out.data=select_provider;
				out.data.errors = apps.getErrors();
			}
		}

		if(current_step_submitted == "secure_keys"){
			if(apps.isValid()){
				out.success=true;
				out.data=select_balancer
			} else {
				out.success=false;
				out.data=select_provider;
				out.data.errors = apps.getErrors();
			}
		}

		if(current_step_submitted == "select_balancer"){
			if(apps.isValid()){
				out.success=true;
				out.data=configure_image
			} else {
				out.success=false;
				out.data=secure_keys;
				out.data.errors = apps.getErrors()
			}
		}

		if(current_step_submitted == "configure_image"){
			if(apps.isValid()){
				out.success=true;
				out.data=review_finalize;
			} else {
				out.success=false;
				out.data=configure_image;
				out.data.errors = apps.getErrors()
			}
		}

		// writeDump(out);
		// abort;

		// writeDump(form);
		// writeDump(arguments);
		// abort;
		// 
		// if(step == "0"){
		// 	var apps = new web.model.apps(Deploy);
		// 	var out = {
		// 		success:true,
		// 		data:{
		// 			providers:apps.getProviders(),		
		// 			next_step:"/index.cfm/apps/new##balancer",
		// 			step:"1",					
		// 			select_provider:{
		// 				show:true
		// 			}		
		// 		}
		// 	}	
		// }
		// else if(step == "1"){
		// 	var apps = new web.model.apps(Deploy);
		// 	apps.populate(arguments);
		// 	if(apps.isValid()){			
		// 		var out = {
		// 			success:true,
		// 			data:{
		// 				secure_keys_options:apps.getSecureKeyOptions(),
		// 				providers:apps.getProviders(),
		// 				balancer_options:apps.getBalancerOptions(),
		// 				image_options:apps.getImageOptions(),
		// 				next_step:"/index.cfm/apps/new##instance",						
		// 				step:"2",						
		// 				select_provider:{complete:true},
		// 				select_balancer:{show:true}			
		// 			}
		// 		}		
		// 		// writeDump(out);	
		// 	} else {
		// 		var out = {
		// 			success:false,
		// 			data:{
		// 				step:"1",						
		// 				providers:apps.getProviders(),
		// 				errors:apps.getErrors(),
		// 				select_provider:{show:true}
		// 			}
		// 		}
		// 	}			
		// } else if(step == "2"){
		// 	var apps = new web.model.apps(Deploy);
		// 	apps.populate(arguments);
		// 	// writeDump(apps);
		// 	if(apps.isValid()){		
				
		// 		var out = {
		// 			success:true,
		// 			data:{
		// 				providers:apps.getProviders(),
		// 				balancer_options:apps.getBalancerOptions(),
		// 				image_options:apps.getImageOptions(),						
		// 				next_step:"/index.cfm/apps/new##review",
		// 				step:"3",						
		// 				select_provider:{complete:true},
		// 				select_balancer:{complete:true},
		// 				configure_image:{show:true}
		// 			}
		// 		}	
		// 		// writeDump(out);
		// 		// writeDump(form);
		// 	} else {
		// 		var out = {
		// 			success:false,
		// 			data:{
		// 				step:"2",						
		// 				errors:apps.getErrors()
		// 			}
		// 		}
		// 	}
		// } else if(step == "3"){
		// 	var apps = new web.model.apps(Deploy);
		// 	apps.populate(arguments);
		// 	// writeDump(apps);
		// 	// abort;
		// 	if(apps.isValid()){
		// 		var out = {
		// 			success:true,
		// 			data:{
		// 				providers:apps.getProviders(),
		// 				balancer_options:apps.getBalancerOptions(),
		// 				image_options:apps.getImageOptions(),	
		// 				next_step:"/index.cfm/apps",						
		// 				step:"4",						
		// 				select_provider:{complete:true},
		// 				select_balancer:{complete:true},
		// 				configure_image:{complete:true},
		// 				review_finalize:{show:true}
		// 			}
		// 		}	
		// 	} else {
		// 		var out = {
		// 			success:false,
		// 			data:{
		// 				step:"3",						
		// 				errors:apps.getErrors()
		// 			}
		// 		}
		// 	}
		// } else if(step == "4"){
		// 	// writeDump(form);
		// 	// abort;
		// 	// forward
		// 	// template="/index.cfm/apps" ;
		// }
		// else {
		// 	var out = {
		// 			success:false,
		// 			message:"Invalid request"
		// 		}	
		// 	return out;
		// }

		for(var key in arguments){
			out.data[key] = arguments[key];
		}

		// writeDump(out);

		return out;
	}	
	
	public struct function list() {
    	var Deploy = variables.fw.getDeploy();
    	// writeDump(Deploy);

    	result = {
    		success:"true",
    		data:serializeApps(Deploy.getApps() ?: [])
    	}
    	return result;
	}

	public struct function create( required name,
								   required domain_name,
								   required provider="sample",
								   image_name,
								   image={},
								   balancer={},
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

		if(!balancer.isEmpty()){
			transaction {
				app.createBalancer(balancer);
				transaction action="commit";
			}
		}

		var data = {
			success:true,			
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
