


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.derivative_IO_pgk.all;


entity derivative_reader_et  is
    generic (
        FileName : string := "./derivative_in.csv"
    );
    port (
        clk : in std_logic ;
        data : out derivative_reader_rec
    );
end entity;   

architecture Behavioral of derivative_reader_et is 

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
  csv_from_integer(csv_r_data(2), data.r_offset);
  csv_from_integer(csv_r_data(3), data.data_in);


end Behavioral;
---------------------------------------------------------------------------------------------------
    


library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;



use work.derivative_IO_pgk.all;

entity derivative_writer_et  is
    generic ( 
        FileName : string := "./derivative_out.csv"
    ); port (
        clk : in std_logic ;
        data : in derivative_writer_rec
    );
end entity;

architecture Behavioral of derivative_writer_et is 
  constant  NUM_COL : integer := 5;
  signal data_int   : c_integer_array(NUM_COL - 1 downto 0)  := (others=>0);
begin

    csv_w : entity  work.csv_write_file 
        generic map (
            FileName => FileName,
            HeaderLines=> "clk; rst; r_offset; data_in; data_out",
            NUM_COL =>   NUM_COL 
        ) port map(
            clk => clk, 
            Rows => data_int
        );


  csv_to_integer(data.clk, data_int(0) );
  csv_to_integer(data.rst, data_int(1) );
  csv_to_integer(data.r_offset, data_int(2) );
  csv_to_integer(data.data_in, data_int(3) );
  csv_to_integer(data.data_out, data_int(4) );


end Behavioral;
---------------------------------------------------------------------------------------------------
    

library ieee;
use ieee.numeric_std.all;
use ieee.std_logic_1164.all;
use work.type_conversions_pgk.all;
use work.CSV_UtilityPkg.all;


use work.derivative_IO_pgk.all;

entity derivative_tb_csv is 
end entity;

architecture behavior of derivative_tb_csv is 
  signal clk : std_logic := '0';
  signal data_in : derivative_reader_rec;
  signal data_out : derivative_writer_rec;

begin 

  clk_gen : entity work.ClockGenerator generic map ( CLOCK_period => 10 ns) port map ( clk => clk );

  csv_read : entity work.derivative_reader_et 
    generic map (
        FileName => "./derivative_tb_csv.csv" 
    ) port map (
        clk => clk ,data => data_in
    );
 
  csv_write : entity work.derivative_writer_et
    generic map (
        FileName => "./derivative_tb_csv_out.csv" 
    ) port map (
        clk => clk ,data => data_out
    );
  

  data_out.clk <=clk;
  data_out.rst <= data_in.rst;
  data_out.r_offset <= data_in.r_offset;
  data_out.data_in <= data_in.data_in;


DUT :  entity work.derivative  port map(

  clk => clk,
  rst => data_out.rst,
  r_offset => data_out.r_offset,
  data_in => data_out.data_in,
  data_out => data_out.data_out
    );

end behavior;
---------------------------------------------------------------------------------------------------
    