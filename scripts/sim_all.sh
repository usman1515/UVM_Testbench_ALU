#!/bin/bash

# script start time
start_time=$(date +%s)

# compile UVM environment
make compile

# array to store test names
declare -a test_list=(
                        "alu_arithmetic_add_test"
                        "alu_arithmetic_div_test"
                        "alu_arithmetic_mul_test"
                        "alu_arithmetic_sub_test"
                        "alu_shift_left_logical_test"
                        "alu_shift_right_logical_test"
                        "alu_rotate_left_test"
                        "alu_rotate_right_test"
                        "alu_logical_and_test"
                        "alu_logical_or_test"
                        "alu_logical_xor_test"
                        "alu_logical_nand_test"
                        "alu_logical_nor_test"
                        "alu_logical_xnor_test"
                        "alu_compare_greater_test"
                        "alu_compare_equal_test"
					)

# simulate all tests
for ((i=0; i < ${#test_list[@]}; i++));
do
	make runtest TEST=${test_list[i]}
done

# script end time
end_time=$(date +%s)
# elapsed time with second resolution
elapsed=$(( end_time - start_time ))

echo " "
echo "----------------------------------------------------------------------------"
echo "-------------------------------- Elapsed Time ------------------------------"
eval "echo Start time:   $(date -ud "@$start_time" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo End time:     $(date -ud "@$end_time" +'$((%s/3600/24)) days %H hr %M min %S sec')"
eval "echo Elapsed time: $(date -ud "@$elapsed" +'$((%s/3600/24)) days %H hr %M min %S sec')"
echo "----------------------------------------------------------------------------"
echo " "