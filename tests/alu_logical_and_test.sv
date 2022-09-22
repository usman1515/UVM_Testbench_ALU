class alu_logical_and_test extends alu_base_test;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_logical_and_test)

    // ------------------------------------------ sequences instances
    alu_config_mode_sequence myseq1;
    int count=10;

    // ------------------------------------------ constructor
    function new (string name="alu_logical_and_test", uvm_component parent=null);
        super.new(name, parent);
    endfunction : new

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        myseq1 = alu_config_mode_sequence::type_id::create("myseq1", this);
    endfunction : build_phase

    // ------------------------------------------ run task
    task run_phase(uvm_phase phase);
        repeat(count) begin
            // set configuration
            myseq1.config_mode = 4'd8;
            // execute test
            phase.raise_objection(this);
            myseq1.start(alu_env.alu_env_agnt.alu_seqr);
            phase.drop_objection(this);
        end
        //set a drain-time for the environment if desired
        phase.phase_done.set_drain_time(this, 20);
    endtask : run_phase

endclass : alu_logical_and_test