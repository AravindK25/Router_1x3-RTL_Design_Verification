module router_1x3(clock,resetn,read_enb_0,read_enb_1,read_enb_2,data_in,pkt_valid,data_out_0,data_out_1,data_out_2,valid_out_0,valid_out_1,valid_out_2,error,busy);
input clock,resetn,read_enb_0,read_enb_1,read_enb_2,pkt_valid;
input [7:0] data_in;
output[7:0] data_out_0,data_out_1,data_out_2;
output valid_out_0,valid_out_1,valid_out_2;
output error,busy;
wire w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16,w17,w18,w19;
wire [2:0]x;
wire [7:0]z;

router_fsm r_fsm(clock,resetn,pkt_valid,busy,w1,data_in[1:0],w2,w3,w4,w5,w6,w7,w8,w9,w10,w11,w12,w13,w14,w15,w16);
router_sync r_sync(w10,data_in[1:0],w14,clock,resetn,valid_out_0,valid_out_1,valid_out_2,read_enb_0,read_enb_1,read_enb_2,x,w5,w7,w8,w9,w2,w3,w4,w17,w18,w19);
router_reg r_reg(clock,resetn,pkt_valid,data_in,w5,w15,w10,w11,w12,w13,w16,w1,w6,error,z);
router_fifo r_fifo1(clock,resetn,x[0],w2,read_enb_0,z,w16,w7,data_out_0,w17);
router_fifo r_fifo2(clock,resetn,x[1],w3,read_enb_1,z,w16,w8,data_out_1,w18);
router_fifo r_fifo3(clock,resetn,x[2],w4,read_enb_2,z,w16,w9,data_out_2,w19);
endmodule
