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
			}
		]
		return out;
	}

	public providerMessage function deployLoadBalancer(required struct balancerOptions){
		var vm = {
		  "droplet": {
		    "id": 3164494,
		    "name": "example.com",
		    "memory": 512,
		    "vcpus": 1,
		    "disk": 20,
		    "locked": true,
		    "status": "new",
		    "kernel": {
		      "id": 2233,
		      "name": "Ubuntu 14.04 x64 vmlinuz-3.13.0-37-generic",
		      "version": "3.13.0-37-generic"
		    },
		    "created_at": "2014-11-14T16:36:31Z",
		    "features": [
		      "virtio"
		    ],
		    "backup_ids": [

		    ],
		    "snapshot_ids": [

		    ],
		    "image": {
		    },
		    "size": {
		    },
		    "size_slug": "512mb",
		    "networks": {
		    },
		    "region": {
		    },
		    "tags": [

		    ]
		  },
		  "links": {
		    "actions": [
		      {
		        "id": 36805096,
		        "rel": "create",
		        "href": "https://api.digitalocean.com/v2/actions/36805096"
		      }
		    ]
		  }
		}

		var message = new providerMessage(argumentCollection={
			success:true,
			data:[
				{
					instanceId:vm.droplet.id,
					name:vm.droplet.name,
					memory:vm.droplet.memory,
					vcpus:vm.droplet.vcpus,
					disk:vm.droplet.disk,
					host:"1.2.3.5"
				},
				{
					instanceId:vm.droplet.id,
					name:vm.droplet.name,
					memory:vm.droplet.memory,
					vcpus:vm.droplet.vcpus,
					disk:vm.droplet.disk,
					host:"1.2.3.6"
				}
			],
			originalResponse:vm
		})
		return message;
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