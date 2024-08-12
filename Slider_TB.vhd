library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Slider_tb is
end entity;

architecture Slider_tb_Arch of Slider_tb is



component Slider is
generic
(
	WORD_WIDTH		: integer	:= 8;
	SIZE				: integer	:= 3
);
port
(
	datain	: in std_logic_vector(WORD_WIDTH - 1 downto 0);
	dataout	: out std_logic_vector( (SIZE + 1) * WORD_WIDTH - 1 downto 0);
	reset_n	: in std_logic;
	clk		: in std_logic
);
end component;
signal datain: std_logic_vector(7 downto 0);
signal dataout: std_logic_vector(31 downto 0);
signal reset_n, clk: std_logic;

begin

dut: Slider
generic map
(
	WORD_WIDTH	=> 8,
	SIZE			=> 3
)
port map
(
	datain	=> datain,
	dataout	=> dataout,
	reset_n	=> reset_n,
	clk		=> clk
);

process
begin

reset_n		<= '0';
clk			<= '0';

wait for 10 ns;

reset_n		<= '1';

wait for 10 ns;

datain		<= x"11";
wait for 10 ns;
clk			<= '1';
wait for 10 ns;
clk			<= '0';

datain		<= x"22";
wait for 10 ns;
clk			<= '1';
wait for 10 ns;
clk			<= '0';

datain		<= x"33";
wait for 10 ns;
clk			<= '1';
wait for 10 ns;
clk			<= '0';
datain		<= x"44";
wait for 10 ns;
clk			<= '1';
wait for 10 ns;
clk			<= '0';


wait;
end process;


end architecture;
