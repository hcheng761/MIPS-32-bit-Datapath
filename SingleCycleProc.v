// Texas A&M University          //
// cpsc350 Computer Architecture //
// $Id: SingleCycleProc.v,v 1.1 2002/04/08 23:16:14 miket Exp miket $ //

// instruction opcode

`define OPCODE_ADD     6'b000000
`define OPCODE_SUB     6'b000000
`define OPCODE_ADDU    6'b000000
`define OPCODE_SUBU    6'b000000
`define OPCODE_AND     6'b000000
`define OPCODE_OR      6'b000000
`define OPCODE_SLL     6'b000000
`define OPCODE_SRA     6'b000000
`define OPCODE_SRL     6'b000000
`define OPCODE_SLT     6'b000000
`define OPCODE_SLTU    6'b000000
`define OPCODE_XOR     6'b000000
`define OPCODE_JR      6'b000000
//I-Type (All opcodes except 000000, 00001x, and 0100xx)
`define OPCODE_ADDI    6'b001000
`define OPCODE_ADDIU   6'b001001
`define OPCODE_ANDI    6'b001100
`define OPCODE_BEQ     6'b000100
`define OPCODE_BNE     6'b000101
`define OPCODE_BLEZ    6'b000110
`define OPCODE_BLTZ    6'b000001
`define OPCODE_ORI     6'b001101
`define OPCODE_XORI    6'b001110
`define OPCODE_NOP     6'b110110
`define OPCODE_LUI     6'b001111
`define OPCODE_SLTI    6'b001010
`define OPCODE_SLTIU   6'b001011
`define OPCODE_LB      6'b100000
`define OPCODE_LW      6'b100011
`define OPCODE_SB      6'b101000
`define OPCODE_SW      6'b101011
// J-Type (Opcode 00001x)
`define OPCODE_J       6'b000010
`define OPCODE_JAL     6'b000011

`define ADD  4'b0111 // 2's compl add
`define ADDU 4'b0001 // unsigned add
`define SUB  4'b0010 // 2's compl subtract
`define SUBU 4'b0011 // unsigned subtract
`define AND  4'b0100 // bitwise AND
`define OR   4'b0101 // bitwise OR
`define XOR  4'b0110 // bitwise XOR
`define SLT  4'b1010 // set result=1 if less than 2's compl
`define SLTU 4'b1011 // set result=1 if less than unsigned
`define NOP  4'b0000 // do nothing

// Top Level Architecture Model //

`include "IdealMemory.v"
`include "PC.v"
`include "ControlUnit.v"
`include "ALU_behav.v"
`include "ALUCtrl.v"

/*-------------------------- CPU -------------------------------
 * This module implements a single-cycle
 * CPU similar to that described in the text book 
 * (for example, see Figure 5.19). 
 *
 */

//
// Input Ports
// -----------
// clock - the system clock (m555 timer).
//
// reset - when asserted by the test module, forces the processor to 
//         perform a "reset" operation.  (note: to reset the processor
//         the reset input must be held asserted across a 
//         negative clock edge).
//   
//         During a reset, the processor loads an externally supplied
//         value into the program counter (see startPC below).
//   
// startPC - during a reset, becomes the new contents of the program counter
//	     (starting address of test program).
// 
// Output Port
// -----------
// dmemOut - contains the data word read out from data memory. This is used
//           by the test module to verify the correctness of program 
//           execution.
//-------------------------------------------------------------------------

module SingleCycleProc(CLK, Reset_L, startPC, dmemOut);

   input 	Reset_L, CLK;
   input[31:0] startPC;
   output[31:0] dmemOut;
	
	wire[31:0] PC;
	wire[31:0] Instr;
    wire RegDst, MemRead, MemtoReg, MemWrite, RegWrite, ALUSrc, Branch, Jump;
	wire[1:0] ALUOp;
	wire[4:0] WriteReg;
	wire[31:0] ALUin, Writedata, Read1, Read2, Immediate;
	wire[31:0] Result;
	wire Zero;
	wire[3:0] ALUctrl;
	
	reg[8:0] loop_counter;
	
	initial
	begin
		loop_counter = 0;
		PC = startPC;
	end
	always@(negedge CLK)
	begin
	InstrMem IM1(PC, Instr);
	ControlUnit C1(RegDst,MemRead,MemtoReg,MemWrite,RegWrite, ALUSrc, Branch, Jump, WriteReg, ALUin, ALUOp, Writedata, Read1, Read2, Immediate, CLK, Reset_L, Instr, Result);
	ALUControl AC1(Instr[5:0], ALUOp, ALUctrl);
	#26
	ALU_behav ALU1(Read1, ALUin, ALUctrl, Writedata, Overflow, 1'b0, Carry_out, Zero); 
	PC = PC+4;
	end
	
	always@(negedge Reset_l)
	begin
		while(!Reset_l && loop_counter<500)	//wait for 10 clock cycles
		#1 loop_counter <= loop_counter + 1;
		end
	if(loop_counter>=500)
		PC<=startPC;
	end;

// Debugging threads that you may find helpful (you may have
// to change the variable names).
//
   /*  Monitor changes in the program counter
   always @(PC)
     #10 $display($time," PC=%d Instr: op=%d rs=%d rt=%d rd=%d imm16=%d funct=%d",
	PC,Instr[31:26],Instr[25:21],Instr[20:16],Instr[15:11],Instr[15:0],Instr[5:0]);
   */

   /*   Monitors memory writes
   always @(MemWrite)
	begin
	#1 $display($time," MemWrite=%b clock=%d addr=%d data=%d", 
	            MemWrite, clock, dmemaddr, rportb);
	end
   */
   
endmodule // CPU


module m555 (CLK);
   parameter StartTime = 0, Ton = 50, Toff = 50, Tcc = Ton+Toff; // 
 
   output CLK;
   reg 	  CLK;
   
   initial begin
      #StartTime CLK = 0;
   end
   
   // The following is correct if clock starts at LOW level at StartTime //
   always begin
      #Toff CLK = ~CLK;
      #Ton CLK = ~CLK;
   end
endmodule

   
module testCPU(Reset_L, startPC, testData);
   input [31:0] testData;
   output 	Reset_L;
   output [31:0] startPC;
   reg 		 Reset_L;
   reg [31:0] 	 startPC;
   
   initial begin
      // Your program 1
      Reset_L = 0;  startPC = 0 * 4;
      #101 // insures reset is asserted across negative clock edge
	  Reset_L = 1; 
      #1000; // allow enough time for program 1 to run to completion
      Reset_L = 0;
     // #1 $display ("Program 1: Result: %d", testData);
      
      // Your program 2
      //startPC = 14 * 4;
      //#101 Reset_L = 1; 
      //#10000;
      //Reset_L = 0;

      //#1 $display ("Program 2: Result: %d", testData);
      
      // etc.
      // Run other programs here
      
      
      $finish;
   end
endmodule // testCPU

module TopProcessor;
   wire reset, CLK, Reset_L;
   wire [31:0] startPC;
   wire [31:0] testData;
   
   m555 system_clock(CLK);
   SingleCycleProc SSProc(CLK, Reset_L, startPC, testData);
   testCPU tcpu(Reset_L, startPC, testData); 

endmodule // TopProcessor