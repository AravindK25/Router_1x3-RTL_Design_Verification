interface router_if(input bit clock);

	logic resetn; //reset 
	logic read_enb; //read_enable
	logic pkt_valid; //packet_valid
	logic [7:0]data_in; //data_in
	logic [7:0]data_out; //data_out
	logic valid_out; //valid_out
	logic error,busy; //error signal and busy signal

//DUV modport
//	modport DUV_MP (input resetn,read_enb,pkt_valid,data_in,clock,output data_out,valid_out,error,busy);

//master driver clocking block

clocking master_cb_drv @(posedge clock);
	default input #1 output #1;
	input busy;
	input error;
	output data_in;
	output pkt_valid;
	output resetn;
endclocking

//master monitor clocking block
clocking master_cb_mon @(posedge clock);
	default input #1 output #1;
	input resetn;
	input pkt_valid;
	input data_in;
	input error;
	input busy;
endclocking

//slave driver clocking block
clocking slave_cb_drv @(posedge clock);
	default input #1 output #1;
	output read_enb;
	input valid_out;
endclocking

//slave monitor clocking block
clocking slave_cb_mon@(negedge clock);
	default input #1 output #1;
	input read_enb;
	input valid_out;
	input data_out;
endclocking

modport MASTER_DRV(clocking master_cb_drv);
modport MASTER_MON(clocking master_cb_mon);
modport SLAVE_DRV(clocking slave_cb_drv);
modport SLAVE_MON(clocking slave_cb_mon);

endinterface










