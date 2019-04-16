library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity g50_clock_divider is
	-- the value 500 000 was calculated by using the period and frequency equations
	 Generic (constant T : integer := 500000);

    Port (enable     : in  std_logic;
	  reset      : in  std_logic;
	  clk        : in  std_logic;
	  en_out     : out std_logic);

end g50_clock_divider;

architecture g50_clock_divider_behavior of g50_clock_divider is

    -- temporary and current variables to store the values
   	 signal temporary : std_logic := '0';
	 signal current   : integer;--:= T-1;

begin
    --process needs to be used to signify the clk and reset are both sequential
    Process(clk, reset) begin
	
    --make sure reset was not asynchronously called
    if (reset = '0') then
        current <= T - 1;
		  temporary <= '0';
		
    -- check for the rising edge of the clock
    elsif (rising_edge(clk)) then
	 -- if rising edge AND enable is active, we decrement the value otherwise we maintain the state
		  if (enable = '1') then
		      current <= current - 1;
		  else
		      current <= current;
		  end if;
    
	 
	 -- the temporary output signal (based on if the cycle reached 0) becomes 1 otherwise, the previous cycle was a 1 and the new one becomes 0
		  if (current > 0) then
				temporary <= '0';
		  else
				temporary <= '1';
				current <= T-1;
	  	  end if;
	 end if;
	 end Process;
	 
	 -- finally, set the output variable equal to the temp variable
	 en_out <= temporary;

end g50_clock_divider_behavior;
