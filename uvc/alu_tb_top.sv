`include "flist.sv"

module alu_tb_top();

    // ------------------------------------------ variable declaration
    localparam T=5; // time unit constant
    bit clk;
    bit reset_n;

    // ------------------------------------------ clock generation
    // clock has a period of (T*2) timeunits
    always begin
        #T clk = 1'b0;
        #T clk = 1'b1;
    end

    // ------------------------------------------ reset generation
    initial begin
        reset_n = 1'b1;
        // #(T*4) reset_n = 1'b0;
    end

    // ------------------------------------------ interface class declaration
    alu_interface alu_vif(clk, reset_n);

    // ------------------------------------------ connect the interface to the DUT instance
    alu DUT_ALU(
        .clk      (alu_vif.clk      ),
        .reset_n  (alu_vif.reset_n  ),
        .in_dataA (alu_vif.in_dataA ),
        .in_dataB (alu_vif.in_dataB ),
        .in_mode  (alu_vif.in_mode  ),
        .out_data (alu_vif.out_data ),
        .out_cout (alu_vif.out_cout )
    );

    // ------------------------------------------ main loop
    initial begin
        // register the interface in the UVM factory database with name alu_vif
        // so that other blocks can use it
        // uvm_resource_db #(virtual alu_interface)::set(.scope("ifs"), .name("alu_interface"), .val(alu_vif));
        uvm_config_db #(virtual alu_interface)::set(uvm_root::get(),"*","vif",alu_vif);
        // execute a specific test at runtime
        run_test();
    end

    // ------------------------------------------ enable the wave dump
    `ifdef VCD
    initial begin
        $dumpfile("tb_waves.vcd");
        $dumpvars;
    end
    `endif

    `ifdef FSDB
    initial begin
        $fsdbDumpfile("tb_waves.fsdb");
        $fsdbDumpvars(0,"+struct","+mda","+all");
    end
    `endif

    `ifdef VPD
    initial begin
        $vcdplusfile("tb_waves.vpd");
        $vcdpluson(0,alu_tb_top);
    end
    `endif


endmodule
