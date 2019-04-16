library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity g50_stopwatch is
    Port (start     : in  std_logic;
			 stop      : in  std_logic;
			 reset     : in  std_logic;
			 clk       : in  std_logic;
			 HEX0      : out std_logic_vector (6 downto 0);
			 HEX1      : out std_logic_vector (6 downto 0);
			 HEX2      : out std_logic_vector (6 downto 0);
			 HEX3      : out std_logic_vector (6 downto 0);
			 HEX4      : out std_logic_vector (6 downto 0);
			 HEX5      : out std_logic_vector (6 downto 0));
end g50_stopwatch;

architecture g50_stopwatch_process of g50_stopwatch is

	-- in order to display the values on the board, we must initialize 6 for each display (must set each to zero to start)
	signal display0 : std_logic_vector(3 downto 0):= "0000";
	signal display1 : std_logic_vector(3 downto 0):= "0000";
	signal display2 : std_logic_vector(3 downto 0):= "0000";
	signal display3 : std_logic_vector(3 downto 0):= "0000";
	signal display4 : std_logic_vector(3 downto 0):= "0000";
	signal display5 : std_logic_vector(3 downto 0):= "0000";
	
	-- we now set up 2 enable (std_logic) variables to hold sw (stopwatch) and od (out divider). These two signals will be used to 
	-- tell if the stopwatch must be incremented or not
	signal en_sw : std_logic;
	signal en_od : std_logic := '0';
	
	-- we need to assign each display its own reset and its own clock because they increment at different times. Because reset
	-- is active low, we initialize at 1
	signal rs0 : std_logic := '1';
	signal rs1 : std_logic := '1';
	signal rs2 : std_logic := '1';
	signal rs3 : std_logic := '1';
	signal rs4 : std_logic := '1';
	signal rs5 : std_logic := '1';
	
	-- signal clk0   : std_logic := NOT reset0; the clock for 0 is the actual enable for the clock_divider
	signal clk1   : std_logic := NOT rs1;
	signal clk2   : std_logic := NOT rs2;
	signal clk3   : std_logic := NOT rs3;
	signal clk4   : std_logic := NOT rs4;
	signal clk5   : std_logic := NOT rs5;
	
	 -- now to complete the architecture, we import the three classes we have built
	 -- clock divider
	component g50_clock_divider is
	    Port (enable   		 	: in  std_logic;
		       reset     		 	: in  std_logic;
				 clk     	    	: in  std_logic;
				 en_out    		 	: out std_logic);
	end component g50_clock_divider;
	-- counter
	component g50_counter is
	    Port (enable 			 	: in  std_logic;
			    reset  			 	: in  std_logic;
			    clk    			 	: in  std_logic;
			    count  				: out std_logic_vector(3 downto 0));
	end component g50_counter;
	-- segment decoder
	component g50_7_segment_decoder is
	    Port(code     		 	: in  std_logic_vector(3 downto 0);
			   segments			 	: out std_logic_vector(6 downto 0));
	end component g50_7_segment_decoder;
begin

    -- for the stop watch, there is one clock_divider for the entire stopwatch - thus only one instance is required
	 clock_divider : g50_clock_divider PORT MAP(enable => en_sw, reset => reset, clk => clk, en_out => en_od);
	 
	 -- since each stopwatch has its own instance of its display, each display needs its own counter. Set each instance to its variables
	 -- for future implementation - port map is used to link separate classes together
	 count0 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs0, 
											 clk => en_od, 
											 count => display0);
											 
	 count1 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs1, 
											 clk => clk1, 
											 count => display1);
											 
	 count2 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs2, 
											 clk => clk2, 
											 count => display2);
											 
	 count3 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs3, 
											 clk => clk3, 
											 count => display3);
											 
	 count4 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs4, 
											 clk => clk4, 
											 count => display4);
											 
    count5 : g50_counter PORT MAP(enable => en_sw, 
											 reset => rs5, 
											 clk => clk5, 
											 count => display5);
	 
	 -- similar to the clock_divider, we must declare process for sequential circuits - rely on the clock
	 Process (en_od, start, stop, reset) 
		begin
	     -- check user manipulated variables. If the start has been pressed, the stopwatch begins else it is off. If stop was pressed
		  -- the stopwatch stops (enable turned off means stopwatch ends) and finally if reset is pressed, all displays are reset. Important
		  -- to note is that it does not stop the watch pressng reset
		  if (start = '0') then en_sw <= '1';
		  elsif (stop = '0') then en_sw <= '0';
		  elsif (reset = '0') then rs0 <= '0';
											rs1 <= '0'; 
											rs2 <= '0';
											rs3 <= '0';
											rs4 <= '0';
											rs5 <= '0';
			-- if neither start, stop, nor reset are pressed, we check for positive edge. Positive edge of the clock means the 
			-- stopwatch will increment by one each clock_divider 10ms. If a positive edge is caught, multiple situations may
			-- occur. First, the digits may need to move to the next display in which the next display increments by 1, and the 
			-- current is reset. Otherwise, if this does not happen, we simply increment the variable
		  elsif (rising_edge(en_od)) then
				if (display0 > "1001") then rs0 <= '0';
					elsif (display0 = "0000") then rs0 <= '1';
				end if;	 
				
			   if (display1 > "1001") then rs1 <= '0';
					elsif (display1 = "0000") then rs1 <= '1';
				end if;
				
				if (display2 > "1001") then rs2 <= '0';
					elsif (display2 = "0000") then rs2 <= '1';
				end if;
				
				-- important to note - like a regular clock, this display can only reach 5 and resets if incremented one more
				if (display3 > "0101") then rs3 <= '0';
					elsif (display3 = "0000") then rs3 <= '1';
				end if;
				
				if (display4 > "1001") then rs4 <= '0';
					elsif (display4 = "0000") then rs4 <= '1';
				end if;
				
				if (display5 > "0101") then rs5 <= '0';
					elsif (display5 = "0000") then rs5 <= '1';
				end if;
				
		end if;
 end Process;
 
 -- to display everything on the display of the altera board, we must link it to the decoder. Each display on the board gets its 
 -- own instance for the display
	displayDecoder0: g50_7_segment_decoder PORT MAP(code => display0, segments => HEX0);
	displayDecoder1: g50_7_segment_decoder PORT MAP(code => display1, segments => HEX1);
	clk1 <= NOT rs0;
	displayDecoder2: g50_7_segment_decoder PORT MAP(code => display2, segments => HEX2);
	clk2 <= NOT rs1;
	displayDecoder3: g50_7_segment_decoder PORT MAP(code => display3, segments => HEX3);
	clk3 <= NOT rs2;
	displayDecoder4: g50_7_segment_decoder PORT MAP(code => display4, segments => HEX4);
	clk4 <= NOT rs3;
	displayDecoder5: g50_7_segment_decoder PORT MAP(code => display5, segments => HEX5);
	clk5 <= NOT rs4;
	
end g50_stopwatch_process;
