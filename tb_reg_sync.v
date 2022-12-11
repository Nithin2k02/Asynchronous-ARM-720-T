`timescale 1ns / 1ps

module register_test;

reg[3:0] write_address_1;
reg[3:0] write_address_2;
reg[3:0] write_address_3;
reg[3:0] write_address_4;

reg[3:0] in_address_1;
reg[3:0] in_address_2;
reg[3:0] in_address_3;

//reg[31:0] write_data_1;
//reg write_enable_1 = 0;
reg[31:0] write_data_1;
reg[31:0] write_data_2;
reg[31:0] write_data_3;
reg[31:0] write_data_4;
reg write_enable_1;
reg write_enable_2;
reg write_enable_3;
reg write_enable_4;
reg read_enable_1;
reg read_enable_2;
reg read_enable_3;
reg read_enable_4;
 

reg[31:0] pc_update;
reg pc_write;

reg clk;

wire[31:0] out_data_1;
wire[31:0] out_data_2;
wire[31:0] out_data_3;
wire[31:0] cspr;
wire[31:0] pc;

reg[31:0] Rm;
reg[31:0] Rs;
wire[31:0] result;


reg_sync RegisterFile(	//inputs
							.in_address_1(in_address_1),
							.in_address_2(in_address_2),
							.in_address_3(in_address_3),
							.in_address_4(),

							
							.write_address_1(write_address_1),
							.write_address_2(write_address_2),
							.write_address_3(write_address_3),
							.write_address_4(write_address_4),
							.write_data_1(write_data_1),
							.write_data_2(write_data_2),
							.write_data_3(write_data_3),
							.write_data_4(write_data_4),
							.write_enable_1(write_enable_1),
							.write_enable_2(write_enable_2),
							.write_enable_3(write_enable_3),
							.write_enable_4(write_enable_4),
							.read_enable_1(read_enable_1),
							.read_enable_2(read_enable_2),
							.read_enable_3(read_enable_3),
							.read_enable_4(read_enable_4),
							
							.pc_update(pc_update), 
							.pc_write(pc_write), 
							.cspr_write(), 
							.cspr_update(),
							.clk(clk), 
							
							//outputs
							.out_data_1(out_data_1),
							.out_data_2(out_data_2),
							.out_data_3(out_data_3),
							
							
							
							.pc(pc), 
							.cspr(cspr)			
							
							);


 multiplier mult(.Rs(Rs), .Rm(Rm), .result(result));

initial 
begin
clk = 0;
forever
#5 clk = ~clk;
end

always @(negedge clk)
begin
	in_address_1 = write_address_1;
	in_address_2 = write_address_2;
	in_address_3 = write_address_3;
end


initial begin
       	
	write_address_1 = 0;
	write_address_2 = 0;
	write_address_3 = 0;
	write_address_4 = 0;
	
	#2 //[0,10) => delay of 10ns; [10,20) => delay of 20ns
	write_address_1 = 4'b0000;
   write_enable_1 = 1;
   write_data_1 = 32'h00000002;

	#20 // 
	write_address_2 = 4'b0001;
	write_enable_2 = 1;
	write_data_2 = 32'h00000001;

	//$display("pc %h", pc);
	#20
	read_enable_1 = 1;
	read_enable_2 = 1;
	#15
	Rs = out_data_1;
	Rm = out_data_2; 
	#5 
	repeat(30)  
	begin
	#5 
	write_address_3 = 4'b0010; //result address on address lines of reg
	write_enable_3 = 1; //indicates result address is set
	write_data_3 = result;	//write result in that reg
	//write_enable_3 = 0;	//indicates writing is done
	#15
	read_enable_3 = 1;
	#10 Rm = out_data_3; //result placed on bus; given to multiplier
	end

	#5 
	write_address_4 = 4'b0011;
	write_enable_4 = 1; 
	write_data_4 = result;
	//$display("pc %h", pc);
end 


endmodule
