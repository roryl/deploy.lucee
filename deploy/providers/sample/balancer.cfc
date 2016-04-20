component {

	/*
	SSH tools: https://github.com/hierynomus/sshj
	https://github.com/hierynomus/sshj
	 */

	public function enableMaintenance(){
		return true;
	}

	public boolean function isInMaintenance(){
		return true;
	}

	public function disableMainteance(){
		return true;
	}

	public function start(){
		return true;
	}

	public boolean function isActive(){
		return true;
	}

	public function stop(){
		return true;
	}

	public boolean function isStopped(){
		return true;
	}

}