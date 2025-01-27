library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

  use work.AXI4LITE_pac.all;
  use work.roling_register_p.all;

entity axi4_lite_target_c_connector is
  port (
        clk : in std_logic;
        rst : in std_logic;

        rx_m2s : in AXI4LITE_m2s;
        rx_s2m : out AXI4LITE_s2m;
        
        
        reg : out  registerT := registerT_null;
        
	    slv_reg1_o	: out  std_logic_vector(15 downto 0);
	    slv_reg2_o  : IN   std_logic_vector(15 downto 0)
	    
  );
end entity;

architecture rtl of axi4_lite_target_c_connector is
    signal i_slv_reg0_o	:  std_logic_vector(32-1 downto 0) :=  (others =>'0');
	signal i_slv_reg1_o	:  std_logic_vector(32-1 downto 0) := (others =>'0');
	signal i_slv_reg2_o  :   std_logic_vector(32-1 downto 0):= (others =>'0');
	signal i_reg_new_value : std_logic;
begin

  
  slv_reg1_o <= i_slv_reg1_o(15 DOWNTO 0);
  


  reg.address <= i_slv_reg0_o(31 DOWNTO 16);
  reg.value <= i_slv_reg0_o(15 DOWNTO 0);
  reg.new_value <= i_reg_new_value;

  
process(clk, rst) is 
  variable rx: AXI4LITE_slave := AXI4LITE_slave_null;
  variable rx_data : std_logic_vector(31 downto 0);
  variable rx_addr : std_logic_vector(31 downto 0);
begin 

if rising_edge(clk) then
    if rst ='1' then 
      rx := AXI4LITE_slave_null;
      i_slv_reg0_o <= (others =>'0');
      i_slv_reg1_o <= (others =>'0');
      i_slv_reg2_o <= (others =>'0');
     
    end if;
    i_slv_reg2_o(slv_reg2_o'range) <= slv_reg2_o;
    pull(rx , rx_m2s);
    i_reg_new_value <= '0';
    rx_data := (others => '0');
    rx_addr := (others => '0');

    if is_requesting_data(rx) then
        get_read_address(rx, rx_addr);
        if rx_addr = x"00000000" then 
          set_read_data(rx, x"000000AA");
        elsif rx_addr = x"00000004" then 
          set_read_data(rx, i_slv_reg1_o);
        elsif rx_addr = x"00000008" then 
          set_read_data(rx, i_slv_reg2_o);          
  
        else      
          set_read_data(rx, rx_addr);
        end if;
    end if;
    if is_receiving_data(rx) then 
        get_write_data(rx, rx_addr, rx_data);
        if rx_addr = x"00000000" then 
          i_reg_new_value <= '1';
          i_slv_reg0_o <= rx_data;
        elsif rx_addr = x"00000004" then 
          i_slv_reg1_o <= rx_data;

        end if;
    end if;

    push(rx, rx_s2m);
end if;

end process;
end architecture;
