<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		
		<header>
			<div class="row">
				<div class="col-lg-8">
						<a class="btn btn-xs btn-primary btn-outline" href="/index.cfm/apps/{{data.id}}"><i class="glyphicon glyphicon-chevron-left"></i> Back to App</a>
						<h1>Edit App Custom Version Settings</h1>
						<p>The App version settings are the key/values that must be set on each new version created. 
						They are usually values that change for every release, like the github repo address. Version Settings can
						be used in the image install script to setup the image properly for the version.</p>		
				</div>
			</div>
		</header>
		<div class="row">			
			
			<div class="col-md-8">
				

				<div class="row">
					<strong>
					<div class="col-lg-3">Key</div>
					<div class="col-lg-3">Value</div>
					<div class="col-lg-3">Default</div>
					<div class="col-lg-3">Actions</div>
					</strong>
				</div>
	
				{{#if view_state.new}}
				<div class="row alert alert-info">
					<form method="post" action="/index.cfm/apps/{{data.id}}/version_settings/{{#if view_state.version_setting.id}}{{view_state.version_setting.id}}{{/if}}" style="display:inline;">
					<div class="col-lg-3"><input type="text" class="form-control" name="key" placeholder="Setting Key" {{#if view_state.version_setting.key}}value="{{view_state.version_setting.key}}"{{/if}}></div>
					<div class="col-lg-3"><input type="text" class="form-control" name="value" placeholder="Setting Value" {{#if view_state.version_setting.value}}value="{{view_state.version_setting.value}}"{{/if}}></div>
					<div class="col-lg-3"><input type="text" class="form-control" name="default" placeholder="Default Value" {{#if view_state.version_setting.default}}value="{{view_state.version_setting.default}}"{{/if}}></div>
					<div class="col-lg-3">
						<input type="hidden" name="goto" value="/index.cfm/apps/{{data.id}}/version_settings" />
						<button type="submit" name="submit" class="btn btn-primary btn-xs" value="true">Save</button>						
						<a href="/index.cfm/apps/{{data.id}}/version_settings" class="btn btn-default btn-xs" value="true">Cancel</a>	
					</div>
					</form>
				</div>
				{{/if}}
	
				{{#each data.version_settings}}
				<div class="row">
					<div class="col-lg-3">{{key}}</div>
					<div class="col-lg-3">{{value}}</div>
					<div class="col-lg-3">{{default}}</div>
					<div class="col-lg-3">
						<a href="/index.cfm/apps/{{@root.data.id}}/version_settings/{{id}}" type="submit" name="submit" class="btn btn-primary btn-xs" value="true">Edit</a>
						<button type="submit" name="submit" class="btn btn-primary btn-xs" value="true">Delete</button>
					</div>
				</div>
				{{/each}}

				
			</div>
			
		</div>	
		<div class="row">
			<div class="col-lg-4">
				<a href="/index.cfm/apps/{{data.id}}/version_settings/new" type="submit" name="submit" class="btn btn-success" value="true">Add Setting</a>
			</div>
		</div>
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
