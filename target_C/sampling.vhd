LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
USE work.target_c_pack.ALL;

entity tc_sampling is
  port (
    clk : in std_logic;
    rst : in std_logic;

    trigger_in : trigger_raw;


    sampling_out : out  sampling_t := sampling_t_null

  ) ;
end entity;

architecture   rtl of tc_sampling is
    signal i_sampling_out : sampling_t := sampling_t_null;
    signal counter : unsigned(31 downto 0) := (others =>'0');

begin

    sampling_out  <= i_sampling_out;


    process( clk )
    begin
        if rising_edge(clk) then 
            counter <= counter + 1;
            set_output_address( i_sampling_out, counter);
            

        end if;
    end process ; 

end architecture; 