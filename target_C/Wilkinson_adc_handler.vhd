LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.all;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;



ENTITY Wilkinson_adc_handler IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        reg : In registerT;
        
        rx_m2s : IN axisStream_32_m2s := axisStream_32_m2s_null;
        rx_s2m : OUT axisStream_32_s2m := axisStream_32_s2m_null;
        
        will_out : out  willkinson_ADC_t := willkinson_ADC_t_null;

        tx_m2s : out axisStream_32_m2s := axisStream_32_m2s_null;
        tx_s2m : in axisStream_32_s2m := axisStream_32_s2m_null

    );
END ENTITY;
ARCHITECTURE arch OF Wilkinson_adc_handler IS
    


    signal DISCH_PERIOD : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL WL_CNT_EN : STD_LOGIC := '0';

    --State
    TYPE wilkinson_type IS (
        IDLE,
        START,
        SAMPLE_END,
        RAMP_DISCH
    );
    SIGNAL wlstate : wilkinson_type := IDLE;
    SIGNAL WL_CNT_INTL : UNSIGNED(15 DOWNTO 0) := x"0000";
    SIGNAL ramp_count_max : std_logic_vector(15 downto 0) := x"0000";
BEGIN

    -- Wilkinson
    PROCESS (rst, clk)
        VARIABLE rx : axisStream_32_slave := axisStream_32_slave_null;
        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;

        VARIABLE rx_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF rst = '1' THEN
            will_out.ramp <= '0'; --Vdischarge
            will_out.GCC_reset   <= '1';

            rx := axisStream_32_slave_null;
            WL_CNT_EN <= '0';
            wlstate <= IDLE;
            tx := axisStream_32_master_null;
            rx_data := (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            pull(rx, rx_m2s);
            pull(tx, tx_s2m);
            WL_CNT_INTL <= WL_CNT_INTL + 1;
            will_out.ramp <= '0';
            will_out.GCC_reset <= '1';
            CASE wlstate IS
                WHEN IDLE =>
                    WL_CNT_INTL <= (OTHERS => '0');
                    IF isReceivingData(rx) THEN
                        read_data(rx, rx_data);
                        wlstate <= START;
                    END IF;

                WHEN START =>
                    will_out.GCC_reset <= '0';
                    will_out.ramp <= '1';
                    IF (WL_CNT_INTL = unsigned(ramp_count_max) ) THEN --x"7ff"
                        wlstate <= SAMPLE_END;
                        will_out.ramp <= '0';
                    END IF;
                    
                WHEN SAMPLE_END =>
                    WL_CNT_INTL <= (OTHERS => '0');

                    IF  ready_to_send(tx) THEN
                        send_data(tx, rx_data);
                        wlstate <= RAMP_DISCH;
                    END IF;

                WHEN RAMP_DISCH =>
                    will_out.GCC_reset <= '0';
                    IF WL_CNT_INTL > UNSIGNED(DISCH_PERIOD) THEN
                        wlstate <= IDLE;
                    END IF;

                WHEN OTHERS =>
                    --nop
                    wlstate <= IDLE;
            END CASE;
            push(rx, rx_s2m);
            push(tx, tx_m2s);
        END IF;
    END PROCESS;


    PROCESS (clk) is
        BEGIN
            if rising_edge(clk) then
                read_data_s(reg , DISCH_PERIOD , reg_list.DISCH_PERIOD); 
                read_data_s(reg , ramp_count_max , reg_list.ramp_count_max); 
                
            end if;
        end process;
END ARCHITECTURE;