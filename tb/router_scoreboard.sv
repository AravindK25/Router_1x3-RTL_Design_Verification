class router_scoreboard extends uvm_scoreboard;

	`uvm_component_utils(router_scoreboard);

	uvm_tlm_analysis_fifo#(write_xtn) wr_fifo;

	uvm_tlm_analysis_fifo#(read_xtn) rd_fifo[];

	router_env_config env_cfg;
	
	write_xtn wr_xtn;

	read_xtn rd_xtn1, rd_xtn2, rd_xtn3;

	read_xtn read_cov_data;//read_cov
	write_xtn write_cov_data;//write_cov
	int data_verified_count;

	extern function new(string name="router_scoreboard", uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern task run_phase(uvm_phase phase);
	extern task check_data(read_xtn rd);
	extern function void report_phase(uvm_phase phase);


//cover_group1
covergroup router_fcov1;
option.per_instance=1;
CHANNEL:coverpoint write_cov_data.header[1:0]{
				bins dest1 = {2'b00};
				bins dest2 = {2'b01};
				bins dest3 = {2'b10};
				}
PAYLOAD_SIZE:coverpoint write_cov_data.header[7:2]{
						bins small_packet = {[1:20]};
						bins medium_packet = {[20:42]};
						bins big_packet = {[43:63]};
						}
BAD_PKT:coverpoint write_cov_data.err{bins bad_pkt={1};}

CHANNEL_X_PAYLOAD_SIZE:cross CHANNEL,PAYLOAD_SIZE;

CHANNEL_X_PAYLOAD_SIZE_X_BAD_PKT:cross CHANNEL,PAYLOAD_SIZE,BAD_PKT;

endgroup

//covergroup2
covergroup router_fcov2;
option.per_instance=1;
CHANNEL:coverpoint read_cov_data.header[1:0]{
				bins dest1 = {2'b00};
				bins dest2 = {2'b01};
				bins dest3 = {2'b10};
				}
PAYLOAD_SIZE:coverpoint read_cov_data.header[7:2]{
						bins small_packet = {[1:15]};
						bins medium_packet = {[16:30]};
						bins big_packet = {[31:63]};
						}

CHANNEL_X_PAYLOAD_SIZE:cross CHANNEL,PAYLOAD_SIZE;

endgroup

endclass

function router_scoreboard::new(string name="router_scoreboard",uvm_component parent);
	super.new(name,parent);
	router_fcov1=new();//creating object for covergroup1
	router_fcov2=new();//creating object for covergroup2
endfunction

function void router_scoreboard::build_phase(uvm_phase phase);
	if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",env_cfg))
		`uvm_fatal("SB","cannot get the config data");
	rd_fifo=new[env_cfg.no_of_slave_agents];
	wr_fifo=new("wr_fifo",this);
	foreach(rd_fifo[i])
		rd_fifo[i]=new($sformatf("rd_fifo[%0d]",i),this);
	super.build_phase(phase);
endfunction


task router_scoreboard::run_phase(uvm_phase phase);
	
	fork
		begin
			forever
				begin
				wr_fifo.get(wr_xtn);
				`uvm_info("WRITE_SB","wr_fifo",UVM_LOW)
				wr_xtn.print;
				write_cov_data=wr_xtn;//cov
				router_fcov1.sample();//cov
				end
		end
		begin
			forever
				begin
				fork:A
					begin
						rd_fifo[0].get(rd_xtn1);
						`uvm_info("READ_SB[0]","rd_xtn1",UVM_LOW)
						rd_xtn1.print;
						check_data(rd_xtn1);
						read_cov_data=rd_xtn1;//cov
						router_fcov2.sample();//cov
					end
					
					begin
						rd_fifo[1].get(rd_xtn2);
						`uvm_info("READ_SB[1]","rd_xtn2",UVM_LOW)
						rd_xtn2.print;
						check_data(rd_xtn2);
						read_cov_data=rd_xtn2;//cov
						router_fcov2.sample();//cov
					end

					begin
						rd_fifo[2].get(rd_xtn3);
						`uvm_info("READ_SB[2]","rd_xtn3",UVM_LOW)
						rd_xtn3.print;
						check_data(rd_xtn3);
						read_cov_data=rd_xtn3;//cov
						router_fcov2.sample();//cov
					end
				join_any
					disable A;

				end
		end	
			join
endtask

task router_scoreboard::check_data(read_xtn rd);
	
	if(rd.header==wr_xtn.header)
	begin
	`uvm_info("SB","HEADER_MATCHED",UVM_MEDIUM)
		foreach(rd.payload[i])
		if(rd.payload[i]==wr_xtn.payload[i])
			`uvm_info("SB","PAYLOAD_MATCHED",UVM_MEDIUM)
		else
			`uvm_info("SB","PAYLOAD_MISMATCH",UVM_MEDIUM)
	end
	else
	`uvm_info("SB","HEADER_MISMATCH",UVM_MEDIUM)
	
	if(rd.parity==wr_xtn.parity)
	`uvm_info("SB","PARITY_MATCHED",UVM_MEDIUM)
	else
	`uvm_info("SB","PARITY_MISMATCH",UVM_MEDIUM)
	
	data_verified_count++;
endtask



function void router_scoreboard::report_phase(uvm_phase phase);
	`uvm_info(get_type_name(), $sformatf("Report: Router Scoreboard compared %0d transactions", data_verified_count), UVM_LOW)
endfunction
