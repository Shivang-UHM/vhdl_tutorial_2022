



library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;
  
package register_list is

type reg_list_t is record 
    DISCH_PERIOD : integer;
    ramp_count_max : integer;

    SAMPLEMODE : integer;
    SSACK : integer;
end record;


constant reg_list : reg_list_t := (
    DISCH_PERIOD => 200,
    ramp_count_max => 201,

    SAMPLEMODE => 100,
    SSACK => 101
);
end package;