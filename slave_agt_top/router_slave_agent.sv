
class router_slave_agent extends uvm_agent;

`uvm_component_utils(router_slave_agent)

router_slave_agent_config slave_cfg;

router_slave_monitor slave_mon;
router_slave_sequencer slave_sequencer;
router_slave_driver slave_drv;


extern function new(string name="router_slave_agent",uvm_component parent =null);

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass :router_slave_agent

function router_slave_agent::new(string name="router_slave_agent", uvm_component parent =null);
	super.new(name,parent);
endfunction

function void router_slave_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	if(!uvm_config_db #(router_slave_agent_config)::get(this,"","router_slave_agent_config",slave_cfg))
	`uvm_fatal("SLAVE_CONFIG","cannot get config from uvm_config_db. have you set it?")
	slave_mon=router_slave_monitor::type_id::create("slave_mon",this);
	if(slave_cfg.is_active==UVM_ACTIVE)
	begin
	slave_drv=router_slave_driver::type_id::create("slave_drv",this);
	slave_sequencer=router_slave_sequencer::type_id::create("slave_sequencer",this);
	end
endfunction

function void router_slave_agent::connect_phase(uvm_phase phase);
	if(slave_cfg.is_active==UVM_ACTIVE)
	begin
	slave_drv.seq_item_port.connect(slave_sequencer.seq_item_export);
	end
endfunction

