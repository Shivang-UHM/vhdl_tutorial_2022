LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

PACKAGE target_c_pack IS

    type trigger_raw is record 
        timestamp : std_logic_vector(31 downto 0) ;
        valid : std_logic;
    end record;

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

    TYPE serial_shift_out_m2s IS RECORD
        HSCLK : STD_LOGIC;
        increment : STD_LOGIC;
        reset : STD_LOGIC;
        --LD_SIN : STD_LOGIC;  -- unused 
        -- LD_DIR : STD_LOGIC;  -- unused 
    END RECORD;

    CONSTANT serial_shift_out_m2s_null : serial_shift_out_m2s := (
        HSCLK => '0',
        increment => '0',
        
        --LD_SIN => '0',
        --LD_DIR => '0'

        reset => '0'
    );

    TYPE serial_shift_out_s2m IS RECORD
        data  : std_logic_vector(31 downto 0) ;
    END RECORD;

    constant serial_shift_out_s2m_null :serial_shift_out_s2m:= (
        data => (others =>'0')
    );

    type sample_select_t is record 
        RDAD_clk : STD_LOGIC;
        RDAD_SIN : STD_LOGIC;
        RDAD_DIR : STD_LOGIC;
        SAMPLESEL_ANY : STD_LOGIC;
    end record;

    constant sample_select_t_null : sample_select_t :=(
        RDAD_clk => '0',
        RDAD_SIN=> '0',
        RDAD_DIR => '0',
        SAMPLESEL_ANY=> '0'
    );


    TYPE sampling_t IS RECORD
        SSTIN : STD_LOGIC;    
        WR_Coloumn_Select : STD_LOGIC_VECTOR(5 DOWNTO 0); 
        WR_Row_Select : STD_LOGIC_VECTOR(1 DOWNTO 0);     
    END RECORD;

    CONSTANT sampling_t_null : sampling_t := (
        SSTIN => '0',
        WR_Coloumn_Select =>  (others =>'0'),
        WR_Row_Select =>  (others =>'0')
    );

    procedure set_output_address(signal  self:  inout sampling_t; data: in unsigned);
    TYPE target_c_inputs_t IS RECORD
        sampling : sampling_t;
        willkinson_ADC : willkinson_ADC_t;
        serial_shift_out : serial_shift_out_m2s;
    END RECORD;
    
    
    constant target_c_inputs_t_null : target_c_inputs_t:= (
        sampling=> sampling_t_null,
        willkinson_ADC => willkinson_ADC_t_null,
        serial_shift_out => serial_shift_out_m2s_null
    );

    type Legacy_serial_m2s is record 
        SIN  :  STD_LOGIC;
        SCLK :  STD_LOGIC;
        PCLK :  STD_LOGIC;
    end record;
    constant Legacy_serial_m2s_null : Legacy_serial_m2s := (
        SIN => '0',
        SCLK => '0',
        PCLK => '0'
    );


    type Legacy_serial_s2m  is record 
        SHOUT:   STD_LOGIC;
    end record;

    constant Legacy_serial_s2m_null : Legacy_serial_s2m := (
        SHOUT=>'0'
    );
END PACKAGE;

package body target_c_pack is 

    procedure set_output_address(signal  self:  inout sampling_t; data: in unsigned)is 
    begin 
        self.WR_Row_Select <= std_logic_vector(data(1 downto 0));
        self.WR_Coloumn_Select <= std_logic_vector(data(5 + self.WR_Row_Select'length downto  0 + self.WR_Row_Select'length) );
    end procedure;
end package body;