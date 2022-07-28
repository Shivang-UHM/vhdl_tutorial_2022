LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.ALL;

ENTITY data_shift_out2 IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;

        HSCLK : OUT STD_LOGIC;
        CtrlBus_IxSL : IN T_CtrlBus_IxSL;
        acknowledge_intl : IN STD_LOGIC;
        NBRWINDOW_clkd : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        DO_A_B : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        Handshake_IxSEND : IN T_Handshake_IxSEND;
        Handshake_Data : OUT T_Handshake_SS_FIFO;
        Handshake_OxSEND : OUT T_Handshake_OxSEND
    );
END ENTITY;

ARCHITECTURE arch OF data_shift_out2 IS

    TYPE T_HANDSHAKE IS RECORD
        busy : STD_LOGIC;
        valid : STD_LOGIC;
        ready : STD_LOGIC;
        response : STD_LOGIC;
    END RECORD;

    SIGNAL WL : T_HANDSHAKE;
    SIGNAL SS : T_HANDSHAKE;
    SIGNAL ss_incr_flg : STD_LOGIC := '0';
    --State
    TYPE state_type IS (
        IDLE,
        READY,
        LOW_SET0,
        LOW_SET1,
        HIGH_SET0,
        REQUEST,
        RESP_ACK,
        REQ_GRANT,
        IDLERESET,
    );

    SIGNAL hsout_stm : state_type := IDLE;

    SIGNAL SSCnt : INTEGER := 0;
    SIGNAL SSBitCnt : INTEGER := 0;
    SIGNAL SS_INCR_intl : STD_LOGIC;

    SIGNAL SS_RESET_intl : STD_LOGIC;
    SIGNAL Handshake_SEND_intl : T_Handshake_SEND_intl;
    SIGNAL SS_CNT_EN : STD_LOGIC := '0';
    SIGNAL A_CH0_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH1_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH2_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH3_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL A_CH4_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH5_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH6_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH7_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL A_CH8_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH9_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH10_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH11_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL A_CH12_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH13_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH14_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL A_CH15_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL B_CH0_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH1_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH2_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH3_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL B_CH4_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH5_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH6_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH7_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL B_CH8_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH9_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH10_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH11_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);

    SIGNAL B_CH12_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH13_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH14_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
    SIGNAL B_CH15_intl : STD_LOGIC_VECTOR(11 DOWNTO 0);
BEGIN

    PROCESS (rst, clk)
        VARIABLE rx : axisStream_32_slave := axisStream_32_slave_null;
        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;
    BEGIN
        IF rst = '1' THEN
            rx := axisStream_32_slave_null;
            tx := axisStream_32_master_null;
            SS_INCR_flg <= '0';
            hsout_stm <= IDLE;
            SScnt <= 0;
            SSBitcnt <= 0;
            SS_INCR_intl <= '0';
            SS_RESET_intl <= '1';

            Handshake_SEND_intl.REQ <= '0';

        ELSE
            IF rising_edge(clk) THEN
                pull(rx, rx_m2s);
                pull(tx, tx_s2m);
                --STM
                CASE hsout_stm IS
                    WHEN IDLE =>
                        hsout_stm <= READY;
                        HSCLK <= '0';
                        SS_RESET_intl <= '0';
                        SS_INCR_intl <= '0';

                    WHEN READY =>
                        IF (CtrlBus_IxSL.SS_INCR = '1') THEN
                            SS_INCR_flg <= '1';
                            SS_INCR_intl <= '1';
                            hsout_stm <= LOW_SET0;
                        ELSE
                            hsout_stm <= READY;
                        END IF;

                        SScnt <= 0;
                        SSBitcnt <= 0;

                    WHEN LOW_SET0 =>
                        HSCLK <= '1'; --'0'
                        SS_INCR_intl <= '0';
                        SS_RESET_intl <= '0';
                        hsout_stm <= LOW_SET1;

                        IF SSBitCnt = 0 THEN
                            SS_INCR_intl <= '1';
                        END IF;
                        
                    WHEN LOW_SET1 =>
                        HSCLK <= '1';
                        SS_INCR_intl <= '0';
                        hsout_stm <= HIGH_SET0;

                    WHEN HIGH_SET0 =>
                        HSCLK <= '0';
                        -- SAmple the output of TARGETC
                        IF SSBitCnt > 2 THEN

                            A_CH0_intl(SSBitCnt - 3) <= DO_A_B(0);
                            A_CH1_intl(SSBitCnt - 3) <= DO_A_B(1);
                            A_CH2_intl(SSBitCnt - 3) <= DO_A_B(2);
                            A_CH3_intl(SSBitCnt - 3) <= DO_A_B(3);

                            A_CH4_intl(SSBitCnt - 3) <= DO_A_B(4);
                            A_CH5_intl(SSBitCnt - 3) <= DO_A_B(5);
                            A_CH6_intl(SSBitCnt - 3) <= DO_A_B(6);
                            A_CH7_intl(SSBitCnt - 3) <= DO_A_B(7);

                            A_CH8_intl(SSBitCnt - 3) <= DO_A_B(8);
                            A_CH9_intl(SSBitCnt - 3) <= DO_A_B(9);
                            A_CH10_intl(SSBitCnt - 3) <= DO_A_B(10);
                            A_CH11_intl(SSBitCnt - 3) <= DO_A_B(11);

                            A_CH12_intl(SSBitCnt - 3) <= DO_A_B(12);
                            A_CH13_intl(SSBitCnt - 3) <= DO_A_B(13);
                            A_CH14_intl(SSBitCnt - 3) <= DO_A_B(14);
                            A_CH15_intl(SSBitCnt - 3) <= DO_A_B(15);

                            B_CH0_intl(SSBitCnt - 3) <= DO_A_B(16);
                            B_CH1_intl(SSBitCnt - 3) <= DO_A_B(17);
                            B_CH2_intl(SSBitCnt - 3) <= DO_A_B(18);
                            B_CH3_intl(SSBitCnt - 3) <= DO_A_B(19);

                            B_CH4_intl(SSBitCnt - 3) <= DO_A_B(20);
                            B_CH5_intl(SSBitCnt - 3) <= DO_A_B(21);
                            B_CH6_intl(SSBitCnt - 3) <= DO_A_B(22);
                            B_CH7_intl(SSBitCnt - 3) <= DO_A_B(23);

                            B_CH8_intl(SSBitCnt - 3) <= DO_A_B(24);
                            B_CH9_intl(SSBitCnt - 3) <= DO_A_B(25);
                            B_CH10_intl(SSBitCnt - 3) <= DO_A_B(26);
                            B_CH11_intl(SSBitCnt - 3) <= DO_A_B(27);

                            B_CH12_intl(SSBitCnt - 3) <= DO_A_B(28);
                            B_CH13_intl(SSBitCnt - 3) <= DO_A_B(29);
                            B_CH14_intl(SSBitCnt - 3) <= DO_A_B(30);
                            B_CH15_intl(SSBitCnt - 3) <= DO_A_B(31);

                        END IF;


                        IF SSBitCnt = 14 THEN
                            --if SSBitCnt = 13 then
                            --if SSBitCnt = 11 then
                            hsout_stm <= REQUEST;
                            SSBitCnt <= 0;
                        ELSE
                            hsout_stm <= LOW_SET1;
                            SSBitCnt <= SSBitCnt + 1;
                        END IF;

                    WHEN REQUEST =>
                        IF Handshake_IxSEND.Busy = '0' THEN
                            Handshake_SEND_intl.REQ <= '1';
                            HSCLK <= '0';
                            hsout_stm <= RESP_ACK;
                        ELSE
                            Handshake_SEND_intl.REQ <= '0';
                            HSCLK <= '0';
                            hsout_stm <= REQUEST;
                        END IF;
                    WHEN RESP_ACK =>
                        HSCLK <= '0';
                        --CtrlBus_OxSL.SS_SELECT <= std_logic_vector(to_unsigned(SScnt,CtrlBus_OxSL.SS_SELECT'length));
                        IF (CtrlBus_IxSL.SSACK = '1' AND CtrlBus_IxSL.SAMPLEMODE = '0') OR (acknowledge_intl = '1' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
                            Handshake_SEND_intl.REQ <= '0';
                            hsout_stm <= REQ_GRANT;

                        ELSE
                            hsout_stm <= RESP_ACK;
                        END IF;

                    WHEN REQ_GRANT =>
                        --if CtrlBus_IxSL.SSACK = '0' then
                        IF (CtrlBus_IxSL.SSACK = '0' AND CtrlBus_IxSL.SAMPLEMODE = '0') OR (acknowledge_intl = '0' AND CtrlBus_IxSL.SAMPLEMODE = '1') THEN
                            IF (SS_INCR_flg = '0') THEN
                                SScnt <= SScnt + 1;
                                IF (SScnt < 31) THEN
                                    --hsout_stm <= LOW_SET0;
                                    hsout_stm <= LOW_SET0;
                                    SS.busy <= '1';
                                ELSE
                                    --SS_RESET_intl <= '1';
                                    hsout_stm <= IDLERESET;
                                    SS.busy <= '0';
                                END IF;
                            ELSE
                                --SS_RESET_intl <= '1';
                                SS_INCR_flg <= '0';
                                SS.busy <= '0';
                                hsout_stm <= IDLERESET;
                            END IF;
                        ELSE
                            hsout_stm <= REQ_GRANT;
                        END IF;
                    WHEN IDLERESET =>
                        SS.busy <= '0';
                        --SS_RESET_intl <= '1';
                        hsout_stm <= IDLE;
                    WHEN OTHERS =>
                        -- nop
                END CASE;
                push(rx, rx_s2m);
                push(tx, tx_m2s);
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;