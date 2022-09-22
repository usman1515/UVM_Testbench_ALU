class alu_transaction extends uvm_sequence_item;

    // ------------------------------------------ declare IO signals
    // random values to be driven to the inputs
    rand bit    [7:0]   in_dataA;
    rand bit    [7:0]   in_dataB;
    rand bit    [3:0]   in_mode;
    // store the output result
    bit         [7:0]   out_data;
    bit                 out_cout;
    // ------------------------------------------ UVM utility and field macros
    `uvm_object_utils_begin(alu_transaction)
        `uvm_field_int(in_dataA,    UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(in_dataB,    UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(in_mode,     UVM_ALL_ON | UVM_DEC)
        `uvm_field_int(out_data,    UVM_ALL_ON | UVM_HEX)
        `uvm_field_int(out_cout,    UVM_ALL_ON | UVM_BIN)
    `uvm_object_utils_end
    // ------------------------------------------ constructor
    extern function new(string name="alu_transaction");
    // ------------------------------------------ constraints
    constraint C_input_data_1 { in_dataA != in_dataB; };
    constraint C_input_data_2 { in_dataA > in_dataB; };
    // ------------------------------------------ DUT inputs/outputs printing
    extern function string inputs2str();
    extern function string outputs2str();

endclass : alu_transaction

//*================================================================================================
//*================================================================================================

// ------------------------------------------ constructor
function alu_transaction :: new(string name="alu_transaction");
    super.new(name);
endfunction : new

// ------------------------------------------ DUT inputs/outputs printing
function string alu_transaction :: inputs2str();
    if(in_mode < 'd4)
        return($sformatf("InData_A: %d | InData_B: %d | In_Mode: %d |",in_dataA, in_dataB, in_mode));
    else
        return($sformatf("InData_A: %h | InData_B: %h | In_Mode: %d |",in_dataA, in_dataB, in_mode));
endfunction : inputs2str

function string alu_transaction :: outputs2str();
    if(in_mode < 'd4)
        return($sformatf("OutData: %d | Cout: %d |",in_dataA, in_dataB, in_mode));
    else
        return($sformatf("OutData: %h | Cout: %d |",in_dataA, in_dataB, in_mode));
endfunction : outputs2str
