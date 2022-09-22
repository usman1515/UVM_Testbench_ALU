class alu_sequencer extends uvm_sequencer #(alu_transaction);

    // ------------------------------------------ UVM utility and field macros
    `uvm_component_utils(alu_sequencer)

    // ------------------------------------------ constructor
    function new(string name, uvm_component parent);
        super.new(name);
    endfunction : new

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING sequence:    "), UVM_LOW)
        super.build_phase(phase);
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING sequence:  "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ start of simulation phase
    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTING SIMULATION for:  "), UVM_LOW)
        super.start_of_simulation_phase(phase);
        `uvm_info(get_type_name(), $sformatf("COMPLETED SIMULATION for: "), UVM_LOW)
    endfunction : start_of_simulation_phase

endclass : alu_sequencer
