class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);

//facatory registration
`uvm_object_utils(router_vbase_seq);

router_env_config env_cfg;


router_small_packet_wr_xtns small_wr_xtns;
router_small_packet_rd_xtns small_rd_xtns;

router_medium_packet_wr_xtns medium_wr_xtns;
router_medium_packet_rd_xtns medium_rd_xtns;

router_big_packet_wr_xtns big_wr_xtns;
router_big_packet_rd_xtns big_rd_xtns;

router_virtual_sequencer v_seqrh;

router_master_sequencer m_seqrh[];

router_slave_sequencer s_seqrh[];

bit [1:0] addr;


extern function new(string name="router_vbase_seq");
extern task body();
endclass: router_vbase_seq

function router_vbase_seq::new(string name ="router_vbase_seq");
	super.new(name);
endfunction

task router_vbase_seq::body();

//get the env_config from database using uvm_config_db
	if(!uvm_config_db #(router_env_config)::get(null,get_full_name(),"router_env_config",env_cfg))
	`uvm_fatal("VSEQ","cannot get env_config  from uvm_config_db.have you set it?")

	m_seqrh=new[env_cfg.no_of_master_agents];
	s_seqrh=new[env_cfg.no_of_slave_agents];

assert($cast(v_seqrh,m_sequencer)) 
else 
	begin
	`uvm_error("BODY","Error in $cast of virtual sequencer")
	end

foreach(m_seqrh[i])
	m_seqrh[i]=v_seqrh.m_seqrh[i];
foreach(s_seqrh[i])
	s_seqrh[i]=v_seqrh.s_seqrh[i];
endtask:body


class router_small_vseq extends router_vbase_seq;
	
	`uvm_object_utils(router_small_vseq)

extern function new(string name= "router_small_vseq");
extern task body();
endclass:router_small_vseq

function router_small_vseq::new(string name= "router_small_vseq");
	super.new(name);
endfunction

task router_small_vseq::body();
	super.body();
small_wr_xtns=router_small_packet_wr_xtns::type_id::create("small_wr_xtns");
small_rd_xtns=router_small_packet_rd_xtns::type_id::create("small_rd_xtns");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"unable to get the address from configuration, check have you set it?")
	fork
		begin
		small_wr_xtns.start(m_seqrh[0]);
		//`uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
		end
		begin
		if(addr==2'b00)
		small_rd_xtns.start(s_seqrh[0]);
		if(addr==2'b01)
		small_rd_xtns.start(s_seqrh[1]);
		if(addr==2'b10)
		small_rd_xtns.start(s_seqrh[2]);
		end
		
	join
endtask



class router_medium_vseq extends router_vbase_seq;
	
	`uvm_object_utils(router_medium_vseq)

extern function new(string name= "router_medium_vseq");
extern task body();
endclass:router_medium_vseq

function router_medium_vseq::new(string name= "router_medium_vseq");
	super.new(name);
endfunction

task router_medium_vseq::body();
	super.body();
medium_wr_xtns=router_medium_packet_wr_xtns::type_id::create("medium_wr_xtns");
medium_rd_xtns=router_medium_packet_rd_xtns::type_id::create("medium_rd_xtns");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"unable to get the address from configuration, check have you set it?")
	fork
		begin
		medium_wr_xtns.start(m_seqrh[0]);
		//`uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
		end
		begin
		if(addr==2'b00)
		medium_rd_xtns.start(s_seqrh[0]);
		if(addr==2'b01)
		medium_rd_xtns.start(s_seqrh[1]);
		if(addr==2'b10)
		medium_rd_xtns.start(s_seqrh[2]);
		end
		
	join
endtask




class router_big_vseq extends router_vbase_seq;
	
	`uvm_object_utils(router_big_vseq)

extern function new(string name= "router_big_vseq");
extern task body();
endclass:router_big_vseq

function router_big_vseq::new(string name= "router_big_vseq");
	super.new(name);
endfunction

task router_big_vseq::body();
	super.body();
big_wr_xtns=router_big_packet_wr_xtns::type_id::create("big_wr_xtns");
big_rd_xtns=router_big_packet_rd_xtns::type_id::create("big_rd_xtns");
	if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
	`uvm_fatal(get_type_name(),"unable to get the address from configuration, check have you set it?")
	fork
		begin
		big_wr_xtns.start(m_seqrh[0]);
		//`uvm_info("virtual_sequence","end of body task of virtual sequence",UVM_LOW)
		end
		begin
		if(addr==2'b00)
		big_rd_xtns.start(s_seqrh[0]);
		if(addr==2'b01)
		big_rd_xtns.start(s_seqrh[1]);
		if(addr==2'b10)
		big_rd_xtns.start(s_seqrh[2]);
		end
		
	join
endtask









	
