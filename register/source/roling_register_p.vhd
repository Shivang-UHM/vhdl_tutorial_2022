library IEEE;
  use IEEE.std_logic_1164.all;
  use IEEE.numeric_std.all;

package roling_register_p is

  type registerT is record 
    address : std_logic_vector(15 downto 0);
    value   : std_logic_vector(15 downto 0);
    new_value : std_logic;
  end record;

  constant registerT_null : registerT := (
    address => (others => '0'),
    value   => (others => '0'),
    new_value => '0'
  );

  type registerT_a is array (natural range <>) of registerT;

  type reg_addr is record
    header : STD_LOGIC_VECTOR(3 downto 0);
    asic   : STD_LOGIC_VECTOR(3 downto 0);
    channel: STD_LOGIC_VECTOR(4 downto 0);
    Lower_higher: STD_LOGIC;
  end record;
  constant reg_addr_null : reg_addr := (
    header => (others => '0'),
    asic => (others => '0'),
    channel  => (others => '0'),
    Lower_higher => '0'
  );

  constant Register_signle_bit_header : std_logic_vector(31 downto 0) := (others => '1');
  
  -- procedure read_data(self : in registerT; value :out  STD_LOGIC_VECTOR; addr :in integer);

  function registerT_to_slv32(self : registerT) return std_logic_vector;
  function slv32_to_registerT(self : std_logic_vector ) return registerT;
  
  function reg_addr_ctr(header : STD_LOGIC_VECTOR; asic   : STD_LOGIC_VECTOR; channel: STD_LOGIC_VECTOR;  Lower_higher:STD_LOGIC) return reg_addr;
  function reg_addr_to_slv(data_in : reg_addr) return STD_LOGIC_VECTOR;
  function slv_to_reg_addr(dataIn:STD_LOGIC_VECTOR) return reg_addr;
  procedure read_data(self : in registerT;  value :out  STD_LOGIC_VECTOR ; addr :in integer);
  procedure read_data_s(self : in registerT; signal value :out  STD_LOGIC_VECTOR ; addr :in integer);
  procedure read_data_s(self : in registerT; signal value :out  STD_LOGIC ; addr :in integer);

  function is_register( self : in registerT;  addr :in integer) return boolean;


  procedure timeWindow(signal OutData : inout std_logic; timeCounter : STD_LOGIC_VECTOR; StartTime : STD_LOGIC_VECTOR; EndTime : STD_LOGIC_VECTOR);
  procedure timeWindow(signal OutData : inout std_logic_vector; timeCounter : STD_LOGIC_VECTOR; StartTime : STD_LOGIC_VECTOR; EndTime : STD_LOGIC_VECTOR; InData : in std_logic_vector);




  constant gRegisterDelay: integer := 10;
end package;

package body roling_register_p is
  
  function registerT_to_slv32(self : registerT) return std_logic_vector is 
  begin 
    return self.address & self.value;
  end function;


  function slv32_to_registerT(self : std_logic_vector ) return registerT is 
  variable ret :registerT := registerT_null;
  begin 
    ret.address := self(31 downto 16);
    ret.value   := self(15 downto 0);
    return ret;
  end function;


  function reg_addr_ctr(header : STD_LOGIC_VECTOR; asic   : STD_LOGIC_VECTOR; channel: STD_LOGIC_VECTOR; Lower_higher:STD_LOGIC) return reg_addr is 
    variable ret : reg_addr :=reg_addr_null;
  begin 
    ret.header := header(ret.header'range);
    ret.asic := asic(ret.asic'range);
    ret.channel := channel;
    ret.Lower_higher := Lower_higher;
    return ret;
  end function;

function slv_to_reg_addr(dataIn:STD_LOGIC_VECTOR) return reg_addr is
  variable ret : reg_addr :=reg_addr_null;
begin
  ret.header  := dataIn(15                                       downto 12 );
  ret.asic    := dataIn(ret.asic'length + ret.channel'length - 1 downto ret.channel'length );
  ret.channel := dataIn(ret.channel'length - 1                   downto 0 );
  return ret;
end function;
  
function reg_addr_to_slv(data_in : reg_addr) return STD_LOGIC_VECTOR is
    variable ret : STD_LOGIC_VECTOR(15 downto 0)  := (others => '0');
  begin
    
    ret(data_in.channel'length - 1                          downto 0 )                           := data_in.channel;
    ret(data_in.channel'length)                                                                  := data_in.Lower_higher;
    ret(data_in.asic'length - 1  + data_in.channel'length+1 downto data_in.channel'length +1)    := data_in.asic ;
    ret(15                                                  downto 12)                           := data_in.header ;
    return ret;  
  end function;
  
  procedure read_data(self : in registerT;  value :out  STD_LOGIC_VECTOR ; addr :in integer) is 

  variable m1 : integer := 0;
  variable m2 : integer := 0;
  variable m : integer := 0;
begin
  m1 := value'length;
  m2 := self.value'length;

  if (m1 < m2) then 
    m := m1;
  else 
    m := m2;
  end if;

  if to_integer(signed(self.address)) = addr then
    value(m - 1 downto 0) := self.value(  m - 1 downto 0);
  end if; 
  end procedure;

  procedure read_data_s(self : in registerT;signal value :out  std_logic_vector ; addr :in integer) is 
    variable m1 : integer := 0;
    variable m2 : integer := 0;
    variable m : integer := 0;
  begin
    m1 := value'length;
    m2 := self.value'length;

    if (m1 < m2) then 
      m := m1;
    else 
      m := m2;
    end if;

    if to_integer(signed(self.address)) = addr then
      value(m - 1 downto 0) <= self.value(  m - 1 downto 0);
    end if; 
  end procedure;

  function is_register( self : in registerT;  addr :in integer) return boolean is 
  begin 
    return  to_integer(signed(self.address)) = addr;
  end function;

  procedure read_data_s(self : in registerT;signal value :out  std_logic ; addr :in integer) is 
  variable r : std_logic_vector(15 downto 0) := (others => '0');
  
begin
  if to_integer(signed(self.address)) = addr then
    read_data(self, r, addr);
    value <= r(0);
  end if;
end procedure;

  procedure timeWindow(signal OutData : inout std_logic; timeCounter : STD_LOGIC_VECTOR; StartTime : STD_LOGIC_VECTOR; EndTime : STD_LOGIC_VECTOR) is

  begin 
    OutData<='0';
    if StartTime < timeCounter and timeCounter< EndTime then
      OutData <= '1';
    end if;

  end procedure;

  procedure timeWindow(signal OutData : inout std_logic_vector; timeCounter : STD_LOGIC_VECTOR; StartTime : STD_LOGIC_VECTOR; EndTime : STD_LOGIC_VECTOR; InData : in std_logic_vector) is
  begin 
    OutData <= (others => '0');
    if StartTime < timeCounter  and timeCounter < EndTime then
      OutData <= InData;
    end if;
  end procedure;
end package body;