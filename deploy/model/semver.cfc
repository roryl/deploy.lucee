component {

	property name="major";
	property name="minor";
	property name="patch";
	property name="string";

	public function init(required string semver){
		variables.semverValue = listToArray(arguments.semver,".");
		if(variables.semverValue.len() < 3){
			throw("Invalid semver. Must have three sections x.x.x");
		} else {
			return this;
		}
	}

	public numeric function getMajor(){
		return variables.semverValue[1];
	}

	public numeric function getMinor(){
		return variables.semverValue[2];
	}

	public numeric function getPatch(){
		return variables.semverValue[3];
	}

	public boolean function equals(required Semver Semver){
		return this.toString() == arguments.Semver.toString();
	}

	public function toString(){
		return variables.semverValue.toList(".");
	}

	public function getString(){
		return this.toString();
	}

	public function isBefore(required Semver Semver){

		var left = this;
		var right = arguments.Semver;

		if(left.getMajor() < right.getMajor()){
			return true;
		} else if(left.getMajor() > right.getMajor()){
			return false;
		} else if(left.getMinor() < right.getMinor()){
			return true;
		} else if(left.getMinor() > right.getMinor()){
			return false;
		} else if(left.getPatch() < right.getPatch()){
			return true;
		} else if(left.getPatch() > right.getPatch()){
			return false;
		} else {
			return false;
		}
	}

	public function isAfter(required Semver Semver){
		//Simply flip into the isBefore to get the opposite
		left = this;
		right = arguments.semver;
		
		if(left.getMajor() > right.getMajor()){
			return true;
		} else if(left.getMajor() < right.getMajor()){
			return false;
		} else if(left.getMinor() > right.getMinor()){
			return true;
		} else if(left.getMinor() < right.getMinor()){
			return false;
		} else if(left.getPatch() > right.getPatch()){
			return true;
		} else if(left.getPatch() < right.getPatch()){
			return false;
		} else {
			return false;
		}
	}
	
	public Semver function diff(required Semver Semver){
		left = this;
		right = arguments.semver;	

		var major = abs(right.getMajor() - left.getMajor());
		if(major IS 0){
			var minor = abs(right.getMinor() - left.getMinor());
			if(minor IS 0){
				var patch = abs(right.getPatch() - left.getPatch());
				if(patch IS 0){
					var value = "0.0.0";
					return createObject("semver").init(value);
				} else{
					var value = "0.0.#patch#";
					return createObject("semver").init(value);
				}
			} else {
				value = "0.#minor#.0";			
				return createObject("semver").init(value);
			}
		} else {
			value = "#major#.0.0";
			return createObject("semver").init(value);
		}
	}

	public function isMajor(){
		if(this.getMajor() != 0){
			return true;
		} else {
			return false;
		}
	}

	public function isMinor(){
		if(!isMajor() AND this.getMinor() != 0){
			return true;
		} else {
			return false;
		}
	}

	public function isPatch(){
		if(!isMajor() AND !isMinor() AND this.getPatch() != 0){
			return true;
		} else {
			return false;
		}
	}

	public function incrementMajor(count=1){

		var major = duplicate(this.getMajor()) + count;
		var minor = duplicate(this.getMinor());
		var patch = duplicate(this.getPatch());
		value = "#major#.#minor#.#patch#";
		return createObject("semver").init(value);
	}

	public function incrementMinor(count=1){

		var major = duplicate(this.getMajor());
		var minor = duplicate(this.getMinor()) + count;
		var patch = duplicate(this.getPatch());
		value = "#major#.#minor#.#patch#";
		return createObject("semver").init(value);
	}

	public function incrementPatch(count=1){

		var major = duplicate(this.getMajor());
		var minor = duplicate(this.getMinor());
		var patch = duplicate(this.getPatch()) + count;
		value = "#major#.#minor#.#patch#";
		return createObject("semver").init(value);
	}

	public function isZero(){
		return this.toString() == "0.0.0";
	}
}