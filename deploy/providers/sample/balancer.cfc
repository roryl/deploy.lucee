component {

	/*
	SSH tools: https://github.com/hierynomus/sshj
	https://github.com/hierynomus/sshj
	Adding Hosts http://stackoverflow.com/questions/10922292/struggling-with-sshj-example-exec-could-not-verify-ssh-rsa-host-key-with
	 */

	public function enableMaintenance(){
		return callStackGet();
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