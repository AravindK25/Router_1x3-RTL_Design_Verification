
class router_slave_monitor extends uvm_monitor;


	`uvm_component_utils(router_slave_monitor)

	virtual router_if.SLAVE_MON slave_vif;

	int mon_xtns_count;

	read_xtn packet_rcvd;
	
	router_slave_agent_config slave_cfg;
	
	uvm_analysis_port #(read_xtn) monitor_port;
	
	extern function new(string name="router_slave_monitor",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task collect_data();
	extern function void report_phase(uvm_phase phase);
endclass

function router_slave_monitor::new(string name="router_slave_monitor", uvm_component parent);
	super.new(name,parent);
	monitor_port=new("monitor_port",this);
endfunction


function void router_slave_monitor::build_phase(uvm_phase phase);
	super.build_phase(phase);
if(!uvm_config_db #(router_slave_agent_config)::get(this,"","router_slave_agent_config",slave_cfg))
	`uvm_fatal("CONFIG","cannot get() slave_configuration rom uvm_config_db.Have you set it?")
endfunction

function void router_slave_monitor::connect_phase(uvm_phase phase);
	slave_vif=slave_cfg.slave_vif;
endfunction


task router_slave_monitor::run_phase(uvm_phase phase);
forever
collect_data();
endtask


task router_slave_monitor::collect_data();

	packet_rcvd=read_xtn::type_id::create("packet_rcvd");
	wait(slave_vif.slave_cb_mon.read_enb)
	@(slave_vif.slave_cb_mon);
	//packet_rcvd=read_xtn::type_id::create("packet_rcvd");
	packet_rcvd.header=slave_vif.slave_cb_mon.data_out;
	packet_rcvd.payload=new[packet_rcvd.header[7:2]];
	//	@(slave_vif.slave_cb_mon);
	foreach(packet_rcvd.payload[i])
	begin
	@(slave_vif.slave_cb_mon);
	packet_rcvd.payload[i]=slave_vif.slave_cb_mon.data_out;
	//@(slave_vif.slave_cb_mon);
	end
	@(slave_vif.slave_cb_mon);
	packet_rcvd.parity=slave_vif.slave_cb_mon.data_out;
	`uvm_info("ROUTER_SLAVE_MONITOR",$sformatf("printing from slave_monitor \n %s", packet_rcvd.sprint()),UVM_LOW)
	mon_xtns_count++;
	@(slave_vif.slave_cb_mon);
	monitor_port.write(packet_rcvd);
endtask


function void router_slave_monitor::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router slave  monitor received %0d transactions", mon_xtns_count), UVM_LOW)
endfunction






















