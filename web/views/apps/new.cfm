<cf_handlebars context="#{}#">
<div class="row">
	<article class="col-md-12 main-content" role="main">

		<header>
			<h1>New App</h1>
			<form method="post" action="/index.cfm/apps">
				<input type="hidden" name="goto_success" value="/index.cfm"/>
				<div class="form-group">
				<label for="exampleInputEmail1">App Name</label>
					<input type="text" class="form-control" name="name" placeholder="friendly name">
				</div>
				<div class="form-group">
					<label for="domain_name">Domain Name</label>
					<input type="text" class="form-control" name="domain_name" placeholder="domain.com">
				</div>				
				<button type="submit" class="btn btn-default">Submit</button>
			</form>
			<br />
		</article>
		<!-- END Main content -->
	</div>
	</cf_handlebars>
