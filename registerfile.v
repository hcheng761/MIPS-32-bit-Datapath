//6.3 Register File
module RegisterFile(Read1, Read2, Writedata, Readad1, Readad2, Writad, RegWr, CLK, RESET);
    output [31:0] Read1;
    output [31:0] Read2;
    input [31:0] Writedata;
	input [4:0] Readad1, Readad2, CLK, RESET;
    input RegWr, CLK, RESET;
    reg [31:0] reg0;		//32-bit registers
	reg [31:0] reg1;
	reg [31:0] reg2;
	reg [31:0] reg3;
	reg [31:0] reg4;
	reg [31:0] reg5;
	reg [31:0] reg6;
	reg [31:0] reg7;
	reg [31:0] reg8;
	reg [31:0] reg9;
	reg [31:0] reg10;
	reg [31:0] reg11;
	reg [31:0] reg12;
	reg [31:0] reg13;
	reg [31:0] reg14;
	reg [31:0] reg15;
	reg [31:0] reg16;
	reg [31:0] reg17;
	reg [31:0] reg18;
	reg [31:0] reg19;
	reg [31:0] reg20;
	reg [31:0] reg21;
	reg [31:0] reg22;
	reg [31:0] reg23;
	reg [31:0] reg24;
	reg [31:0] reg25;
	reg [31:0] reg26;
	reg [31:0] reg27;
	reg [31:0] reg28;
	reg [31:0] reg29;
	reg [31:0] reg30;
	reg [31:0] reg31;
	
	always@(negedge CLK)
	begin
		assign Read1 = regs(Readad1);
		assign Read2 = regs(Readad2);
	end
	
	always @(negedge CLK)
	begin
	#47
		if(RegWr)	//RegWr signal on
		begin
            regs[Writad] = Writedata;
		end
	end	
	
	always@(RegWr or Writedata)
	begin 
		$display("Register display: \n");
		$display("time %0d\t \n", $time);
		$display("reg[11] %b " ,regs[11]);
		$display("reg[12] %b " ,regs[12]);
		$display("reg[13] %b " ,regs[13]);
		$display("reg[14] %b " ,regs[14]);
		$display("reg[15] %b " ,regs[15]);
	end
	 
endmodule