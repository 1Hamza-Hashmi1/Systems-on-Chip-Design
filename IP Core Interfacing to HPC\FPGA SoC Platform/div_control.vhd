-- mult_control.vhd

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity div_control is
	port (
		avs_s0_address   : in  std_logic_vector(3 downto 0)  := (others => '0'); --         s0.address
		avs_s0_write     : in  std_logic                     := '0';             --           .write
		avs_s0_writedata : in  std_logic_vector(31 downto 0) := (others => '0'); --           .writedata
		avs_s0_read      : in  std_logic                     := '0';             --           .read
		avs_s0_readdata  : out std_logic_vector(31 downto 0);                    --           .readdata
		clk              : in  std_logic                     := '0';             --      clock.clk
		reset            : in  std_logic                     := '0';             --      reset.reset
		div_start       : out std_logic_vector(31 downto 0);                    --           .m_start
		div_reset       : out std_logic_vector(31 downto 0);                    --           .m_reset
		div_done        : in  std_logic_vector(31 downto 0) := (others => '0')  --            .m_done
	);
end entity div_control;

architecture rtl of div_control is

	SIGNAL start, reset2 : STD_logic_vector(31 DOWNTO 0);

begin

		PROCESS(clk, reset, avs_s0_address, avs_s0_write, avs_s0_writedata, avs_s0_read)
	BEGIN
		IF(reset = '1')THEN
			start <= (OTHERS => '0');
			reset2 <= (OTHERS => '0');
		ELSIF(rising_edge(clk))THEN

			IF(avs_s0_write = '1')THEN
				CASE avs_s0_address IS
					WHEN "0000" =>
						start <= avs_s0_writedata;
					WHEN "0001" => 
						reset2 <= avs_s0_writedata;
					WHEN OTHERS =>

				END CASE;			
			ELSIF(avs_s0_read = '1')THEN
				reset2 <= (OTHERS => '0');
				CASE avs_s0_address IS
					WHEN "0000" =>
						avs_s0_readdata <= start;
					WHEN "0001" => 
						avs_s0_readdata <= reset2;
					WHEN "0010" =>
						avs_s0_readdata <= div_done;
					WHEN OTHERS => 
					
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	div_start <= start;
	div_reset <= reset2;
	
end architecture rtl; -- of mult_input
