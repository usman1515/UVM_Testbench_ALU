// Self-contained model that observes the communication of the DUT with the testbench.
// Monitor is a passive component.
// monitor_before, will solely look for the output of the device and it will pass the result to the scoreboard.

class alu_monitor_before extends uvm_monitor;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_monitor_before)

    // ------------------------------------------ analysis port
    // to send transaction to scoreboard
    uvm_analysis_port #(alu_transaction) alu_mon_ap_before;

    // ------------------------------------------ virtual interface
    virtual alu_interface alu_vif;
    `define MON_XMR alu_vif.monitor_modport.monitor_cb

    // ------------------------------------------ transaction for recieving data
    alu_transaction alu_trans1;

    // ------------------------------------------ constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING monitor_before:    "), UVM_LOW)
        super.build_phase(phase);
        alu_mon_ap_before = new("alu_mon_ap_before", this);
        // create object to store temp alu transaction
        alu_trans1 = alu_transaction::type_id::create("alu_trans1", this);
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING monitor_before:  "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ connect phase
    function void connect_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED CONNECTING monitor_before:    "), UVM_LOW)
        super.connect_phase(phase);
        // Get the interface from the factory database.
        // The same interface that is instantiated in the top block.
        if (!uvm_config_db #(virtual alu_interface)::get(this, "*", "vif", alu_vif))
            `uvm_fatal("NO VIF FOUND", $sformatf("virtual interface must be set for: ",get_full_name(),".vif"))
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING monitor_before:    "), UVM_LOW)
    endfunction : connect_phase

    // ------------------------------------------ run phase
    // convert signal level activity to transaction level
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED RUNNING monitor_before:   "), UVM_LOW)

        forever begin
            // drive the monitor cb outputs to the temp transaction
            @(posedge alu_vif.monitor_modport.clk iff (alu_vif.monitor_modport.reset_n));
            // alu_trans1.reset_n  = alu_vif.monitor_modport.reset_n;
            alu_trans1.in_dataA = `MON_XMR.in_dataA;
            alu_trans1.in_dataB = `MON_XMR.in_dataB;
            alu_trans1.in_mode  = `MON_XMR.in_mode;
            @(posedge alu_vif.monitor_modport.clk iff (alu_vif.monitor_modport.reset_n));
            alu_trans1.out_data = `MON_XMR.out_data;
            alu_trans1.out_cout = `MON_XMR.out_cout;
            // send the monitor transction to scoreboard via analysis port
            alu_mon_ap_before.write(alu_trans1);
        end

        `uvm_info(get_type_name(), $sformatf("COMPLETED RUNNING monitor_before: "), UVM_LOW)
    endtask : run_phase

endclass : alu_monitor_before