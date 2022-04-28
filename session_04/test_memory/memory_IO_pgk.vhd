

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.xgen_axistream_32.all;

-- End Include user packages --

package memory_IO_pgk is

		
		
type memory_writer_rec is record
        clk : std_logic;  
    write_enable : std_logic;  
    write_address : std_logic_vector ( 8 - 1 downto 0 );  
    write_data : std_logic_vector ( 32 - 1 downto 0 );  
    read_address : std_logic_vector ( 8 - 1 downto 0 );  
    read_data : std_logic_vector ( 32 - 1 downto 0 );  

end record;



type memory_reader_rec is record
        clk : std_logic;  
    write_enable : std_logic;  
    write_address : std_logic_vector ( 8 - 1 downto 0 );  
    write_data : std_logic_vector ( 32 - 1 downto 0 );  
    read_address : std_logic_vector ( 8 - 1 downto 0 );  

end record;


end memory_IO_pgk;

package body memory_IO_pgk is

end package body memory_IO_pgk;

        