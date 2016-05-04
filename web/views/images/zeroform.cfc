component accessors="true" {

	this.children = [];
	property name="name";
	property name="action";
	property name="method";

	/**
	 * Constructor for the custom tag
	 * @param  {component} component parent        Whether the tag has a parent tag, default is null
	 * @param  {boolean} boolean   hasEndTag     Whether the tag has an end tag
	 * @return {void}           
	 */
	public void function init(component parent, required boolean hasEndTag){
	
	}

	public function addChild(required component child){
		this.children.append(child);
	}	

	/**
	 * Invoked during the start of the custom tag
	 * @param  {struct} required struct        attributes The attributes passed to the custom tag
	 * @param  {struct} required struct        caller     A reference to the variables scope from the location that calls the custom tag
	 * @return {boolean}          To control whether to execute the body of the custom tag
	 */
	public boolean function onStartTag(required struct attributes, required struct caller){
		variables.name = attributes.name;
		variables.action = attributes.action;
		variables.method = attributes.method;
		echo("<input type='hidden' name='zero_form' value='#variables.name#' />");
		echo("<input type='hidden' name='#variables.name#.action' value='#variables.action#' />");
		echo("<input type='hidden' name='#variables.name#.method' value='#variables.method#' />");
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
		echo(generatedContent);
		return false;
	}

}