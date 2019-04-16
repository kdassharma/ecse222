-- Copyright (C) 1991-2013 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- ***************************************************************************
-- This file contains a Vhdl test bench template that is freely editable to   
-- suit user's needs .Comments are provided in each section to help the user  
-- fill out necessary details.                                                
-- ***************************************************************************
-- Generated on "04/10/2019 21:39:02"
                                                            
-- Vhdl Test Bench template for design  :  g50_FSM
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 

LIBRARY ieee;                                               
USE ieee.std_logic_1164.all;                                

ENTITY g50_FSM_vhd_tst IS
END g50_FSM_vhd_tst;
ARCHITECTURE g50_FSM_arch OF g50_FSM_vhd_tst IS
-- constants                                                 
-- signals                                                   
SIGNAL clk : STD_LOGIC;
SIGNAL count : STD_LOGIC_VECTOR(3 DOWNTO 0);
SIGNAL direction : STD_LOGIC;
SIGNAL enable : STD_LOGIC;
SIGNAL reset : STD_LOGIC;
COMPONENT g50_FSM
	PORT (
	clk : IN STD_LOGIC;
	count : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
	direction : IN STD_LOGIC;
	enable : IN STD_LOGIC;
	reset : IN STD_LOGIC
	);
END COMPONENT;
BEGIN
	i1 : g50_FSM
	PORT MAP (
-- list connections between master ports and signals
	clk => clk,
	count => count,
	direction => direction,
	enable => enable,
	reset => reset
	);
--init process to loop clock values
init : PROCESS 
BEGIN
--looping of the clock
		clk <= '1';
		WAIT FOR 1ns;
		clk <= '0';
		WAIT FOR 1ns;                                                      
END PROCESS init; 

always : PROCESS                                                                             
BEGIN                                                         
     
--initialize the cicuit with a reset and forward direction
		reset <= '1';
		enable <= '1';
		direction <='1';
--test if reset works
		WAIT FOR 30ns;
		reset<='0';
		WAIT FOR 30ns;
		reset <= '1';
--test to see if asynchonous (start / stop) enable works
		WAIT FOR 30ns;
		enable <= '0';
		WAIT FOR 30ns;
		enable <= '1';
--test direction of the circuit with a reset
		WAIT FOR 30ns;
		direction <='0';
		WAIT FOR 30ns;
		reset<='0';
		WAIT FOR 1ns;
		reset <='1';
		
WAIT;                                                        
END PROCESS always;                                          
END g50_FSM_arch;
