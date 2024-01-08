module router_sync(detect_add,data_in,write_enb_reg,clock,resetn,vld_out_0,vld_out_1,vld_out_2,read_enb_0,read_enb_1,read_enb_2,write_enb,fifo_full,empty_0,empty_1,empty_2,soft_reset_0,soft_reset_1,soft_reset_2,full_0,full_1,full_2);
input clock,resetn,detect_add,write_enb_reg,read_enb_0,read_enb_1,read_enb_2,full_0,full_1,full_2,empty_0,empty_1,empty_2;
input [1:0]data_in;
output vld_out_0,vld_out_1,vld_out_2;
output reg fifo_full;
output reg soft_reset_0,soft_reset_1,soft_reset_2;
output reg[2:0] write_enb;
reg [1:0]int_reg_addr;
reg [4:0] timer0,timer1,timer2;

/*task timeout(input reset_n,vld_out,read_enb, output reg[4:0]timer, output reg soft_reset);
begin
if(~reset_n)
begin
timer<=5'b0;
soft_reset<=1'b0;
end

else if(vld_out)
begin
if(!read_enb)
begin
 if(timer>=5'b11101)
 begin
	timer<=5'b0;
	soft_reset<=1'b1;
end
end
else
begin
soft_reset<=1'b0;
timer<=timer+1;
end
end
end
endtask

//timer0 and soft_reset_0 logic
always@(posedge clock)
timeout(resetn,vld_out_0,read_enb_0,timer0,soft_reset_0);

//timer1 and soft_reset_1 logic
always@(posedge clock)
timeout(resetn,vld_out_1,read_enb_1,timer1,soft_reset_1);

//timer2 and soft_reset_2 logic
always@(posedge clock)
timeout(resetn,vld_out_2,read_enb_2,timer2,soft_reset_2);*/
always@(posedge clock)
begin
if(~resetn)
begin
timer0<=5'b0;
soft_reset_0<=1'b0;
end

else if(vld_out_0)
begin
if(~read_enb_0)
begin
 if(timer0>=5'b11101)
 begin
timer0<=5'b0;
soft_reset_0<=1'b1;
end
else
begin
soft_reset_0<=1'b0;
timer0<=timer0+1;
end
end
end
end

//timer 1 logic
always@(posedge clock)
begin
if(~resetn)
begin
timer1<=5'b0;
soft_reset_1<=1'b0;
end

else if(vld_out_1)
begin
if(~read_enb_1)
begin
 if(timer1>=5'b11101)
 begin
timer1<=5'b0;
soft_reset_1<=1'b1;
end
else
begin
soft_reset_1<=1'b0;
timer1<=timer1+1;
end
end
end
end

//timer 2 logic
always@(posedge clock)
begin
if(~resetn)
begin
timer2<=5'b0;
soft_reset_2<=1'b0;
end

else if(vld_out_2)
begin
if(~read_enb_2)
begin
 if(timer2>=5'b11101)
 begin
timer2<=5'b0;
soft_reset_2<=1'b1;
end
else
begin
soft_reset_2<=1'b0;
timer2<=timer2+1;
end
end
end
end

//internal register address logic
always @(posedge clock)
begin
  if (~resetn)
  int_reg_addr<=0;
  else if(detect_add)
  int_reg_addr<=data_in;
end



//write enable logic
always @(*)
begin
write_enb=3'b0;
if(write_enb_reg)
begin
case(int_reg_addr)
2'b00:write_enb = 3'b001;
2'b01:write_enb = 3'b010;
2'b10:write_enb = 3'b100;
default:write_enb<=3'b000;
endcase
end
end


//fifo full logic
always@(*)
begin
case(int_reg_addr)
2'b00:fifo_full=full_0;
2'b01:fifo_full=full_1;
2'b10:fifo_full=full_2;
default:fifo_full<=0;
endcase
end

//valid out logic
assign vld_out_0=(empty_0==1)?1'b0:1'b1;
assign vld_out_1=(empty_1==1)?1'b0:1'b1;
assign vld_out_2=(empty_2==1)?1'b0:1'b1;

endmodule

/*always@(*)
begin
case(int_reg_addr)
2'b00= full_0;
2'b01= full_1;
2'b10= full_2;
endcase
end*/

/*task timeout(input reset_n,vld_out,read_enb, output reg timer,soft_reset);
begin

if(reset_n)
begin
timer<=5'b0;
soft_reset<=1'b0;
end

else if(vld_out)
begin
if(!read_enb)
begin
 if(timer>=5'd29)
 begin
	timer<=5'b0;
	soft_reset<=1'b1;
end
end
else
begin
soft_reset<=1'b0;
timer<=timer+1'b1;
end
end
end
endtask


//internal register address logic
always @(posedge clock)
begin
  if (resetn)
  int_reg_addr<=0;
  else if(detect_add)
  int_reg_addr<=data_in;
end

//timer0 and soft_reset_0 logic
always@(posedge clock)
timeout(resetn,vld_out_0,read_enb_0,timer0,soft_reset_0);

//timer1 and soft_reset_1 logic
always@(posedge clock)
timeout(resetn,vld_out_1,read_enb_1,timer1,soft_reset_1);

//timer2 and soft_reset_2 logic
always@(posedge clock)
timeout(resetn,vld_out_2,read_enb_2,timer2,soft_reset_2);
*/


/*//internal timer timeout task for softreset logic
always@(posedge clock)
begin
if(~reset_n)
begin
timer<=5'b0;
soft_reset<=1'b0;
end

else if(vld_out_0||vld_out_1||vld_out_2)
begin
if(~read_enb_0||~read_enb_1||~read_enb_2)
begin
 if(timer>=5'd29)
 begin
	timer<=5'b0;
	soft_reset<=1'b1;
end
end
else
begin
soft_reset<=1'b0;
timer<=timer+1'b1;
end
end
else
timer<=5'b0;
end
endtask*/






/*

always@(posedge clock)
begin
if(~resetn)
begin
timer0<=5'b0;
soft_reset_0<=1'b0;
end

else if(vld_out_0 && ~read_enb_0)
begin
 if(timer0>=5'b11101)
 begin
timer0<=5'b0;
soft_reset_0<=1'b1;
end
end
else if(vld_out_0)
begin
soft_reset_0<=1'b0;
timer0<=timer1+1;
end
end


always@(posedge clock)
begin
if(~resetn)
begin
timer1<=5'b0;
soft_reset_1<=1'b0;
end

else if(vld_out_1 && ~read_enb_1)
begin
 if(timer1>=5'b11101)
 begin
timer1<=5'b0;
soft_reset_1<=1'b1;
end
end
else if(vld_out_1)
begin
soft_reset_1<=1'b0;
timer1<=timer1+1;
end
else
timer1<=0;
end



/*
always@(posedge clock)
begin
if(~resetn)
begin
timer1<=5'b0;
soft_reset_1<=1'b0;
end

else if(vld_out_1)
begin
if(~read_enb_1)
begin
 if(timer1>=5'b11101)
 begin
timer1<=5'b0;
soft_reset_1<=1'b1;
end
end
else
begin
soft_reset_1<=1'b0;
timer1<=timer1+1;
end
end
end
*/

