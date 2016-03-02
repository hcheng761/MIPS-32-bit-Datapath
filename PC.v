
module Reset(Reset_l, startPC,CLK);
output [31:0] Next;
input [31:0] startPC;
input Reset_l;
input CLK;

//master reset
reg[8:0] loop_counter;
loop_counter = 0;
always@(negedge Reset_l)
begin
	while(!Reset_l && loop_counter<500)	//wait for 10 clock cycles
	#1 loop_counter <= loop_counter + 1;
	end
	if(loop_counter>=500)
	Next<=startPC;
end;

endmodule