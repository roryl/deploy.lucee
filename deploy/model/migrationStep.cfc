component persistent="true" table="migration_step" discriminatorColumn="step_type" {
	property name="id" fieldtype="id" generator="native";
	property name="status";
	property name="migration" fieldtype="many-to-one" cfc="migration" fkcolumn="migration_id";

	public boolean function run(){
		return true;
	}
}