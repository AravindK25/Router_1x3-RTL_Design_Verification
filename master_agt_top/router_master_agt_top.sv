class router_master_agt_top extends uvm_env;

	`uvm_component_utils(router_master_agt_top)
	
	router_env_config router_env_cfg;
	router_master_agent master_agth[];

	extern function new(string name = "router_master_agt_top",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
endclass:router_master_agt_top

	function router_master_agt_top::new(string name="router_master_agt_top",uvm_component parent);

	super.new(name,parent);
	endfunction

	function void router_master_agt_top::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",router_env_cfg))
	`uvm_fatal("ENV_CONFIG","cannot get env_config.have you set it?")
	
	if(router_env_cfg.has_master_agent)
	begin
	master_agth=new[router_env_cfg.no_of_master_agents];
	foreach(master_agth[i])
	begin
	uvm_config_db #(router_master_agent_config)::set(this,"*","router_master_agent_config",router_env_cfg.master_cfg[i]);
	master_agth[i]=router_master_agent::type_id::create($sformatf("master_agth[%0d]",i),this);
	end
	end
		super.build_phase(phase);
	endfunction

	


