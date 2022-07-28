


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.readout_simple_complete_IO_pgk.all;


entity readout_simple_complete_reader_et  is
    generic (
        FileName : string := "./readout_simple_complete_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out readout_simple_complete_reader_rec
    );
end entity;   

architecture Behavioral of readout_simple_complete_reader_et is 

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
  csv_from_integer(csv_r_data(1), data.rst);
  csv_from_integer(csv_r_data(2), data.trigger_in);
  csv_from_integer(csv_r_data(3), data.addr);
  csv_from_integer(csv_r_data(4), data.reg.address);
  csv_from_integer(csv_r_data(5), data.reg.value);
  csv_from_integer(csv_r_data(6), data.reg.new_value);
  csv_from_integer(csv_r_data(7), data.data_shift_out_s2m.data);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.readout_simple_complete_IO_pgk.all;

entity readout_simple_complete_writer_et  is
    generic ( 
        FileName : string := "./readout_simple_complete_out.csv"
    ); port (
        clk : in std_logic ;
        data : in readout_simple_complete_writer_rec
    );
end entity;

architecture Behavioral of readout_simple_complete_writer_et is 
  constant  NUM_COL : integer := 21;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; trigger_in; addr; data; reg_address; reg_value; reg_new_value; sampling_out_sstin; sampling_out_wr_coloumn_select; sampling_out_wr_row_select; will_out_ramp; will_out_clk; will_out_gcc_reset; data_shift_out_m2s_hsclk; data_shift_out_m2s_increment; data_shift_out_m2s_reset; data_shift_out_s2m_data; sample_select_m2s_rdad_clk; sample_select_m2s_rdad_sin; sample_select_m2s_rdad_dir",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.trigger_in, data_int(2) );
  csv_to_integer(data.addr, data_int(3) );
  csv_to_integer(data.data, data_int(4) );
  csv_to_integer(data.reg.address, data_int(5) );
  csv_to_integer(data.reg.value, data_int(6) );
  csv_to_integer(data.reg.new_value, data_int(7) );
  csv_to_integer(data.sampling_out.sstin, data_int(8) );
  
  data_int(9) <= to_integer(unsigned(data.sampling_out.wr_coloumn_select));
  data_int(10) <= to_integer(unsigned(data.sampling_out.wr_row_select));
  --csv_to_integer(data.sampling_out.wr_coloumn_select, data_int(9) );
  --csv_to_integer(data.sampling_out.wr_row_select, data_int(10) );
  
  
  csv_to_integer(data.will_out.ramp, data_int(11) );
  csv_to_integer(data.will_out.clk, data_int(12) );
  csv_to_integer(data.will_out.gcc_reset, data_int(13) );
  csv_to_integer(data.data_shift_out_m2s.hsclk, data_int(14) );
  csv_to_integer(data.data_shift_out_m2s.increment, data_int(15) );
  csv_to_integer(data.data_shift_out_m2s.reset, data_int(16) );
  csv_to_integer(data.data_shift_out_s2m.data, data_int(17) );
  csv_to_integer(data.sample_select_m2s.rdad_clk, data_int(18) );
  csv_to_integer(data.sample_select_m2s.rdad_sin, data_int(19) );
  csv_to_integer(data.sample_select_m2s.rdad_dir, data_int(20) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.readout_simple_complete_IO_pgk.all;

entity readout_simple_complete_tb_csv is 
end entity;

architecture behavior of readout_simple_complete_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : readout_simple_complete_reader_rec;
  signal data_out : readout_simple_complete_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.readout_simple_complete_reader_et 
    generic map (
        FileName => "./readout_simple_complete_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.readout_simple_complete_writer_et
    generic map (
        FileName => "./readout_simple_complete_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.reg <= data_in.reg;
  data_out.trigger_in <= data_in.trigger_in;
  data_out.data_shift_out_s2m <= data_in.data_shift_out_s2m;
  data_out.addr <= data_in.addr;


DUT :  entity work.readout_simple_complete  port map(

  clk => clk,
  rst => data_out.rst,
  reg => data_out.reg,
  trigger_in => data_out.trigger_in,
  sampling_out => data_out.sampling_out,
  will_out => data_out.will_out,
  data_shift_out_m2s => data_out.data_shift_out_m2s,
  data_shift_out_s2m => data_out.data_shift_out_s2m,
  sample_select_m2s => data_out.sample_select_m2s,
  addr => data_out.addr,
  data => data_out.data
    );

end behavior;
---------------------------------------------------------------------------------------------------
    