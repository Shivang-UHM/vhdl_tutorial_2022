


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.roundbuffer_simple_IO_pgk.all;


entity roundbuffer_simple_reader_et  is
    generic (
        FileName : string := "./roundbuffer_simple_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out roundbuffer_simple_reader_rec
    );
end entity;   

architecture Behavioral of roundbuffer_simple_reader_et is 

  constant  NUM_COL    : integer := 7;
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
  csv_from_integer(csv_r_data(2), data.trigger_in);
  csv_from_integer(csv_r_data(3), data.reg.address);
  csv_from_integer(csv_r_data(4), data.reg.value);
  csv_from_integer(csv_r_data(5), data.reg.new_value);
  csv_from_integer(csv_r_data(6), data.trigger_tx_s2m.ready);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.roundbuffer_simple_IO_pgk.all;

entity roundbuffer_simple_writer_et  is
    generic ( 
        FileName : string := "./roundbuffer_simple_out.csv"
    ); port (
        clk : in std_logic ;
        data : in roundbuffer_simple_writer_rec
    );
end entity;

architecture Behavioral of roundbuffer_simple_writer_et is 
  constant  NUM_COL : integer := 13;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; trigger_in; reg_address; reg_value; reg_new_value; sampling_out_sstin; sampling_out_wr_coloumn_select; sampling_out_wr_row_select; trigger_tx_m2s_last; trigger_tx_m2s_valid; trigger_tx_m2s_data; trigger_tx_s2m_ready",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.trigger_in, data_int(2) );
  csv_to_integer(data.reg.address, data_int(3) );
  csv_to_integer(data.reg.value, data_int(4) );
  csv_to_integer(data.reg.new_value, data_int(5) );
  csv_to_integer(data.sampling_out.sstin, data_int(6) );

  data_int(7) <= to_integer(unsigned(data.sampling_out.wr_coloumn_select));
  data_int(8) <= to_integer(unsigned(data.sampling_out.wr_row_select));
  --csv_to_integer(data.sampling_out.wr_coloumn_select, data_int(7) );
  --csv_to_integer(data.sampling_out.wr_row_select, data_int(8) );


  csv_to_integer(data.trigger_tx_m2s.last, data_int(9) );
  csv_to_integer(data.trigger_tx_m2s.valid, data_int(10) );
  csv_to_integer(data.trigger_tx_m2s.data, data_int(11) );
  csv_to_integer(data.trigger_tx_s2m.ready, data_int(12) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.roundbuffer_simple_IO_pgk.all;

entity roundbuffer_simple_tb_csv is 
end entity;

architecture behavior of roundbuffer_simple_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : roundbuffer_simple_reader_rec;
  signal data_out : roundbuffer_simple_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.roundbuffer_simple_reader_et 
    generic map (
        FileName => "./roundbuffer_simple_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.roundbuffer_simple_writer_et
    generic map (
        FileName => "./roundbuffer_simple_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.reg <= data_in.reg;
  data_out.trigger_in <= data_in.trigger_in;
  data_out.trigger_tx_s2m <= data_in.trigger_tx_s2m;


DUT :  entity work.roundbuffer_simple  port map(

  clk => clk,
  rst => data_out.rst,
  reg => data_out.reg,
  trigger_in => data_out.trigger_in,
  sampling_out => data_out.sampling_out,
  trigger_tx_m2s => data_out.trigger_tx_m2s,
  trigger_tx_s2m => data_out.trigger_tx_s2m
    );

end behavior;
---------------------------------------------------------------------------------------------------
    