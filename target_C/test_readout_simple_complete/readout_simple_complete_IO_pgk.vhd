

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
use work.target_c_pack.all;

-- End Include user packages --

package readout_simple_complete_IO_pgk is


type readout_simple_complete_writer_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    trigger_in : std_logic;  
    sampling_out : sampling_t;  
    will_out : willkinson_adc_t;  
    data_shift_out_m2s : serial_shift_out_m2s;  
    data_shift_out_s2m : serial_shift_out_s2m;  
    sample_select_m2s : sample_select_t;  
    addr : std_logic_vector ( 15 downto 0 );  
    data : std_logic_vector ( 15 downto 0 );  

end record;



type readout_simple_complete_reader_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    trigger_in : std_logic;  
    data_shift_out_s2m : serial_shift_out_s2m;  
    addr : std_logic_vector ( 15 downto 0 );  

end record;


end readout_simple_complete_IO_pgk;

package body readout_simple_complete_IO_pgk is

end package body readout_simple_complete_IO_pgk;

        