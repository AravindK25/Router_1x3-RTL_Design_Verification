class router_mbase_seq extends uvm_sequence #(write_xtn);
	
	`uvm_object_utils(router_mbase_seq)
	
	bit [1:0] address;


//standard UVM methods
	extern function new(string name= "router_mbase_seq");
endclass

function router_mbase_seq::new(string name= "router_mbase_seq");
	super.new(name);
endfunction


class router_small_packet_wr_xtns extends router_mbase_seq;

	`uvm_object_utils(router_small_packet_wr_xtns)

extern function new(string name= "router_small_packet_wr_xtns");
extern task body();
endclass

function router_small_packet_wr_xtns::new(string name= "router_small_packet_wr_xtns");
	super.new(name);
endfunction

task router_small_packet_wr_xtns::body();
//repeat(2)
//begin
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
	`uvm_fatal("small_packet_seq","cannot get address from uvm_config_db.have you set it?")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[0:20]};
				   header[1:0]==address;});
	finish_item(req);
//end
endtask



class router_medium_packet_wr_xtns extends router_mbase_seq;

	`uvm_object_utils(router_medium_packet_wr_xtns)

extern function new(string name= "router_medium_packet_wr_xtns");
extern task body();
endclass

function router_medium_packet_wr_xtns::new(string name= "router_medium_packet_wr_xtns");
	super.new(name);
endfunction

task router_medium_packet_wr_xtns::body();
//repeat(2)
//begin
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
	`uvm_fatal("medium_packet_seq","cannot get address from uvm_config_db.have you set it?")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[20:42]};
				   header[1:0]==address;});
	finish_item(req);
//end
endtask



class router_big_packet_wr_xtns extends router_mbase_seq;

	`uvm_object_utils(router_big_packet_wr_xtns)

extern function new(string name= "router_big_packet_wr_xtns");
extern task body();
endclass

function router_big_packet_wr_xtns::new(string name= "router_big_packet_wr_xtns");
	super.new(name);
endfunction

task router_big_packet_wr_xtns::body();
//repeat(2)
//begin
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"bit[1:0]",address))
	`uvm_fatal("big_packet_seq","cannot get address from uvm_config_db.have you set it?")
	req=write_xtn::type_id::create("req");
	start_item(req);
	assert(req.randomize with {header[7:2] inside {[43:63]};
				   header[1:0]==address;});
	finish_item(req);
//end
endtask

