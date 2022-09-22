// Self-contained model that observes the communication of the DUT with the testbench.
// Monitor is a passive component.
// monitor_after, will look for the inputs of the device, will generate and expected output
// and pass the result to the scoreboard.

class alu_monitor_after extends uvm_monitor;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_monitor_after)
    // ------------------------------------------ analysis port
    // to send transaction to scoreboard
    uvm_analysis_port #(alu_transaction) alu_mon_ap_after;
    // ------------------------------------------ virtual interface
    virtual alu_interface alu_vif;
    `define MON_XMR alu_vif.monitor_modport.monitor_cb
    bit [8:0] temp_result;
    // ------------------------------------------ transaction for recieving data
    alu_transaction alu_trans1;
    // ------------------------------------------ transaction for coverage
    alu_transaction alu_trans_cov;
    // ------------------------------------------ defining coverpoints and covergroup
    covergroup cg_alu;
        cp_in_dataA:    coverpoint alu_trans_cov.in_dataA;
        cp_in_dataB:    coverpoint alu_trans_cov.in_dataB;
        cp_in_mode:     coverpoint alu_trans_cov.in_mode;
        cp_out_data:    coverpoint alu_trans_cov.out_data;
        cp_out_cout:    coverpoint alu_trans_cov.out_cout;

        cross cp_in_dataA, cp_in_dataB;
        cross cp_in_dataA, cp_in_mode;
        cross cp_in_dataB, cp_in_mode;
        cross cp_out_data, cp_out_cout;
    endgroup : cg_alu
    // ------------------------------------------ constructor
    extern function new(string name, uvm_component parent);
    // ------------------------------------------ build phase
    extern function void build_phase(uvm_phase phase);
    // ------------------------------------------ connect phase
    extern function void connect_phase(uvm_phase phase);
    // ------------------------------------------ run phase
    extern task run_phase(uvm_phase phase);
    extern virtual function void predictor();

endclass : alu_monitor_after

//*================================================================================================
//*================================================================================================

// ------------------------------------------ constructor
function alu_monitor_after :: new(string name, uvm_component parent);
    super.new(name, parent);
    cg_alu = new;
endfunction

// ------------------------------------------ build phase
function void alu_monitor_after :: build_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("STARTED BUILDING monitor_after:    "), UVM_LOW)
    super.build_phase(phase);
    alu_mon_ap_after = new("alu_mon_ap_after", this);
    alu_trans1 = alu_transaction::type_id::create(.name("alu_trans1"), .contxt(get_full_name()));
    `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING monitor_after:  "), UVM_LOW)
endfunction : build_phase

// ------------------------------------------ connect phase
function void alu_monitor_after :: connect_phase(uvm_phase phase);
    `uvm_info(get_type_name(), $sformatf("STARTED CONNECTING monitor_after:    "), UVM_LOW)
    super.connect_phase(phase);
    // Get the interface from the factory database.
    // The same interface that is instantiated in the top block.
    if (!uvm_config_db #(virtual alu_interface)::get(this, "*", "vif", alu_vif))
        `uvm_fatal("NO VIF FOUND", $sformatf("virtual interface must be set for: ",get_full_name(),".vif"))
    `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING monitor_after:    "), UVM_LOW)
endfunction : connect_phase

// ------------------------------------------ run phase
task alu_monitor_after :: run_phase(uvm_phase phase);
    // create object to store temp alu transaction
    `uvm_info(get_type_name(), $sformatf("STARTED RUNNING monitor_after:   "), UVM_LOW)
    forever begin
        @(posedge alu_vif.monitor_modport.clk iff (alu_vif.monitor_modport.reset_n));
        alu_trans1.in_dataA = `MON_XMR.in_dataA;
        alu_trans1.in_dataB = `MON_XMR.in_dataB;
        alu_trans1.in_mode  = `MON_XMR.in_mode;
        // expected output generator
        @(posedge alu_vif.monitor_modport.clk iff (alu_vif.monitor_modport.reset_n));
        predictor();
        // generate coverage
        alu_trans_cov = alu_trans1;
        cg_alu.sample();
        // send the monitor transction to scoreboard via analysis port
        alu_mon_ap_after.write(alu_trans1);
    end
    `uvm_info(get_type_name(), $sformatf("COMPLETED RUNNING monitor_after: "), UVM_LOW)
endtask : run_phase

function void alu_monitor_after :: predictor();
    if (alu_trans1.in_mode == 4'd0)
        alu_trans1.out_data = alu_trans1.in_dataA + alu_trans1.in_dataB;    // add
    else if (alu_trans1.in_mode == 4'd1)
        alu_trans1.out_data = alu_trans1.in_dataA - alu_trans1.in_dataB;    // subtract
    else if (alu_trans1.in_mode == 4'd2)
        alu_trans1.out_data = alu_trans1.in_dataA * alu_trans1.in_dataB;    // multiply
    else if (alu_trans1.in_mode == 4'd3)
        alu_trans1.out_data = alu_trans1.in_dataA / alu_trans1.in_dataB;    // divide
    else if (alu_trans1.in_mode == 4'd4)
        alu_trans1.out_data = alu_trans1.in_dataA << 1;                     // left shift logical
    else if (alu_trans1.in_mode == 4'd5)
        alu_trans1.out_data = alu_trans1.in_dataA >> 1;                     // right shift logical
    else if (alu_trans1.in_mode == 4'd6)
        alu_trans1.out_data = {alu_trans1.in_dataA[6:0], alu_trans1.in_dataA[7]};        // rotate left
    else if (alu_trans1.in_mode == 4'd7)
        alu_trans1.out_data = {alu_trans1.in_dataA[0], alu_trans1.in_dataA[7:1]};        // rotate right
    else if (alu_trans1.in_mode == 4'd8)
        alu_trans1.out_data = alu_trans1.in_dataA & alu_trans1.in_dataB;                 // logical and
    else if (alu_trans1.in_mode == 4'd9)
        alu_trans1.out_data = alu_trans1.in_dataA | alu_trans1.in_dataB;                 // logical or
    else if (alu_trans1.in_mode == 4'd10)
        alu_trans1.out_data = alu_trans1.in_dataA ^ alu_trans1.in_dataB;                 // logical xor
    else if (alu_trans1.in_mode == 4'd11)
        alu_trans1.out_data = ~(alu_trans1.in_dataA & alu_trans1.in_dataB);              // logical nand
    else if (alu_trans1.in_mode == 4'd12)
        alu_trans1.out_data = ~(alu_trans1.in_dataA | alu_trans1.in_dataB);              // logical nor
    else if (alu_trans1.in_mode == 4'd13)
        alu_trans1.out_data = ~(alu_trans1.in_dataA ^ alu_trans1.in_dataB);              // logical xnor
    else if (alu_trans1.in_mode == 4'd14)
        alu_trans1.out_data = (alu_trans1.in_dataA > alu_trans1.in_dataB)? 8'd1 : 8'd0;  // greater comparison
    else if (alu_trans1.in_mode == 4'd15)
        alu_trans1.out_data = (alu_trans1.in_dataA == alu_trans1.in_dataB)? 8'd1 : 8'd0; // equal comparison
    else
        alu_trans1.out_data = alu_trans1.in_dataA + alu_trans1.in_dataB;
    //  carry out
    temp_result = {1'b0, alu_trans1.in_dataA} + {1'b0, alu_trans1.in_dataB};
    alu_trans1.out_cout = temp_result[8];
endfunction : predictor
