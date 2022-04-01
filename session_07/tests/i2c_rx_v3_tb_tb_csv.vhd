


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.i2c_rx_v3_tb_IO_pgk.all;


entity i2c_rx_v3_tb_reader_et  is
    generic (
        FileName : string := "./i2c_rx_v3_tb_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out i2c_rx_v3_tb_reader_rec
    );
end entity;   

architecture Behavioral of i2c_rx_v3_tb_reader_et is 

  constant  NUM_COL    : integer := 8;
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
  csv_from_integer(csv_r_data(1), data.dreset);
  csv_from_integer(csv_r_data(2), data.sync);
  csv_from_integer(csv_r_data(3), data.reset_n);
  csv_from_integer(csv_r_data(4), data.ena);
  csv_from_integer(csv_r_data(5), data.addr);
  csv_from_integer(csv_r_data(6), data.rw);
  csv_from_integer(csv_r_data(7), data.data_wr);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.i2c_rx_v3_tb_IO_pgk.all;

entity i2c_rx_v3_tb_writer_et  is
    generic ( 
        FileName : string := "./i2c_rx_v3_tb_out.csv"
    ); port (
        clk : in std_logic ;
        data : in i2c_rx_v3_tb_writer_rec
    );
end entity;

architecture Behavioral of i2c_rx_v3_tb_writer_et is 
  constant  NUM_COL : integer := 20;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; dreset; sync; reset_n; ena; addr; rw; data_wr; busy; data_rd; ack_error; sda; scl; regisers_out_0; regisers_out_1; regisers_out_2; regisers_out_3; regisers_out_4; regisers_out_5; regisers_out_6",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.dreset, data_int(1) );
  csv_to_integer(data.sync, data_int(2) );
  csv_to_integer(data.reset_n, data_int(3) );
  csv_to_integer(data.ena, data_int(4) );
  csv_to_integer(data.addr, data_int(5) );
  csv_to_integer(data.rw, data_int(6) );
  csv_to_integer(data.data_wr, data_int(7) );
  csv_to_integer(data.busy, data_int(8) );
  csv_to_integer(data.data_rd, data_int(9) );
  csv_to_integer(data.ack_error, data_int(10) );
  csv_to_integer(data.sda, data_int(11) );
  csv_to_integer(data.scl, data_int(12) );
  csv_to_integer(data.regisers_out(0), data_int(13) );
  csv_to_integer(data.regisers_out(1), data_int(14) );
  csv_to_integer(data.regisers_out(2), data_int(15) );
  csv_to_integer(data.regisers_out(3), data_int(16) );
  csv_to_integer(data.regisers_out(4), data_int(17) );
  csv_to_integer(data.regisers_out(5), data_int(18) );
  csv_to_integer(data.regisers_out(6), data_int(19) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.i2c_rx_v3_tb_IO_pgk.all;

entity i2c_rx_v3_tb_tb_csv is 
end entity;

architecture behavior of i2c_rx_v3_tb_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : i2c_rx_v3_tb_reader_rec;
  signal data_out : i2c_rx_v3_tb_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.i2c_rx_v3_tb_reader_et 
    generic map (
        FileName => "./i2c_rx_v3_tb_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.i2c_rx_v3_tb_writer_et
    generic map (
        FileName => "./i2c_rx_v3_tb_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.dreset <= data_in.dreset;
  data_out.sync <= data_in.sync;
  data_out.reset_n <= data_in.reset_n;
  data_out.ena <= data_in.ena;
  data_out.addr <= data_in.addr;
  data_out.rw <= data_in.rw;
  data_out.data_wr <= data_in.data_wr;


DUT :  entity work.i2c_rx_v3_tb  port map(

  clk => clk,
  dreset => data_out.dreset,
  sync => data_out.sync,
  reset_n => data_out.reset_n,
  ena => data_out.ena,
  addr => data_out.addr,
  rw => data_out.rw,
  data_wr => data_out.data_wr,
  busy => data_out.busy,
  data_rd => data_out.data_rd,
  ack_error => data_out.ack_error,
  sda => data_out.sda,
  scl => data_out.scl,
  regisers_out => data_out.regisers_out
    );

end behavior;
---------------------------------------------------------------------------------------------------
    