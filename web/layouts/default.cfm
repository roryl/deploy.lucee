<!DOCTYPE html>
<cfoutput>
<html lang="en">
  <head>
	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<meta name="description" content="">
	<meta name="keywords" content="">

	<title>theDocs - </title>

	<!-- Styles -->
	<link href="/assets/admin/css/theDocs.all.min.css" rel="stylesheet">
	<link href="/assets/admin/css/custom.css" rel="stylesheet">
	<link href="/assets/admin/css/skin-white.css" rel="stylesheet">

	<!-- Fonts -->
	<link href='http://fonts.googleapis.com/css?family=Raleway:100,300,400,500%7CLato:300,400' rel='stylesheet' type='text/css'>

	<!-- Favicons -->
	<link rel="apple-touch-icon" href="/apple-touch-icon.png">
	<link rel="icon" href="/assets/admin/img/favicon.ico">

	<script src="/assets/admin/js/theDocs.all.min.js"></script>
	<script src="/assets/admin/js/custom.js"></script>
	<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery.isotope/2.2.2/isotope.pkgd.js"></script>
<!--- 	<link href="/assets/admin/vendors/bootstrap-switch/css/bootstrap3/bootstrap-switch.min.css" rel="stylesheet">	
	<script src="/assets/admin/vendors/bootstrap-switch/js/bootstrap-switch.min.js"></script> --->
  </head>

  <body>

	<header class="site-header">

	  <!-- Top navbar & branding -->
	  <nav class="navbar navbar-default">
		<div class="container">

		  <!-- Toggle buttons and brand -->
		  <div class="navbar-header">
			<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="##navbar" aria-expanded="true" aria-controls="navbar">
			  <span class="glyphicon glyphicon-option-vertical"></span>
			</button>

			<button type="button" class="navbar-toggle for-sidebar" data-toggle="offcanvas">
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			  <span class="icon-bar"></span>
			</button>

			<a class="navbar-brand" href="#buildURL('')#"><img src="/assets/img/deploy.lucee.fw.png" alt="logo"></a>
		  </div>
		  <!-- END Toggle buttons and brand -->

		  <!-- Top navbar -->
		  <div id="navbar" class="navbar-collapse collapse" aria-expanded="true" role="banner">
			<ul class="nav navbar-nav navbar-right">
			  <li><a href="#buildURL('status.default')#">Status</a></li>
			  <li><a href="#buildURL('main.default')#">Apps</a></li>
			  <li><a href="http://docs.syncql.io/docs" target="_blank">Docs</a></li>
			  <li class="hero"><a href="/index.cfm/apps/new">Create App</a></li>
			</ul>
		  </div>
		  <!-- END Top navbar -->

		</div>
	  </nav>
	  <!-- END Top navbar & branding -->
	  
	</header>


	<main class="container">
	  #body#
	</main>

	<!-- Footer -->
	<footer class="site-footer">
	  <div class="container">
		<a id="scroll-up" href="##"><i class="fa fa-angle-up"></i></a>

		<div class="row">
		  <div class="col-md-6 col-sm-6">
			<p>Copyright &copy; 2015. All right reserved</p>
		  </div>
		  <div class="col-md-6 col-sm-6">
			<ul class="footer-menu">
			  
			  
			  <li><a href="mailto:support@shamsoft.net">Contact us</a></li>
			</ul>
		  </div>
		</div>
	  </div>
	</footer>
	<!-- END Footer -->

	<!-- Scripts -->
	
	
	
  </body>
</html>
</cfoutput>