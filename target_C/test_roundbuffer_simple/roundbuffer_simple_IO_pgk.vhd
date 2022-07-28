

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.targetc_pkg.all;
use work.xgen_axistream_32.all;
use work.handshake.all;
use work.roling_register_p.all;
use work.target_c_pack.all;

-- End Include user packages --

package roundbuffer_simple_IO_pgk is


type roundbuffer_simple_writer_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    trigger_in : std_logic;  
    sampling_out : sampling_t;  
    trigger_tx_m2s : axisstream_32_m2s;  
    trigger_tx_s2m : axisstream_32_s2m;  

end record;



type roundbuffer_simple_reader_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    trigger_in : std_logic;  
    trigger_tx_s2m : axisstream_32_s2m;  

end record;


end roundbuffer_simple_IO_pgk;

package body roundbuffer_simple_IO_pgk is

end package body roundbuffer_simple_IO_pgk;

        