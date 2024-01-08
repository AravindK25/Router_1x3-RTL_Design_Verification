
class router_slave_driver extends uvm_driver #(read_xtn);


	`uvm_component_utils(router_slave_driver)
	
	virtual router_if.SLAVE_DRV slave_vif;

	int read_xtns_count;

	router_slave_agent_config slave_cfg;

	extern function new(string name="router_slave_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(read_xtn xtn);
	extern function void report_phase(uvm_phase phase);
endclass

function router_slave_driver::new(string name="router_slave_driver", uvm_component parent);
	super.new(name,parent);
endfunction


function void router_slave_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_slave_agent_config)::get(this,"","router_slave_agent_config",slave_cfg))
	`uvm_fatal("CONFIG","cannot get() slave_cfg from uvnm_config_db. Have you set it?")
endfunction


function void router_slave_driver::connect_phase(uvm_phase phase);
	slave_vif=slave_cfg.slave_vif;
endfunction


task router_slave_driver::run_phase(uvm_phase phase);
	forever
	begin
	seq_item_port.get_next_item(req);
	//req.print(uvm_default_table_printer);
	send_to_dut(req);
	seq_item_port.item_done();
	end
endtask


task router_slave_driver::send_to_dut(read_xtn xtn);
	
	`uvm_info("ROUTER_SLAVE_DRIVER", $sformatf("printing the data from slave_driver \n %s", xtn.sprint()), UVM_LOW)

	@(slave_vif.slave_cb_drv);

	wait(slave_vif.slave_cb_drv.valid_out)

/*	repeat(xtn.no_of_cycles)
	@(slave_vif.slave_cb_drv);*/

	slave_vif.slave_cb_drv.read_enb<=1'b1;
	
	wait(~slave_vif.slave_cb_drv.valid_out)
	@(slave_vif.slave_cb_drv);

	slave_vif.slave_cb_drv.read_enb<=1'b0;

	read_xtns_count++;
	
	@(slave_vif.slave_cb_drv);

endtask
		
function void router_slave_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router slave driver sent %0d transactions", read_xtns_count), UVM_LOW)
endfunction



















