library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY div_unit IS
	PORT( clk, reset, enable			: IN STD_LOGIC;
			denominator, numerator		: IN STD_LOGIC_VECTOR(15 DOWNTO 0);
			div_done						: OUT STD_LOGIC;
			quotient						: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
			remainder						: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
);
END ENTITY div_unit;

ARCHITECTURE Behaviour of div_unit IS

COMPONENT div
	PORT
	(
		aclr		: IN STD_LOGIC ;
		clken		: IN STD_LOGIC ;
		clock		: IN STD_LOGIC ;
		denom		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		numer		: IN STD_LOGIC_VECTOR (15 DOWNTO 0);
		quotient	: OUT STD_LOGIC_VECTOR (15 DOWNTO 0);
		remain		: OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
	);
END COMPONENT;

SIGNAL done0, done1, done2 : STD_LOGIC;
SIGNAL temp_rem : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
SIGNAL temp_quo : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');

BEGIN

divider : div
PORT MAP(aclr => reset, clken	=> enable, clock => clk, 
		numer	=> numerator, denom => denominator, quotient => temp_quo, remain => temp_rem);

PROCESS(clk, reset)
BEGIN
	IF(reset = '1')THEN
		done0 <= '0'; done1 <= '0'; done2 <= '0';
	ELSIF(rising_edge(clk))THEN
		IF(enable = '1')THEN
					done0 <= '1';
		END IF;
		--pipeline the done signal til multiplication is complete
		done1 <= done0;
		done2 <= done1;
	END IF;
END PROCESS;		

quotient <= temp_quo;
remainder <= temp_rem;
div_done <= done2;
		
END Behaviour;
