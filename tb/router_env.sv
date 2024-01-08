class router_env extends uvm_env;

`uvm_component_utils(router_env)

	router_master_agt_top master_top;
	router_slave_agt_top slave_top;

	router_virtual_sequencer v_sequencer;
	
	router_env_config router_env_cfg;

	router_scoreboard sb;

	extern function new(string name="router_env", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
endclass: router_env

	function router_env::new(string name="router_env", uvm_component parent);
	super.new(name,parent);

	endfunction

	function void router_env::build_phase(uvm_phase phase);

	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",router_env_cfg))
	`uvm_fatal("Router_env_config","Not able to get router config object,have you set it?")

	if(router_env_cfg.has_master_agent)
	begin
	master_top=router_master_agt_top::type_id::create("master_top",this);
	end

	
	if(router_env_cfg.has_slave_agent)
	begin
	slave_top=router_slave_agt_top::type_id::create("slave_top",this);
	end

	super.build_phase(phase);
	
	if(router_env_cfg.has_virtual_sequencer)
	v_sequencer=router_virtual_sequencer::type_id::create("v_sequencer",this);

	if(router_env_cfg.has_scoreboard)
	sb=router_scoreboard::type_id::create("sb",this);

	endfunction

	function void router_env::connect_phase(uvm_phase phase);
	if(router_env_cfg.has_virtual_sequencer)begin
	if(router_env_cfg.has_master_agent)
		foreach(master_top.master_agth[i])
		v_sequencer.m_seqrh[i]=master_top.master_agth[i].master_sequencer;
		
	if(router_env_cfg.has_slave_agent)
		foreach(slave_top.slave_agth[i])
		v_sequencer.s_seqrh[i]=slave_top.slave_agth[i].slave_sequencer;

	if(router_env_cfg.has_scoreboard)
		begin
		if(router_env_cfg.has_master_agent)
		begin
		foreach(router_env_cfg.master_cfg[i])
			begin
			master_top.master_agth[i].master_mon.monitor_port.connect(sb.wr_fifo.analysis_export);
			end
		end
		if(router_env_cfg.has_slave_agent)
		begin
		foreach(router_env_cfg.slave_cfg[i])
		slave_top.slave_agth[i].slave_mon.monitor_port.connect(sb.rd_fifo[i].analysis_export);
		end
		end
	
	end
	endfunction












