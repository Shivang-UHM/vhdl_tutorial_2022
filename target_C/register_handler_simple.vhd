
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;


entity  register_handler_simple is
  port (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    reg : In registerT;

    LC_m2s : out Legacy_serial_m2s;
    LC_s2m : in Legacy_serial_s2m
  ) ;
end entity;


architecture arch of register_handler_simple is
    
    signal REG_addr :      STD_LOGIC_VECTOR(6 downto 0);
    signal REG_Value :     STD_LOGIC_VECTOR(11 downto 0);
    signal reg_update :     STD_LOGIC;
    signal reg_busy :     STD_LOGIC;
    
    signal REG_DATA_IN :   STD_LOGIC_VECTOR(18 downto 0);

begin

    process(clk) is 
    begin 
        if rising_edge(clk) then 
            reg_update <= '0';
            read_data_s(reg , REG_addr ,  reg_list.Legacy_serial_addr); 
            read_data_s(reg , REG_Value , reg_list.Legacy_serial_data); 

            if is_register(reg, reg_list.Legacy_serial_update) and reg_busy= '0' then 
                reg_update <= reg.new_value;
            end if;
        end if;
    end process;

    REG_DATA_IN <= REG_addr & REG_Value;
	TC_Legacy_serial : entity work.TARGETX_DAC_CONTROL
	    generic map(
		    REGISTER_WIDTH =>19
		)
		Port map(
		    CLK 		=> CLK,
		    PCLK_LATCH_PERIOD 		=> x"0005",	--With SCLK (brut) 50 MHz, 20ns * 5 = 100ns High period
		    PCLK_TRANSITION_PERIOD 	=> x"0003",
		    LOAD_PERIOD 	=> (others => '0'),
		    LATCH_PERIOD 	=> (others => '0'),

            UPDATE => reg_update,
            REG_DATA_IN => REG_DATA_IN,
            REG_DATA_OUT=> open,
            busy   => reg_busy,


		SIN 	=> LC_m2s.SIN,
		SCLK 	=> LC_m2s.SCLK,
		PCLK 	=> LC_m2s.PCLK,
		SHOUT	=> LC_s2m.SHOUT
	);

end architecture ;