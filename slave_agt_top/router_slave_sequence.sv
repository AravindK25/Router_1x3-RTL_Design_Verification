class router_sbase_seq extends uvm_sequence #(read_xtn);

	`uvm_object_utils(router_sbase_seq)

	
//standard UVM methods
	extern function new(string name= "router_sbase_seq");
endclass

function router_sbase_seq::new(string name= "router_sbase_seq");
	super.new(name);
endfunction

class router_small_packet_rd_xtns extends router_sbase_seq;

	`uvm_object_utils(router_small_packet_rd_xtns)

extern function new(string name= "router_small_packet_rd_xtns");
extern task body();
endclass

function router_small_packet_rd_xtns::new(string name= "router_small_packet_rd_xtns");
	super.new(name);
endfunction

task router_small_packet_rd_xtns::body();

req=read_xtn::type_id::create("req");
start_item(req);
assert(req.randomize with {no_of_cycles inside {[1:28]};});
finish_item(req);
endtask


class router_medium_packet_rd_xtns extends router_sbase_seq;

	`uvm_object_utils(router_medium_packet_rd_xtns)

extern function new(string name= "router_medium_packet_rd_xtns");
extern task body();
endclass

function router_medium_packet_rd_xtns::new(string name= "router_medium_packet_rd_xtns");
	super.new(name);
endfunction

task router_medium_packet_rd_xtns::body();

req=read_xtn::type_id::create("req");
start_item(req);
assert(req.randomize with {no_of_cycles inside {[1:28]};});
finish_item(req);
endtask


class router_big_packet_rd_xtns extends router_sbase_seq;

	`uvm_object_utils(router_big_packet_rd_xtns)

extern function new(string name= "router_big_packet_rd_xtns");
extern task body();
endclass

function router_big_packet_rd_xtns::new(string name= "router_big_packet_rd_xtns");
	super.new(name);
endfunction

task router_big_packet_rd_xtns::body();

req=read_xtn::type_id::create("req");
start_item(req);
assert(req.randomize with {no_of_cycles inside {[1:28]};});
finish_item(req);
endtask




