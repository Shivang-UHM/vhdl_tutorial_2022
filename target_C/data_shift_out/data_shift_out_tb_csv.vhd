


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.data_shift_out_IO_pgk.all;


entity data_shift_out_reader_et  is
    generic (
        FileName : string := "./data_shift_out_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out data_shift_out_reader_rec
    );
end entity;   

architecture Behavioral of data_shift_out_reader_et is 

  constant  NUM_COL    : integer := 10;
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
  csv_from_integer(csv_r_data(2), data.do_a_b);
  csv_from_integer(csv_r_data(3), data.a0_reg.address);
  csv_from_integer(csv_r_data(4), data.a0_reg.value);
  csv_from_integer(csv_r_data(5), data.a0_reg.new_value);
  csv_from_integer(csv_r_data(6), data.rx_m2s.last);
  csv_from_integer(csv_r_data(7), data.rx_m2s.valid);
  csv_from_integer(csv_r_data(8), data.rx_m2s.data);
  csv_from_integer(csv_r_data(9), data.tx_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.data_shift_out_IO_pgk.all;

entity data_shift_out_writer_et  is
    generic ( 
        FileName : string := "./data_shift_out_out.csv"
    ); port (
        clk : in std_logic ;
        data : in data_shift_out_writer_rec
    );
end entity;

architecture Behavioral of data_shift_out_writer_et is 
  constant  NUM_COL : integer := 17;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; hsclk; ss_incr; ss_reset; do_a_b; a0_reg_address; a0_reg_value; a0_reg_new_value; rx_m2s_last; rx_m2s_valid; rx_m2s_data; tx_m2s_last; tx_m2s_valid; tx_m2s_data; rx_s2m_ready; tx_s2m_ready",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.hsclk, data_int(2) );
  csv_to_integer(data.ss_incr, data_int(3) );
  csv_to_integer(data.ss_reset, data_int(4) );
  csv_to_integer(data.do_a_b, data_int(5) );
  csv_to_integer(data.a0_reg.address, data_int(6) );
  csv_to_integer(data.a0_reg.value, data_int(7) );
  csv_to_integer(data.a0_reg.new_value, data_int(8) );
  csv_to_integer(data.rx_m2s.last, data_int(9) );
  csv_to_integer(data.rx_m2s.valid, data_int(10) );
  csv_to_integer(data.rx_m2s.data, data_int(11) );
  csv_to_integer(data.tx_m2s.last, data_int(12) );
  csv_to_integer(data.tx_m2s.valid, data_int(13) );
  csv_to_integer(data.tx_m2s.data, data_int(14) );
  csv_to_integer(data.rx_s2m.ready, data_int(15) );
  csv_to_integer(data.tx_s2m.ready, data_int(16) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.data_shift_out_IO_pgk.all;

entity data_shift_out_tb_csv is 
end entity;

architecture behavior of data_shift_out_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : data_shift_out_reader_rec;
  signal data_out : data_shift_out_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.data_shift_out_reader_et 
    generic map (
        FileName => "./data_shift_out_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.data_shift_out_writer_et
    generic map (
        FileName => "./data_shift_out_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.a0_reg <= data_in.a0_reg;
  data_out.do_a_b <= data_in.do_a_b;
  data_out.rx_m2s <= data_in.rx_m2s;
  data_out.tx_s2m <= data_in.tx_s2m;


DUT :  entity work.data_shift_out  port map(

  clk => clk,
  rst => data_out.rst,
  a0_reg => data_out.a0_reg,
  hsclk => data_out.hsclk,
  ss_incr => data_out.ss_incr,
  ss_reset => data_out.ss_reset,
  do_a_b => data_out.do_a_b,
  rx_m2s => data_out.rx_m2s,
  rx_s2m => data_out.rx_s2m,
  tx_m2s => data_out.tx_m2s,
  tx_s2m => data_out.tx_s2m
    );

end behavior;
---------------------------------------------------------------------------------------------------
    