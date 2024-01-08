module router_fsm(clock,resetn,pkt_valid,busy,parity_done,data_in,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
input clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2;
input [1:0] data_in;
output detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
output busy;

parameter DECODE_ADDRESS=3'b000;
parameter LOAD_FIRST_DATA=3'b001;
parameter WAIT_TILL_EMPTY=3'b010;
parameter LOAD_DATA=3'b011;
parameter LOAD_PARITY=3'b100;
parameter FIFO_FULL_STATE=3'b101;
parameter LOAD_AFTER_FULL=3'b110;
parameter CHECK_PARITY_ERROR=3'b111;

reg[2:0] present_state,next_state;
reg [1:0]addr;

//present_state logic
always@(posedge clock)
begin
if (!resetn)
present_state<=DECODE_ADDRESS;
else if((soft_reset_0 && addr==2'b00)||(soft_reset_1 && addr==2'b01)||(soft_reset_2 && addr==2'b10))
begin
present_state<=DECODE_ADDRESS;
end
else
present_state<=next_state;
end

//address register for soft reset logic
always@(posedge clock)
begin
if(!resetn)
addr<=2'b00;
else if(detect_add)
addr<=data_in;
end

//next_state logic
always@(*)
begin

next_state<=DECODE_ADDRESS;
case(present_state)
DECODE_ADDRESS:begin
if((pkt_valid && data_in[1:0]==2'd0 && fifo_empty_0)||(pkt_valid && data_in[1:0]==2'd1 && fifo_empty_1)||(pkt_valid && data_in[1:0]==2'd2 && fifo_empty_2))
next_state<=LOAD_FIRST_DATA;
else if ((pkt_valid && data_in[1:0]==2'd0 && !fifo_empty_0)||(pkt_valid && data_in[1:0]==2'd1 && !fifo_empty_1)||(pkt_valid && data_in[1:0]==2'd2 && !fifo_empty_2))
next_state<=WAIT_TILL_EMPTY;
else
next_state<=DECODE_ADDRESS;
end

LOAD_FIRST_DATA:begin next_state<=LOAD_DATA;
end

WAIT_TILL_EMPTY:begin
if((fifo_empty_0 && (addr==2'd0))||(fifo_empty_1 && (addr==2'd1))||(fifo_empty_2 && (addr==2'd2)))
next_state<=LOAD_FIRST_DATA;
else
next_state<=WAIT_TILL_EMPTY;
end

LOAD_DATA:begin
if(fifo_full)
next_state<=FIFO_FULL_STATE;
else if(!fifo_full && !pkt_valid)
next_state<=LOAD_PARITY;
else
next_state<=LOAD_DATA;
end

LOAD_PARITY:begin
next_state<=CHECK_PARITY_ERROR;
end

FIFO_FULL_STATE:begin
if(!fifo_full)
next_state<=LOAD_AFTER_FULL;
else
next_state<=FIFO_FULL_STATE;
end

LOAD_AFTER_FULL:begin
if(!parity_done && low_pkt_valid)
next_state<=LOAD_PARITY;
else if (!parity_done && !low_pkt_valid)
next_state<=LOAD_DATA;
else if (parity_done)
next_state<=DECODE_ADDRESS;
else
next_state<=LOAD_AFTER_FULL;
end

CHECK_PARITY_ERROR:begin
if(!fifo_full)
next_state<=DECODE_ADDRESS;
else
next_state<=FIFO_FULL_STATE;
end
default:next_state<=DECODE_ADDRESS;

endcase
end

//output logic
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==DECODE_ADDRESS)?8'b10000000:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==LOAD_FIRST_DATA)?8'b00000011:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==LOAD_DATA)?8'b01001000:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==LOAD_PARITY)?8'b00001001:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==FIFO_FULL_STATE)?8'b00010001:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==LOAD_AFTER_FULL)?8'b00101001:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==WAIT_TILL_EMPTY)?8'b00000001:8'bz;
assign {detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state,busy}=(present_state==CHECK_PARITY_ERROR)?8'b00000101:8'bz;

endmodule  


