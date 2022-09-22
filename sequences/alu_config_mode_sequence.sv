class alu_config_mode_sequence extends alu_base_sequence;

    // ------------------------------------------ UVM utility and field macros
    `uvm_object_utils(alu_config_mode_sequence)

    alu_transaction req;    // alu transaction object
    int N=1;                // number of iterations
    bit [3:0] config_mode;  // configure operation mode

    // ------------------------------------------ constructor
    function new(string name="alu_config_mode_sequence");
        super.new(name);
        // initialize a blank transaction
        req = alu_transaction::type_id::create("alu_transaction");
    endfunction : new

    // ------------------------------------------ main task of the sequence
    virtual task body();
        // generate N total transactions
        repeat(N) begin
            `uvm_info(get_type_name(), $sformatf("ENTERING sequence alu_config_mode_sequence"), UVM_LOW)
            `uvm_do_with(req, { req.in_mode == config_mode; })
            `uvm_info(get_type_name(), $sformatf("config mode: %d", config_mode), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("EXITING  sequence alu_config_mode_sequence"), UVM_LOW)
        end
    endtask : body

endclass : alu_config_mode_sequence