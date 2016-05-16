import deploy.model.providerMessage;
component {

	public function init(required struct secureKeys){
		variables.secureKeys = arguments.secureKeys;		
		return this;
	}

	public boolean function validateSettings(){
		return true;
	}

	public boolean function destroyInstance(required id){
		var droplet = new do(variables.secureKeys.authorization).destroyDroplet(arguments.id);	
		if(isBoolean(droplet) and droplet == true){
			return droplet;
		} else {
			writeDump("Could not destory the droplet, this should not have happened");
			writeDump(droplet);
			abort;
		};		
	}

	public function getInstance(required id){
		var droplet = new do(variables.secureKeys.authorization).getDroplet(arguments.id);
		
		if(structKeyExists(droplet,"droplet")){
			droplet = droplet.droplet;
		} else {
			writeDump(droplet);
			abort;
		}		

		try {
			var data = {
				instanceId:droplet.id,
				name:droplet.name,
				memory:droplet.memory,
				vcpus:droplet.vcpus,
				disk:droplet.disk,
				status:droplet.status,
				host:""
			}

			if(droplet.networks.v4.len() GT 0){
				data.host = droplet.networks.v4[1].ip_address;
			}

			var message = new providerMessage(argumentCollection={
				success:true,
				data:data,
				originalResponse:droplet
			});

			return message;

		} catch(any e){
			writeDump(droplet);
			writeDump(e);
			abort;
		}
	}

	public providerMessage function createInstance(required string name, required struct imageOptions, baseScript=""){		
		var args = {
			name:name,
			size:imageOptions.size,
			region:imageOptions.region,
			image:imageOptions.image,
			user_data:baseScript
		}

		// if(trim(baseScript).len() GT 0){			
		// 	args.user_data = baseScript;
		// }

		// writeDump(args);
		// abort;
		var droplet = new do(variables.secureKeys.authorization).createDroplet(argumentCollection=args);

		if(structKeyExists(droplet,"droplet")){
			droplet = droplet.droplet;
		} else {
			writeDump("Error creating the droplet");
			writeDump(droplet);
			abort;
		}
		try {
			var message = new providerMessage(argumentCollection={
				success:true,
				data:{
					instanceId:droplet.id,
					name:droplet.name,
					memory:droplet.memory,
					vcpus:droplet.vcpus,
					disk:droplet.disk,
					status:droplet.status,
					host:""
				},
				originalResponse:droplet
			})			
		} catch(any e){
			writeDump(droplet);
			writeDump(e);
			abort;
		}

		return message;
	}

	public function getImageOptions(){
		var out = [
			{
				name:"Base Image",
				id:"image",
				options:[

					{
						id:"centos-7-2-x64",
						name:"CentOS"
					},
					{
						id:"centos-6-5-x64",
						name:"CentOS 6.5 x64"
					},
					{
						id:"ubuntu-14-04-x64",
						name:"Ubuntu"
					}				
				]
			},
			{
				name:"Image Size",
				id:"size",
				options: [

					{
						id:"512mb",
						name:"512 MB / 1 VCPU / 20GB"
					},
					{
						id:"1gb",
						name:"1 GB / 1 VCPU / 30GB"
					}


			        // "32gb",
			        // "16gb",
			        // "2gb",
			        // "1gb",
			        // "4gb",
			        // "8gb",
			        // "512mb",
			        // "64gb",
			        // "48gb"
			    ]
		    },
		    {
		    	name:"Region",
		    	id:"region",
				options:[

					{
						id:"nyc1",
						name:"New York City 1"
					},
					{
						id:"nyc2",
						name:"New York City 2"
					},
					{
						id:"sfo1",
						name:"San Francisco 1"
					},
					// "nyc1",
					// "nyc2",
					// "sfo1"
				]
			}		
		]
		return out;
	}

	public function getBalancer(required host, required password){
		return new balancer(arguments.host, arguments.password);
	}

	public function getBalancerOptions(){

		out = [
			{
				name:"type",
				id:"type",
				options:[
					{
						id:"single_mod_proxy",
						name:"Single Mod Proxy"
					},
					{
						id:"ha_mod_proxy",
						name:"HA Mod Proxy"
					}			
				]
			},
			{
				name:"Region",
				id:"region",
				options:[

					{
						id:"nyc1",
						name:"New York City 1"
					},
					{
						id:"nyc2",
						name:"New York City 2"
					},
					{
						id:"sfo1",
						name:"San Francisco 1"
					},					
				]
			},
			{
				name:"Image Size",
				id:"size",
				options: [

					{
						id:"512mb",
						name:"512 MB / 1 VCPU / 20GB"
					},
					{
						id:"1gb",
						name:"1 GB / 1 VCPU / 30GB"
					}			     
			    ]
		    },
		]
		return out;
	}

	public providerMessage function deployLoadBalancer(required string name, required struct balancerOptions){
		
		var options = {			
			size:balancerOptions.size,
			region:balancerOptions.region,
			image:"centos-7-2-x64",			
		}

		var fileName = createUUID();
		var userDataOut = fileOpen(fileName, "append");
		var password = toBase64(createUUID());
		
		/*
		Create the basic user data information
		 */
		var userData = fileOpen("scripts/balancer_user_data.sh");
		while(!fileIsEOF(userData)){
			var line = fileReadLine(userData);
			line = replaceNoCase(line, "{{password}}", password, "all");
			fileWriteLine(userDataOut, line);
			// echo(line);
		}		
		fileWriteLine(userDataOut, "");
		fileClose(userData);
		
		/*
		Append out the httpd.conf file
		 */
		// var httpd = fileOpen("scripts/httpd.conf");
		// while(!fileIsEOF(httpd)){
		// 	var line = fileReadLine(httpd);
		// 	line = replaceNoCase(line, '"', '\"', "all");
		// 	fileWriteLine(userDataOut, 'echo "#line#" >> /etc/httpd/conf/httpd.conf');
		// }
		// fileWriteLine(userDataOut, "");
		// fileClose(httpd);

		var script = toBase64(fileRead("scripts/httpd.conf"));
		fileWriteLine(userDataOut, 'echo "#script#" | base64 -d >> /etc/httpd/conf/httpd.conf');
		
		
		var script = toBase64(fileRead("scripts/updatelb.sh"));
		fileWriteLine(userDataOut, "echo #script# | base64 -d >> /home/balancer/bin/updatelb.sh");
		fileClose(userDataOut);
		// abort;
		var PrimaryDropletProviderMessage = this.createInstance(arguments.name & "-primary", options, fileRead(fileName));
		var SecondaryDropletProviderMessage = this.createInstance(arguments.name & "-secondary", options, fileRead(fileName));
		fileDelete(fileName);		

		var out = {
			instances:[],
			password:password
		};
		
		if(PrimaryDropletProviderMessage.isSuccess() and secondaryDropletProviderMessage.isSuccess()){

			out.instances.append(PrimaryDropletProviderMessage.getData());
			out.instances.append(SecondaryDropletProviderMessage.getData());
			
			var balancerProviderMessage = new providerMessage(
				success:true,
				data:out,
				originalResponse:[
					PrimaryDropletProviderMessage.getOriginalResponse(),
					SecondaryDropletProviderMessage.getOriginalResponse()
				]
			);

			return balancerProviderMessage;
		} else {
			writeDump("Error executing balancer droplet creation");
			writeDump(DropletProviderMessage.getOriginalResponse());
			abort;
		}


		// var message = new providerMessage(argumentCollection={
		// 	success:true,
		// 	data:[
		// 		{
		// 			instanceId:vm.droplet.id,
		// 			name:vm.droplet.name,
		// 			memory:vm.droplet.memory,
		// 			vcpus:vm.droplet.vcpus,
		// 			disk:vm.droplet.disk,
		// 			host:"1.2.3.5"
		// 		},
		// 		{
		// 			instanceId:vm.droplet.id,
		// 			name:vm.droplet.name,
		// 			memory:vm.droplet.memory,
		// 			vcpus:vm.droplet.vcpus,
		// 			disk:vm.droplet.disk,
		// 			host:"1.2.3.6"
		// 		}
		// 	],
		// 	originalResponse:vm
		// })		
	}

	public array function getSecureKeys(){
		var out = [
			{
				id:"authorization",
				name:"Authorization Token",
				required:true
			}
		]
		return out;
	}

}