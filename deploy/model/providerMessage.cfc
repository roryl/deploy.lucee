component accessors="true" {

	property name="success" setter="false";
	property name="data" setter="false";
	property name="originalResponse" setter="false";

	public function init(required boolean success, required struct data, required struct originalResponse){
		variables.success = arguments.success;
		variables.data = arguments.data;
		variables.originalResponse = arguments.originalResponse;
	}

	public function isSuccess(){
		return variables.success;
	}


}