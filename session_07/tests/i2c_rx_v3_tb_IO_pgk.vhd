

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use ieee.std_logic_arith.all;
use work.CSV_UtilityPkg.all;


-- Start Include user packages --
use work.i2c_rx_v3_pac.all;

-- End Include user packages --

package i2c_rx_v3_tb_IO_pgk is


type i2c_rx_v3_tb_writer_rec is record
        clk : std_logic;  
    dreset : std_logic;  
    sync : std_logic;  
    reset_n : std_logic;  
    ena : std_logic;  
    addr : std_logic_vector ( 6 downto 0 );  
    rw : std_logic;  
    data_wr : std_logic_vector ( 7 downto 0 );  
    busy : std_logic;  
    data_rd : std_logic_vector ( 7 downto 0 );  
    ack_error : std_logic;  
    sda : std_logic;  
    scl : std_logic;  
    regisers_out : i2c_data_t_a ( 7 downto 0 );  

end record;



type i2c_rx_v3_tb_reader_rec is record
        clk : std_logic;  
    dreset : std_logic;  
    sync : std_logic;  
    reset_n : std_logic;  
    ena : std_logic;  
    addr : std_logic_vector ( 6 downto 0 );  
    rw : std_logic;  
    data_wr : std_logic_vector ( 7 downto 0 );  

end record;


end i2c_rx_v3_tb_IO_pgk;

package body i2c_rx_v3_tb_IO_pgk is

end package body i2c_rx_v3_tb_IO_pgk;

        