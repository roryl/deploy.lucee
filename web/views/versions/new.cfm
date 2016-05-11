<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<form method="post" action="/index.cfm/apps/{{data.app.id}}/versions">
			<input type="hidden" name="goto" value="/index.cfm/apps/{{data.app.id}}" />		
		<header>
			<div class="row">
				<div class="col-lg-12">
						<a class="btn btn-xs btn-primary btn-outline" href="/index.cfm/apps/{{data.app.id}}"><i class="glyphicon glyphicon-chevron-left"></i> Back to App</a>
						<h1>New Version </h1>
						<p>Creates a new released version for your application. Specify the image variables for the version and the level to increment by</p>			
				</div>
			</div>
		</header>
		<div class="row">			
			<div class="col-lg-4">
				<h4>Define New Version</h4> 
				<strong>Current Version:</strong> {{data.current_version.semver.string}} <br />
				<h5>Increment By</h5>
				<input type="radio" name="increment" value="major">
				<strong>Major</strong> (Backwards incompatible model migration, downtime required) <br />
				<input type="radio" name="increment" value="minor">
				<strong>Minor</strong> (Backwards compatible model migration, no downtime required)<br />
				<input type="radio" name="increment" value="patch" checked="true">
				<strong>Patch</strong> (Patch level change, no model migration, no downtime required) <br />
			</div>
			<div class="col-lg-6">
				<h4>Version Settings:</h4>
				{{#each data.version_settings}}
					{{key}}: <input name="version_settings.{{key}}" value="{{value}}" /><br />
				{{/each}}
			</div>
			
		</div>		
		<div class="row">
			<div class="col-lg-12">
				<button type="submit" value="create_version" class="btn btn-success">Create Version</button>
			</div>
		</div>
		</form>
			
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
