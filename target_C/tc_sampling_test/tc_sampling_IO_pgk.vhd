

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.target_c_pack.all;

-- End Include user packages --

package tc_sampling_IO_pgk is


type tc_sampling_writer_rec is record
    clk : std_logic;  
    rst : std_logic;  
    trigger_in : trigger_raw;  
    sampling_out : sampling_t;  

end record;



type tc_sampling_reader_rec is record
    clk : std_logic;  
    rst : std_logic;  
    trigger_in : trigger_raw;  

end record;


end tc_sampling_IO_pgk;

package body tc_sampling_IO_pgk is

end package body tc_sampling_IO_pgk;

        