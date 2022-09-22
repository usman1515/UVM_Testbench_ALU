// Doesnt require a run_phase. No simulation code to be executed.
//

class alu_agent extends uvm_agent;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_agent)

    // ------------------------------------------ analysis ports
    // proxy ports to connect monitors to the scoreboards
    uvm_analysis_port #(alu_transaction) alu_agent_ap_before;
    uvm_analysis_port #(alu_transaction) alu_agent_ap_after;

    // ------------------------------------------ component instances
    alu_sequencer       alu_seqr;
    alu_driver          alu_drv;
    alu_monitor_before  alu_mon_before;
    alu_monitor_after   alu_mon_after;

    // ------------------------------------------ constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING agent:       "), UVM_LOW)
        super.build_phase(phase);
        // creating alu_seqr and alu_drv for ACTIVE agent only
        if(get_is_active() == UVM_ACTIVE) begin
            alu_seqr = alu_sequencer::type_id::create("alu_seqr", this);
            alu_drv = alu_driver::type_id::create("alu_drv", this);
        end
		alu_agent_ap_before	= new("alu_agent_ap_before", this);
		alu_agent_ap_after	= new("alu_agent_ap_after", this);
        alu_mon_after = alu_monitor_after::type_id::create("alu_mon_after", this);
        alu_mon_before = alu_monitor_before::type_id::create("alu_mon_before", this);
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING agent:     "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ connect phase
    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        // connecting alu_seqr and alu_drv for ACTIVE agent only
        if(get_is_active == UVM_ACTIVE) begin
            alu_drv.seq_item_port.connect(alu_seqr.seq_item_export);
        end
        // proxy ports creating a connection to to connect monitors to scoreboard via agent
        alu_mon_before.alu_mon_ap_before.connect(alu_agent_ap_before);
        alu_mon_after.alu_mon_ap_after.connect(alu_agent_ap_after);
    endfunction : connect_phase

endclass : alu_agent