library IEEE;

  use IEEE.numeric_std.all;
  use IEEE.std_logic_1164.all;

  use ieee.std_logic_unsigned.all;

  use work.xgen_SerialDataRout_p.all;
  use work.xgen_axiStream_registerT.all;
  use work.roling_register_p.all;

  use work.xgen_axistream_32.all;
  use work.clk_domain_crossing.all;
 use work.klm_scint_globals.all;

entity roling_register_sb is
  generic(
    ADDR     : integer := 10
   
  );
  port (
    clk            : in   std_logic;

    reg_in         : in registerT := registerT_null;   
    
    
    registerIN_m2s  : in axisStream_registert_m2s := axisStream_registert_m2s_null;
    registerIN_s2m  : out axisStream_registert_s2m := axisStream_registert_s2m_null;

    globals_sb :  out globals_sb_t := globals_sb_t_null;
    globals :  out globals_t := globals_t_null;
    debug_register_out : out registerT :=registerT_null
  );
end entity;

architecture rtl of roling_register_sb is


  procedure increment_until_rollover(signal reg_array_counter: inout integer; reg_array_length : in integer) is 
  begin
    reg_array_counter <= reg_array_counter +1;
    if reg_array_counter >= reg_array_length - 1 then
      reg_array_counter  <= 0;
    end if;
  end procedure;
  
  signal i_regbuf_in : registerT := registerT_null;  
  signal i_regBuffer : registerT := registerT_null;
  signal i_regBuffer1 : registerT := registerT_null;

 
 signal  TX_m2s  : axisStream_32_m2s := axisStream_32_m2s_null;
 signal  TX_s2m  : axisStream_32_s2m := axisStream_32_s2m_null;

  signal  reg_TX_m2s : axisStream_32_m2s := axisStream_32_m2s_null;
  signal  reg_TX_s2m : axisStream_32_s2m := axisStream_32_s2m_null;
 signal reset : std_logic := '0';

 signal reg_sb_out : std_logic := '0';
 
 constant data : integer := 32;
 signal wea    : std_logic;
 signal addra  : std_logic_vector(ADDR-1 downto 0);
 signal dina   : std_logic_vector(DATA-1 downto 0);
 -- Port B
 signal addrb  : std_logic_vector(ADDR-1 downto 0);
 signal doutb  : std_logic_vector(DATA-1 downto 0);

 signal reg_slv  : std_logic_vector(31 downto 0);
begin

   reg_slv <= registerT_to_slv32(registerIN_m2s.data);
  infifo : entity  work.fifo_cc_axi_32 generic map (

    DEPTH => 10
  ) port map (
    clk      => clk,
    
    RX_m2s.data  => reg_slv,
    RX_m2s.valid  => registerIN_m2s.valid,
    RX_m2s.last  => registerIN_m2s.last,
    RX_s2m.ready  => registerIN_s2m.ready,

    TX_m2s  => TX_m2s,
    TX_s2m  => TX_s2m
  );

  ram : entity work.bram_sdp_cc generic map(
    DATA    => data,
    ADDR    => ADDR
  ) port map(
    -- Port A
    clk   =>clk,
    wea    => wea,   
    addra  => addra, 
    dina   => dina , 
  -- port B
    addrb  => addrb ,
    doutb  => doutb  
  );
  process(clk) is
    variable reg_rx : axisStream_32_slave:= axisStream_32_slave_null;

    variable reg_tx : axisStream_32_master:= axisStream_32_master_null;
    variable DataBuffer : STD_LOGIC_VECTOR(31 downto 0) := (others =>'0');
    variable DataBuffer_cl : registerT := registerT_null;
    variable reg_address : integer := 0; 
    

    
    
  begin 
    if rising_edge(clk) then
      pull(reg_rx, TX_m2s);
      pull(reg_tx, reg_TX_s2m);

      i_regBuffer <= registerT_null;

      wea <= '1';
      addra <= i_regbuf_in.address(addra'range);   
      dina <= i_regbuf_in.address & i_regbuf_in.value; 
      addrb <= addrb +1;
      i_regBuffer <= slv32_to_registerT(doutb);
      
      

      if isReceivingData(reg_rx) and ready_to_send(reg_tx) then
        read_data(reg_rx,DataBuffer);
        send_data(reg_tx,DataBuffer);
        
        DataBuffer_cl  := slv32_to_registerT(DataBuffer );
        reg_address := to_integer(signed(DataBuffer_cl.address));

        if reg_address = register_val.Global_reset then
          reset <= '1';
        else 
          i_regBuffer.address <= DataBuffer_cl.address;
          i_regBuffer.value <= DataBuffer_cl.value;
          i_regBuffer.new_value <= '1';
        end if;
        


      end if;
     

      push(reg_tx, reg_TX_m2s);
      push(reg_rx, TX_s2m);
    end if;
  end process;



reg_sender : entity work.register_single_bit_sender port  map(
        clk => clk,
        rst => reset,
        
        RX_m2s =>reg_TX_m2s,
        RX_s2m =>reg_TX_s2m,

        register_out => reg_sb_out
    );

  reg_receiver : entity work.register_single_bit_receiver port  map(
        clk => clk,
        rst => reset,
        register_in => reg_sb_out,


        register_out => debug_register_out

    );
  
  
  reg_buffer : entity work.registerBuffer generic map (
    Depth =>  10
  ) port map (

    clk => clk,
    registersIn   => i_regBuffer,
    registersOut  => i_regBuffer1
  );
  
  
  globals_sb.clk <= clk;
  globals_sb.rst <= reset;
  globals_sb.reg <= reg_sb_out;


  globals.reg <= i_regBuffer1;
  
  globals.clk <= clk;
  globals.rst  <= reset;
  

  reg_buffer1 : entity work.registerBuffer generic map (
    Depth =>  10
  ) port map (

    clk => clk,
    registersIn   => reg_in,
    registersOut  => i_regbuf_in
  );
end rtl;