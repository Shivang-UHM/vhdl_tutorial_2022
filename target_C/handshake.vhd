LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;


package handshake is

    type handshake_t is record 
        valid : std_logic;
        response : std_logic;
        response_old : std_logic;
    end record;
    constant handshake_t_null : handshake_t := (
        valid =>'0',
        response =>'0',
        response_old =>'0'
    );

    procedure start_handshake(signal self: inout  handshake_t);
    function  done_start_handshake(self:  handshake_t) return boolean;
    
    procedure receive_handshake(signal self: inout  handshake_t);
    function  done_receive_handshake(self: handshake_t) return boolean;

end package ;

package body handshake is 


    procedure start_handshake(signal self: inout  handshake_t) is 
    begin 
        self.valid <= '1';
        self.response <= 'Z';
        self.response_old <= self.response;
        if self.valid ='1' and self.response_old ='0' and self.response ='0' then 
            self.valid <= '0';
        end if;

    end procedure;
    
    function  done_start_handshake(self:  handshake_t) return boolean is
    begin 
        return self.valid ='1' and self.response_old ='0' and self.response ='0';
    end function;

    procedure receive_handshake(signal self: inout  handshake_t) is 
    begin 
        self.response <= '0';
        if self.valid = '1' then 
            self.response <= '1';
        end if;
        if self.valid = '1' and self.response = '1' then 
            self.response <= '0';
        end if;

        self.valid <= 'Z';
        self.response_old  <='Z';
    end procedure;

    function  done_receive_handshake(self: handshake_t) return boolean is 
    begin 

        return self.valid = '1' and self.response = '1';
    end function;

end  package body ;
