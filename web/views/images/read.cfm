<cf_handlebars context="#rc#">
<div class="row">
	<article class="col-md-12 main-content" role="main">
		<div class="row">
			<header>
				<h1>Edit Image </h1>				
			</header>
			<div class="col-md-4">
				<form method="post" action="{{data.next_step}}">
					<!--- <div class="form-group">
						<label for="image_name">Image Name</label>
						<p>Give your image a friendly name to refer to</p>
						<input type="text" class="form-control disabled" name="name" placeholder="friendly name" {{#if data.name}}value="{{data.name}}"{{/if}}>
					</div> --->

					<div class="form-group">
					{{#each data.image_options}}
					<label for="image.{{id}}">{{name}}</label>
					<select class="form-control" name="image.{{id}}" >
						>
						{{#each options}}
						<option value="{{id}}" {{#if selected}}selected{{/if}}>{{name}}</option>
						{{/each}}										
					</select>
					{{/each}}
					</div>
					<button type="submit" name="submit" class="btn btn-success" value="true">Save Changes</button>
					<hr/>
					<h4>Actions</h4>
					<button type="submit" name="submit" class="btn btn-success" value="true">Test Deploy</button>
				</form>
			</div>
			<div class="col-md-8" role="main">
				
				<div class="tabs tabs-text">
				
					<!-- Nav tabs -->
					<ul class="nav nav-tabs text-left" role="tablist">
						<li role="presentation" class="active">
							<a href="#versions" aria-controls="versions" role="tab" data-toggle="tab">Image Versions</a>
						</li>

						<li role="presentation" class="">
						<a href="#home3" aria-controls="home" role="tab" data-toggle="tab">Base Script</a>
						</li>
						<li role="presentation">
							<a href="#profile3" aria-controls="profile" role="tab" data-toggle="tab">Version Script</a>
						</li>						
					</ul>

					<!-- Tab panes -->
					<div class="tab-content">
						<div role="tabpanel" class="tab-pane active fade in" id="versions">
							<p>These are the versions of your application that this image is used on.</p>
						</div>
						<div role="tabpanel" class="tab-pane fade in" id="home3">
							<p>The base script is used for the initial creation of the image. Subsequent deploys clone the base image and apply the version script.</p>
							<textarea style="width:100%; min-height:300px;">
								
							</textarea>
						</div>
						<div role="tabpanel" class="tab-pane fade" id="profile3">
							<p>The version script is applied on top of a clone of an image created with the base script.</p>
						</div>
						
					</div>

				</div>
				
			</div>
		</div>
	</article>
	<!-- END Main content -->
</div>
</cf_handlebars>