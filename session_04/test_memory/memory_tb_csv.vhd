


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.memory_IO_pgk.all;


entity memory_reader_et  is
    generic (
        FileName : string := "./memory_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out memory_reader_rec
    );
end entity;   

architecture Behavioral of memory_reader_et is 

  constant  NUM_COL    : integer := 5;
  signal    csv_r_data : c_integer_array(NUM_COL -1 downto 0)  := (others=>0)  ;
begin

  csv_r :entity  work.csv_read_file 
    generic map (
        FileName =>  FileName, 
        NUM_COL => NUM_COL,
        useExternalClk=>true,
        HeaderLines =>  2
    ) port map (
        clk => clk,
        Rows => csv_r_data
    );

  csv_from_integer(csv_r_data(0), data.clk);
  csv_from_integer(csv_r_data(1), data.write_enable);
  csv_from_integer(csv_r_data(2), data.write_address);
  csv_from_integer(csv_r_data(3), data.write_data);
  csv_from_integer(csv_r_data(4), data.read_address);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.memory_IO_pgk.all;

entity memory_writer_et  is
    generic ( 
        FileName : string := "./memory_out.csv"
    ); port (
        clk : in std_logic ;
        data : in memory_writer_rec
    );
end entity;

architecture Behavioral of memory_writer_et is 
  constant  NUM_COL : integer := 6;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; write_enable; write_address; write_data; read_address; read_data",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.write_enable, data_int(1) );
  csv_to_integer(data.write_address, data_int(2) );
  csv_to_integer(data.write_data, data_int(3) );
  csv_to_integer(data.read_address, data_int(4) );
  csv_to_integer(data.read_data, data_int(5) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.memory_IO_pgk.all;

entity memory_tb_csv is 
end entity;

architecture behavior of memory_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : memory_reader_rec;
  signal data_out : memory_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.memory_reader_et 
    generic map (
        FileName => "./memory_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.memory_writer_et
    generic map (
        FileName => "./memory_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.write_enable <= data_in.write_enable;
  data_out.write_address <= data_in.write_address;
  data_out.write_data <= data_in.write_data;
  data_out.read_address <= data_in.read_address;


DUT :  entity work.memory  port map(

  clk => clk,
  write_enable => data_out.write_enable,
  write_address => data_out.write_address,
  write_data => data_out.write_data,
  read_address => data_out.read_address,
  read_data => data_out.read_data
    );

end behavior;
---------------------------------------------------------------------------------------------------
    