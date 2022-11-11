LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.all;
use work.roling_register_p.all;
use work.target_c_pack.all;
use work.register_list.all;

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
    signal sst_counter : unsigned(15 downto 0) := ( others => '0');

    signal sst_period  : std_logic_vector(15 downto 0)  := ( others => '0');

    signal wait_time  : std_logic_vector(15 downto 0)  := ( others => '0');
    signal sample_after_threshold  : std_logic_vector(15 downto 0)  := ( others => '0');

    signal window_counter : unsigned(7 downto 0)  := ( others => '0');
    
    signal window_counter_triggered : std_logic_vector(31 downto 0)  := ( others => '0');

    signal window_counter_sat : std_logic_vector(7 downto 0)  := ( others => '0');
    
    signal i_sampling_out :  sampling_t := sampling_t_null;
    type state_t is ( sampling , SAT, send_data_s,  waiting);
    signal roundbuffer_simple_state : state_t := sampling;

    signal i_trigger_in   : std_logic;
    signal i_sw_trigger_in   : std_logic;

    --signal edge_t : std_logic_vector(1 downto 0) := "00";
    --signal sw_trig_update : std_logic := '0';

    procedure increment_counter (signal  window_counter_in : inout unsigned  ; signal sampling_t_in : inout sampling_t; signal  sst_counter_in : inout   unsigned ; sst_period_in : std_logic_vector ) is 

    begin 
        if sst_counter_in >=  unsigned( '0' & sst_period_in(15 downto 1) ) then 
            sampling_t_in.SSTIN <= '1';
        end if;
        if sst_counter_in >=  unsigned( sst_period_in ) - 1 then 
            sst_counter_in<= (others => '0');
            window_counter_in <= window_counter_in + 1;
        end if;

    end procedure;
begin

    -- -- edge detector for SW_trigger

    -- process (clk)
    -- begin
    --     if rising_edge(clk) then
    --         edge_t(1) <= edge_t(0);
    --         edge_t(0) <= i_sw_trigger_in;
            
    --     end if;
    -- end process;

    -- sw_trig_update <= '1' when edge_t = "01" else
    --                     '0';

    --i_trigger_in <= sw_trig_update or trigger_in;
    i_trigger_in <= i_sw_trigger_in or trigger_in;
    sampling_out <= i_sampling_out;
    
    process( clk,rst )

        VARIABLE tx_data : STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
        VARIABLE tx : axisStream_32_master := axisStream_32_master_null;
    begin
        if rst = '1' then 
            i_sampling_out <= sampling_t_null;
            tx := axisStream_32_master_null;
            roundbuffer_simple_state <= sampling;
            sst_counter <= ( others => '0');
        elsif rising_edge(clk) then 
            pull(tx, trigger_tx_s2m);
            i_sampling_out.SSTIN <= '0';
            sst_counter <= sst_counter + 1;

            i_sampling_out.WR_Row_Select <= std_logic_vector(window_counter( i_sampling_out.WR_Row_Select'range ));
            i_sampling_out.WR_Coloumn_Select  <= std_logic_vector(
                                                        window_counter( i_sampling_out.WR_Coloumn_Select'length + i_sampling_out.WR_Row_Select'length - 1    
                                                        downto  
                                                        i_sampling_out.WR_Row_Select'length )
                                                    );
            
            
            CASE roundbuffer_simple_state IS
                WHEN sampling =>
                    increment_counter(  
                        window_counter_in  => window_counter , 
                        sampling_t_in  => i_sampling_out , 
                        sst_counter_in => sst_counter, 
                        sst_period_in => sst_period
                     );

                    if i_trigger_in = '1'  and  ready_to_send(tx)  then 
                        window_counter_triggered (window_counter'range ) <= std_logic_vector(window_counter);
                        window_counter_sat <= std_logic_vector(   window_counter    +   unsigned(sample_after_threshold(7 downto 0) )   );
                        roundbuffer_simple_state <= SAT;
                    end if;

                when SAT => 
                    increment_counter(  
                        window_counter_in  => window_counter , 
                        sampling_t_in  => i_sampling_out , 
                        sst_counter_in => sst_counter, 
                        sst_period_in => sst_period
                     );
                    if  window_counter_sat = std_logic_vector(window_counter) then 
                        roundbuffer_simple_state <= send_data_s;
                    end if;
                when send_data_s => 
                    i_sampling_out <= sampling_t_null;
                    if  ready_to_send(tx) then 
                        send_data(tx, window_counter_triggered);
                        roundbuffer_simple_state <= waiting;
                        sst_counter <= ( others => '0');
                    end if;
                when waiting => 
                    i_sampling_out <= sampling_t_null;
                    if sst_counter = unsigned(wait_time) then 
                        roundbuffer_simple_state <= sampling;   
                        window_counter <= (others => '0');
                        sst_counter<= (others => '0');
                    end if;
                WHEN OTHERS =>
                    roundbuffer_simple_state <= sampling;   
            END CASE;
          



            push(tx, trigger_tx_m2s);
        end if;        
    end process ; 


    
    PROCESS (clk) is
    BEGIN
        if rising_edge(clk) then
            i_sw_trigger_in <= '0';
            read_data_s(reg , wait_time , reg_list.wait_time); 
            read_data_s(reg , sst_period , reg_list.sst_period); 
            read_data_s(reg , sample_after_threshold , reg_list.sample_after_threshold); 
            if is_register(reg, reg_list.SW_trigger) then 
                 i_sw_trigger_in <= reg.new_value;
             end if;
            --read_data_s(reg , i_sw_trigger_in , reg_list.SW_trigger);

            
        end if;
    end process;

    

end architecture ; 