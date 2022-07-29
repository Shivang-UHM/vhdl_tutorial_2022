----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 06/24/2022 04:47:37 PM
-- Design Name: 
-- Module Name: target_C_top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;


use work.AXI4LITE_pac.all;


entity target_C_top is
  Port (     
    DDR_0_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_0_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_0_cas_n : inout STD_LOGIC;
    DDR_0_ck_n : inout STD_LOGIC;
    DDR_0_ck_p : inout STD_LOGIC;
    DDR_0_cke : inout STD_LOGIC;
    DDR_0_cs_n : inout STD_LOGIC;
    DDR_0_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_0_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_0_odt : inout STD_LOGIC;
    DDR_0_ras_n : inout STD_LOGIC;
    DDR_0_reset_n : inout STD_LOGIC;
    DDR_0_we_n : inout STD_LOGIC;
    FIXED_IO_0_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_0_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_0_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_0_ps_clk : inout STD_LOGIC;
    FIXED_IO_0_ps_porb : inout STD_LOGIC;
    FIXED_IO_0_ps_srstb : inout STD_LOGIC

    
    );
end target_C_top;

architecture Behavioral of target_C_top is
    signal gp_in_0_0 : STD_LOGIC_VECTOR ( 31 downto 0 ) := (others =>'0');
    signal gp_out_0_0 : STD_LOGIC_VECTOR ( 31 downto 0 ):= (others =>'0');
    
    
    signal gp_in_1_0 : STD_LOGIC_VECTOR ( 31 downto 0 ):= (others =>'0');
    signal gp_out_1_0 : STD_LOGIC_VECTOR ( 31 downto 0 ):= (others =>'0');
    
    
        

    
    

    

    signal FCLK_CLK0 : STD_LOGIC;
    signal peripheral_aresetn : STD_LOGIC_VECTOR ( 0 to 0 );
    signal m00_axi_m2s_0 : STD_LOGIC_VECTOR ( 104 downto 0 );
    signal m00_axi_s2m_0 : STD_LOGIC_VECTOR ( 40 downto 0 );
    signal rx_m2s :  AXI4LITE_m2s;
    signal rx_s2m :  AXI4LITE_s2m;

   
begin


u_zynq : entity work.design_1_wrapper port map (

    DDR_0_addr  => DDR_0_addr,
    DDR_0_ba => DDR_0_ba ,
    DDR_0_cas_n => DDR_0_cas_n ,
    DDR_0_ck_n => DDR_0_ck_n ,
    DDR_0_ck_p => DDR_0_ck_p ,
    DDR_0_cke => DDR_0_cke ,
    DDR_0_cs_n => DDR_0_cs_n ,
    DDR_0_dm => DDR_0_dm ,
    DDR_0_dq => DDR_0_dq ,
    DDR_0_dqs_n => DDR_0_dqs_n ,
    DDR_0_dqs_p => DDR_0_dqs_p ,
    DDR_0_odt => DDR_0_odt ,
    DDR_0_ras_n => DDR_0_ras_n ,
    DDR_0_reset_n => DDR_0_reset_n ,
    DDR_0_we_n => DDR_0_we_n ,
    FIXED_IO_0_ddr_vrn => FIXED_IO_0_ddr_vrn ,
    FIXED_IO_0_ddr_vrp => FIXED_IO_0_ddr_vrp ,
    FIXED_IO_0_mio => FIXED_IO_0_mio ,
    FIXED_IO_0_ps_clk => FIXED_IO_0_ps_clk ,
    FIXED_IO_0_ps_porb =>FIXED_IO_0_ps_porb ,
    FIXED_IO_0_ps_srstb => FIXED_IO_0_ps_srstb ,
    gp_in_0_0  => gp_in_0_0 ,
    gp_in_1_0  => gp_in_1_0 ,
    gp_out_0_0 => gp_out_0_0 ,
    gp_out_1_0  =>gp_out_1_0,
    
    
    

    FCLK_CLK0 => FCLK_CLK0,
    
    m00_axi_m2s_0(104 downto 0) => m00_axi_m2s_0(104 downto 0),
    m00_axi_s2m_0(40 downto 0) => m00_axi_s2m_0(40 downto 0),
    peripheral_aresetn(0) => peripheral_aresetn(0)
);


u_axi4lite_slave_example : entity work.axi4lite_slave_example port map(
    clk => FCLK_CLK0,
    rst => not peripheral_aresetn(0),

    rx_m2s => rx_m2s,
    rx_s2m => rx_s2m

);
    rx_m2s        <= AXI4LITE_m2s_deserialize(m00_axi_m2s_0);
    m00_axi_s2m_0 <= AXI4LITE_s2m_serialize(rx_s2m);



    
end Behavioral;
