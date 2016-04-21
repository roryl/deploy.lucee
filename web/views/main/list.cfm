<!--- <cfdump var="#rc#"> --->
<cf_handlebars context="#rc#">
<div class="row">

<article class="col-md-12 main-content" role="main">
	
	<header>
	<h1>Apps Overview</h1>
	<table class="table">	
	<thead class="text-center">
	<tr>
		<th>Domain</th>
		<th>## of Instances</th>
		<th>Version</th>
		<th>Last Migrated</th>
		<th>Manage</th>
	</tr>
	</thead >
	<tbody>
		{{#each DATA}}
		<tr>
			<td>{{domain_name}}</td>
			<td>test</td>
			<td>{{current_version.semver.string}}</td>
		</tr>
		{{/each}}
	<!--- <cfloop array="#rc.connectors#" item="connector" index="i">
		<tr>
			<td scope="row">
				<cfswitch expression="#connector.status#">
					<cfcase value="success">
						<span class="glyphicon glyphicon-ok-sign" style=""></span>						
					</cfcase>
					<cfcase value="failed">
						<span class="glyphicon glyphicon-warning-sign" style=""></span>						
					</cfcase>
					<cfcase value="alert">
						<span class="glyphicon glyphicon-exclamation-sign" style=""></span>						
					</cfcase>
				</cfswitch>
			</td>
			<td>#connector.datasource.name#</td>
			<td>#connector.api.name#</td>
			<td>#dateTimeFormat(now(), "mm-dd-yy - hh:mm:ss")#</td>
			<td>
				<a href="/connectors/#connector.connector_id#" class="btn btn-primary btn-round">Configure</a>
				<button class="btn btn-primary btn-round">Status</button>
			</td>

		</tr>			
	</cfloop>	 --->
	</tbody>
</table>
	</header>
</article>
<!-- END Main content -->
</div>
</cf_handlebars>
