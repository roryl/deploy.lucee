component persistent="true" table="migration" {
	property name="id" fieldtype="id" generator="native";
	property name="versionFrom" fieldtype="one-to-one" cfc="version" fkcolun="version_from_id";
	property name="versionTo" fieldtype="one-to-one" cfc="version" fkcolun="version_to_id";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="status";
	property name="migrationSteps" fieldtype="one-to-many" cfc="migrationStep" fkcolumn="migration_id" singularname="migrationStep";
	property name="instances" fieldtype="one-to-many" cfc="instance" fkcolumn="migration_id" singularname="instance";
	property name="removedInstances" fieldtype="one-to-many" cfc="instance" fkcolumn="migration_removed_instance_id" singularname="removedInstance";

	/**
	 * Steps to performa  migration
	 * ----------------
	 *
	 * 		Check if the version change is major, minor or patch
	 *   		MAJOR
	 *   			Put up maintenance page
	 *   			Perform Model Migration
	 *   			Spin up VMs and smoke test against model
	 *   			Remove existing VMs from load balancer
	 *   			Add new VMs to load balance
	 *   			Remove maintenance page
	 *   		MINOR
	 *   			Perform Model Migration
	 *   			Run Smoke test against existing VM in load balancer
	 *   			Spin up new VM and run smoke test
	 *   			Add new VM to load balance
	 *   			Remove an Old VM from Load balancer
	 *   			Repeat process for remaining VMs
	 *   		PATCH
	 *   			Spin up new VM and run smoke test
	 *   			Add new VM to load balancer
	 *   			Remove old VM from load balancer
	 * 	
	 * 
	 * Create a new instance on the new version
	 * Check that 
	 */
	
	public function run(){

		var migrationSteps = this.getMigrationSteps();
		this.setStatus("running");
		for(step in migrationSteps){
			try {
				step.setStatus("running");
				result = step.run();
				if(result){
					step.setStatus("success");
				} else {
					step.setStatus("failed");
				}
			} catch(any e){
				throw(e);
			}

		}
		this.setStatus("success");
		return true;
	}

	public semver function getVersionChange(){
		return this.getVersionFrom().getSemver().diff(this.getVersionTo().getSemver());
	}

}