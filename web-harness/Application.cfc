/**
* Copyright Since 2005 Ortus Solutions, Corp
* www.ortussolutions.com
**************************************************************************************
*/
component{
	this.name = "A TestBox Runner Suite " & hash( getCurrentTemplatePath() );
	// any other application.cfc stuff goes below:
	this.sessionManagement = true;

	// any mappings go here, we create one that points to the root called test.
	this.mappings[ "/tests" ] = getDirectoryFromPath( getCurrentTemplatePath() );

	currentPath = getDirectoryFromPath(getCurrentTemplatePath());
	this.mappings[ "/deploy" ] = expandPath(currentPath & "../deploy");
	this.mappings[ "/web" ] = expandPath(currentPath & "../web");
	

	// this.mappings["/deploy"] = getDirectoryFromPath( get)
	
	this.datasources["deploy"] = {
		  class: 'org.gjt.mm.mysql.Driver'
		, connectionString: 'jdbc:mysql://192.168.33.10:3306/deploy?useUnicode=true&characterEncoding=UTF-8&useLegacyDatetimeCode=false&allowMultiQueries=true'
		, username: 'deploy'
		, password: "123456"
	};

	this.datasource = "deploy";
	this.ormenabled = true;
	this.ormsettings={cfclocation=["/deploy/model"],useDBforMapping=false,dbcreate="update"};
	this.ormsettings.savemapping = false;
	this.ormsettings.logsql="true";
	this.ormsettings.flushAtRequestEnd = false;
	this.ormsettings.autoManageSession=false;
	// this.ormsettings.dialect = "MySQLwithInnoDB";
	// any orm definitions go here.

	// request start
	public boolean function onRequestStart( String targetPage ){
		return true;
	}
}