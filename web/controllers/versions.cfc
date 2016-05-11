import web.vendor.serializer.serializer;
component accessors="true" {    
	
	public any function init( fw ) {
		variables.fw = fw;
		return this;
	}

	public struct function new( apps_id ){
		var Deploy = variables.fw.getDeploy();
		var App = Deploy.getAppById(apps_id).elseThrow("Could not load the app #apps_id#");
		var DefaultImage = App.getDefaultImage();
		var versionSettings = DefaultImage.getVersionSettings();

		var out = {
			"success":true,
			"data":{
				"app":new serializer().serializeEntity(App),
				"current_version":new serializer().serializeEntity(App.getCurrentVersion(), {semver:{}}),
				"latest_version":new serializer().serializeEntity(App.getLatestVersion(), {semver:{}}),
				"version_settings":new serializer().serializeEntity(VersionSettings)				
			}
		}

		return out;
	}
	
	public struct function list( rc ) {
      
	}

	public struct function create( required numeric apps_id,
								   struct version_settings={},
								   required string increment ) {		
		var Deploy = variables.fw.getDeploy();
		var App = Deploy.getAppById(apps_id).elseThrow("Could not load the app #apps_id#");
		var LatestVersion = App.getLatestVersion();
		var LatestSemver = LatestVersion.getSemver();
		
		switch(increment){
			case "major":
				newSemver = LatestSemver.incrementMajor();
			break;

			case "minor":
				newSemver = LatestSemver.incrementMinor();
			break;

			case "patch":
				newSemver = LatestSemver.incrementPatch();
			break;

			default:
				throw("Could not increment the version because the submission was not correct. Must be major, minor or patch");
			break;
		}

		transaction {
			var newVersionThrowable = App.createVersion(newSemver, version_settings);
			if(newVersionThrowable.threw()){				
				transaction action="rollback";
				newVersionThrowable.rethrow();
			} else {
				var out = {
					"success":true,
					"new_version":new serializer().serializeEntity(newVersionThrowable.get())
				}
				transaction action="commit";
			}
			
		}
    	return out;
	}

	public struct function read( rc ) {
      
	}

	public struct function update( rc ) {
      
	}

	public struct function delete( rc ) {
      
	}
	
}
