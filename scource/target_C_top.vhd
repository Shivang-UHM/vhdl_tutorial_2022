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
library UNISIM;
use UNISIM.VComponents.all;


use work.AXI4LITE_pac.all;
USE work.TARGETC_pkg.ALL;
USE work.xgen_axistream_32.ALL;
USE work.handshake.ALL;
use work.roling_register_p.all;
use work.register_list.all;
use work.target_c_pack.all;

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
    FIXED_IO_0_ps_srstb : inout STD_LOGIC;
    
    SSTIN_P : out std_logic;
    SSTIN_N : out std_logic;
    
    WL_CLK_P : out std_logic;
    WL_CLK_N : out std_logic;
    
    
    -- Legacy Serial interface 
    LCS_SIN : out std_logic;
    LCS_SCLK : out std_logic;
    
    ---         Target C A
    A_RAMP : out std_logic;
    A_GCC_RESET : out std_logic;
    
    
    A_DO : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
    A_WR_RS : out  STD_LOGIC_VECTOR ( 1 downto 0 );
    A_WR_CS : out  STD_LOGIC_VECTOR ( 5 downto 0 );
    
    A_RDAD_DIR : out std_logic;
    A_RDAD_SIN : out std_logic;
    A_RDAD_CLK : out std_logic;
    
    A_SS_INCR : out std_logic;
    A_HSCLK_P : out std_logic;
    A_HSCLK_N : out std_logic;
    A_SS_RESET: out std_logic;
    
    A_LCS_PCLK :out std_logic ;
    A_LCS_SHOUT : in std_logic ;
    A_SAMPLESEL_ANY : out std_logic ;
    A_DONE:			in	std_logic;
    
    -- Target C B
    B_RAMP  : out std_logic;
    B_GCC_RESET : out std_logic;
    B_DO : in STD_LOGIC_VECTOR ( 15 downto 0 );
    
    
    B_WR_RS : out  STD_LOGIC_VECTOR ( 1 downto 0 );
    B_WR_CS : out  STD_LOGIC_VECTOR ( 5 downto 0 );
    
    B_RDAD_DIR : out std_logic;
    B_RDAD_SIN : out std_logic;
    B_RDAD_CLK : out std_logic;
    
    B_SS_INCR : out std_logic;
    B_HSCLK_P : out std_logic;
    B_HSCLK_N : out std_logic;
    B_SS_RESET: out std_logic;
    
    B_LCS_PCLK : out std_logic ;
    B_LCS_SHOUT : in std_logic; 
    B_SAMPLESEL_ANY : out std_logic ;
    B_DONE:			in	std_logic
    
    
    
    
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

    signal    clk : std_logic;
    signal rst : std_logic;
    signal reg : registerT;
    signal trigger_in   : std_logic;
    signal sampling_out : sampling_t := sampling_t_null;
    
    
    signal will_out :   willkinson_ADC_t;
    
    signal data_shift_out_m2s : serial_shift_out_m2s;
    signal data_shift_out_s2m : serial_shift_out_s2m;

    
    signal sample_select_m2s :  sample_select_t := sample_select_t_null;
    
    signal addr  : std_logic_vector( 15 downto 0) := (others =>'0');
    signal data  : std_logic_vector( 15 downto 0) := (others =>'0');
    
    signal LC_m2s : Legacy_serial_m2s;
    signal LC_s2m : Legacy_serial_s2m;
    
    -- debug signals
    signal wlclk : std_logic;
    attribute mark_debug : string;
--    attribute mark_debug of wlclk: signal is "true";
    
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
rst <= not peripheral_aresetn(0);

u_axi4_lite_target_c_connector : entity work.axi4_lite_target_c_connector port map(
    clk => FCLK_CLK0,
    rst => rst,

    rx_m2s => rx_m2s,
    rx_s2m => rx_s2m,
    reg => reg,
    
        
    slv_reg1_o	=> addr,
    slv_reg2_o  => data
);
    rx_m2s        <= AXI4LITE_m2s_deserialize(m00_axi_m2s_0);
    m00_axi_s2m_0 <= AXI4LITE_s2m_serialize(rx_s2m);


U_readout: entity work.readout_simple_complete port map(
    clk => FCLK_CLK0,
    rst => rst,
    reg => reg,
    trigger_in   => trigger_in,
    sampling_out => sampling_out,
    
    
    will_out => will_out, 
    
    data_shift_out_m2s => data_shift_out_m2s,
    data_shift_out_s2m => data_shift_out_s2m,

    
    sample_select_m2s =>   sample_select_m2s ,
    
    addr  =>  addr  ,
    data  =>   data  
  ) ;


  Lagacy_serial :  entity  work.register_handler_simple port  map (
        clk => FCLK_CLK0,
        rst => rst,
        reg => reg,
  
       LC_m2s => LC_m2s,
       LC_s2m => LC_s2m
    ) ;
    
    LCS_SIN <= LC_m2s.SIN;
    LCS_SCLK <= LC_m2s.SCLK;
    A_LCS_PCLK <= LC_m2s.PCLK;
    B_LCS_PCLK <= LC_m2s.PCLK;

OBUFDS_inst_SSTIN : OBUFDS
port map (
   O  => SSTIN_P,  
   OB => SSTIN_N, 
   I => sampling_out.SSTIN 
);


OBUFDS_inst_WLCLK : OBUFDS
port map (
   O => WL_CLK_P,  
   OB => WL_CLK_N, 
   I => will_out.CLK
);


A_RAMP  <= will_out.ramp;
A_GCC_RESET <= will_out.GCC_reset;

A_WR_RS <= sampling_out.WR_Row_Select;
A_WR_CS <= sampling_out.WR_Coloumn_Select;

A_RDAD_CLK      <=  sample_select_m2s.RDAD_clk;
A_RDAD_SIN      <=  sample_select_m2s.RDAD_SIN;
A_RDAD_DIR      <=  sample_select_m2s.RDAD_DIR;
A_SAMPLESEL_ANY <=  sample_select_m2s.SAMPLESEL_ANY;

A_SS_RESET <= data_shift_out_m2s.reset;
A_SS_INCR <= data_shift_out_m2s.increment;

OBUFDS_inst_HSCLK_A : OBUFDS
port map (
   O => A_HSCLK_P,  
   OB => A_HSCLK_N, 
   I => data_shift_out_m2s.HSCLK
);


B_RAMP  <= will_out.ramp;
B_GCC_RESET <= will_out.GCC_reset;
B_WR_RS <= sampling_out.WR_Row_Select;
B_WR_CS <= sampling_out.WR_Coloumn_Select;

B_RDAD_CLK <=  sample_select_m2s.RDAD_clk;
B_RDAD_SIN <=  sample_select_m2s.RDAD_SIN;
B_RDAD_DIR <=  sample_select_m2s.RDAD_DIR; 
B_SAMPLESEL_ANY <=  sample_select_m2s.SAMPLESEL_ANY;
 
B_SS_RESET <= data_shift_out_m2s.reset;
B_SS_INCR <= data_shift_out_m2s.increment;

OBUFDS_inst_HSCLK_B : OBUFDS
port map (
   O => B_HSCLK_P,  
   OB => B_HSCLK_N, 
   I => data_shift_out_m2s.HSCLK
);


data_shift_out_s2m.data <=  A_DO &B_DO;
    
    
end Behavioral;
