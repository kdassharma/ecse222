library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

--entity again provided to us in the lab outline. Important to note are the start, stop, HEX0, and HEX1 variables.
--the start and stop directly affect the enable of the FSM where enable is turned off ('0') when stop is pressed and activated ('1') when start is 
--pressed. For this lab, we only require two displays thus only requiring to variables to send to the 7_segment_decoder
entity g50_multi_mode_counter is
	port (start 		: in std_logic;
			stop			: in std_logic;
			direction	: in std_logic;
			reset			: in std_logic;
			clk			: in std_logic;
			HEX0			: out std_logic_vector(6 downto 0);
			HEX1			: out std_logic_vector(6 downto 0));
end g50_multi_mode_counter;

--to start the architecture, we first define the imports
architecture MMC of g50_multi_mode_counter is

--importing the 7_segment_decoder to use for displaying the correct hexadecimal representation on the Altera Board display
component g50_7_segment_decoder is 
	port ( code : in std_logic_vector(3 downto 0);
			 segments : out std_logic_vector(6 downto 0));
end component g50_7_segment_decoder;

--importing the clock divider to determine the period of the clock cycle (50 000 000) corresponds to a wait time of 1 second.
component g50_clock_divider is
	Port ( enable	: in std_logic;
			 reset	: in std_logic;
			 clk		: in std_logic;
			 en_out	: out std_logic);
end component g50_clock_divider;

--importing the FSM for the maintaining, switching, and remembering of the given state for each cycle. This will provide information to the 7_segment_decoder
--decoder about what needs to be displayed
component g50_FSM is 
	port (enable 		: in std_logic;
			direction	: in std_logic;
			reset			: in std_logic;
			clk			: in std_logic;
			count			: out std_logic_vector(3 downto 0));
end component g50_FSM;

--defining the relevent variables for the process. The two defined enables are for the clock_divider and the multi mode counter which 
--will be used for the individual circuits

signal cd_enable 	 				 : std_logic;
signal mmc_enable		 			 : std_logic;

--temporary is used to store the count value of the FSM clock divider output 
signal temporary		 			 : std_logic_vector(3 downto 0);

--for this lab, we needed to implement BCD's to ensure we don't result in a letter output (states are numerical). We create a display_BCD for each
--each display we are using
signal display0_BCD				 : std_logic_vector(3 downto 0);
signal display1_BCD				 : std_logic_vector(3 downto 0);

begin
--assign each variable created to the designated circuits below. 
--CD_FSM is the clock divider for the FSM circuit 
CD_FSM : g50_clock_divider port map (enable => mmc_enable, 			
												 reset => reset, 
												 clk => clk, 
												 en_out => cd_enable);
--variables sent to the FSM																	 
FSM : g50_FSM port map 					(enable => mmc_enable, 
												 direction => direction, 
												 reset => reset, 
												 clk => cd_enable, 
												 count => temporary);

process(start, stop, temporary)
begin
	--since start is active low, when pressed, a '0' will be set which means we start the cycles. mmc_enable, a variable sent to clock divider,
	--will will start the cycle
	if(start = '0') then 
		mmc_enable <= '1';
	--if stop is pressed (active low), stop is set to '0' meaning the clock divider cycle must stop (setting mmc_enable to 0).
	elsif(stop = '0') then
		mmc_enable <= '0';	
	end if;
	
	--when considering what needs to be sent to the 7_segment_decoder, we must consider what is stored. The temporary defined variable will 
	--hold all the information needed (it holds the value of the current state in the FSM).
	
	--because this lab requires all values to be numerical (no letters) we can't have 10 be written as an A. To overcome this, we use 
	--the BCD to separate the single 4 bit value into 2 4 bit values to be spread across the 2 displays.
	
	--as written below, if the temporary value is greater than 9 (1001), we must set the displays to the numerical value of the first digit
	--by adding a 0110 (6) as shown in class, and set the second display to the 1.
	if(temporary > "1001") then 
		display0_BCD <= std_logic_vector(unsigned(temporary) + "0110");
		display1_BCD <= "0001";
		
	--if temporary is not greater than 1001 (9), then the display is set to the temporary value (second display shows 0)
	else 
		display0_BCD <= temporary;
		display1_BCD <= "0000";
	end if;
	
end process;

--finally, when all values are defined the appropriate cycle, we set them to the 7_segment_decoder to be displayed on the board with the 
--appropriate pin planner assigned
--first display
display0 : g50_7_segment_decoder port map (code => display0_BCD, 
														 segments => HEX0);
--second display
display1 : g50_7_segment_decoder port map (code => display1_BCD, 
														 segments => HEX1);

end MMC;
	
