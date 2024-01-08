
class router_slave_sequencer extends uvm_sequencer #(read_xtn);


	`uvm_component_utils(router_slave_sequencer)

	extern function new(string name="router_slave_sequencer",uvm_component parent);

endclass

function router_slave_sequencer::new(string name="router_slave_sequencer", uvm_component parent);
	super.new(name,parent);
endfunction
