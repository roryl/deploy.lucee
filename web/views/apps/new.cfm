<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<div class="row">
			<header>
				<h1>New App</h1>
			</header>
			{{#if data.errors}}
				<div class="alert alert-danger">
				<strong>Your submission had errors:</strong>
				<ol class="">
					{{#each data.errors}}
						<li>{{this}}</li>
					{{/each}}					
				</ol>
				</div>
			{{/if}}
			<div class="col-md-8">
				<form method="post" action="{{data.next_step}}">
					<input type="hidden" value="{{data.step}}" name="step">
					<ul class="step-text" style="margin-top:0;">
						<li>
							<!--- STEP 1 --->
							<a id="basics"></a>
							<h2 style="margin-top:0;">App Basics</h2>
										
							<div class="form-group">
								<label for="exampleInputEmail1">App Name</label>
								<input type="text" class="form-control disabled" name="name" placeholder="friendly name" {{#if data.name}}value="{{data.name}}"{{/if}} {{#unless data.step_1}}readonly{{/unless}}>
							</div>
							<div class="form-group">
								<label for="domain_name">Domain Name</label>
								<input type="text" class="form-control" name="domain_name" placeholder="domain.com" {{#if data.domain_name}}value="{{data.domain_name}}"{{/if}} {{#unless data.step_1}}readonly{{/unless}}>
							</div>
							<div class="form-group">
								<label for="domain_name">Provider</label>
								<p>Providers are the cloud platforms that this app will create instances on. An app can only live in a single provider</p>
								<select class="form-control" name="provider" 
									{{#if data.provider}}value="{{data.provider}}"{{/if}}
									{{#unless data.step_1}}readonly{{/unless}}>
									<option>Sample</option>
								</select>
							</div>
						</li>

						<li {{#unless data.step_1_complete}}style="display:none;"{{/unless}}>
							<!--- STEP 2 --->
							<div>
								<a id="balancer"></a>
								<h2>Select Balancer</h2>
								<p>Each App needs a load balancer. Select one of the balancer options provider by {{data.provider}}</p>
								{{#each data.balancer_options}}
								<label for="domain_name">Balancers</label>
								<select class="form-control" name="balancer.{{id}}" 
									{{#if data.balancer}}value="{{data.balancer}}"{{/if}}
									{{#unless data.step_2}}readonly{{/unless}}>
										{{#each options}}
										<option value="{{id}}" {{#if selected}}selected{{/if}}>{{name}}</option>
										{{/each}}
								</select>
								{{/each}}
							</div>
						</li>

						<li {{#unless data.step_2_complete}}style="display:none;"{{/unless}}>
							<!--- STEP 2 --->
							<div>
								<a id="instance"></a>
								<h2>Configure Default Image</h2>
								<p>Select the configuration options for the default image for this applicaiton. These can be changed later</p>
											
								<div class="form-group">
									<label for="image_name">Image Name</label>
									<p>Give your image a friendly name to refer to</p>
									<input type="text" class="form-control disabled" name="image_name" placeholder="friendly name" {{#if data.image_name}}value="{{data.image_name}}"{{/if}} {{#unless data.step_3}}readonly{{/unless}}>
								</div>

								{{#each data.image_options}}
									<label for="image.{{id}}">{{name}}</label>
									<select class="form-control" name="image.{{id}}" 
										{{#unless data.step_3}}readonly{{/unless}}>
										>
										{{#each options}}
											<option value="{{id}}" {{#if selected}}selected{{/if}}>{{name}}</option>
										{{/each}}										
									</select>
								{{/each}}

								<!--- <select class="form-control" name="instance.image" 
									{{#if data.image}}value="{{data.image}}"{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>
									<option value="image">NYC</option>
								</select>
								<label for="location">Location</label>
								<select class="form-control" name="instance.location" 
									{{#if data.location}}value="{{data.location}}"{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>
									<option value="location">NYC</option>
								</select>
								<label for="location">Memory</label>
								<select class="form-control" name="instance.memory" 
									{{#if data.memory}}value="{{data.memory}}"{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>
									<option value="memory">NYC</option>
								</select>
								<label for="location">Vcpus</label>
								<select class="form-control" name="instance.vcpu" 
									{{#if data.vcpu}}value="{{data.vcpu}}"{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>
									<option value="vcpu">NYC</option>
								</select>
								<label for="location">Disk Space</label>
								<select class="form-control" name="instance.disk" 
									{{#if data.disk}}value="{{data.disk}}"{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>
									<option value="disk">NYC</option>
								</select>
								 --->
								<label for="location">Boot Script</label>
								<p>This is the shell script which will be executed at boot</p>
								<textarea 
									class="form-control" 
									name="image.boot_script" 
									{{#if data.boot_script}}
										value="{{data.boot_script}}"
									{{/if}}
									{{#unless data.step_3}}readonly{{/unless}}>{{#if data.boot_script}}{{data.boot_script}}{{/if}}</textarea>
							</div>
						</li>

						<li {{#unless data.step_3_complete}}style="display:none;"{{/unless}}>
							<!--- STEP 2 --->
							<div>
								<a id="review"></a>
								<h2>Review and Finalize</h2>
								<p>Review your selections above. If complete, the next step create the app</p>
							</div>
						</li>											
					</ul>
					{{#unless data.step_1}}
					<button type="submit" name="back" class="btn btn-default" value="true">Back</button>										
					{{/unless}}

					{{#if data.step_4}}	
						<input type="hidden" name="goto" value="/index.cfm/apps/:data.id" />
						<button type="submit" name="submit" class="btn btn-success" value="true">Create App</button>
					{{else}}
						<button type="submit" name="submit" class="btn btn-default" value="true">Next</button>
					{{/if}}
					
				</form>
				<br />
			</div>
			<div class="col-md-4" role="main">
				<div class="panel panel-default">
					<div class="panel-body">
						<h4>Creating an App</h4>
			        	<p>Each app is a collection of services unique to a particular domain name. There can only be one app per domain name (yourdomain.com), but each subdomain can have its own app. (staging.yourdomain.com, customer.yourdomain.com, etc)</p>
			        	<p>Once you select your provider you will be able to configure your default instances</p>  		
					</div>
				</div>	
			</div>
		</div>
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
