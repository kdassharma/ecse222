library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
--the FSM circuit file is devoted to determining the current state as well as the next state in the cycle. The entity includes information
--about the enable (determining whether the state should switch or stay on the current state ('0')) the direction of the cycle (between forward 
--and backwards determined by the first switch) the reset which sets the state based of the direction set (('0') resulting in the end state 09 and 
--('1') resulting in the end state of 01) and finally setting the count which determines the increment from one state to the next

entity g50_FSM is 
Port (enable 		: in std_logic ;
		direction 	: in std_logic ;
		reset 		: in std_logic ;
		clk 			: in std_logic ; 
		count 		: out std_logic_vector (3 downto 0)); 
end g50_FSM;


architecture g_50_FSM_Behavior of g50_FSM is 
--there are a total of 15 states that have to be defined. In order to declare the types of states, we give each a unique name (roman numerals)
--and set them into an enumeration as seen below. Later we define the transition between each going forward and backwards.
type state is (I, II, IV, VIII, III, VI, XII, XI, V, X, VII, XIV, XV, XIII, IX);

--defining the initial state for the FSM. The initial state of the directions is different as mentioned in the outline. This will be discussed below
--temporary will hold the state for each cycle
signal temporary : state := I;

begin
--When we talk about FSM, we need the circuit to be sequential, thus requiring the process declaration of the clock (determining the period of the
--state changes), the asynchronous reset button, and the direction which determines which direction the state traverses - forwards ('1') and backwards ('0').
	process(clk, reset, direction)
	begin
	--if reset is 0, we immediately set the initial state. What is important to note is the check for direction where if the direction is forward ('1'),
	--the initial state is I (1) whereas if the direction is '0', the initial state set will be the last in the enumeration IX (9).
	if(reset = '0') then
		if(direction = '1') then
			temporary <= I;
		else
			temporary <= IX;
		end if;
		
	--if reset is not activated, we must check the rising edge of the clock. If there is no rising edge, nothing happens. However if there is a
	--rising edge, change will occur. 
	elsif(rising_edge(clk)) then
		--Before a state can change, we must first check if the stop had been pressed recently (stop -> sets enable 0) and (start -> sets enable 1). If
		--stop is set, the next state is directed to itself. If enable is set 1 (start is activated) the next state is defined by the direction
		if enable = '1' then
			--if enabled is 1, reset is 0, and at the leading edge of the clock, we are going to change states. The question is, which direction.
			--Direction is determined by the variable set where 1 is forward and 0 is backward. Once that is determined, the next state is easily 
			--defined by the transitions shown in the outline. 
			
			--Each state is checked until the current state is found where it will either move forward a state or backwards
			case temporary is
			--state 1
				when I => 
					if(direction = '1') then
						--state 2
						temporary <= II;
					else
						--state 9
						temporary <= IX;
					end if;
			--state 2
				when II =>
					if(direction = '1') then
						--state 4
						temporary <= IV;
					else
						--state 1
						temporary <= I;
					end if;
			--state 4
				when IV =>
					if(direction = '1') then
						--state 8
						temporary <= VIII;
					else
						--state 2
						temporary <= II;
					end if;
			--state 8
				when VIII =>
					if(direction = '1') then
						--state 3
						temporary <= III;
					else
						--state 4
						temporary <= IV;
					end if;
			--state 3
				when III =>
					if(direction = '1') then
						--state 6
						temporary <= VI;
					else
						--state 8
						temporary <= VIII;
					end if;
			--state 6
				when VI =>
					if(direction = '1') then
						--state 12
						temporary <= XII;
					else
						--state 3
						temporary <= III;
					end if;
			--state 12
				when XII =>
					if(direction = '1') then
						--state 11
						temporary <= XI;
					else
						--state 6
						temporary <= VI;
					end if;
			--state 11
				when XI =>
					if(direction = '1') then
						--state 5
						temporary <= V;
					else
						--state 12
						temporary <= XII;
					end if;
			--state 5
				when V =>
					if(direction = '1') then
						--state 10
						temporary <= X;
					else
						--state 11
						temporary <= XI;
					end if;
			--state 10
				when X =>
					if(direction = '1') then 
						--state 7
						temporary <= VII;
					else
						--state 5
						temporary <= V;
					end if;
			--state 7
				when VII =>
					if(direction = '1') then
						--state 14
						temporary <= XIV;
					else
						--state 10
						temporary <= X;
					end if;
			--state 14
				when XIV =>
					if(direction = '1') then
						--state 15
						temporary <= XV;
					else
						--state 7
						temporary <= VII;
					end if;
			--state 15
				when XV =>
					if(direction = '1') then
						--state 13
						temporary <= XIII;
					else
						--state 14
						temporary <= XIV;
					end if;
			--state 13
				when XIII =>
					if(direction = '1') then
						--state 9
						temporary <= IX;
					else
						--state 15
						temporary <= XV;
					end if;
			--state 9
				when IX =>
					if(direction = '1') then
						--state 1
						temporary <= I;
					else
						--state 13
						temporary <= XIII;
					end if;
			end case;
		else
		--if the clock is not on its positive edge, the state is maintained and remembered in the flip flop for the next cycle
			temporary <= temporary;
		end if;
	end if;
	end process;
	--using a selected signal assignment for efficiency. Checks the state at the end of each cycle to sent the correct count to the multi mode counter
	--to then be displayed on the 7_segment_decoder.
					--state 1
	count <= 	"0001" when temporary = I		else
					--state 2
					"0010" when temporary = II 	else
					--state 4
					"0100" when temporary = IV 	else
					--state 8
					"1000" when temporary = VIII  else
					--state 3
					"0011" when temporary = III 	else
					--state 6
					"0110" when temporary = VI 	else
					--state 12
					"1100" when temporary = XII 	else
					--state 11
					"1011" when temporary = XI 	else
					--state 5
					"0101" when temporary = V 	 	else
					--state 10
					"1010" when temporary = X 		else
					--state 7
					"0111" when temporary = VII 	else
					--state 14
					"1110" when temporary = XIV	else
					--state 15
					"1111" when temporary = XV 	else
					--state 13
					"1101" when temporary = XIII 	else
					--state 9
					"1001" when temporary = IX; 
	end g_50_FSM_Behavior;
