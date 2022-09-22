`timescale 1ns/100ps

// -------------------------------- pre defined macros
import uvm_pkg::*;
`include "uvm_macros.svh"
// `include "defines.svh"
`include "alu_interface.sv"

// -------------------------------- UVM Environment
`include "alu_transaction.sv"
`include "alu_sequencer.sv"
`include "alu_driver.sv"
`include "alu_monitor_before.sv"
`include "alu_monitor_after.sv"
`include "alu_agent.sv"
`include "alu_scoreboard.sv"
`include "alu_environment.sv"

// --------------------------------------------------------- Sequences
`include "../sequences/alu_base_sequence.sv"
`include "../sequences/alu_config_mode_sequence.sv"
// ---------------------------------------------------------

// --------------------------------------------------------- Test cases
`include "../tests/alu_base_test.sv"

`include "../tests/alu_arithmetic_add_test.sv"
`include "../tests/alu_arithmetic_div_test.sv"
`include "../tests/alu_arithmetic_mul_test.sv"
`include "../tests/alu_arithmetic_sub_test.sv"
`include "../tests/alu_shift_left_logical_test.sv"
`include "../tests/alu_shift_right_logical_test.sv"
`include "../tests/alu_rotate_left_test.sv"
`include "../tests/alu_rotate_right_test.sv"
`include "../tests/alu_logical_and_test.sv"
`include "../tests/alu_logical_or_test.sv"
`include "../tests/alu_logical_xor_test.sv"
`include "../tests/alu_logical_nand_test.sv"
`include "../tests/alu_logical_nor_test.sv"
`include "../tests/alu_logical_xnor_test.sv"
`include "../tests/alu_compare_greater_test.sv"
`include "../tests/alu_compare_equal_test.sv"
// ---------------------------------------------------------

// `include "alu_tb_top.sv"
