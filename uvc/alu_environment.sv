class alu_environment extends uvm_env;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_environment)

    // ------------------------------------------ component instances
    alu_scoreboard  alu_env_scb;
    alu_agent       alu_env_agnt;


    // ------------------------------------------ constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING environment:       "), UVM_LOW)
        super.build_phase(phase);
        alu_env_agnt = alu_agent::type_id::create("alu_env_agnt", this);
        alu_env_scb = alu_scoreboard::type_id::create("alu_env_scb", this);
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING environment:     "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ connect phase
    function void connect_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED CONNECTING environment:       "), UVM_LOW)
        super.connect_phase(phase);
        alu_env_agnt.alu_agent_ap_before.connect(alu_env_scb.alu_scb_ap_before);
        alu_env_agnt.alu_agent_ap_after.connect(alu_env_scb.alu_scb_ap_after);
        `uvm_info(get_type_name(), $sformatf("COMPLETED CONNECTING environment:     "), UVM_LOW)
    endfunction : connect_phase

endclass : alu_environment
