


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tc_sampling_IO_pgk.all;


entity tc_sampling_reader_et  is
    generic (
        FileName : string := "./tc_sampling_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out tc_sampling_reader_rec
    );
end entity;   

architecture Behavioral of tc_sampling_reader_et is 

  constant  NUM_COL    : integer := 4;
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
  csv_from_integer(csv_r_data(2), data.trigger_in.timestamp);
  csv_from_integer(csv_r_data(3), data.trigger_in.valid);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.tc_sampling_IO_pgk.all;

entity tc_sampling_writer_et  is
    generic ( 
        FileName : string := "./tc_sampling_out.csv"
    ); port (
        clk : in std_logic ;
        data : in tc_sampling_writer_rec
    );
end entity;

architecture Behavioral of tc_sampling_writer_et is 
  constant  NUM_COL : integer := 12;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; trigger_in_timestamp; trigger_in_valid; sampling_out_rdad_clk; sampling_out_rdad_sin; sampling_out_rdad_dir; sampling_out_sstin; sampling_out_sin; sampling_out_sclk; sampling_out_wr_coloumn_select; sampling_out_wr_row_select",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.trigger_in.timestamp, data_int(2) );
  csv_to_integer(data.trigger_in.valid, data_int(3) );
  csv_to_integer(data.sampling_out.rdad_clk, data_int(4) );
  csv_to_integer(data.sampling_out.rdad_sin, data_int(5) );
  csv_to_integer(data.sampling_out.rdad_dir, data_int(6) );
  csv_to_integer(data.sampling_out.sstin, data_int(7) );
  csv_to_integer(data.sampling_out.sin, data_int(8) );
  csv_to_integer(data.sampling_out.sclk, data_int(9) );
  csv_to_integer(data.sampling_out.wr_coloumn_select, data_int(10) );
  csv_to_integer(data.sampling_out.wr_row_select, data_int(11) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.tc_sampling_IO_pgk.all;

entity tc_sampling_tb_csv is 
end entity;

architecture behavior of tc_sampling_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : tc_sampling_reader_rec;
  signal data_out : tc_sampling_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.tc_sampling_reader_et 
    generic map (
        FileName => "./tc_sampling_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.tc_sampling_writer_et
    generic map (
        FileName => "./tc_sampling_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.trigger_in <= data_in.trigger_in;


DUT :  entity work.tc_sampling  port map(

  clk => clk,
  rst => data_out.rst,
  trigger_in => data_out.trigger_in,
  sampling_out => data_out.sampling_out
    );

end behavior;
---------------------------------------------------------------------------------------------------
    