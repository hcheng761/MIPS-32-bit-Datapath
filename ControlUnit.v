`include "mux.v"
`include "registerfile.v"
`include "signextend.v"

module ControlUnit(RegDst,MemRead,MemtoReg,MemWrite,RegWrite, ALUSrc, Branch, Jump, WriteReg, ALUin, ALUOp, Writedata, Read1, Read2, Immediate, CLK, Reset_L, Instr, Result);
	
	output wire RegDst, MemRead, MemtoReg, MemWrite, RegWrite, ALUSrc, Branch, Jump;
	output wire[1:0] ALUOp;
	output wire[4:0] WriteReg;
	output wire[31:0] Writedata, Read1, Read2, Immediate, ALUin;
	
	input wire CLK, Reset_L;
	input wire[31:0] Instr;
	input wire[31:0] Result;	
	wire[31:0] memData;
	
	always@(negedge CLK)	//main control unit only deals with R-type instructions for now
	begin
		#20
		if(Instr[31:26]==0)
		begin
			RegDst <= 1;
			RegWrite <= 1;
			ALUSrc <= 0;
			ALUOp <= 2;
		end
	end
	
	always@(negedge CLK)
	begin
	#3
	SIGN_EXTEND SE1(Instr[15:0], Immediate);
	#3
	MUX5_2to1 mux1(Instr[20:16], Instr[15:11], RegDst, WriteReg);
	RegisterFile RF1(Read1, Read2, Writedata, Instr[25:21],Instr[20:16], WriteReg, RegWrite, CLK, Reset_L);
	#20
	MUX32_2to1 mux2(Read2, Immediate, ALUSrc, ALUin);
	#21
	MUX32_2to1 mux3(Result, memData, MemtoReg, Writedata);
	end
endmodule