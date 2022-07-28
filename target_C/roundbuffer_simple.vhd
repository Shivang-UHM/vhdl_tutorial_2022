LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.all;
use work.roling_register_p.all;
use work.target_c_pack.all;


entity roundbuffer_simple is
  port (
    clk : IN STD_LOGIC;
    RST :  in STD_Logic;
    reg : In registerT;

    trigger_in   : in std_logic;
    
    sampling_out : out sampling_t := sampling_t_null;

    trigger_tx_m2s : out axisStream_32_m2s := axisStream_32_m2s_null;
    trigger_tx_s2m : in axisStream_32_s2m := axisStream_32_s2m_null
  ) ;
end entity;


architecture arch of roundbuffer_simple is
    

begin

    process( clk,rst )

        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;
    begin
        if rst = '1' then 
            sampling_out <= sampling_t_null;
            tx := axisStream_32_master_null;
        elsif rising_edge(clk) then 
        pull(tx, trigger_tx_s2m);








        push(tx, trigger_tx_m2s);
        end if;        
    end process ; 

end architecture ; 