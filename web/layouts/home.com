<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="keywords" content="">

    <title>theDocs - </title>

    <!-- Styles -->
    <link href="assets/css/theDocs.all.min.css" rel="stylesheet">
    <link href="assets/css/custom.css" rel="stylesheet">

    <!-- Fonts -->
    <link href='http://fonts.googleapis.com/css?family=Raleway:100,300,400,500%7CLato:300,400' rel='stylesheet' type='text/css'>

    <!-- Favicons -->
    <link rel="apple-touch-icon" href="/apple-touch-icon.png">
    <link rel="icon" href="assets/img/favicon.ico">
  </head>

  <body>

    <header class="site-header">

      <!-- Top navbar & branding -->
      <nav class="navbar navbar-default">
        <div class="container">

          <!-- Toggle buttons and brand -->
          <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#navbar" aria-expanded="true" aria-controls="navbar">
              <span class="glyphicon glyphicon-option-vertical"></span>
            </button>

            <a class="navbar-brand" href="index.html"><img src="assets/img/logo.png" alt="logo"></a>
          </div>
          <!-- END Toggle buttons and brand -->

          <!-- Top navbar -->
          <div id="navbar" class="navbar-collapse collapse" aria-expanded="true" role="banner">
            <ul class="nav navbar-nav navbar-right">
              <li class="active"><a href="index.html">Documentation</a></li>
              <li><a href="page_faq.html">FAQ</a></li>
              <li><a href="http://themeforest.net/item/thedocs-online-documentation-template/13070884/comments" target="_blank">Support</a></li>
              <li class="hero"><a href="http://themeforest.net/item/thedocs-online-documentation-template/13070884">Purchase</a></li>
            </ul>
          </div>
          <!-- END Top navbar -->

        </div>
      </nav>
      <!-- END Top navbar & branding -->
      
    </header>


    <main class="container">
      <div class="row">

        <article class="col-md-12 main-content" role="main">
          
          <header>
            <h1>Page title</h1>
            <p>All HTML headings, h1 through h6, are available. .h1 through .h6 classes are also available, for when you want to match the font styling of a heading but still want your text to be displayed inline.</p>
            <ol class="toc">
              <li>
                <a href="#">First topic</a>
                <ol>
                  <li><a href="#">Sub topic 1</a></li>
                  <li><a href="#">Sub topic 2</a></li>
                </ol>
              </li>
              <li><a href="#">Second topic</a></li>
              <li><a href="#">Third topic</a></li>
              <li><a href="#">Fourth topic</a></li>
            </ol>
          </header>

          <section>
            <h2 id="ftt">First topic title</h2>
            <p></p>

            <div class="code-window">
              <div class="code-preview">

              </div>

<pre class="line-numbers"><code class="language-markup">

</code></pre>
            </div>

          </section>

          
        </article>
        <!-- END Main content -->
      </div>
    </main>


    <!-- Footer -->
    <footer class="site-footer">
      <div class="container">
        <a id="scroll-up" href="#"><i class="fa fa-angle-up"></i></a>

        <div class="row">
          <div class="col-md-6 col-sm-6">
            <p>Copyright &copy; 2015. All right reserved</p>
          </div>
          <div class="col-md-6 col-sm-6">
            <ul class="footer-menu">
              <li><a href="page_changelog.html">Changelog</a></li>
              <li><a href="page_credits.html">Credits</a></li>
              <li><a href="mailto:support@shamsoft.net">Contact us</a></li>
            </ul>
          </div>
        </div>
      </div>
    </footer>
    <!-- END Footer -->

    <!-- Scripts -->
    <script src="assets/js/theDocs.all.min.js"></script>
    <script src="assets/js/custom.js"></script>

  </body>
</html>