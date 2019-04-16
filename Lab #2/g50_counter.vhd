library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- to begin the entity, we must declare 3 in entities, entities that the user can direclty manipulate
-- the out count will be the combination of incremental values that lead up to 9
entity g50_counter is
	Port (enable : in std_logic;
			reset : in std_logic;
			clk : in std_logic;
			count : out std_logic_vector(3 downto 0)
			);
end g50_counter;

--architecture for the sequential behaviour of the counter
architecture behaviour of g50_counter is
	--temp_count will store the 
	signal temporary: std_logic_vector(3 downto 0);
	
begin
	-- by defining process, we imply that both clock and reset are sequential variables thus giving them
	-- the property of being asynchronous (controlled by the user)
	Process(clk, reset) begin
		-- because reset is asynchronous, we define first and set it to 0. If it isn't at a reset	
		-- then we check to see if the clock has a rising edge (if not) then nothing happens and 
		-- temporary variable is preserved for the next cycle
		if (reset = '0') then 
			temporary <= "0000";
		elsif(rising_edge(clk)) then
			-- as shown in the lab, must increment up with an unsigned bit count (no negative increments)
			if(enable = '1') then
				temporary <= std_logic_vector(unsigned(temporary) + 1);
			else
			--preserve the variable
				temporary  <= temporary;
			end if;
		end if;
	end Process;
	-- assigning the output variable to the temporary variable used inside the process
	count <= temporary;
	
end behaviour;