class alu_base_sequence extends uvm_sequence #(alu_transaction);

    // ------------------------------------------ UVM utility and field macros
    `uvm_object_utils(alu_base_sequence)

    // create object of alu transaction
    alu_transaction req;
    // int N=1; // number of transactions

    // ------------------------------------------ constructor
    function new(string name="alu_base_sequence");
        super.new(name);
    endfunction : new

    // ------------------------------------------ pre body sequence
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase(); // in UVM1.2, get starting phase from method
        `else
            phase = starting_phase;
        `endif
        if (phase != null) begin
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise objection", UVM_LOW)
        end
    endtask : pre_body

    // ------------------------------------------ main task of the sequence
    virtual task body();
        // generate N total transactions
        repeat(1) begin
            // initialize a blank transaction
            req = alu_transaction::type_id::create("alu_transaction");
            `uvm_info(get_type_name(), $sformatf("ENTERING sequence alu_base_sequence"), UVM_LOW)
            `uvm_do(req)
            `uvm_info(get_type_name(), $sformatf("EXITING  sequence alu_base_sequence"), UVM_LOW)
        end
    endtask : body

    // ------------------------------------------ post body sequence
    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase(); // in UVM1.2, get starting phase from method
        `else
            phase = starting_phase;
        `endif
        if (phase != null) begin
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_LOW)
        end
    endtask : post_body

endclass : alu_base_sequence
