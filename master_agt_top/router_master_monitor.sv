class router_master_monitor extends uvm_monitor;


	`uvm_component_utils(router_master_monitor)

	virtual router_if.MASTER_MON master_vif;

	int mon_xtns_count;

	write_xtn packet_sent;
	
	router_master_agent_config master_agt_cfg;
	
	uvm_analysis_port #(write_xtn) monitor_port;

	extern function new(string name="router_master_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);

endclass

function router_master_monitor::new(string name="router_master_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction

function void router_master_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(router_master_agent_config)::get(this,"","router_master_agent_config",master_agt_cfg))
	`uvm_fatal("CONFIG","cannot get() master_configuration rom uvm_config_db.Have you set it?")
endfunction

function void router_master_monitor::connect_phase(uvm_phase phase);
	master_vif=master_agt_cfg.master_vif;
endfunction


task router_master_monitor::run_phase(uvm_phase phase);
forever
collect_data();
endtask


task router_master_monitor::collect_data();
	wait(master_vif.master_cb_mon.pkt_valid)
	packet_sent=write_xtn::type_id::create("packet_sent");
	packet_sent.header=master_vif.master_cb_mon.data_in;
	packet_sent.payload=new[packet_sent.header[7:2]];
		@(master_vif.master_cb_mon);
	foreach(packet_sent.payload[i])
	begin
	wait(~master_vif.master_cb_mon.busy)
	packet_sent.payload[i]=master_vif.master_cb_mon.data_in;
	@(master_vif.master_cb_mon);
	end
	wait(~master_vif.master_cb_mon.busy)
	packet_sent.parity=master_vif.master_cb_mon.data_in;
	//packet_sent.print;
	`uvm_info("ROUTER_MASTER_MONITOR",$sformatf("printing from master_monitor \n %s", packet_sent.sprint()),UVM_LOW)
	mon_xtns_count++;
	@(master_vif.master_cb_mon);
	monitor_port.write(packet_sent);
endtask

	
function void router_master_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router master monitor received  %0d transactions", mon_xtns_count), UVM_LOW)
endfunction







