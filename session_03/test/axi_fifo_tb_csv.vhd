


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axi_fifo_IO_pgk.all;


entity axi_fifo_reader_et  is
    generic (
        FileName : string := "./axi_fifo_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out axi_fifo_reader_rec
    );
end entity;   

architecture Behavioral of axi_fifo_reader_et is 

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
  csv_from_integer(csv_r_data(1), data.rst);
  csv_from_integer(csv_r_data(2), data.data_in_valid);
  csv_from_integer(csv_r_data(3), data.data_in_data);
  csv_from_integer(csv_r_data(4), data.data_out_ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.axi_fifo_IO_pgk.all;

entity axi_fifo_writer_et  is
    generic ( 
        FileName : string := "./axi_fifo_out.csv"
    ); port (
        clk : in std_logic ;
        data : in axi_fifo_writer_rec
    );
end entity;

architecture Behavioral of axi_fifo_writer_et is 
  constant  NUM_COL : integer := 8;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; data_in_valid; data_in_ready; data_in_data; data_out_valid; data_out_ready; data_out_data",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.data_in_valid, data_int(2) );
  csv_to_integer(data.data_in_ready, data_int(3) );
  csv_to_integer(data.data_in_data, data_int(4) );
  csv_to_integer(data.data_out_valid, data_int(5) );
  csv_to_integer(data.data_out_ready, data_int(6) );
  csv_to_integer(data.data_out_data, data_int(7) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.axi_fifo_IO_pgk.all;

entity axi_fifo_tb_csv is 
end entity;

architecture behavior of axi_fifo_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : axi_fifo_reader_rec;
  signal data_out : axi_fifo_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.axi_fifo_reader_et 
    generic map (
        FileName => "./axi_fifo_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.axi_fifo_writer_et
    generic map (
        FileName => "./axi_fifo_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.data_in_valid <= data_in.data_in_valid;
  data_out.data_in_data <= data_in.data_in_data;
  data_out.data_out_ready <= data_in.data_out_ready;


DUT :  entity work.axi_fifo  port map(

  clk => clk,
  rst => data_out.rst,
  data_in_valid => data_out.data_in_valid,
  data_in_ready => data_out.data_in_ready,
  data_in_data => data_out.data_in_data,
  data_out_valid => data_out.data_out_valid,
  data_out_ready => data_out.data_out_ready,
  data_out_data => data_out.data_out_data
    );

end behavior;
---------------------------------------------------------------------------------------------------
    