library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity g50_adder is
	port( A, B              : in std_logic_vector(4 downto 0);
			decoded_A			: out std_logic_vector(13 downto 0);
			decoded_B			: out std_logic_vector(13 downto 0);
			decoded_AplusB		: out std_logic_vector(13 downto 0));
end g50_adder;

architecture adder of g50_adder is

--the first and most important variable is the sum variable which will contain two 4-bit values that will
--be displayed on the right most screen of the LED display. What is important (as seen in the adding part below)
--is that the sum is made of 6-bits to compensate for a potential carry out.
signal sum		: std_logic_vector(5 downto 0);

--all 3 groupings of variables below are used for the same reason but correspond to different LED displays 
--on the Altera Board. The x_pad represents the 8 bit value that includes a '000' or '00' concatenation
--with the previous 5-bit switch combination. The x0 and x1 (x being one of the three: sum, A, B) relates to
--the splitting of the 8-bits into two groups of 4 to be passed into the 7_segment_decoder.

signal sum_pad		: std_logic_vector(7 downto 0);
signal sum0		: std_logic_vector(3 downto 0);
signal sum1		: std_logic_vector(3 downto 0);

signal A_pad		: std_logic_vector(7 downto 0);
signal A0		: std_logic_vector(3 downto 0);
signal A1		: std_logic_vector(3 downto 0);

signal B_pad		: std_logic_vector(7 downto 0);
signal B0		: std_logic_vector(3 downto 0);
signal B1		: std_logic_vector(3 downto 0);

--this is the initialization of the 7_segment_decoder (link)
	component g50_lab1 is 
		Port ( code : in std_logic_vector(3 downto 0); 
		segments : out std_logic_vector(6 downto 0)); 
	end component g50_lab1;

begin
--this is the addition of A and B resulting in a 6-bit sum output
sum <= std_logic_vector((resize(unsigned(A), 6)) + unsigned(B));

--concatenation of the 5-bit for A and B and 6-bit for sum with 0's to ensure an 8-bit value is created
A_pad   <= "000" & A;
B_pad   <= "000" & B;
sum_pad <= "00" & sum;

--this is the splitting of the 8-bit combination into 2 groups of 4 to correspond to 6 displays
A0      <= A_pad(7 downto 4);
A1      <= A_pad(3 downto 0);

B0      <= B_pad(7 downto 4);
B1      <= B_pad(3 downto 0);

sum0    <= sum_pad(7 downto 4);
sum1    <= sum_pad(3 downto 0);

--finally, this is the section which inputs the 4 bit value into the 7_segment_decoder and creates the output
--of the 7-bit combination that will display the approrpriate hexadecimal character on the screen.
i1: g50_lab1
	PORT MAP (
			code => A0,
			segments => decoded_A(13 downto 7)
			);
i2: g50_lab1
	PORT MAP (
			code => A1,
			segments => decoded_A(6 downto 0)
			);
i3: g50_lab1
	PORT MAP (
			code => B0,
			segments => decoded_B(13 downto 7)
			);
i4: g50_lab1
	PORT MAP (
			code => B1,
			segments => decoded_B(6 downto 0)
			);
i5: g50_lab1
	PORT MAP (
			code => sum0,
			segments => decoded_AplusB(13 downto 7)
			);
i6: g50_lab1
	PORT MAP (
			code => sum1,
			segments => decoded_AplusB(6 downto 0)
			);
			
end adder;
	
				