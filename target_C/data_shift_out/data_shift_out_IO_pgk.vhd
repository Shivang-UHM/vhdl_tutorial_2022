

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.targetc_pkg.all;
use work.xgen_axistream_32.all;
use work.handshake.all;
use work.roling_register_p.all;
use work.register_list.all;

-- End Include user packages --

package data_shift_out_IO_pgk is


type data_shift_out_writer_rec is record
    clk : std_logic;  
    rst : std_logic;  
    a0_reg : registert;  
    hsclk : std_logic;  
    ss_incr : std_logic;  
    ss_reset : std_logic;  
    do_a_b : std_logic_vector ( 31 downto 0 );  
    rx_m2s : axisstream_32_m2s;  
    rx_s2m : axisstream_32_s2m;  
    tx_m2s : axisstream_32_m2s;  
    tx_s2m : axisstream_32_s2m;  

end record;



type data_shift_out_reader_rec is record
    clk : std_logic;  
    rst : std_logic;  
    a0_reg : registert;  
    do_a_b : std_logic_vector ( 31 downto 0 );  
    rx_m2s : axisstream_32_m2s;  
    tx_s2m : axisstream_32_s2m;  

end record;


end data_shift_out_IO_pgk;

package body data_shift_out_IO_pgk is

end package body data_shift_out_IO_pgk;

        