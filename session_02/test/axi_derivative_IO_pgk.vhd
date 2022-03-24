

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;

-- End Include user packages --

package axi_derivative_IO_pgk is


type axi_derivative_writer_rec is record
        clk : std_logic;  
    data_in_valid : std_logic;  
    data_in_ready : std_logic;  
    data_in_data : std_logic_vector ( 15 downto 0 );  
    data_out_valid : std_logic;  
    data_out_ready : std_logic;  
    data_out_data : std_logic_vector ( 15 downto 0 );  

end record;



type axi_derivative_reader_rec is record
        clk : std_logic;  
    data_in_valid : std_logic;  
    data_in_data : std_logic_vector ( 15 downto 0 );  
    data_out_ready : std_logic;  

end record;


end axi_derivative_IO_pgk;

package body axi_derivative_IO_pgk is

end package body axi_derivative_IO_pgk;

        