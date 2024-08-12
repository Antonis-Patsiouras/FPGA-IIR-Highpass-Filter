library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Slider is
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
end entity;

architecture Slider_Arch of Slider is

signal c: std_logic_vector( (SIZE + 1) * WORD_WIDTH - 1 downto 0);

begin

p: process(reset_n, clk, datain)
begin

if reset_n = '0' then
	
	c( (SIZE + 1) * WORD_WIDTH - 1 downto WORD_WIDTH)		<= (others => '0');
	
elsif rising_edge(clk) then
	
	for i in SIZE downto 1 loop
		c( (i + 1) * WORD_WIDTH - 1 downto i * WORD_WIDTH )	<= c( i * WORD_WIDTH - 1 downto (i - 1) * WORD_WIDTH );
	end loop;
	
end if;

c(WORD_WIDTH - 1 downto 0)			<= datain;

end process;

dataout			<= c;

end architecture;
