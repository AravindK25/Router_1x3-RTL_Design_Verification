class read_xtn extends uvm_sequence_item;

	`uvm_object_utils(read_xtn)

	 bit[7:0] header;
	 bit[7:0] payload[];
	 bit[7:0] parity;
	 rand bit [5:0]no_of_cycles;

extern function new(string name = "read_xtn");
extern function void do_print(uvm_printer printer);

endclass:read_xtn

function read_xtn::new(string name = "read_xtn");
	super.new(name);
endfunction:new


function void read_xtn::do_print(uvm_printer printer);
super.do_print(printer);

printer.print_field( "header", this.header, 8, UVM_DEC );

printer.print_field( "header_address", this.header[1:0], 2, UVM_DEC );

foreach(this.payload[i])
printer.print_field( "payload", this.payload[i], 8, UVM_DEC );

printer.print_field( "parity", this.parity, 8, UVM_DEC);

printer.print_field( "no_of_cycles", this.no_of_cycles, 6, UVM_DEC);

endfunction

