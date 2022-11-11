LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.all;
use work.roling_register_p.all;
use work.target_c_pack.all;

ENTITY TwoTARGETC_RDAD_WL_SMPL IS
    PORT (
        
        clk : IN STD_LOGIC;
        RST :  in STD_Logic;
        reg : In registerT;


        sample_in_m2s  : in  axisStream_32_m2s := axisStream_32_m2s_null;
        sample_in_s2m  : out axisStream_32_s2m := axisStream_32_s2m_null;

        data_out_m2s  : out  axisStream_32_m2s := axisStream_32_m2s_null;
        data_out_s2m  : in   axisStream_32_s2m := axisStream_32_s2m_null;

        will_out : out  willkinson_ADC_t;

        data_shift_out_m2s : out  serial_shift_out_m2s;
        data_shift_out_s2m : in  serial_shift_out_s2m;

        
        sample_select_m2s : out sample_select_t := sample_select_t_null

    );

END TwoTARGETC_RDAD_WL_SMPL;

ARCHITECTURE Behavioral OF TwoTARGETC_RDAD_WL_SMPL IS

    SIGNAL u_readout_h_rx_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
    SIGNAL u_readout_h_rx_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

    signal u_readout_h_tx_m2s :  axisStream_32_m2s := axisStream_32_m2s_null;
    signal u_readout_h_tx_s2m :  axisStream_32_s2m := axisStream_32_s2m_null;

    SIGNAL u_wlk_tx_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
    SIGNAL u_wlk_tx_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

    SIGNAL u_wlk_rx_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
    SIGNAL u_wlk_rx_s2m : axisStream_32_s2m := axisStream_32_s2m_null;

BEGIN




    u_readout_h : ENTITY work.readout_location_handler PORT map(
        clk => clk,
        rst => RST,
        reg => reg,


        rx_m2s => sample_in_m2s,
        rx_s2m => sample_in_s2m,

        sample_select_m2s => sample_select_m2s,
        

        tx_m2s => u_readout_h_tx_m2s,
        tx_s2m => u_readout_h_tx_s2m
    );
    

    U_willkinson : entity work.Wilkinson_adc_handler port map(
        clk => clk,
        rst => RST,
        reg => reg,
        rx_m2s => u_readout_h_tx_m2s,
        rx_s2m => u_readout_h_tx_s2m,

        will_out => will_out,

        tx_m2s => u_wlk_tx_m2s,
        tx_s2m => u_wlk_tx_s2m
    );

    u_data_shift_out : entity work.data_shift_out port  map(
          clk => clk,
          rst => RST,
          
          a0_reg => reg,

          data_shift_out_m2s => data_shift_out_m2s,
          data_shift_out_s2m => data_shift_out_s2m,

          
          rx_m2s =>    u_wlk_tx_m2s,
          rx_s2m=>     u_wlk_tx_s2m,
          tx_m2s=>     data_out_m2s,
          tx_s2m=>     data_out_s2m
    ) ;


    


        
END Behavioral;