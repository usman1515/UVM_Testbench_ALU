// Verifies the proper operation of a design at a functional level.
// Varies from project to project.

// If export connects to an analysis_fifo, then you do not need to use the macros because each fifo instance provides a write() implementation.
`uvm_analysis_imp_decl(_before)
`uvm_analysis_imp_decl(_after)

class alu_scoreboard extends uvm_scoreboard;

    // ------------------------------------------ UVM macros
    `uvm_component_utils(alu_scoreboard)

    // ------------------------------------------ analysis ports
    // connect monitors to the scoreboards
    uvm_analysis_export #(alu_transaction) alu_scb_ap_before;
    uvm_analysis_export #(alu_transaction) alu_scb_ap_after;

    // ------------------------------------------ uvm analysis fifos for syncing mon before and after transactions.
    uvm_tlm_analysis_fifo #(alu_transaction) scb_before_fifo;
    uvm_tlm_analysis_fifo #(alu_transaction) scb_after_fifo;

    // create object of alu transaction
    alu_transaction alu_trans_before;
    alu_transaction alu_trans_after;

    // vector counters
    int VECTOR_CNT  = 0;
    int PASS_CNT    = 0;
    int ERROR_CNT   = 0;

    // ------------------------------------------ constructor
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // ------------------------------------------ build phase
    function void build_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED BUILDING alu_scoreboard:      "), UVM_LOW)
        super.build_phase(phase);
        // create object to store analysis exports
        alu_scb_ap_before   = new("alu_scb_ap_before", this);
        alu_scb_ap_after    = new("alu_scb_ap_after", this);
        // create object to store analysis fifos
        scb_before_fifo     = new("scb_before_fifo", this);
        scb_after_fifo      = new("scb_after_fifo", this);
        // create object to store alu transactions
        alu_trans_before    = new("alu_trans_before");
        alu_trans_after     = new("alu_trans_after");
        `uvm_info(get_type_name(), $sformatf("COMPLETED BUILDING alu_scoreboard:    "), UVM_LOW)
    endfunction : build_phase

    // ------------------------------------------ connect phase
    function void connect_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("STARTED CONNECTING alu_scoreboard:    "), UVM_LOW)
        super.connect_phase(phase);
        alu_scb_ap_before.connect(scb_before_fifo.analysis_export);
        alu_scb_ap_after.connect(scb_after_fifo.analysis_export);
        `uvm_info(get_type_name(), $sformatf("COMPLETED CONNECTING alu_scoreboard:  "), UVM_LOW)
    endfunction : connect_phase

    // ------------------------------------------ run task
    task run();
        forever begin
            // `uvm_info(get_type_name(), $sformatf("STARTED RUNNING alu_scoreboard:   "), UVM_LOW)
            // store current transaction in fifo
            scb_before_fifo.get(alu_trans_before);
            scb_after_fifo.get(alu_trans_after);
            // compare the transactions
            compare_trans();
            // `uvm_info(get_type_name(), $sformatf("COMPLETED RUNNING alu_scoreboard: "), UVM_LOW)
        end
    endtask : run

    // ------------------------------------------ report phase
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
        if(!ERROR_CNT && (VECTOR_CNT > 0)) begin
            `uvm_info(get_type_name(), $sformatf("==================================================================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("=========================== TEST PASSED ==========================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("==================================================================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("| Vectors Ran: %d | Vectors Passed: %d | Vectors Failed: %d |", VECTOR_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
        end
        else begin
            `uvm_info(get_type_name(), $sformatf("==================================================================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("=========================== TEST FAILED ==========================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("==================================================================="), UVM_LOW)
            `uvm_info(get_type_name(), $sformatf("| Vectors Ran: %d | Vectors Passed: %d | Vectors Failed: %d |", VECTOR_CNT, PASS_CNT, ERROR_CNT), UVM_LOW)
        end
    endfunction : report_phase

    // ------------------------------------------ compare function
    virtual function void compare_trans();
        if( alu_trans_before.out_data === alu_trans_after.out_data && alu_trans_before.out_cout === alu_trans_after.out_cout) begin
            if( alu_trans_before.in_mode >= 0 && alu_trans_before.in_mode <= 3) begin
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_A: %3d === expected InData_A: %3d |",  alu_trans_before.in_dataA,  alu_trans_after.in_dataA),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_B: %3d === expected InData_B: %3d |",  alu_trans_before.in_dataB,  alu_trans_after.in_dataB),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InMode:   %3d === expected InMode:   %3d |",  alu_trans_before.in_mode,   alu_trans_after.in_mode),   UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual OutData:  %3d === expected OutData:  %3d |",  alu_trans_before.out_data,  alu_trans_after.out_data),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual Cout:    %3d === expected Cout:     %3d |",  alu_trans_before.out_cout,  alu_trans_after.out_cout),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------- actual data IS EQUAL TO expected data ----------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                PASS();
            end
            else begin
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_A: %8b === expected InData_A: %8b |",  alu_trans_before.in_dataA,  alu_trans_after.in_dataA),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_B: %8b === expected InData_B: %8b |",  alu_trans_before.in_dataB,  alu_trans_after.in_dataB),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InMode:   %8d === expected InMode:   %8d |",  alu_trans_before.in_mode,   alu_trans_after.in_mode),   UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual OutData:  %8b === expected OutData:  %8b |",  alu_trans_before.out_data,  alu_trans_after.out_data),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual Cout:     %8d === expected Cout:     %8d |",  alu_trans_before.out_cout,  alu_trans_after.out_cout),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------- actual data IS EQUAL TO expected data ----------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                PASS();
            end
        end
        else begin
            if( alu_trans_before.in_mode >= 0 && alu_trans_before.in_mode <= 3) begin
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_A: %3d !== expected InData_A: %3d |",  alu_trans_before.in_dataA,  alu_trans_after.in_dataA),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_B: %3d !== expected InData_B: %3d |",  alu_trans_before.in_dataB,  alu_trans_after.in_dataB),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InMode:   %3d !== expected InMode:   %3d |",  alu_trans_before.in_mode,   alu_trans_after.in_mode),   UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual OutData:  %3d !== expected OutData:  %3d |",  alu_trans_before.out_data,  alu_trans_after.out_data),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual Cout:     %3d !== expected Cout:     %3d |",  alu_trans_before.out_cout,  alu_trans_after.out_cout),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------- actual data IS NOT EQUAL TO expected data ----------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------------------------------------------------------------"), UVM_LOW)
                ERROR();
            end
            else begin
                `uvm_info(get_type_name(), $sformatf("-----------------------------------------------------------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_A: %8b !== expected InData_A: %8b |",  alu_trans_before.in_dataA,  alu_trans_after.in_dataA),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InData_B: %8b !== expected InData_B: %8b |",  alu_trans_before.in_dataB,  alu_trans_after.in_dataB),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual InMode:   %8d !== expected InMode:   %8d |",  alu_trans_before.in_mode,   alu_trans_after.in_mode),   UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual OutData:  %8b !== expected OutData:  %8b |",  alu_trans_before.out_data,  alu_trans_after.out_data),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("| actual Cout:     %8d !== expected Cout:     %8d |",  alu_trans_before.out_cout,  alu_trans_after.out_cout),  UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------- actual data IS NOT EQUAL TO expected data ----------"), UVM_LOW)
                `uvm_info(get_type_name(), $sformatf("---------------------------------------------------------------"), UVM_LOW)
                ERROR();
            end
        end
    endfunction : compare_trans

    function void PASS();
        VECTOR_CNT++;
        PASS_CNT++;
    endfunction : PASS

    function void ERROR();
        VECTOR_CNT++;
        ERROR_CNT++;
    endfunction : ERROR

endclass : alu_scoreboard
