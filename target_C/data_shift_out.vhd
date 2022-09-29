LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.ALL;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;

ENTITY data_shift_out IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        a0_reg : In registerT;

        data_shift_out_m2s : out  serial_shift_out_m2s := serial_shift_out_m2s_null;
        data_shift_out_s2m : in  serial_shift_out_s2m := serial_shift_out_s2m_null;

        rx_m2s : IN axisStream_32_m2s := axisStream_32_m2s_null;
        rx_s2m : OUT axisStream_32_s2m := axisStream_32_s2m_null;

        tx_m2s : OUT axisStream_32_m2s := axisStream_32_m2s_null;
        tx_s2m : IN axisStream_32_s2m := axisStream_32_s2m_null

    );
END ENTITY;

ARCHITECTURE arch OF data_shift_out IS

    signal data_out : slv_12_array(0 TO 31);

    
    


    
    --State
    TYPE state_type IS (
        IDLE,
        READY,
        RESPREADY,
        LOW_SET0,
        LOW_SET1,
        HIGH_SETWait,
        HIGH_SET0,
        REQ_GRANT
    );

    SIGNAL hsout_stm : state_type := IDLE;

    SIGNAL SSCnt : unsigned(15 downto 0) := (others => '0');
    SIGNAL word_out_cnt  : INTEGER := 0;
    SIGNAL SSBitCnt : INTEGER := 0;


    
    constant c_ignore_start : INTEGER := 2;
    constant c_magic_wait_time_for_increment : INTEGER := 10; -- your bet is as good as mine

BEGIN


    PROCESS (rst, clk)
        VARIABLE rx : axisStream_32_slave := axisStream_32_slave_null;
        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;
        VARIABLE rx_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
    BEGIN
        IF rst = '1' THEN
            hsout_stm <= IDLE;
            SScnt <= (others => '0');
            SSBitcnt <= 0;
            word_out_cnt <= 0;
            data_shift_out_m2s.increment <= '0';
            data_shift_out_m2s.reset <= '1';

            rx := axisStream_32_slave_null;
            tx := axisStream_32_master_null;
            rx_data := (OTHERS => '0');

        ELSIF rising_edge(clk) THEN
            pull(rx, rx_m2s);
            pull(tx, tx_s2m);
            
            
            data_shift_out_m2s.HSCLK <= '0';
            data_shift_out_m2s.increment <= '0';

            data_shift_out_m2s.reset <= '0';

            CASE hsout_stm IS
                WHEN IDLE =>
                    word_out_cnt <= 0;
                    SScnt <= (others => '0');
                    SSBitcnt <= 0;

                    If (isReceivingData(rx))  then
                        read_data(rx, rx_data);
                        data_shift_out_m2s.reset <= '1';
                        hsout_stm <= RESPREADY;
                    END IF;
                
                When RESPREADY =>
                    data_shift_out_m2s.reset <= '1';
                    data_shift_out_m2s.increment <= '1';
                    
                    SSBitCnt <= SSBitCnt + 1;
                    if SSBitCnt = c_magic_wait_time_for_increment then 
                        SSBitCnt <= 0;
                        hsout_stm <= LOW_SET0;
                    end if;

                WHEN LOW_SET0 =>
                    hsout_stm <= LOW_SET1;
                    data_shift_out_m2s.HSCLK <= '1'; 
                    
                    IF SSBitCnt = 0 THEN
                        data_shift_out_m2s.increment <= '1';
                    END IF;

                WHEN LOW_SET1 =>
                
                    hsout_stm <= HIGH_SETWait;

                    data_shift_out_m2s.HSCLK <= '1';
                    
                when HIGH_SETWait => 
                     hsout_stm <= HIGH_SET0;
                     data_shift_out_m2s.HSCLK <= '1';

                WHEN HIGH_SET0 =>
                    hsout_stm <= LOW_SET1;
                    
                    IF SSBitCnt >= c_ignore_start THEN
                        FOR index IN data_out'RANGE LOOP
                            data_out(index)(SSBitCnt - c_ignore_start) <= data_shift_out_s2m.data(index);
                        END LOOP;
                    END IF;
                    
                    SSBitCnt <= SSBitCnt + 1;
                    IF SSBitCnt = 11 + c_ignore_start THEN
                        hsout_stm <= REQ_GRANT;
                        SSBitCnt <= 0;
                    END IF;



                WHEN REQ_GRANT =>
                    if ready_to_send(tx) then 
                        word_out_cnt <= word_out_cnt + 1;
                        
                        rx_data := (others => '0');
                        rx_data(11 downto 0) :=  data_out(word_out_cnt);
                        send_data(tx, rx_data);
                        
                        if word_out_cnt >= data_out'length - 1 then 
                            word_out_cnt <= 0;
                            SScnt <= SScnt + 1;
                            IF (SScnt < 31) THEN
                                hsout_stm <= LOW_SET0;
                            ELSE
                                Send_end_Of_Stream(tx,true);
                                hsout_stm <= IDLE;
                            END IF;
                        end if;

                        

                    end if;



                WHEN OTHERS =>
                 hsout_stm <= IDLE;
            END CASE;
            push(rx, rx_s2m);
            push(tx, tx_m2s);
    END IF;
END PROCESS;






PROCESS (clk) is
BEGIN
    if rising_edge(clk) then
       
    end if;
end process;

    

END ARCHITECTURE;