

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

package twotargetc_rdad_wl_smpl_IO_pgk is


type twotargetc_rdad_wl_smpl_writer_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    sample_in_m2s : axisstream_32_m2s;  
    sample_in_s2m : axisstream_32_s2m;  
    data_out_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  
    will_out : willkinson_adc_t;  
    data_shift_out_m2s : serial_shift_out_m2s;  
    data_shift_out_s2m : serial_shift_out_s2m;  
    sample_select_m2s : sample_select_t;  

end record;



type twotargetc_rdad_wl_smpl_reader_rec is record
    clk : std_logic;  
    rst : std_logic;  
    reg : registert;  
    sample_in_m2s : axisstream_32_m2s;  
    data_out_s2m : axisstream_32_s2m;  
    data_shift_out_s2m : serial_shift_out_s2m;  

end record;


end twotargetc_rdad_wl_smpl_IO_pgk;

package body twotargetc_rdad_wl_smpl_IO_pgk is

end package body twotargetc_rdad_wl_smpl_IO_pgk;

        