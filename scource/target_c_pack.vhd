LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

PACKAGE target_c_pack IS
    TYPE willkinson_ADC_t IS RECORD
        ramp : STD_LOGIC;
        CLK : STD_LOGIC;
        GCC_reset : STD_LOGIC;
    END RECORD;

    CONSTANT willkinson_ADC_t_null : willkinson_ADC_t := (
        ramp => '0',
        CLK => '0',
        GCC_reset => '0'
    );

    TYPE serial_shift_out_t IS RECORD
        clk : STD_LOGIC;
        increment : STD_LOGIC;
        reset : STD_LOGIC;
        LD_SIN : STD_LOGIC;
        LD_DIR : STD_LOGIC;
    END RECORD;

    CONSTANT serial_shift_out_t_null : serial_shift_out_t := (
        clk => '0',
        increment => '0',
        reset => '0',
        LD_SIN => '0',
        LD_DIR => '0'
    );

    TYPE sampling_t IS RECORD
        RDAD_clk : STD_LOGIC;
        RDAD_SIN : STD_LOGIC;
        RDAD_DIR : STD_LOGIC;
        SSTIN : STD_LOGIC;
        SIN : STD_LOGIC;
        SCLK : STD_LOGIC;
        WR_Coloumn_Select : STD_LOGIC_VECTOR(5 DOWNTO 0);
        WR_Row_Select : STD_LOGIC_VECTOR(1 DOWNTO 0);
    END RECORD;

    CONSTANT sampling_t_null : sampling_t := (
        RDAD_clk => '0',
        RDAD_SIN=> '0',
        RDAD_DIR => '0',
        SSTIN => '0',
        SIN => '0',
        SCLK => '0',
        WR_Coloumn_Select =>  (others =>'0'),
        WR_Row_Select =>  (others =>'0')
    );

    TYPE target_c_inputs_t IS RECORD
        sampling : sampling_t;
        willkinson_ADC : willkinson_ADC_t;
        serial_shift_out : serial_shift_out_t;
    END RECORD;
    
    
    constant target_c_inputs_t_null : target_c_inputs_t:= (
        sampling=> sampling_t_null,
        willkinson_ADC => willkinson_ADC_t_null,
        serial_shift_out => serial_shift_out_t_null
    );


END PACKAGE;