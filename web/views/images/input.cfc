component {

	/**
	 * Constructor for the custom tag
	 * @param  {component} component parent        Whether the tag has a parent tag, default is null
	 * @param  {boolean} boolean   hasEndTag     Whether the tag has an end tag
	 * @return {void}           
	 */
	public void function init(component parent, required boolean hasEndTag){
		if(!isNull(parent)){
			parent.addChild(this);
		} else {
			throw("Cannot have form inputs without a <cf_zeroform>");
		}
		variables.parent = parent;
	}	

	/**
	 * Invoked during the start of the custom tag
	 * @param  {struct} required struct        attributes The attributes passed to the custom tag
	 * @param  {struct} required struct        caller     A reference to the variables scope from the location that calls the custom tag
	 * @return {boolean}          To control whether to execute the body of the custom tag
	 */
	public boolean function onStartTag(required struct attributes, required struct caller){		
		return true;
	}

	/**
	 * Invoked after the completion of the closing tag
	 * @param  {struct} required struct        attributes The attributes passed to the custom tag
	 * @param  {struct} required struct        caller     A reference to the variables scope from the location that calls the custom tag
	 * @param  {string} string        generatedContent     The output generated between the start and end tags at the caller
	 * @return {boolean}          To control whether to execute the body of the custom tag
	 */
	public boolean function onEndTag(required struct attributes, required struct caller, string generatedContent){		
		echo("<input ");
		for(var key in attributes){
			if(key is "name"){
				echo("name='#parent.getName()#.data.#attributes.name#'");
			} else {
				echo("#key#='#attributes[key]#'")
			}
		}

		echo(" />");
		return false;
	}

}