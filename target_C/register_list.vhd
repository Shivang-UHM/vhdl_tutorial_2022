



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  
package register_list is

type reg_list_t is record 
    DISCH_PERIOD : integer;
    ramp_count_max : integer;
    
    sst_period : integer;
    wait_time : integer;
    sample_after_threshold: integer;
    SW_trigger : integer;

    SAMPLEMODE : integer;
    SSACK : integer;
end record;


constant reg_list : reg_list_t := (
    DISCH_PERIOD => 200,
    ramp_count_max => 201,
    
    
    sst_period => 300,
    wait_time => 301,
    sample_after_threshold => 302,
    SW_trigger => 303,

    SAMPLEMODE => 100,
    SSACK => 101
);
end package;