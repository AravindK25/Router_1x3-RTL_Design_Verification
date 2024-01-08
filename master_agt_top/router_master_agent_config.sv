class router_master_agent_config extends uvm_object;

`uvm_object_utils(router_master_agent_config)

virtual router_if master_vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

extern function new(string name = "router_master_agent_config");

endclass:router_master_agent_config

function router_master_agent_config::new(string name = "router_master_agent_config");
	super.new(name);
endfunction
