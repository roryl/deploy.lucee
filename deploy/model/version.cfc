component persistent="true" table="version"{
	property name="id" fieldtype="id" generator="native";
	property name="semver" notnull="true";
	property name="app" fieldtype="many-to-one" cfc="app" fkcolumn="app_id" inverse="true";
	property name="currentApp" fieldtype="one-to-one" cfc="app" mappedby="currentVersion";
	property name="migrationFrom" fieldtype="one-to-one" cfc="migration" mappedby="versionFrom";
	property name="migrationTo" fieldtype="one-to-one" cfc="migration" mappedby="versionTo";
	property name="instances" fieldtype="one-to-many" cfc="instance" singularname="instance";

	public void function setSemver(required semver Semver){
		variables.semver = arguments.semver.toString();
	}

	public semver function getSemver(){
		return new semver(variables.semver);
	}
}