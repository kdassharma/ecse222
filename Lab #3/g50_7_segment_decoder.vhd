-- decoder
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

-- same segment coder as defined in the previous lab
entity g50_7_segment_decoder is 
	Port ( code : in std_logic_vector(3 downto 0);
			 segments : out std_logic_vector(6 downto 0));
end g50_7_segment_decoder;


architecture arch_g50_7_segment_decoder of g50_7_segment_decoder is
begin

	-- conditional assignment allows for fewer calls.
		--represents 0
	segments <= "1000000" when 
						code = "0000" else
		--represents 1
					"1111001" when 
						code = "0001" else
		--represents 2
					"0100100" when 
						code = "0010" else
		--represents 3
					"0110000" when 
						code = "0011" else
		--represents 4
					"0011001" when 
						code = "0100" else
		--represents 5
					"0010010" when 
						code = "0101" else
		--represents 6
					"0000010" when 
						code = "0110" else
		--represents 7
					"1111000" when 
						code = "0111" else
		--represents 8
					"0000000" when 
						code = "1000" else
		--represents 9
					"0010000" when 
						code = "1001" else
		--represents A 
					"0001000" when 
						code = "1010" else
		--represents B
					"0000011" when 
						code = "1011" else
		--represents C
					"1000110" when 
						code = "1100" else
		--represents D
					"0100001" when 
						code = "1101" else
		--represents E
					"0000110" when 
						code = "1110" else
		--represents F
					"0001110" when 
						code = "1111";

end arch_g50_7_segment_decoder;