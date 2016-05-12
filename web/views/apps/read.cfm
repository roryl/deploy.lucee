<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<div class="row">
			<div class="col-lg-12">
				<header>
					<h1>{{data.name}} App </h1>
				</header>
			</div>
		</div>
		<div class="row">
			<div class="col-md-4">
				<table class="table table-bordered table-striped table-info text-left">
					<thead>						
					</thead>
					<tbody>
						<tr>
							<td>Status:</td>							
							<td><span class="label label-default">{{data.status}}</span></td>
						</tr>
						<tr>
							<td>Current Version:</td>
							<td>0.0.0 <span class="label label-deploy"></span></td>
						</tr>
						<tr>
							<td>Versions Available:</td>
							<td>
								<ul class="list-unstyled">
									{{#each data.versions}}
										{{this.semver.string}}<br />
									{{/each}}								
								</ul>
							</td>							
						</tr>
						<tr>
							<td># of Instances</td>
							<td>2</td>
						</tr>
						<tr>
							<td>Auto Scaling</td>
							<td><strong>Off</strong> &nbsp;&nbsp; <a class="btn btn-default btn-xs btn-depoy"><i class="fa fa-paper-plane"></i> Turn On</a></td>
							<script>

							</script>
						</tr>
						<tr>
							<td>Default Image</td>
							<td>{{data.default_image.name}} <a class="btn btn-default btn-xs btn-depoy" href="/index.cfm/images/{{data.default_image.id}}"><i class="glyphicon glyphicon-edit"></i> Edit</a></td>
						</tr>
						<tr>
							<td>Provider</td>
							<td>{{data.provider}}</td>
						</tr>
					</tbody>
				</table>
				<h4>Actions</h4>
				<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-circle-arrow-up"></i> Upgrade</button>
				<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-circle-arrow-down"></i> Downgrade</button>
				<a href="/index.cfm/apps/{{data.id}}/versions/new" class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-open-file"></i> Add Version</a>
			</div>
			<div class="col-md-8" role="main">
				<div class="panel panel-default">
					<div class="panel-body">
						<div>
							<h4>HA Load Balancer</h4>
							{{#if data.balancer.deployed}}							
							<table class="table">
								<thead>
									<tr>
										<td>Instance ID</td>
										<td>status</td>
										<td>Primary?</td>																				
									</tr>
								</thead>
								<tbody>
									{{#each data.balancer.balancer_instances}}
									<tr>
										<td>{{instance_id}}</td>
										<td>{{status}}</td>
										<td>{{is_primary}}</td>										
									</tr>
									{{/each}}
								</tbody>
							</table>							
							{{else}}
							<p>Each application requires a load balancer to deploy instances behind. Your load balancer is not yet configured. Once the load balancer is setup you will be able to deploy instances. This will create instances at the provider.</p>
							<form action="/index.cfm/balancers/{{data.balancer.id}}/deploy" method="post">
								<input type="hidden" name="goto" value="/index.cfm/apps/{{data.id}}" />
								<input type="hidden" name="preserve_response" value="balancer_deploy" />								
								<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-off"></i> Deploy Load Balancer</button>
							</form>
							{{/if}}
						</div>								
					</div>
				</div>
				{{#if data.balancer.deployed}}
				<div class="panel panel-default">
					<div class="panel-body">
						<div>
							<h4>Active Balanced Instances <!--- <span class="btn btn-primary"><i class="glyphicon glyphicon glyphicon-plus-sign"></i> Add Instance</span> --->
								<!--- <form action="/index.cfm/apps/{{data.id}}/instances" method="post" style="display:inline;">
									<input type="hidden" name="goto" value="/index.cfm/apps/{{data.id}}" />
									<input type="hidden" name="preserve_response" value="create_instance" />								
									<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon glyphicon-plus-sign"></i> Add Instance</button>
								</form> --->
							</h4>							
							<table class="table">
								<thead>
									<tr>
										<td>id</td>
										<td>status</td>
										<td>Version</td>
										<td>Host</td>
										<td>Actions</td>
									</tr>
								</thead>
								<tbody>
									{{#each data.balancer.instances}}
									<tr>
										<td>{{instance_id}}</td>
										<td>{{status}}</td>																			
										<td>{{version.semver.string}}</td>
										<td>{{host}}</td>
										<td>
											<form action="/index.cfm/instances/{{id}}/unbalance" method="post">
												<input type="hidden" name="goto" value="/index.cfm/apps/{{@root.data.id}}" />
												<button type="submit" class="btn btn-primary btn-xs">Unbalance</button>
											</form>
											<form action="/index.cfm/instances/{{id}}/refresh" method="post">
												<input type="hidden" name="goto" value="/index.cfm/apps/{{@root.data.id}}" />
												<button type="submit" class="btn btn-primary btn-xs">Refresh</button>
											</form>
										</td>																			
									</tr>
									{{/each}}
								</tbody>
							</table>
							<hr/>
						</div>
						<div>
							<h4>Inactive Instances
								<form action="/index.cfm/apps/{{data.id}}/instances" method="post" style="display:inline;">
									<input type="hidden" name="goto" value="/index.cfm/apps/{{data.id}}" />
									<input type="hidden" name="add_to_balancer" value="false"/>
									<input type="hidden" name="preserve_response" value="create_instance" />								
									<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon glyphicon-plus-sign"></i> Add Instance</button>
								</form>
							</h4>
							<table class="table">
								<thead>
									<tr>
										<td>id</td>
										<td>status</td>
										<td>Version</td>
										<td>Host</td>
										<td>Actions</td>
									</tr>
								</thead>
								<tbody>
									{{#each data.inactive_instances}}
									<tr>
										<td>{{instance_id}}</td>
										<td>{{status}}</td>																			
										<td>{{version.semver.string}}</td>
										<td>{{host}}</td>
										<td>
											<form action="/index.cfm/instances/{{id}}/delete" method="post" style="display:inline;">
												<input type="hidden" name="goto" value="/index.cfm/apps/{{@root.data.id}}" />
												<button type="submit" class="btn btn-primary btn-xs">Delete</button>
											</form>
											<form action="/index.cfm/instances/{{id}}/balance" method="post" style="display:inline;">
												<input type="hidden" name="goto" value="/index.cfm/apps/{{@root.data.id}}" />
												<button type="submit" class="btn btn-primary btn-xs">Balance</button>
											</form>
											<form action="/index.cfm/instances/{{id}}/refresh" method="post">
												<input type="hidden" name="goto" value="/index.cfm/apps/{{@root.data.id}}" />
												<button type="submit" class="btn btn-primary btn-xs">Refresh</button>
											</form>
										</td>																			
									</tr>
									{{/each}}
								</tbody>
							</table>
						</div>  		
					</div>
				</div> <!--- Instances Panel --->
				{{/if}} <!---/data.balancer --->
			</div>
		</div>
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
