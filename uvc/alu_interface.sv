
interface alu_interface(input logic clk, reset_n);

    // ------------------------------------------ signals from the ALU IP
    logic [7:0] in_dataA;
    logic [7:0] in_dataB;
    logic [3:0] in_mode;
    logic [7:0] out_data;
    logic       out_cout;

    // ------------------------------------------ driver clocking block
    // All IO pins/ports direction must be reversed. For the driver clocking block:
    // all the DUT input ports are changed to output ports.
    // all the DUT output ports are changed to input ports.
    clocking driver_cb @(posedge clk);
        default input #1 output #1;
        output  in_dataA;
        output  in_dataB;
        output  in_mode;
        input   out_data;
        input   out_cout;
    endclocking

    // ------------------------------------------ monitor clocking block
    // For the monitor clocking block:
    // All the DUT input and output ports are changed to input ports.
    clocking monitor_cb @(posedge clk);
        default input #1 output #1;
        input   in_dataA;
        input   in_dataB;
        input   in_mode;
        input   out_data;
        input   out_cout;
    endclocking

    // ------------------------------------------ driver modport
    modport driver_modport (input clk, reset_n, clocking driver_cb);
    // modport driver_modport (
    //     input out_data, out_cout,
    //     output in_dataA, in_dataB, in_mode
    // );

    // ------------------------------------------ monitor modport
    modport monitor_modport (input clk, reset_n, clocking monitor_cb);
    // modport monitor_modport (
    //     input in_dataA, in_dataB, in_mode, out_data, out_cout
    // );

endinterface : alu_interface