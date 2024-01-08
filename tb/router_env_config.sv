class router_env_config extends uvm_object;

	int no_of_master_agents;
	int no_of_slave_agents;
	bit has_master_agent=1;
	bit has_slave_agent=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;

	router_master_agent_config master_cfg[];
	router_slave_agent_config slave_cfg[];

	`uvm_object_utils(router_env_config)

	extern function new(string name = "router_env_config");
	
endclass: router_env_config

	function router_env_config ::new(string name = "router_env_config");
	super.new(name);
	endfunction
