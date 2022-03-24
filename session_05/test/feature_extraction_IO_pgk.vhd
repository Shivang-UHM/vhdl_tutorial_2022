

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;
use work.roling_register_p.all;

-- End Include user packages --

package feature_extraction_IO_pgk is


type feature_extraction_writer_rec is record
        clk : std_logic;  
    data_in_m2s : axisstream_32_m2s;  
    data_in_s2m : axisstream_32_s2m;  
    trigger_in_m2s : axisstream_32_m2s;  
    trigger_in_s2m : axisstream_32_s2m;  
    data_out_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

end record;



type feature_extraction_reader_rec is record
        clk : std_logic;  
    data_in_m2s : axisstream_32_m2s;  
    trigger_in_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

end record;


end feature_extraction_IO_pgk;

package body feature_extraction_IO_pgk is

end package body feature_extraction_IO_pgk;

        