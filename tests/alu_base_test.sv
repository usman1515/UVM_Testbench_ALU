class alu_base_test extends uvm_test;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_base_test)

    // ------------------------------------------ component instances
    alu_environment alu_env;

    // ------------------------------------------ constructor
    function new (string name="alu_base_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING alu_base_test:       "), UVM_LOW)
        super.build_phase(phase);
        alu_env = alu_environment::type_id::create("alu_env", this);
        `uvm_info(get_full_name(), $sformatf("COMPLETED BUILDING alu_base_test:     "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ end of elaboration phase
    function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED ELABORTING alu_base_test:     "), UVM_LOW)
        super.end_of_elaboration_phase(phase);
        // this.print();
        uvm_top.print_topology();
        `uvm_info(get_type_name(), $sformatf("COMPLETED alu_base_test alu_base_test:"), UVM_LOW)
    endfunction : end_of_elaboration_phase

	// ------------------------------------------ report phase
    function void report_phase(uvm_phase phase);
        uvm_report_server rpt_svr;
        `uvm_info(get_type_name(), $sformatf("STARTED REPORTING alu_base_test:      "), UVM_LOW)
		super.report_phase(phase);
		rpt_svr = uvm_report_server::get_server();
		if(rpt_svr.get_severity_count(UVM_FATAL) + rpt_svr.get_severity_count(UVM_ERROR) > 1) begin
			// `uvm_info(get_type_name(), "-----------------------------------------------------------------------------", UVM_LOW)
			`uvm_info(get_type_name(), "--------------------------- TEST COMPILATION FAIL ---------------------------", UVM_LOW)
			// `uvm_info(get_type_name(), "-----------------------------------------------------------------------------", UVM_LOW)
		end
		else begin
			// `uvm_info(get_type_name(), "-----------------------------------------------------------------------------", UVM_LOW)
			`uvm_info(get_type_name(), "--------------------------- TEST COMPILATION PASS ---------------------------", UVM_LOW)
			// `uvm_info(get_type_name(), "-----------------------------------------------------------------------------", UVM_LOW)
		end
        `uvm_info(get_type_name(), $sformatf("COMPLETED REPORTING alu_base_test:    "), UVM_LOW)
	endfunction : report_phase

endclass //alu_base_test extends uvm_test