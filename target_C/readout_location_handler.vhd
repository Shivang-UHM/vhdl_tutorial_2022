LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.all;
use work.roling_register_p.all;
use work.target_c_pack.all;


ENTITY readout_location_handler IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        reg : In registerT;

        rx_m2s : in axisStream_32_m2s := axisStream_32_m2s_null;
        rx_s2m : out axisStream_32_s2m := axisStream_32_s2m_null;
        
        sample_select_m2s : out sample_select_t := sample_select_t_null;


        tx_m2s : out axisStream_32_m2s := axisStream_32_m2s_null;
        tx_s2m : in axisStream_32_s2m := axisStream_32_s2m_null
    );
END ENTITY;
ARCHITECTURE arch OF readout_location_handler IS

SIGNAL BitCnt : INTEGER := 8;

signal ClockBus :  T_ClockBus;

TYPE rdad_state_type IS (
    IDLE,  
    WDO_LOW_SET0, 
    WDO_LOW_SET1, 
    WDO_HIGH_SET1, 
    WDO_HIGH_SET0,
    WDO_VALID
);
SIGNAL rdad_stm : rdad_state_type := IDLE;

BEGIN

    -- Digitilization Readout the Samples Storage Location
    PROCESS (rst, clk)
        VARIABLE rx : axisStream_32_slave := axisStream_32_slave_null;
        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;
        VARIABLE rx_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');

    BEGIN
        IF rst = '1' THEN
            sample_select_m2s.RDAD_clk <= '0';
            sample_select_m2s.RDAD_SIN <= '0';
            sample_select_m2s.RDAD_DIR <= '0';
            BitCnt <= 8;
            RDAD_stm <= IDLE;

            rx_data := (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            pull (rx, rx_m2s);
            pull(tx, tx_s2m);
            sample_select_m2s.RDAD_DIR <= '0';
            CASE rdad_stm IS
                WHEN IDLE =>
                    rx_data := (OTHERS => '0');
                    sample_select_m2s.RDAD_clk <= '0';
                    sample_select_m2s.RDAD_SIN <= '0';
                    BitCnt <= 0;

                    IF isReceivingData(rx) THEN
                        read_data(rx, rx_data);
                        rdad_stm <= WDO_LOW_SET0;
                    END IF;

                WHEN WDO_LOW_SET0 =>
                    rdad_stm <= WDO_LOW_SET1;
                    sample_select_m2s.RDAD_clk <= '0';
                    sample_select_m2s.RDAD_SIN <= rx_data(8 - BitCnt); --MSB First
                    sample_select_m2s.RDAD_DIR <= '1';
                WHEN WDO_LOW_SET1 =>
                    rdad_stm <= WDO_HIGH_SET1;
                    sample_select_m2s.RDAD_clk <= '1';
                    sample_select_m2s.RDAD_DIR <= '1';

                WHEN WDO_HIGH_SET1 =>
                    sample_select_m2s.RDAD_DIR <= '1';
                    sample_select_m2s.RDAD_clk <= '1';
                    rdad_stm <= WDO_HIGH_SET0;
                WHEN WDO_HIGH_SET0 =>

                    sample_select_m2s.RDAD_clk <= '0';
                    sample_select_m2s.RDAD_DIR <= '1';
                    BitCnt <= BitCnt + 1;
                    rdad_stm <= WDO_LOW_SET0;
                    
                    IF BitCnt >= 8 THEN
                        BitCnt <= 0;
                        sample_select_m2s.RDAD_DIR <= '0';
                        rdad_stm <= WDO_VALID;
                    END IF;
                WHEN WDO_VALID =>
                    if ready_to_send(tx) then 
                        send_data(tx, rx_data);
                        rdad_stm <= IDLE;
                    end if;

                WHEN OTHERS =>
                    rdad_stm <= IDLE;
            END CASE;

            push(tx, tx_m2s);
            push(rx, rx_s2m);
        END IF;
    END PROCESS;
END ARCHITECTURE;