LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
PACKAGE i2c_rx_v3_pac IS

  SUBTYPE i2c_data_t IS STD_LOGIC_VECTOR(8 - 1 DOWNTO 0);
  TYPE i2c_data_t_a IS ARRAY (NATURAL RANGE <>) OF i2c_data_t;
  SUBTYPE i2c_addr_t IS STD_LOGIC_VECTOR(8 - 2 DOWNTO 0);
  TYPE i2c_addr_t_a IS ARRAY (NATURAL RANGE <>) OF i2c_addr_t;

  PROCEDURE reset_s(SIGNAL self : OUT i2c_data_t_a);

  PROCEDURE set_addr_data(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : OUT i2c_data_t_a; id : INTEGER; addr : i2c_addr_t; data : i2c_data_t);
  PROCEDURE set_addr_data_loop_back(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : OUT i2c_data_t_a; SIGNAL addr_self_in : OUT i2c_addr_t_a; SIGNAL data_self_in : IN i2c_data_t_a; id : INTEGER; addr : i2c_addr_t);

  PROCEDURE get_addr_data(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : IN i2c_data_t_a; id : INTEGER; addr : i2c_addr_t;SIGNAL data : OUT i2c_data_t);
  PURE FUNCTION to_i2c_addr_t(addr : INTEGER) RETURN i2c_addr_t;
END PACKAGE;

PACKAGE BODY i2c_rx_v3_pac IS

  PROCEDURE reset_s(SIGNAL self : OUT i2c_data_t_a) IS
  BEGIN
    self <= (OTHERS => (OTHERS => '0'));
  END PROCEDURE;

  PROCEDURE set_addr_data(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : OUT i2c_data_t_a; id : INTEGER; addr : i2c_addr_t; data : i2c_data_t) IS
  BEGIN
    IF id > addr_self'length THEN
      RETURN;
    END IF;

    addr_self(id) <= addr;
    data_self(id) <= data;
  END PROCEDURE;

  PROCEDURE set_addr_data_loop_back(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : OUT i2c_data_t_a; SIGNAL addr_self_in : OUT i2c_addr_t_a; SIGNAL data_self_in : IN i2c_data_t_a; id : INTEGER; addr : i2c_addr_t) IS
  BEGIN
    IF id > addr_self'length THEN
      RETURN;
    END IF;
    addr_self_in(id) <= addr;
    addr_self(id) <= addr;
    data_self(id) <= data_self_in(id);
  END PROCEDURE;

  PROCEDURE get_addr_data(SIGNAL addr_self : OUT i2c_addr_t_a; SIGNAL data_self : IN i2c_data_t_a; id : INTEGER; addr : i2c_addr_t;SIGNAL data : OUT i2c_data_t) IS
  BEGIN
    IF id > addr_self'length THEN
      RETURN;
    END IF;

    addr_self(id) <= addr;
    data <= data_self(id);
  END PROCEDURE;

  PURE FUNCTION to_i2c_addr_t(addr : INTEGER) RETURN i2c_addr_t IS
BEGIN
  -- convert integer to std_logic_vector
  RETURN STD_LOGIC_VECTOR(to_unsigned(addr, 7));

END FUNCTION;
END PACKAGE BODY;