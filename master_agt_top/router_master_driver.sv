class router_master_driver extends uvm_driver #(write_xtn);


	`uvm_component_utils(router_master_driver)

	virtual router_if.MASTER_DRV master_vif;

	int write_xtns_count;

	router_master_agent_config master_cfg;

//standard UVM methods
	extern function new(string name="router_master_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task send_to_dut(write_xtn xtn);
	extern function void report_phase(uvm_phase phase);

endclass

function router_master_driver::new(string name="router_master_driver", uvm_component parent);
	super.new(name,parent);
endfunction

function void router_master_driver::build_phase(uvm_phase phase);
	super.build_phase(phase);
	
	if(!uvm_config_db #(router_master_agent_config)::get(this,"","router_master_agent_config",master_cfg))
	`uvm_fatal("CONFIG","cannot get() master_cfg from uvnm_config_db. Have you set it?")
endfunction

function void router_master_driver::connect_phase(uvm_phase phase);
	master_vif=master_cfg.master_vif;
endfunction

task router_master_driver::run_phase(uvm_phase phase);
	@(master_vif.master_cb_drv);
		master_vif.master_cb_drv.resetn<=0;
	@(master_vif.master_cb_drv);
		master_vif.master_cb_drv.resetn<=1;
	forever
	begin
	seq_item_port.get_next_item(req);
	//req.print(uvm_default_table_printer);
	send_to_dut(req);
	seq_item_port.item_done();
	end
endtask


task router_master_driver::send_to_dut(write_xtn xtn);
	
	`uvm_info("ROUTER_MASTER_DRIVER", $sformatf("printing the data from master_driver \n %s", xtn.sprint()), UVM_LOW)
	//xtn.print;
	//@(master_vif.master_cb_drv);
	wait(~master_vif.master_cb_drv.busy)
		@(master_vif.master_cb_drv);
		master_vif.master_cb_drv.pkt_valid<=1'b1;
		master_vif.master_cb_drv.data_in<=xtn.header;
		@(master_vif.master_cb_drv);
		for(int i=0;i<xtn.header[7:2];i++)
			begin
			wait(~master_vif.master_cb_drv.busy)
			master_vif.master_cb_drv.data_in<=xtn.payload[i];
			@(master_vif.master_cb_drv);
			end

			wait(~master_vif.master_cb_drv.busy)
			master_vif.master_cb_drv.pkt_valid<=1'b0;
			master_vif.master_cb_drv.data_in<=xtn.parity;	
			write_xtns_count++;
			@(master_vif.master_cb_drv);				

endtask
			
function void router_master_driver::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router master driver sent %0d transactions", write_xtns_count), UVM_LOW)
endfunction







	
