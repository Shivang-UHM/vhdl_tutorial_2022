-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (lin64) Build 3064766 Wed Nov 18 09:12:47 MST 2020
-- Date        : Thu Jul 28 15:18:48 2022
-- Host        : idlab2 running 64-bit Ubuntu 20.04.4 LTS
-- Command     : write_vhdl -force -mode funcsim
--               /home1/shivang/github/HMB_CalRDout/HMB_Cal/HMB_Cal.gen/sources_1/bd/design_1/ip/design_1_my_axi4_lite_exporter_0_0/design_1_my_axi4_lite_exporter_0_0_sim_netlist.vhdl
-- Design      : design_1_my_axi4_lite_exporter_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity design_1_my_axi4_lite_exporter_0_0 is
  port (
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 15 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    m00_axi_m2s : out STD_LOGIC_VECTOR ( 104 downto 0 );
    m00_axi_s2m : in STD_LOGIC_VECTOR ( 40 downto 0 )
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of design_1_my_axi4_lite_exporter_0_0 : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of design_1_my_axi4_lite_exporter_0_0 : entity is "design_1_my_axi4_lite_exporter_0_0,my_axi4_lite_exporter_v1_0,{}";
  attribute downgradeipidentifiedwarnings : string;
  attribute downgradeipidentifiedwarnings of design_1_my_axi4_lite_exporter_0_0 : entity is "yes";
  attribute x_core_info : string;
  attribute x_core_info of design_1_my_axi4_lite_exporter_0_0 : entity is "my_axi4_lite_exporter_v1_0,Vivado 2020.2";
end design_1_my_axi4_lite_exporter_0_0;

architecture STRUCTURE of design_1_my_axi4_lite_exporter_0_0 is
  signal \<const0>\ : STD_LOGIC;
  signal \^m00_axi_s2m\ : STD_LOGIC_VECTOR ( 40 downto 0 );
  signal \^s00_axi_araddr\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \^s00_axi_arvalid\ : STD_LOGIC;
  signal \^s00_axi_awaddr\ : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal \^s00_axi_awvalid\ : STD_LOGIC;
  signal \^s00_axi_bready\ : STD_LOGIC;
  signal \^s00_axi_rready\ : STD_LOGIC;
  signal \^s00_axi_wdata\ : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s00_axi_wstrb\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \^s00_axi_wvalid\ : STD_LOGIC;
  attribute x_interface_info : string;
  attribute x_interface_info of s00_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK";
  attribute x_interface_parameter : string;
  attribute x_interface_parameter of s00_axi_aclk : signal is "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 50000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute x_interface_info of s00_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S00_AXI_RST RST";
  attribute x_interface_parameter of s00_axi_aresetn : signal is "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute x_interface_info of s00_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  attribute x_interface_info of s00_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  attribute x_interface_info of s00_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  attribute x_interface_info of s00_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  attribute x_interface_info of s00_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  attribute x_interface_info of s00_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  attribute x_interface_info of s00_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  attribute x_interface_info of s00_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  attribute x_interface_info of s00_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  attribute x_interface_info of s00_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  attribute x_interface_info of s00_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  attribute x_interface_info of s00_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  attribute x_interface_info of s00_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  attribute x_interface_parameter of s00_axi_awaddr : signal is "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 50000000, ID_WIDTH 0, ADDR_WIDTH 16, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN design_1_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute x_interface_info of s00_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  attribute x_interface_info of s00_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  attribute x_interface_info of s00_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  attribute x_interface_info of s00_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  attribute x_interface_info of s00_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  attribute x_interface_info of s00_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
begin
  \^m00_axi_s2m\(40 downto 0) <= m00_axi_s2m(40 downto 0);
  \^s00_axi_araddr\(15 downto 0) <= s00_axi_araddr(15 downto 0);
  \^s00_axi_arvalid\ <= s00_axi_arvalid;
  \^s00_axi_awaddr\(15 downto 0) <= s00_axi_awaddr(15 downto 0);
  \^s00_axi_awvalid\ <= s00_axi_awvalid;
  \^s00_axi_bready\ <= s00_axi_bready;
  \^s00_axi_rready\ <= s00_axi_rready;
  \^s00_axi_wdata\(31 downto 0) <= s00_axi_wdata(31 downto 0);
  \^s00_axi_wstrb\(3 downto 0) <= s00_axi_wstrb(3 downto 0);
  \^s00_axi_wvalid\ <= s00_axi_wvalid;
  m00_axi_m2s(104) <= \^s00_axi_arvalid\;
  m00_axi_m2s(103) <= \<const0>\;
  m00_axi_m2s(102) <= \<const0>\;
  m00_axi_m2s(101) <= \<const0>\;
  m00_axi_m2s(100) <= \<const0>\;
  m00_axi_m2s(99) <= \<const0>\;
  m00_axi_m2s(98) <= \<const0>\;
  m00_axi_m2s(97) <= \<const0>\;
  m00_axi_m2s(96) <= \<const0>\;
  m00_axi_m2s(95) <= \<const0>\;
  m00_axi_m2s(94) <= \<const0>\;
  m00_axi_m2s(93) <= \<const0>\;
  m00_axi_m2s(92) <= \<const0>\;
  m00_axi_m2s(91) <= \<const0>\;
  m00_axi_m2s(90) <= \<const0>\;
  m00_axi_m2s(89) <= \<const0>\;
  m00_axi_m2s(88) <= \<const0>\;
  m00_axi_m2s(87 downto 72) <= \^s00_axi_araddr\(15 downto 0);
  m00_axi_m2s(71) <= \^s00_axi_awvalid\;
  m00_axi_m2s(70) <= \<const0>\;
  m00_axi_m2s(69) <= \<const0>\;
  m00_axi_m2s(68) <= \<const0>\;
  m00_axi_m2s(67) <= \<const0>\;
  m00_axi_m2s(66) <= \<const0>\;
  m00_axi_m2s(65) <= \<const0>\;
  m00_axi_m2s(64) <= \<const0>\;
  m00_axi_m2s(63) <= \<const0>\;
  m00_axi_m2s(62) <= \<const0>\;
  m00_axi_m2s(61) <= \<const0>\;
  m00_axi_m2s(60) <= \<const0>\;
  m00_axi_m2s(59) <= \<const0>\;
  m00_axi_m2s(58) <= \<const0>\;
  m00_axi_m2s(57) <= \<const0>\;
  m00_axi_m2s(56) <= \<const0>\;
  m00_axi_m2s(55) <= \<const0>\;
  m00_axi_m2s(54 downto 39) <= \^s00_axi_awaddr\(15 downto 0);
  m00_axi_m2s(38) <= \^s00_axi_bready\;
  m00_axi_m2s(37) <= \^s00_axi_rready\;
  m00_axi_m2s(36) <= \^s00_axi_wvalid\;
  m00_axi_m2s(35 downto 32) <= \^s00_axi_wstrb\(3 downto 0);
  m00_axi_m2s(31 downto 0) <= \^s00_axi_wdata\(31 downto 0);
  s00_axi_arready <= \^m00_axi_s2m\(40);
  s00_axi_awready <= \^m00_axi_s2m\(39);
  s00_axi_bresp(1 downto 0) <= \^m00_axi_s2m\(37 downto 36);
  s00_axi_bvalid <= \^m00_axi_s2m\(38);
  s00_axi_rdata(31 downto 0) <= \^m00_axi_s2m\(32 downto 1);
  s00_axi_rresp(1 downto 0) <= \^m00_axi_s2m\(34 downto 33);
  s00_axi_rvalid <= \^m00_axi_s2m\(35);
  s00_axi_wready <= \^m00_axi_s2m\(0);
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
end STRUCTURE;
