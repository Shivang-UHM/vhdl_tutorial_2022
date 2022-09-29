LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.ALL;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;




entity fifo_manager_simple is
  port (
    clk : in std_logic;
    rst : in std_logic;
    
    rx_m2s : in   axisStream_32_m2s := axisStream_32_m2s_null;
    rx_s2m : out  axisStream_32_s2m := axisStream_32_s2m_null;

    addr  : in  std_logic_vector( 15 downto 0) := (others =>'0');
    data  : out std_logic_vector( 15 downto 0) := (others =>'0')

  ) ;
end entity;

architecture arch of fifo_manager_simple is

    signal mem : slv_12_array(4000 downto 0) := (others => (others => '0'));
    signal counter : unsigned( 15 downto 0) := (others =>'0');
begin

    process(clk) is 
        VARIABLE rx : axisStream_32_slave := axisStream_32_slave_null;
        VARIABLE rx_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    begin 
        if rising_edge(clk) then 
            pull(rx, rx_m2s);
                If (isReceivingData(rx))  then
                    read_data(rx, rx_data);
                    mem( to_integer(counter)  ) <= rx_data( 11 downto 0);
                    counter <= counter + 1;
                    if IsEndOfStream(rx) then 
                        counter<= (others => '0');
                    end if;
                end if;

            data <=  "0000" & mem( to_integer(unsigned( addr )) );
            push(rx, rx_s2m);
        end if;
    end process;

end architecture ; 