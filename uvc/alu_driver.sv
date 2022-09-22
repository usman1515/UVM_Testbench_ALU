// Derive the class alu_driver from UVM class uvm_driver
// #(alu_transaction) is an SV parameter and represents the
// data type that will be retrieved from the sequencer.

class alu_driver extends uvm_driver #(alu_transaction);

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_driver)
    // ------------------------------------------ interface declaration
    protected virtual alu_interface alu_vif;
    // variable to access the IO in the driver clocking block interface
    `define DRV_XMR alu_vif.driver_modport.driver_cb
    // ------------------------------------------ constructor
    extern function new(string name, uvm_component parent);
    // ------------------------------------------ build phase
    extern function void build_phase(uvm_phase phase);
    // ------------------------------------------ connect phase
    extern function void connect_phase(uvm_phase phase);
    // ------------------------------------------ run phase
    extern task run_phase(uvm_phase phase);
    // ------------------------------------------ task drive
    extern virtual task reset_signals();
    extern virtual task drive();

endclass : alu_driver

//*================================================================================================
//*================================================================================================

// ------------------------------------------ constructor
function alu_driver :: new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// ------------------------------------------ build phase
function void alu_driver :: build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("STARTED BUILDING driver:    "), UVM_LOW)
    super.build_phase(phase);
    `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING driver:  "), UVM_LOW)
endfunction : build_phase

// ------------------------------------------ connect phase
function void alu_driver :: connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("STARTED CONNECTING driver:    "), UVM_LOW)
    super.connect_phase(phase);
    // Get the interface from the factory database.
    // The same interface that is instantiated in the top block.
    if (!uvm_config_db #(virtual alu_interface)::get(this, "*", "vif", alu_vif))
        `uvm_fatal("NO VIF FOUND", $sformatf("virtual interface must be set for: ",get_full_name(),".vif"))
    `uvm_info(get_type_name(), $sformatf("COMPLETED CONNECTING driver:  "), UVM_LOW)
endfunction : connect_phase

// ------------------------------------------ run phase
task alu_driver :: run_phase(uvm_phase phase);
    reset_signals();
    forever begin
        `uvm_info(get_type_name(), $sformatf("STARTED RUNNING driver:   "), UVM_LOW)
        // gets a new transaction from the sequencer once current transaction has finished
        seq_item_port.get_next_item(req);
        // drive respective interface signals
        drive();
        // inform sequencer that the current operation with transaction has finished
        seq_item_port.item_done();
        `uvm_info(get_type_name(), $sformatf("COMPLETED RUNNING driver: "), UVM_LOW)
    end
endtask : run_phase

// ------------------------------------------ task reset_signals
task alu_driver :: reset_signals();
    @(posedge alu_vif.driver_modport.clk iff (alu_vif.driver_modport.reset_n));
    `DRV_XMR.in_dataA   <= '0;
    `DRV_XMR.in_dataB   <= '0;
    `DRV_XMR.in_mode    <= '0;
    @(posedge alu_vif.driver_modport.clk iff (alu_vif.driver_modport.reset_n));
endtask : reset_signals

// ------------------------------------------ task drive
task alu_driver :: drive();
    // drive input if and only if reset_n is HIGH
    @(posedge alu_vif.driver_modport.clk iff (alu_vif.driver_modport.reset_n));
    // drive data to inputs in Nth clock cycle
    `DRV_XMR.in_dataA   <= req.in_dataA;
    `DRV_XMR.in_dataB   <= req.in_dataB;
    `DRV_XMR.in_mode    <= req.in_mode;
    @(posedge alu_vif.driver_modport.clk iff (alu_vif.driver_modport.reset_n));
endtask : drive
