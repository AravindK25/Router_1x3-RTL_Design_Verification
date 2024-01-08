package router_test_pkg;

	import uvm_pkg::*;
//include uvm_macros.sv
`include "uvm_macros.svh"
`include "write_xtn.sv"
`include "router_master_agent_config.sv"
`include "router_slave_agent_config.sv"
`include "router_env_config.sv"
`include "router_master_driver.sv"
`include "router_master_monitor.sv"
`include "router_master_sequencer.sv"
`include "router_master_agent.sv"
`include "router_master_agt_top.sv"
`include "router_master_sequence.sv"


`include "read_xtn.sv"
`include "router_slave_monitor.sv"
`include "router_slave_sequencer.sv"
`include "router_slave_sequence.sv"
`include "router_slave_driver.sv"
`include "router_slave_agent.sv"
`include "router_slave_agt_top.sv"

`include "router_virtual_sequencer.sv"
`include "router_virtual_sequences.sv"
`include "router_scoreboard.sv"

`include "router_env.sv"

`include "router_testcases.sv"
endpackage
