class router_master_agent extends uvm_agent;

`uvm_component_utils(router_master_agent)

router_master_agent_config master_cfg;

router_master_monitor master_mon;
router_master_sequencer master_sequencer;
router_master_driver master_drv;


extern function new(string name="router_master_agent",uvm_component parent =null);

extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass :router_master_agent

function router_master_agent::new(string name="router_master_agent", uvm_component parent=null);
	super.new(name,parent);
endfunction

function void router_master_agent::build_phase(uvm_phase phase);
	super.build_phase(phase);
	master_mon=router_master_monitor::type_id::create("master_mon",this);
	if(!uvm_config_db #(router_master_agent_config)::get(this,"","router_master_agent_config",master_cfg))
	`uvm_fatal("MASTER_CONFIG","cannot get config from uvm_config_db. have you set it?")
	if(master_cfg.is_active==UVM_ACTIVE)
	begin
	master_drv=router_master_driver::type_id::create("master_drv",this);
	master_sequencer=router_master_sequencer::type_id::create("master_sequencer",this);
	end
endfunction

function void router_master_agent::connect_phase(uvm_phase phase);
	if(master_cfg.is_active==UVM_ACTIVE)
	begin
	master_drv.seq_item_port.connect(master_sequencer.seq_item_export);
	end
endfunction

