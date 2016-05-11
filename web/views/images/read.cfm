<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<form method="post" action="/index.cfm/images/{{data.image.id}}">
			<input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}" />
		
		<header>
			<div class="row">
				<div class="col-lg-12">
						<a class="btn btn-xs btn-primary btn-outline" href="/index.cfm/apps/{{data.image.app.id}}"><i class="glyphicon glyphicon-chevron-left"></i> Back to App</a>
						<h1>Edit Image </h1>				
				</div>
			</div>
		</header>
		<div class="row">			
			<div class="col-md-4">				
					<div class="form-group">
						<label for="image_name">Image Name</label>
						<p>Give your image a friendly name to refer to</p>
						<input type="text" class="form-control disabled" name="name" placeholder="friendly name" {{#if data.image.name}}value="{{data.image.name}}"{{/if}}>
					</div>

					<div class="form-group">
					{{#each data.image_options}}
					<label for="image_settings.{{id}}">{{name}}</label>
					<select class="form-control" name="image_settings.{{id}}" >
						>
						{{#each options}}
						<option value="{{id}}" {{#if selected}}selected{{/if}}>{{name}}</option>
						{{/each}}										
					</select>
					{{/each}}
					</div>
					<button type="submit" name="submit" class="btn btn-success" value="true">Save Changes</button>
								
			</div>
			<div class="col-md-8" role="main">
				
				<div class="tabs tabs-text">
				
					<!-- Nav tabs -->
					<ul class="nav nav-tabs text-left" role="tablist">
						<li role="presentation" class="{{#if view_state.script_tab}}active{{/if}}">
						<a href="#home3" aria-controls="home" role="tab" data-toggle="tab">Install Script</a>
						</li>
						<li role="presentation" class="{{#if view_state.version_tab}}active{{/if}}">
							<a href="#versions" aria-controls="versions" role="tab" data-toggle="tab">Image Versions</a>
						</li>

						<li role="presentation" class="{{#if view_state.setting_tab}}active{{/if}}">
							<a href="#version_settings" aria-controls="version_settings" role="tab" data-toggle="tab">Version Settings</a>
						</li>						
					</ul>

					<!-- Tab panes -->
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane fade in {{#if view_state.script_tab}}active{{/if}}" id="home3">
							<p>This shell script will be executed on creation of the image</p>
							<textarea name="base_script" style="width:100%; min-height:300px;">{{data.base_script}}</textarea>
						</div>
						<div role="tabpanel" class="tab-pane fade in {{#if view_state.version_tab}}active{{/if}}" id="versions">
							<p>These are the versions of your application that this image is used on.</p>
						</div>
						<div role="tabpanel" class="tab-pane fade in {{#if view_state.setting_tab}}active{{/if}}" id="version_settings">
							<p>Version settings are the key/values that must be set on each new version created. 
							They are usually values that change for every release, like the github repo address. Version Settings can
							be used in the image install script to setup the image properly for the version.</p>
							<div class="row">
								<strong>
								<div class="col-lg-3">Key</div>								
								<div class="col-lg-3">Default</div>
								<div class="col-lg-3">Actions</div>
								</strong>
							</div>
				
							{{#if view_state.add_setting}}
							<div class="row alert alert-info">
								<cf_zeroform name="save_setting" method="post" action="/index.cfm/images/{{data.image.id}}/version_settings/{{##if view_state.version_setting.id}}{{view_state.version_setting.id}}{{/if}}" style="display:inline;">				
									<div class="col-lg-3"><cf_input type="text" class="form-control" name="key" placeholder="Setting Key" value="{{##if view_state.version_setting.key}}{{view_state.version_setting.key}}{{/if}}" /></div>
									<div class="col-lg-3"><cf_input type="text" class="form-control" name="value" placeholder="Setting Value" value="{{##if view_state.version_setting.value}}{{view_state.version_setting.value}}{{/if}}" /></div>									
									<div class="col-lg-3">
										<cf_input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}/" />
										<cf_input type="hidden" name="preserve_response" value="version_setting_response" />
										<cf_button type="submit" name="submit" class="btn btn-primary btn-xs" value="true">Add New</cf_button>
										
										<cf_zeroform action="/index.cfm/images/{{data.image.id}}/read" method="post" name="cancel_setting">
											<cf_button name="cancel_setting" class="btn btn-default btn-xs" value="true">Cancel</cf_button>
										</cf_zeroform>
									</div>								
								</cf_zeroform>
							</div>
							{{/if}}
				
							{{#each data.image.version_settings}}
								{{#if edit}}
								<div class="row alert alert-info">
									<cf_zeroform name="save_setting_{{id}}" method="post" action="/index.cfm/images/{{data.image.id}}/version_settings/{{id}}" style="display:inline;">				
										<div class="col-lg-3"><cf_input type="text" class="form-control" name="key" placeholder="Setting Key" value="{{key}}" /></div>
										<div class="col-lg-3"><cf_input type="text" class="form-control" name="value" placeholder="Setting Value" value="{{value}}" /></div>									
										<div class="col-lg-3">
											<cf_input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}/" />
											<cf_input type="hidden" name="preserve_response" value="version_setting_response" />
											<cf_button type="submit" name="submit" class="btn btn-primary btn-xs" value="true">Save</cf_button>
											
											<cf_zeroform action="/index.cfm/images/{{data.image.id}}/read" method="post" name="cancel_setting_{{id}}">
												<cf_button name="cancel_setting" class="btn btn-default btn-xs" value="true">Cancel</cf_button>
											</cf_zeroform>
										</div>								
									</cf_zeroform>
								</div>
								{{else}}
									<div class="row">
										<div class="col-lg-3">{{key}}</div>
										<div class="col-lg-3">{{value}}</div>								
										<div class="col-lg-3">
											<cf_zeroform name="edit_setting_{{id}}" action="/index.cfm/images/{{data.image.id}}/read" method="post">
												<cf_button name="edit_setting" class="btn btn-primary btn-xs" value="{{id}}">Edit Setting</cf_button>
											</cf_zeroform>
											
											<cf_zeroform name="delete_setting_{{id}}" method="post" action="/index.cfm/images/{{data.image.id}}/version_settings/{{id}}/delete" style="display:inline;">
												<cf_input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}/" />
												<cf_input type="hidden" name="preserve_response" value="version_setting_response" />
												<cf_button name="delete_setting" class="btn btn-primary btn-xs" value="true">Delete</cf_button>
											</cf_zeroform>
										</div>
									</div>
								{{/if}}
							{{/each}}
														

							<cf_zeroform name="test_form" action="/index.cfm/images/{{data.image.id}}/read" method="post">
								<cf_button type="submit" name="add_setting" class="btn btn-success" value="true">Add Setting</cf_button>
							</cf_zeroform>

							<!---<input type="hidden" name="zero_form" value="add_setting">
							<input type="hidden" name="add_setting.action" value="/index.cfm/images/{{data.image.id}}/read">														
							<input type="hidden" name="add_setting.data.goto" value="/index.cfm/images/{{data.image.id}}">
							<button type="submit" name="add_setting.data.submit" class="btn btn-success" value="true">Add Setting</button>--->
							<!--- </cf_zeroform> --->
						</div>
						<!--- <div role="tabpanel" class="tab-pane fade" id="profile3">
							<p>The version script is applied on top of a clone of an image created with the base script.</p>
						</div>
						 --->
					</div>
				</div>				
			</div>
		</div>		
		</form>
		<div class="row">
			<div class="col-lg-12">
				<hr/>	
				<h4>Test Instances 
					<form method="post" action="/index.cfm/images/{{data.image.id}}/deploy" style="display:inline;">
						<input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}"/>					
						<input type="hidden" name="preserve_response" value="deployed_response" />
						<button class="btn btn-primary" type="submit" name="deploy" value="true"><i class="glyphicon glyphicon glyphicon-plus-sign"></i> Create</button>									
					</form>
				</h4>
				<p>Create and test instances based off this image.</p>
				{{#if data.deployed_response.message}}
					<div class="alert alert-success">
						{{data.deployed_response.message}}
					</div>
				{{/if}}		
				<table class="table">
					<thead>
						<tr>
							<td>Instance ID</td>
							<td>Status</td>
							<td>Host</td>
							<td>Name</td>
							<td>disk</td>
							<td>memory</td>
							<td>vcpus</td>
							<td>Actions</td>
						</tr>
					</thead>
					<tbody>
						{{#each data.image.instance_tests}}
							<tr>
								<td>{{instance_id}}</td>
								<td>{{status}}</td>
								<td>{{host}}</td>
								<td>{{name}}</td>
								<td>{{disk}}</td>
								<td>{{memory}}</td>
								<td>{{vcpus}}</td>
								<td>
									<form method="post" action="/index.cfm/instances/{{id}}/delete" style="display:inline;">
										<input type="hidden" name="goto" value="/index.cfm/images/{{data.image.id}}"/>					
										<input type="hidden" name="preserve_response" value="instance_delete_response" />
										<button class="btn btn-primary btn-depoy btn-xs"><i class="fa fa-recycle"></i> Delete</button>
									</form>									
								</td>
							</tr>
						{{/each}}						
					</tbody>
				</table>
			</div>
		</div>		
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
