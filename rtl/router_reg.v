module router_reg(clock,resetn,pkt_valid,data_in,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_valid,err,dout);

input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0]data_in;
output reg parity_done,low_pkt_valid,err;
output reg [7:0]dout;

reg [7:0]header_byte,fifo_full_state_byte,internal_parity,packet_parity_byte;

//parity done logic

always@(posedge clock)
begin
if(!resetn)
parity_done<=0;
else if ((ld_state && ~fifo_full && ~pkt_valid) || (laf_state && low_pkt_valid && ~parity_done))
parity_done<=1'b1;
else if(detect_add)
parity_done<=0;
else
parity_done<=parity_done;
end

//low packet valid logic

always@(posedge clock)
begin
if(!resetn)
low_pkt_valid<=0;
else if(ld_state && ~pkt_valid)
low_pkt_valid<=1'b1;
else if(rst_int_reg)
low_pkt_valid<=0;
end

//parity internal register logic

always@(posedge clock)
begin
if(!resetn)
internal_parity<=0;
else if(detect_add)
internal_parity<=0;
else if(lfd_state)
internal_parity<=internal_parity^header_byte;
else if (ld_state && pkt_valid && ~full_state)//check this while running
internal_parity<=internal_parity^data_in;
else if(ld_state && low_pkt_valid && ~full_state)
internal_parity<=internal_parity^data_in;
else
internal_parity<=internal_parity;
end

//packet parity logic(receiveing from the data_in packet)
always@(posedge clock)
begin
if(!resetn)
packet_parity_byte<=0;
else if(detect_add)
packet_parity_byte<=0;
else if((ld_state && ~pkt_valid && ~fifo_full) || (laf_state && low_pkt_valid && !parity_done))
packet_parity_byte<=data_in;
else
packet_parity_byte<=packet_parity_byte;
end

//error logic
always@(posedge clock)
begin 
if(!resetn)
err<=0;
else if(!parity_done)
err<=0;
else if(internal_parity!=packet_parity_byte)
err<=1;
else
err<=0;
end

//internal header byte register logic

always@(posedge clock)
begin
if(!resetn)
header_byte<=0;
else if(detect_add && pkt_valid && data_in[1:0]!=2'b11)
header_byte<=data_in;
end

//data out logic

always@(posedge clock)
begin
if(!resetn)
dout<=8'b0;
else if(lfd_state)
dout<=header_byte;
else if(ld_state && !fifo_full)
dout<=data_in;
else if(ld_state && fifo_full)
fifo_full_state_byte<=data_in;
else if(laf_state)
dout<=fifo_full_state_byte;
end
endmodule


