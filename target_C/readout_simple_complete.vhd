LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.ALL;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;



entity readout_simple_complete is
  port (
    clk : in std_logic;
    rst : in std_logic;
    reg : In registerT;
    trigger_in   : in std_logic;
    sampling_out : out sampling_t := sampling_t_null;
    
    
    will_out : out  willkinson_ADC_t;
    
    data_shift_out_m2s : out  serial_shift_out_m2s;
    data_shift_out_s2m : in  serial_shift_out_s2m;

    
    sample_select_m2s : out sample_select_t := sample_select_t_null;
    
    addr  : in  std_logic_vector( 15 downto 0) := (others =>'0');
    data  : out std_logic_vector( 15 downto 0) := (others =>'0')
  ) ;
end entity;


architecture arch of readout_simple_complete is
    signal roundbuffer_simple_trigger_tx_m2s :  axisStream_32_m2s := axisStream_32_m2s_null;
    signal roundbuffer_simple_trigger_tx_s2m :  axisStream_32_s2m := axisStream_32_s2m_null;


    signal u_TwoTARGETC_RDAD_WL_SMPL_data_out_m2s  :   axisStream_32_m2s := axisStream_32_m2s_null;
    signal u_TwoTARGETC_RDAD_WL_SMPL_data_out_s2m  :   axisStream_32_s2m := axisStream_32_s2m_null;
begin

    u_roundbuffer_simple : entity work.roundbuffer_simple port map(
          clk => clk,
          RST => RST,
          reg => reg,
      
          trigger_in   => trigger_in,
          
          sampling_out => sampling_out,
      
          trigger_tx_m2s => roundbuffer_simple_trigger_tx_m2s,
          trigger_tx_s2m => roundbuffer_simple_trigger_tx_s2m
        ) ;


        u_TwoTARGETC_RDAD_WL_SMPL :  ENTITY work.TwoTARGETC_RDAD_WL_SMPL PORT map (
            
            clk => clk,
            RST => RST,
            reg => reg,
        
    
    
            sample_in_m2s  => roundbuffer_simple_trigger_tx_m2s,
            sample_in_s2m  => roundbuffer_simple_trigger_tx_s2m,
    
            data_out_m2s  => u_TwoTARGETC_RDAD_WL_SMPL_data_out_m2s,
            data_out_s2m  => u_TwoTARGETC_RDAD_WL_SMPL_data_out_s2m,
    
            will_out => will_out,
    
            data_shift_out_m2s => data_shift_out_m2s,
            data_shift_out_s2m => data_shift_out_s2m,
    
            
            sample_select_m2s => sample_select_m2s
    
        );


        u_fifo_manager_simple : entity work.fifo_manager_simple port map (
            clk => clk,
            RST => RST,
              
            rx_m2s => u_TwoTARGETC_RDAD_WL_SMPL_data_out_m2s,
            rx_s2m => u_TwoTARGETC_RDAD_WL_SMPL_data_out_s2m,
            addr => addr,
            data => data
        ) ;
end architecture;