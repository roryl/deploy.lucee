<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<div class="row">
			<header>
				<h1>{{data.name}} App </h1>
			</header>
			<div class="col-md-4">
				<table class="table table-bordered table-striped table-info text-left">
					<thead>						
					</thead>
					<tbody>
						<tr>
							<td>Status:</td>
							<td><span class="label label-success">Active</span></td>
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
										{{this.semver.string}}
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
							<td><strong>Off</strong> &nbsp;&nbsp; <button class="btn btn-default btn-xs btn-depoy"><i class="fa fa-paper-plane"></i> Turn On</button></td>
							<script>

							</script>
						</tr>
					</tbody>
				</table>
				<h4>Actions</h4>
				<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-circle-arrow-up"></i> Upgrade</button>
				<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-circle-arrow-down"></i> Downgrade</button>
				<button class="btn btn-primary btn-depoy"><i class="glyphicon glyphicon-open-file"></i> Add Version</button>
			</div>
			<div class="col-md-8" role="main">
				<div class="panel panel-default">
					<div class="panel-body">
						<div>
							<h4>HA Load Balancer</h4>
							
							<table class="table">
								<thead>
									<tr>
										<td>id</td>
										<td>status</td>
										<td>Version</td>
										<td>Actions</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
							<hr/>
						</div>								
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<div>
							<h4>Active Balanced Instances <span class="btn btn-primary"><i class="glyphicon glyphicon glyphicon-plus-sign"></i> Add Instance</span></h4>
							
							<table class="table">
								<thead>
									<tr>
										<td>id</td>
										<td>status</td>
										<td>Version</td>
										<td>Actions</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
							<hr/>
						</div>
						<div>
							<h4>Inactive Instances <button class="btn btn-primary btn-depoy"><i class="fa fa-recycle"></i> Cleanup</button></h4>
							<table class="table">
								<thead>
									<tr>
										<td>id</td>
										<td>status</td>
										<td>Version</td>
										<td>Actions</td>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td></td>
										<td></td>
										<td></td>
										<td></td>
									</tr>
								</tbody>
							</table>
						</div>  		
					</div>
				</div>	
			</div>
		</div>
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>
