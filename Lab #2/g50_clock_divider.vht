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
-- Generated on "04/06/2019 13:46:45"
                                                            
-- Vhdl Test Bench template for design  :  g50_clock_divider
-- 
-- Simulation tool : ModelSim-Altera (VHDL)
-- 


LIBRARY ieee;                                               

USE ieee.std_logic_1164.all;                                



ENTITY g50_clock_divider_vhd_tst IS

END g50_clock_divider_vhd_tst;

ARCHITECTURE g50_clock_divider_arch OF g50_clock_divider_vhd_tst IS

-- constants                                                 

-- signals                                                   

SIGNAL clk : STD_LOGIC;

SIGNAL en_out : STD_LOGIC;

SIGNAL enable : STD_LOGIC;

SIGNAL reset : STD_LOGIC;

COMPONENT g50_clock_divider

	PORT (

	clk : IN STD_LOGIC;

	en_out : OUT STD_LOGIC;

	enable : IN STD_LOGIC;

	reset : IN STD_LOGIC

	);

END COMPONENT;

BEGIN

	i1 : g50_clock_divider

	PORT MAP (

-- list connections between master ports and signals

	clk => clk,

	en_out => en_out,

	enable => enable,

	reset => reset

	);

	

--init process to loop clock values

init : PROCESS 

BEGIN

		--FPGA board's clock has 50 MHz frequency

		--this means one period every 20 ns (so change clk every 10 ns)

		

		clk <= '1';

		WAIT FOR 10ns;

		clk <= '0';

		WAIT FOR 10ns;                                                      

END PROCESS init;                                            



--test clock divider's reset, enable, and counting functionalities                                      

clock_divider_test : PROCESS                                                                                 

BEGIN

		--set initial values

		reset <= '1';	

      enable <= '1';

		WAIT FOR 30ns;

		

		--test enable

		enable <= '0';

		WAIT FOR 30ns;

		enable<= '1';

		WAIT FOR 30ns;

		

		--test reset

		reset <= '0';

		WAIT FOR 15ns;

		reset <= '1';

		

		--test counting

		WAIT FOR 15ms;

		

WAIT;                                                       

END PROCESS clock_divider_test;                                      

END g50_clock_divider_arch;
