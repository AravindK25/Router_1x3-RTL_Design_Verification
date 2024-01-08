class router_slave_agent_config extends uvm_object;

`uvm_object_utils(router_slave_agent_config)

int no_of_slave_agents;

virtual router_if slave_vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;

extern function new(string name = "router_slave_agent_config");

endclass:router_slave_agent_config

function router_slave_agent_config::new(string name = "router_slave_agent_config");
	super.new(name);
endfunction
