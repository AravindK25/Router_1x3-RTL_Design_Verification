class router_master_sequencer extends uvm_sequencer #(write_xtn);


	`uvm_component_utils(router_master_sequencer)

	extern function new(string name="router_master_sequencer",uvm_component parent);

endclass

function router_master_sequencer::new(string name="router_master_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction
