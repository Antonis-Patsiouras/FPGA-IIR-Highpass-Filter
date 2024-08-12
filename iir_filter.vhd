library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity iir_filter is
generic
(
    WORD_WIDTH  : integer := 8
);
port
(
    x        : in std_logic_vector(WORD_WIDTH - 1 downto 0);
    y        : out std_logic_vector(WORD_WIDTH - 1 downto 0);
    reset_n  : in std_logic;
    clk      : in std_logic
);
end entity iir_filter;

architecture iir_arch of iir_filter is

constant SCALE : integer := 10;
constant SIZE  : integer := 2; -- Second-order IIR has 2 coefficients (a1, a2)

type coefficients is array(0 to SIZE) of integer;
signal b: coefficients := (23079, -46157, 23079); -- Numerator coefficients
signal a: coefficients := (32768, -43227, 16320); -- Denominator coefficients

component Slider is
generic
(
    WORD_WIDTH : integer := 8;
    SIZE       : integer := 2 -- Delay line needs to match number of denominator coefficients
);
port
(
    datain  : in std_logic_vector(WORD_WIDTH - 1 downto 0);
    dataout : out std_logic_vector((SIZE + 1) * WORD_WIDTH - 1 downto 0);
    reset_n : in std_logic;
    clk     : in std_logic
);
end component;

signal dataout: std_logic_vector((SIZE + 1) * WORD_WIDTH - 1 downto 0);
signal delay_line: std_logic_vector((SIZE + 1) * WORD_WIDTH - 1 downto 0);
signal datain: std_logic_vector((SIZE + 1) * WORD_WIDTH - 1 downto 0);

begin

DS: Slider
generic map
(
    WORD_WIDTH => WORD_WIDTH,
    SIZE       => SIZE
)
port map
(
    datain   => x,
    dataout  => dataout,
    reset_n  => reset_n,
    clk      => clk
);

process(clk)
begin
    if rising_edge(clk) then
        if reset_n = '0' then
            delay_line <= (others => '0');
        else
            delay_line <= dataout;
        end if;
    end if;
end process;

p: process(delay_line, dataout)
variable m: integer;
variable m_vec: std_logic_vector(31 downto 0);
begin
    m := 0;
	 
	 for j in 1 to SIZE loop
        m := m + a(j) * to_integer(signed(delay_line((j + 1) * WORD_WIDTH - 1 downto j * WORD_WIDTH)));
	 end loop;
	 
    for i in 0 to SIZE loop
        m := m + b(i) * to_integer(signed(dataout((i + 1) * WORD_WIDTH - 1 downto i * WORD_WIDTH)));
    end loop;
    
    m_vec := std_logic_vector(to_signed(m, 32));
    y <= m_vec(31) & m_vec(SCALE + WORD_WIDTH - 2 downto SCALE);
end process;

end architecture iir_arch;
