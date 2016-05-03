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
						<li role="presentation" class="active">
						<a href="#home3" aria-controls="home" role="tab" data-toggle="tab">Install Script</a>
						</li>
						<li role="presentation" class="">
							<a href="#versions" aria-controls="versions" role="tab" data-toggle="tab">Image Versions</a>
						</li>

						<!--- <li role="presentation">
							<a href="#profile3" aria-controls="profile" role="tab" data-toggle="tab">Version Script</a>
						</li>		 --->				
					</ul>

					<!-- Tab panes -->
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active fade in" id="home3">
							<p>This shell script will be executed on creation of the image</p>
							<textarea name="base_script" style="width:100%; min-height:300px;">{{data.base_script}}</textarea>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="versions">
							<p>These are the versions of your application that this image is used on.</p>
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
