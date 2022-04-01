

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;
use work.klm_scint_globals.all;
use work.roling_register_p.all;
use work.xgen_klm_scrod_bus.all;
use work.xgen_counter.all;

-- End Include user packages --

package tx_waveform_IO_pgk is


type tx_waveform_writer_rec is record
        globals : globals_t;  
    data_in_m2s : axisstream_32_m2s;  
    data_in_s2m : axisstream_32_s2m;  
    tx_bus_s2m : databus_s2m;  
    tx_bus_m2s : databus_m2s;  

end record;



type tx_waveform_reader_rec is record
        globals : globals_t;  
    data_in_m2s : axisstream_32_m2s;  
    tx_bus_m2s : databus_m2s;  

end record;


end tx_waveform_IO_pgk;

package body tx_waveform_IO_pgk is

end package body tx_waveform_IO_pgk;

        