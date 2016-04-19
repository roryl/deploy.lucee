import deploy.model.providerMessage;
component {

	public function init(){
		return this;
	}

	public providerMessage function createInstance(){

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
			data:{
				id:vm.droplet.id,
				name:vm.droplet.name,
				memory:vm.droplet.memory,
				vcpus:vm.droplet.vcpus,
				disk:vm.droplet.disk,
				host:"1.2.3.4"
			},
			originalResponse:vm
		})
		return message;
	}

	public array function listInstances(){

	}

	public instance function getInstance(required instanceId){

	}

	public function createLoadBalancer(){
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
			data:{
				id:vm.droplet.id,
				name:vm.droplet.name,
				memory:vm.droplet.memory,
				vcpus:vm.droplet.vcpus,
				disk:vm.droplet.disk,
				host:"1.2.3.5"
			},
			originalResponse:vm
		})
		return message;
	}

	public function getLoadBalancer(required instance id){
		
	}

}