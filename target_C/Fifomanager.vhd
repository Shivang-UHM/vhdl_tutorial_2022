LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.TARGETC_pkg.ALL;

ENTITY FifoManager IS
	GENERIC (
		C_M_AXIS_TDATA_WIDTH : INTEGER := 32
	);
	PORT (
		CtrlBus_IxSL : IN T_CtrlBus_IxSL; --Outputs from Control Master

		FIFOBusy : OUT STD_LOGIC;

		ClockBus : IN T_ClockBus;

		--Request and Acknowledge - READOUT
		Handshake_IxRECV : IN T_Handshake_IxRECV;
		Handshake_Data : IN T_Handshake_SS_FIFO;
		Handshake_OxRECV : OUT T_Handshake_OxRECV;

		--Header Information from FIFO
		FIFO_ReadEn : OUT STD_LOGIC;
		FIFO_Time : IN STD_LOGIC_VECTOR(63 DOWNTO 0);
		FIFO_WdoAddr : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
		FIFO_TrigInfo : IN STD_LOGIC_VECTOR(11 DOWNTO 0);
		FIFO_Spare : IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		FIFO_Empty : IN STD_LOGIC;

		--Channels
		data_IN : IN slv_12_array(0 TO 31);

		-- DATA TO STREAM
		FIFOvalid : OUT STD_LOGIC;
		FIFOdata : OUT STD_LOGIC_VECTOR(C_M_AXIS_TDATA_WIDTH - 1 DOWNTO 0);
		StreamReady : IN STD_LOGIC
	);
END TwoTARGETCs_FifoManager;

ARCHITECTURE rtl OF TwoTARGETCs_FifoManager IS
	TYPE fifostate_wr IS (
		IDLE,
		READY,
		ACKNOWLEDGE,
		PROC_REQ,
		WRFULL,
		WRxRD,
		WR_TEMPO,
		REQUEST,
		RESP_ACK,
		REQ_GRANT,
		READ_FIFO_INFO,
		WAIT_FIFO_INFO,
		HEADER_FIFO_PREPARE
	);

	SIGNAL fifo_wr_stm : fifostate_wr := IDLE;

	TYPE fifostate_rd IS (
		IDLE,
		READY,
		ACKNOWLEDGE,
		PROC_REQ,
		WRxRD_INIT,
		WRxRD_HEADER,
		WRxRD_DATA,
		STALL_WRxRD_DATA,
		STALL_WRxRD_HEADER,
		VALID,
		RESPVALID
	);
	SIGNAL FIFO_WR : T_Handshake_signal;
	SIGNAL FIFO_RD : T_Handshake_signal;

	SIGNAL cnt_fifo : STD_LOGIC_VECTOR(9 DOWNTO 0) := (OTHERS => '0');

	TYPE T_DataBus12 IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(11 DOWNTO 0);
	TYPE T_DataBus32 IS ARRAY (31 DOWNTO 0) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL wr_data : T_DataBus12;
	SIGNAL rd_data12 : T_DataBus12;
	SIGNAL rd_data32 : T_DataBus32;
	SIGNAL reg_rd_data32 : T_DataBus32;

	SIGNAL wr_en : STD_LOGIC;
	SIGNAL rd_en : STD_LOGIC;
	SIGNAL rd_en_dly : STD_LOGIC;
	SIGNAL rd_en_v : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL full : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL empty : STD_LOGIC_VECTOR(31 DOWNTO 0);

	SIGNAL WDOTime_intl : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL DIGTime_intl : STD_LOGIC_VECTOR(63 DOWNTO 0);
	SIGNAL Trigger_intl : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL WDONBR_intl : STD_LOGIC_VECTOR(8 DOWNTO 0);

	SIGNAL DataOut_stall : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataOut_last : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataOut_intl : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataOut_intlH : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL DataOut_intlD : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL rdy_state : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '1');
	SIGNAL fifo_rd_stm : fifostate_rd := IDLE;

	--Ack Request signals sets
	SIGNAL request_intl : STD_LOGIC;
	SIGNAL Handshake_RECV_intl : T_Handshake_RECV_intl;
	SIGNAL acknowledge_intl : STD_LOGIC;
	SIGNAL busy_intl : STD_LOGIC;
	SIGNAL testfifo_intl : STD_LOGIC;

	SIGNAL BIN_TIME : STD_LOGIC_VECTOR(59 DOWNTO 0);

	ATTRIBUTE keep : STRING;
	ATTRIBUTE DONT_TOUCH : STRING;
	ATTRIBUTE mark_debug : STRING;
	--	attribute mark_debug of cnt_fifo: signal is "true";
	--	attribute mark_debug of DataOut_intl: signal is "true";

	ATTRIBUTE fsm_encoding : STRING;
	ATTRIBUTE fsm_encoding OF fifo_wr_stm : SIGNAL IS "sequential";
	ATTRIBUTE fsm_encoding OF fifo_rd_stm : SIGNAL IS "sequential";

BEGIN

	request_intl <= Handshake_IxRECV.REQ;
	testfifo_intl <= Handshake_Data.TestFifo;
	Handshake_OxRECV.ACK <= FIFO_WR.recv.ACK;
	Handshake_OxRECV.BUSY <= FIFO_WR.recv.Busy;
	Handshake_OxRECV.ACLK <= ClockBus.AXI_CLK;

	--	-- 1 FIFO per channel
	GEN_FIFO : FOR I IN 0 TO 31 GENERATE
		FIFOCH : ENTITY work.module_fifo_regs_no_flags
		GENERIC MAP(
			g_WIDTH => 12,
			g_DEPTH => 32
		)
		PORT MAP(
			i_rst_sync => CtrlBus_IxSL.SW_nRST,
			i_clk => ClockBus.AXI_CLK,

			-- FIFO Write Interface
			i_wr_en => wr_en,
			i_wr_data => wr_data(I),
			o_full => full(I),

			-- FIFO Read Interface
			i_rd_en => rd_en_v(I),
			o_rd_data => rd_data12(I),
			o_empty => empty(I)

		);
		reg_rd_data32(I) <= x"00000" & rd_data12(I);
	END GENERATE GEN_FIFO;

	rd_data32 <= reg_rd_data32;

	TIME_GRAYDECODE : ENTITY work.GRAY_DECODER
		GENERIC MAP(
			NBITS => 60
		)
		PORT MAP(
			GRAY_IN => FIFO_Time(63 DOWNTO 4),
			BIN_OUT => BIN_TIME
		);
		
	FIFO_Address : ENTITY work.TwoTARGETCs_AddressDecoder
		PORT MAP(
			address => cnt_fifo(9 DOWNTO 5),
			rd_en => rd_en,
			--rd_en => rd_en_dly,
			decode => rd_en_v
		);

	DataDecoderFIFO : ENTITY work.TwoTC_DataDecoder
		PORT MAP(
			address => cnt_fifo(9 DOWNTO 5),
			dataOut => DataOut_intlD,

			dataIN_0 => rd_data32(0),
			dataIN_1 => rd_data32(1),
			dataIN_2 => rd_data32(2),
			dataIN_3 => rd_data32(3),

			dataIN_4 => rd_data32(4),
			dataIN_5 => rd_data32(5),
			dataIN_6 => rd_data32(6),
			dataIN_7 => rd_data32(7),

			dataIN_8 => rd_data32(8),
			dataIN_9 => rd_data32(9),
			dataIN_10 => rd_data32(10),
			dataIN_11 => rd_data32(11),

			dataIN_12 => rd_data32(12),
			dataIN_13 => rd_data32(13),
			dataIN_14 => rd_data32(14),
			dataIN_15 => rd_data32(15),

			dataIN_16 => rd_data32(16),
			dataIN_17 => rd_data32(17),
			dataIN_18 => rd_data32(18),
			dataIN_19 => rd_data32(19),

			dataIN_20 => rd_data32(20),
			dataIN_21 => rd_data32(21),
			dataIN_22 => rd_data32(22),
			dataIN_23 => rd_data32(23),

			dataIN_24 => rd_data32(24),
			dataIN_25 => rd_data32(25),
			dataIN_26 => rd_data32(26),
			dataIN_27 => rd_data32(27),

			dataIN_28 => rd_data32(28),
			dataIN_29 => rd_data32(29),
			dataIN_30 => rd_data32(30),
			dataIN_31 => rd_data32(31)
		);

	HeaderRead : PROCESS (ClockBus.AXI_CLK, CtrlBus_IxSL.SW_nRST)
	BEGIN
		IF (CtrlBus_IxSL.SW_nRST = '0') THEN
			FIFO_ReadEn <= '0';
		ELSE
			IF (falling_edge (ClockBus.AXI_CLK)) THEN
				CASE (fifo_wr_stm) IS
					WHEN IDLE =>
						FIFO_ReadEn <= '0';
					WHEN READ_FIFO_INFO =>
						FIFO_ReadEn <= '1';
					WHEN WAIT_FIFO_INFO =>
						FIFO_ReadEn <= '0';
					WHEN OTHERS =>
						FIFO_ReadEn <= '0';
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	-- FIFO WRITE PROCESS
	fifoWR : PROCESS (ClockBus.AXI_CLK, CtrlBus_IxSL.SW_nRST)
	BEGIN
		IF (CtrlBus_IxSL.SW_nRST = '0') THEN
			fifo_wr_stm <= IDLE;
			FIFO_WR.recv.busy <= '0';
			FIFO_WR.recv.ack <= '0';
			FIFO_WR.send.req <= '0';
		ELSE
			IF (rising_edge (ClockBus.AXI_CLK)) THEN
				CASE (fifo_wr_stm) IS
					WHEN IDLE =>
						wr_en <= '0';

						FIFO_WR.recv.ack <= '0';
						FIFO_WR.recv.busy <= '0';

						IF (FIFO_RD.recv.busy = '1') THEN
							fifo_wr_stm <= IDLE;
						ELSE
							fifo_wr_stm <= READY;
						END IF;

					WHEN READY =>
						IF (request_intl = '1') THEN
							FIFO_WR.recv.ack <= '1';
							FIFO_WR.recv.busy <= '1';

							fifo_wr_stm <= ACKNOWLEDGE;

							wr_data(0) <= CH0;
							wr_data(1) <= CH1;
							wr_data(2) <= CH2;
							wr_data(3) <= CH3;

							wr_data(4) <= CH4;
							wr_data(5) <= CH5;
							wr_data(6) <= CH6;
							wr_data(7) <= CH7;

							wr_data(8) <= CH8;
							wr_data(9) <= CH9;
							wr_data(10) <= CH10;
							wr_data(11) <= CH11;

							wr_data(12) <= CH12;
							wr_data(13) <= CH13;
							wr_data(14) <= CH14;
							wr_data(15) <= CH15;
							wr_data(16) <= CH16;
							wr_data(17) <= CH17;
							wr_data(18) <= CH18;
							wr_data(19) <= CH19;

							wr_data(20) <= CH20;
							wr_data(21) <= CH21;
							wr_data(22) <= CH22;
							wr_data(23) <= CH23;

							wr_data(24) <= CH24;
							wr_data(25) <= CH25;
							wr_data(26) <= CH26;
							wr_data(27) <= CH27;

							wr_data(28) <= CH28;
							wr_data(29) <= CH29;
							wr_data(30) <= CH30;
							wr_data(31) <= CH31;
						ELSE

							FIFO_WR.recv.ack <= '0';
							FIFO_WR.recv.busy <= '0';
							fifo_wr_stm <= READY;
						END IF;
						--when RESPREADY =>
					WHEN ACKNOWLEDGE =>
						FIFO_WR.recv.busy <= '1';

						IF (request_intl = '0') THEN
							FIFO_WR.recv.ack <= '0';

							fifo_wr_stm <= WRxRD;
						ELSE
							fifo_wr_stm <= ACKNOWLEDGE;
							FIFO_WR.recv.ack <= '1';
							--Handshake_RECV_intl.ACK <= '1';
						END IF;
					
					WHEN WRxRD =>
						wr_en <= '1';
						fifo_wr_stm <= WR_TEMPO;

					WHEN WR_TEMPO =>
						wr_en <= '0';
						fifo_wr_stm <= REQUEST;

					WHEN REQUEST =>

						IF (full = x"FFFFFFFF") THEN
							FIFO_WR.send.REQ <= '1'; -- The FiFOS are Full of data, all samples got
					
							IF testfifo_intl = '0' THEN
								fifo_wr_stm <= READ_FIFO_INFO;
							ELSE
								fifo_wr_stm <= RESP_ACK;
								WDOTime_intl <= x"00000000" & x"FFFFFFFF";
								DIGTime_intl <= x"FFFFFFFF" & x"00000000";
								Trigger_intl <= x"12345678";
								WDONbr_intl <= "110110110";
							END IF;
						ELSE
							FIFO_WR.send.REQ <= '0'; -- The FiFOS are Full of data, all samples got
							fifo_wr_stm <= IDLE;
						END IF;
					WHEN READ_FIFO_INFO =>
						fifo_wr_stm <= WAIT_FIFO_INFO;

					WHEN WAIT_FIFO_INFO =>
						fifo_wr_stm <= HEADER_FIFO_PREPARE;

					WHEN HEADER_FIFO_PREPARE =>
						--WDOTime_intl	<= FIFO_Time;
						WDOTime_intl <= BIN_Time & FIFO_Time(3 DOWNTO 0);
						DIGTime_intl <= x"00000000" & x"00000" & "0" & FIFO_Spare;
						Trigger_intl <= x"00000" & FIFO_TrigInfo;
						WDONBR_intl <= FIFO_WdoAddr;
						fifo_wr_stm <= RESP_ACK;

					WHEN RESP_ACK =>
						IF (FIFO_RD.recv.ACK = '1') THEN
							FIFO_WR.send.REQ <= '0';
							fifo_wr_stm <= REQ_GRANT;
						ELSE
							FIFO_WR.send.REQ <= '1';
							fifo_wr_stm <= RESP_ACK;
						END IF;

					WHEN REQ_GRANT =>
						FIFO_WR.send.REQ <= '0';
						IF (FIFO_RD.recv.ACK = '0') THEN
							fifo_wr_stm <= IDLE;
						ELSE
							fifo_wr_stm <= REQ_GRANT;
						END IF;
					WHEN OTHERS =>
						fifo_wr_stm <= IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	-- FIFO READ PROCESS
	fifoRD : PROCESS (ClockBus.AXI_CLK, CtrlBus_IxSL.SW_nRST)
	BEGIN
		IF (CtrlBus_IxSL.SW_nRST = '0') THEN
			rd_en <= '0';

			FIFO_RD.recv.ack <= '0';
			FIFO_RD.recv.busy <= '0';
			FIFO_RD.send.req <= '0';

			dataout_stall <= (OTHERS => '0');
			dataout_last <= (OTHERS => '0');
			DataOut_intlH <= (OTHERS => '0');

			FIFOvalid <= '0';
		ELSE
			IF (rising_edge (ClockBus.AXI_CLK)) THEN
				CASE (fifo_rd_stm) IS
					WHEN IDLE =>
						rd_en <= '0';
						FIFO_RD.recv.busy <= '0';
						FIFO_RD.recv.ack <= '0';

						fifo_rd_stm <= READY;
					WHEN READY =>
						IF (FIFO_WR.send.REQ = '1') THEN
							fifo_rd_stm <= ACKNOWLEDGE;
						ELSE
							fifo_rd_stm <= READY;
						END IF;
					WHEN ACKNOWLEDGE =>

						FIFO_RD.recv.busy <= '1';
						IF (FIFO_WR.send.req = '0') THEN
							FIFO_RD.recv.ack <= '0';
							fifo_rd_stm <= PROC_REQ;

						ELSE
							FIFO_RD.recv.ack <= '1';
							fifo_rd_stm <= ACKNOWLEDGE;
						END IF;
					WHEN PROC_REQ =>
						fifo_rd_stm <= WRxRD_INIT;
					WHEN WRxRD_INIT =>
						FIFO_RD.recv.ack <= '0';
						cnt_fifo <= (OTHERS => '0');
						--if(StreamReady = '1' and TestStream = '1') then
						IF (StreamReady = '1' AND CtrlBus_IxSL.PSBUSY = '0') THEN
							--FIFOvalid <= '1';
							fifo_rd_stm <= WRxRD_HEADER;
							DataOut_intlH <= WDOTime_intl(31 DOWNTO 0);
							FIFOvalid <= '1';
							cnt_fifo <= "0000000001";
						ELSE
							FIFOvalid <= '0';
							rd_en <= '0';
							fifo_rd_stm <= WRxRD_INIT;

						END IF;
					WHEN WRxRD_HEADER =>
						IF (StreamReady = '1') THEN
							FIFOvalid <= '1';

							cnt_fifo <= STD_LOGIC_VECTOR(unsigned(cnt_fifo) + 1);

							CASE cnt_fifo IS
								WHEN "0000000000" =>
									DataOut_intlH <= WDOTime_intl(31 DOWNTO 0);
									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN "0000000001" =>
									DataOut_intlH <= WDOTime_intl(63 DOWNTO 32);

									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN "0000000010" =>
									DataOut_intlH <= DIGTime_intl(31 DOWNTO 0);

									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN "0000000011" =>
									DataOut_intlH <= DIGTime_intl(63 DOWNTO 32);

									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN "0000000100" =>
									DataOut_intlH <= Trigger_intl;

									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN "0000000101" =>
									DataOut_intlH <= x"0000" & "0000000" & WDONBR_intl;
									FIFOvalid <= '1';
									fifo_rd_stm <= WRxRD_HEADER;
								WHEN OTHERS =>
									cnt_fifo <= (OTHERS => '0');
									fifo_rd_stm <= WRxRD_DATA;
									rd_en <= '1';
									FIFOvalid <= '1';
							END CASE;
						ELSE
							rd_en <= '0';
							-- last_fifo_rd_stm <= WRxRD_HEADER;
							dataout_last <= dataout_intlH;
							fifo_rd_stm <= STALL_WRxRD_HEADER;
						END IF;
					WHEN WRxRD_DATA =>
						IF (StreamReady = '1') THEN
							IF (to_integer(unsigned(cnt_fifo)) < 1023) THEN
								cnt_fifo <= STD_LOGIC_VECTOR(unsigned(cnt_fifo) + 1);
								rd_en <= '1';
								FIFOvalid <= '1';
								fifo_rd_stm <= WRxRD_DATA;
							ELSE
								--ENd Transmission
								cnt_fifo <= (OTHERS => '0');
								fifo_rd_stm <= VALID;
								rd_en <= '0';
								FIFOvalid <= '1';
							END IF;
						ELSE
							rd_en <= '0';
							--		last_fifo_rd_stm <= WRxRD_DATA;
							dataout_last <= dataout_intlD;
							fifo_rd_stm <= STALL_WRxRD_DATA;
						END IF;

						-- New State when the AXI is not ready data output should be stalled
					WHEN STALL_WRxRD_HEADER =>
						dataout_stall <= dataout_intlD;
						IF (StreamReady = '1') THEN
							fifo_rd_stm <= WRxRD_HEADER;
							cnt_fifo <= STD_LOGIC_VECTOR(unsigned(cnt_fifo) + 1);
							rd_en <= '1';
						ELSE
							fifo_rd_stm <= STALL_WRxRD_HEADER;
							rd_en <= '0';
						END IF;
						-- New State when the AXI is not ready data output should be stalled
					WHEN STALL_WRxRD_DATA =>
						dataout_stall <= dataout_intlD;
						IF (StreamReady = '1') THEN
							fifo_rd_stm <= WRxRD_DATA;
							cnt_fifo <= STD_LOGIC_VECTOR(unsigned(cnt_fifo) + 1);
							rd_en <= '1';
						ELSE
							fifo_rd_stm <= STALL_WRxRD_DATA;
							rd_en <= '0';
						END IF;
					WHEN VALID =>
						rd_en <= '0';
						FIFOvalid <= '0';
						IF CtrlBus_IxSL.PSBusy = '0' THEN
							fifo_rd_stm <= VALID;
						ELSE
							fifo_rd_stm <= IDLE;
						END IF;
					WHEN RESPVALID =>
						--				when others =>
						--					fifo_rd_stm <= IDLE;
				END CASE;
			END IF;
		END IF;
	END PROCESS;

	--CtrlBus_OxSL.FIFOBusy <= fifo_rd.recv.busy;
	FIFOBusy <= fifo_rd.recv.busy;

	dataout_intl <= DataOut_intlH WHEN fifo_rd_stm = WRxRD_HEADER ELSE
		DataOut_intlD WHEN fifo_rd_stm = WRxRD_DATA ELSE
		(OTHERS => '0');
	-- DATAOUT
	PROCESS (ClockBus.AXI_CLK)
	BEGIN
		IF rising_edge(ClockBus.AXI_CLK) THEN
			rdy_state <= rdy_state(0) & StreamReady;
			CASE rdy_state IS
				WHEN "00" =>
					FIFOData <= dataout_last;
				WHEN "01" =>
					FIFOData <= dataout_stall;
				WHEN "11" =>
					FIFOData <= dataout_intl;
				WHEN "10" =>
					FIFOData <= dataout_last;
				WHEN OTHERS =>
					FIFOData <= (OTHERS => '0');
			END CASE;
		END IF;
	END PROCESS;
END rtl;