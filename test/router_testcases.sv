class router_base_test extends uvm_test;

//factory registration
`uvm_component_utils(router_base_test)

//Handles for env & env_cfg
router_env router_envh;
router_env_config router_env_cfg;

//declare dynamic array for router_master_agent_config and router_slave_agent_config
router_master_agent_config  master_cfg[];
router_slave_agent_config slave_cfg[];

//declare no_of_master_agent,no_of_slave_agent,has_master_agent,has_slave_agent,has_scoreboard

	int no_of_master_agents=1;
	int no_of_slave_agents=3;
	bit has_master_agent=1;
	bit has_slave_agent=1;
	bit has_scoreboard=1;
	bit has_virtual_sequencer=1;
	bit [1:0] address;

//METHODS

//Standard UVM Methods:
	extern function new(string name = "router_base_test" , uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void end_of_elaboration_phase(uvm_phase phase);
	endclass


//Define constructor new() function
	function router_base_test::new(string name = "router_base_test" , uvm_component parent);
		super.new(name,parent);
	endfunction

	function void router_base_test::build_phase(uvm_phase phase);

	address={$urandom}%3;
	
	uvm_config_db #(bit[1:0])::set(this,"*","bit[1:0]",address);
//create environment config object
	router_env_cfg=router_env_config::type_id::create("router_env_cfg");
	
	if(has_master_agent)
			begin
		master_cfg=new[no_of_master_agents];
		router_env_cfg.master_cfg=new[no_of_master_agents];
		foreach(master_cfg[i])
		begin
		master_cfg[i]=router_master_agent_config::type_id::create($sformatf("master_cfg[%0d]",i));
		
		master_cfg[i].is_active=UVM_ACTIVE;
			
		if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("master_vif_%0d",i),master_cfg[i].master_vif))
		`uvm_fatal("Router_Base_Test","Unable to get master_interface,Have you set it?")

		router_env_cfg.master_cfg[i]=master_cfg[i];
		end
			end


	if(has_slave_agent)
			begin
		slave_cfg=new[no_of_slave_agents];
		router_env_cfg.slave_cfg=new[no_of_slave_agents];
		foreach(slave_cfg[i])
		begin
		slave_cfg[i]=router_slave_agent_config::type_id::create($sformatf("slave_cfg[%0d]",i));
		
		slave_cfg[i].is_active=UVM_ACTIVE;

		if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("slave_vif_%0d",i),slave_cfg[i].slave_vif))
		`uvm_fatal("Router_Base_Test","Unable to get slave_interface,Have you set it?")

	

		router_env_cfg.slave_cfg[i]=slave_cfg[i];
		end
	/*	if(slave_cfg[0].slave_vif==null)
		`uvm_fatal("Router_Base_Test","slave_interface,Have you set it?")*/
			end

	router_env_cfg.no_of_master_agents=no_of_master_agents;
	router_env_cfg.no_of_slave_agents=no_of_slave_agents;
	router_env_cfg.has_master_agent=has_master_agent;
	router_env_cfg.has_slave_agent=has_slave_agent;
	router_env_cfg.has_scoreboard=has_scoreboard;
	router_env_cfg.has_virtual_sequencer=has_virtual_sequencer;

	uvm_config_db #(router_env_config)::set(this,"*","router_env_config", router_env_cfg);

		super.build_phase(phase);

		router_envh=router_env::type_id::create("router_envh", this);
	endfunction

	function void router_base_test::end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology;
		super.end_of_elaboration_phase(phase);
	endfunction



class small_write_test extends router_base_test;

//factory registration
`uvm_component_utils(small_write_test)

router_small_vseq small_vseq;

//standard UVM methods
extern function new(string name= "small_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function small_write_test::new(string name="small_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void small_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task small_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	small_vseq=router_small_vseq::type_id::create("small_vseq");

	small_vseq.start(router_envh.v_sequencer);

	phase.drop_objection(this);
endtask


class medium_write_test extends router_base_test;

//factory registration
`uvm_component_utils(medium_write_test)

router_medium_vseq medium_vseq;

//standard UVM methods
extern function new(string name= "medium_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function medium_write_test::new(string name="medium_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void medium_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task medium_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	medium_vseq=router_medium_vseq::type_id::create("medium_vseq");

	medium_vseq.start(router_envh.v_sequencer);

	phase.drop_objection(this);
endtask



class big_write_test extends router_base_test;

//factory registration
`uvm_component_utils(big_write_test)

router_big_vseq big_vseq;

//standard UVM methods
extern function new(string name= "big_write_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

//constructor
function big_write_test::new(string name="big_write_test", uvm_component parent);
	super.new(name,parent);
endfunction

function void big_write_test::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction

task big_write_test::run_phase(uvm_phase phase);

	phase.raise_objection(this);

	big_vseq=router_big_vseq::type_id::create("big_vseq");

	big_vseq.start(router_envh.v_sequencer);

	phase.drop_objection(this);
endtask





