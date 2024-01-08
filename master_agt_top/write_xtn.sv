class write_xtn extends uvm_sequence_item;

	`uvm_object_utils(write_xtn)

	rand bit[7:0] header;
	rand bit[7:0] payload[];
	bit[7:0] parity;
	bit err;

//constraints
constraint wr_pkt{
	payload.size==header[7:2];
	header[1:0]!=3;
	header[7:2]!=0;
		}


//standard UVM methods
extern function new(string name="write_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass: write_xtn

function write_xtn::new(string name="write_xtn");
	super.new(name);
endfunction

function void write_xtn::do_print(uvm_printer printer);
super.do_print(printer);

printer.print_field( "header", this.header, 8, UVM_DEC );

printer.print_field( "header_address", this.header[1:0], 2, UVM_DEC );

foreach(this.payload[i])
printer.print_field( "payload", this.payload[i], 8, UVM_DEC );

printer.print_field( "parity", this.parity, 8, UVM_DEC);

endfunction

function void write_xtn::post_randomize();
	parity=0^header;
	foreach(payload[i])
		parity=parity^payload[i];
endfunction

 
