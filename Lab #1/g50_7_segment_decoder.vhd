library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.NUMERIC_STD.ALL; 
entity g50_lab1 is 
		Port ( code : in std_logic_vector(3 downto 0); 
		segments    : out std_logic_vector(6 downto 0)); 
end g50_lab1;

architecture sevenbit of g50_lab1 is
begin
	 
	process(code)
	begin

	-- we are encorporating an active low thus when 0, the circuit is on
		case code is
		
		--each statement below corresponds to a possible input between the hexadecimal representation
		--of 0 - F. With the 4-bit input inputted, the output will correspond to a 7-bit combination
		--that will recreate that given hexadecimal value on the display.
			
		--example=> here with the input of 0, the output will be a 7-bit sequence of bits that will
		--recreate a 0 image on the LED display. 1 is active off and 0 is active on.
			-- represents 0
			when "0000" =>
			segments <= "1000000"; 

			-- represents 1
			when "0001" =>
			segments <= "1111001";
			
			-- represents 2
			when "0010" =>
			segments <= "0100100"; 

			-- represents 3
			when "0011" =>
			segments <= "0110000"; 

			-- represents 4
			when "0100" =>
			segments <= "0011001"; 

			-- represents 5
			when "0101" =>
			segments <= "0010010"; 

			-- represents 6
			when "0110" =>
			segments <= "0000010"; 
			
			-- represents 7
			when "0111" =>
			segments <= "1111000"; 

			-- represents 8
			when "1000" =>
			segments <= "0000000"; 

			-- represents 9
			when "1001" =>
			segments <= "0010000"; 
			
			-- represents A
			when "1010"=>
			segments <= "0001000"; 
			
			-- represents B
			when "1011" =>
			segments <= "0000011"; 
			
			-- represents C
			when "1100" =>
			segments <= "1000110"; 
			
			-- represents D
			when "1101" =>
			segments <= "0100001"; 
			
			-- represents E
			when "1110" =>
			segments <= "0000110"; 
			
			-- represents F
			when "1111" =>
			segments <= "0001110"; 
			
			-- represents null
			when others =>
			segments <= "1111111"; 

		end case;
	end process;
	
end sevenbit;

	