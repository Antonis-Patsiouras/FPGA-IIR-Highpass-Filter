library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity iir_filter_tb is
end entity iir_filter_tb;

architecture tb_arch of iir_filter_tb is

    constant CLK_PERIOD : time := 10 ns;  -- Clock period (adjust as necessary)
    constant WORD_WIDTH : integer := 8;
    
    signal clk         : std_logic := '0';
    signal reset_n     : std_logic := '0';
    signal x           : std_logic_vector(WORD_WIDTH - 1 downto 0);
    signal y           : std_logic_vector(WORD_WIDTH - 1 downto 0);

begin

    -- Instantiate the IIR filter
    dut: entity work.iir_filter
        generic map (
            WORD_WIDTH => WORD_WIDTH
        )
        port map (
            x       => x,
            y       => y,
            reset_n => reset_n,
            clk     => clk
        );

   

    -- Stimulus process
    stimulus: process
	 file fp_read: text open read_mode is "datain.dat";
	 variable line_rd_var: line;
	 variable a: integer;

	 file fp_write: text open write_mode is "dataout.dat";
	 variable line_wr_var: line;
	 variable b: integer;
    begin
	 
        reset_n <= '0';
        wait for 10 ns;
        reset_n <= '1';
        wait for 10 ns;
		  
	 while(not endfile(fp_read)) loop
		  clk		<= '0';
        readline(fp_read, line_rd_var);
		  read(line_rd_var, a);
	     x <= std_logic_vector(to_signed(a, WORD_WIDTH));

        wait for 10 ns;

		  clk		<= '1';
		  b := to_integer(signed(y));
         -- Write output data to file
            write(line_wr_var, y);
            writeline(fp_write, line_wr_var);

        wait for 10 ns;
	 end loop;
	 -- Close files
    file_close(fp_read);
    file_close(fp_write);
    end process;

end architecture tb_arch;
