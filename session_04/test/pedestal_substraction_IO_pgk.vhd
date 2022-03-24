

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;
use work.xgen_ramhandler_32_10.all;

-- End Include user packages --

package pedestal_substraction_IO_pgk is


type pedestal_substraction_writer_rec is record
        clk : std_logic;  
    ped_data : std_logic_vector ( 31 downto 0 );  
    ped_data_address : std_logic_vector ( 7 downto 0 );  
    data_in_m2s : axisstream_32_m2s;  
    data_in_s2m : axisstream_32_s2m;  
    data_out_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

end record;



type pedestal_substraction_reader_rec is record
        clk : std_logic;  
    ped_data : std_logic_vector ( 31 downto 0 );  
    ped_data_address : std_logic_vector ( 7 downto 0 );  
    data_in_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  

end record;


end pedestal_substraction_IO_pgk;

package body pedestal_substraction_IO_pgk is

end package body pedestal_substraction_IO_pgk;

        