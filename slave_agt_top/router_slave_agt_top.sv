class router_slave_agt_top extends uvm_env;

	`uvm_component_utils(router_slave_agt_top)
	
	router_env_config router_env_cfg;
	router_slave_agent slave_agth[];

	extern function new(string name = "router_slave_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass:router_slave_agt_top

	function router_slave_agt_top::new(string name="router_slave_agt_top",uvm_component parent);

	super.new(name,parent);
	endfunction

	function void router_slave_agt_top::build_phase(uvm_phase phase);
	
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",router_env_cfg))
	`uvm_fatal("ENV_CONFIG", "cannot get env_config.have you set it?")

	if(router_env_cfg.has_slave_agent)
	begin
	slave_agth=new[router_env_cfg.no_of_slave_agents];
	foreach(slave_agth[i])
	begin
	uvm_config_db #(router_slave_agent_config)::set(this,$sformatf("slave_agth[%0d]*",i),"router_slave_agent_config",router_env_cfg.slave_cfg[i]);
	slave_agth[i]=router_slave_agent::type_id::create($sformatf("slave_agth[%0d]",i),this);
	end
	end
	super.build_phase(phase);
	endfunction
