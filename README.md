# UVM Testbench ALU

This repo consists of a unit level UVM based testbench for a simple ALU (Arithmetic and Logic Unit) IP.

## Pre-Requisites
-   This unit level UVM testbench was compiled using Synopsys VCS compiler. Therefore inorder to run the compilation and simulation commands [Synopsys VCS]() must be pre-installed and loaded in the current shell session.

## Directory Structure
```
.
├── .vscode     // vscode settings and extension config files
├── scripts     // contains bash compilation scripts
├── sequences   // contains UVM sequences for testbench
├── src         // contains RTL file/s
├── tests       // contains UVM test case scenarios for tsetbench
├── uvc         // contains UVM testbench
├── Makefile
└── README.md
```
## How to Run
1.  To compile the RTL and UVM TB:
    ```bash
    make compile
    ```
2.  Run a specific test:
    ```bash
    make sim TEST=test_name
    ```
    You can look at the `test_name` from the file `./uvc/flist.sv`
3.  Compile and run a specific test:
    ```bash
    make runtest TEST=test_name
    ```
    You can look at the `test_name` from the file `./uvc/flist.sv`
4.  Run regression and coverage
    ```bash
    make runall
    ```
5.  Clean all data dump generated
    ```bash
    make clean
    ```