



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  
package register_list is

type reg_list_t is record 
    DISCH_PERIOD : integer;
    ramp_count_max : integer;
--    will_period    : integer; --Wl_clk is made fixed to 125 MHz: Sep 28
    
    sst_period : integer;
    wait_time : integer;
    sample_after_threshold: integer;
    SW_trigger : integer;

    RDAD_clk_period : integer;

    SAMPLEMODE : integer;  -- what is this
    SSACK : integer;
    sample_select_any : integer;
 
    Legacy_serial_addr   : integer;
    Legacy_serial_data   : integer;
    Legacy_serial_update : integer;
end record;


constant reg_list : reg_list_t := (
    DISCH_PERIOD => 200,
    ramp_count_max => 201,
--    will_period  => 202,
    
    
    sst_period => 300,
    wait_time => 301,
    sample_after_threshold => 302,
    SW_trigger => 303,

    RDAD_clk_period => 500,

    SAMPLEMODE => 100,
    SSACK => 101,
    sample_select_any => 102,

    Legacy_serial_addr => 400,
    Legacy_serial_data => 401,
    Legacy_serial_update => 402

);
end package;