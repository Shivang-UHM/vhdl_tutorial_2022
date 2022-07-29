LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE work.target_c_pack.ALL;

ENTITY target_c_readout IS
    PORT (
        clk : STD_LOGIC;

        
        TC_A : OUT target_c_inputs_t := target_c_inputs_t_null;
        TC_A_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

        TC_B : OUT target_c_inputs_t := target_c_inputs_t_null;
        TC_B_data_in : IN STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

        gp_in_0_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
        gp_out_0_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
        gp_in_1_0 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
        gp_out_1_0 : IN STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0')
    );
END ENTITY;


architecture arch of target_c_readout is
   

begin


    

end architecture ; 