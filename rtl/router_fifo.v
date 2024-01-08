module router_fifo(clock,resetn,write_enb,soft_reset,read_enb,data_in,lfd_state,empty,data_out,full);
input clock,resetn,soft_reset,read_enb,write_enb,lfd_state;
input [7:0]data_in;
output full,empty;
output reg [7:0]data_out;

reg [6:0]fifo_counter;//for detecting payload length+parity bit
reg [4:0]wr_ptr,rd_ptr;//read and write ptr for fifo
reg lfd_temp;
integer i;
reg [8:0] mem[15:0]; //16x9 memory is used in fifo,MSB(9th) bit is used to detect the lfd state (header packet)

//lfd_state logic
always@(posedge clock)
begin
if(!resetn)
lfd_temp<=0;
else
lfd_temp<=lfd_state;
end

//read and write pointer incrementing logic 
always@(posedge clock)
begin

if(!resetn)
begin
rd_ptr=5'b0;
wr_ptr=5'b0;
end

else if(soft_reset)
begin
rd_ptr=5'b0;
wr_ptr=5'b0;
end

else
begin
if(!full && write_enb)
wr_ptr<=wr_ptr+1;
else
wr_ptr<=wr_ptr;

if(!empty && read_enb)
rd_ptr<=rd_ptr+1;
else
rd_ptr<=rd_ptr;
end

end

//fifo down counter logic

always@(posedge clock)
begin

if(!resetn)
fifo_counter<=7'b0;

else if(soft_reset)
fifo_counter<=7'b0;

else if(read_enb && !empty)
begin
if(mem[rd_ptr[3:0]][8]==1'b1)   
fifo_counter<=mem[rd_ptr[3:0]][7:2]+1'b1;//payload length
else
fifo_counter<=fifo_counter-1'b1;
end
end

//read operation logic

always@(posedge clock)
begin
if(!resetn)
data_out<=8'b0;

else if(soft_reset)
data_out<=8'bz;

else
if(fifo_counter==0 && data_out!=0)
data_out<=8'bz;

else if(read_enb && ~empty)
data_out<=mem[rd_ptr[3:0]];

end

//write operation logic

always@(posedge clock)
begin
if(!resetn)
begin
for(i=0;i<16;i=i+1)
begin
mem[i]<=0;
end
end

else if(soft_reset)
begin
for(i=0;i<16;i=i+1)
begin
mem[i]<=0;
end
end


else
begin
if(write_enb && !full)
begin
{mem[wr_ptr[3:0]][8],mem[wr_ptr[3:0]][7:0]}<={lfd_temp,data_in};
end
end
end


//empty and full logic

assign full=(wr_ptr=={~rd_ptr[4],rd_ptr[3:0]})?1'b1:1'b0;
assign empty=(wr_ptr==rd_ptr)?1'b1:1'b0;
endmodule



