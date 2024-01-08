module top;

//import ram_test_pkg
	
	import router_test_pkg::*;

//import uvm_pkg.sv
	import uvm_pkg::*;

//Generate clock signal
	bit clock;
	always
	#10 clock=!clock;

//Instantiate 4 router_if interface instances with clock as input

	router_if master_if(clock);
	router_if slave_if0(clock);
	router_if slave_if1(clock);
	router_if slave_if2(clock);

//Instantiate router soc

	router_1x3 DUV(.clock(clock), .resetn(master_if.resetn), .read_enb_0(slave_if0.read_enb), .read_enb_1(slave_if1.read_enb), .read_enb_2(slave_if2.read_enb), .data_in(master_if.data_in), .pkt_valid(master_if.pkt_valid), .data_out_0(slave_if0.data_out), .data_out_1(slave_if1.data_out), .data_out_2(slave_if2.data_out), .valid_out_0(slave_if0.valid_out), .valid_out_1(slave_if1.valid_out), .valid_out_2(slave_if2.valid_out), .error(master_if.error), .busy(master_if.busy));

//In initial block

	initial 
	begin
	
	//set the virtual interface instances as strings using the uvm_config_db
	uvm_config_db #(virtual router_if)::set(null,"*","master_vif_0",master_if);
	
	uvm_config_db #(virtual router_if)::set(null,"*","slave_vif_0",slave_if0);

	uvm_config_db #(virtual router_if)::set(null,"*","slave_vif_1",slave_if1);

	uvm_config_db #(virtual router_if)::set(null,"*","slave_vif_2",slave_if2);

	//call run_test

	run_test();
	end

endmodule



