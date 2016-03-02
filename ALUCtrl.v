`define LWSW 	2'b00
`define BEQ 	2'b01
`define RTYPE 	2'b10
`define ADDFUNCT 6'b100000
`define SUBFUNCT 6'b100010
`define ANDFUNCT 6'b100100
`define ORFUNCT  6'b100101
`define SETFUNCT 6'b101010

module ALU_Ctrl(Funct, ALUOp, ALUCtr)

	input wire[5:0] Funct;
	input wire[1:0] ALUOp;
	output wire[3:0] ALUCtr;
	
	#26
		case(ALUOp)
			`LWSW:	assign ALUCtr = 2;
			`BEQ:	assign ALUCtr = 6;
			`RTYPE: begin
				case(Funct)
					`ADDFUNCT: assign ALUCtr = 2;
					`SUBFUNCT: assign ALUCtr = 6;
					`ANDFUNCT: assign ALUCtr = 0;
					`ORFUNCT:  assign ALUCtr = 1;
					`SETFUNCT: assign ALUCtr = 7;
				endcase
			end
		endcase
	
endmodule