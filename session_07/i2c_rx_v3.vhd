library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use work.i2c_rx_v3_pac.all;


entity i2c_rx_v3 is
  generic (
      nr_of_input_addresses : integer := 1;
      nr_of_output_addresses : integer := 1
  );
  port (
	clk    : in std_logic;
	DReset : in std_logic;
	Sync   : in std_logic;

	scl          : in  std_logic;
	sda          : in  std_logic;
	sda_out      : out std_logic;
	write_enable : out std_logic;  

    i2c_address_in  : in  i2c_addr_t_a(nr_of_input_addresses-1 downto 0);
    i2c_data_in     : in  i2c_data_t_a(nr_of_input_addresses-1 downto 0);

    i2c_address_out  : in  i2c_addr_t_a(nr_of_output_addresses-1 downto 0);
    i2c_data_out     : out i2c_data_t_a(nr_of_output_addresses-1 downto 0);
    i2c_data_out_trig: out std_logic_vector(nr_of_output_addresses-1 downto 0)

    
  );
end entity;

architecture rtl of i2c_rx_v3 is


    type state_t is (
   		READ_ADDR ,
   		SEND_ACK , 
   		READ_DATA ,
   		WRITE_DATA,
   		SEND_ACK2 ,
   		SEND_ACK3 
   );


	
	signal clk1MHz : unsigned(7 downto 0) := (others => '0');
    signal start : std_logic := '0';
    signal prev_sda : std_logic := '0';



	procedure reset_s(signal self : out std_logic_vector) is
	begin
		self <= (others => '0');
	end procedure;

	procedure reset_s(signal self : out std_logic) is
	begin
		self <= '0';
	end procedure;


	type i2c_handler is record
		state : state_t;
		addr : std_logic_vector(7 downto 0);
		regaddr : std_logic_vector(6 downto 0);
		wr  : std_logic;
		data_in : std_logic_vector(7 downto 0);
		data_out : std_logic_vector(7 downto 0);
		counter : natural range 0 to 7;
		addr_seen : std_logic;
		rising_edge_scl : std_logic;
		falling_edge_scl : std_logic;
		sda : std_logic;
		scl : std_logic;
        prev_scl : std_logic;
		sda_out : std_logic;
		write_enable : std_logic;
	end record;

	constant i2c_handler_init : i2c_handler := (
					state => READ_ADDR, 
					addr => (others => '0'), 
					regaddr =>  (others => '0'), 
					wr => '0',
					data_in => (others => '0'), 
					data_out => (others => '0'), 
					counter =>  7,
					addr_seen => '0',
					rising_edge_scl => '0',
					falling_edge_scl => '0',
					sda => '1',
					scl => '1',
                    prev_scl => '1',
					sda_out => '0',
					write_enable => '0'
					
					
				);

	signal i2c_handler_s : i2c_handler := i2c_handler_init;
    procedure push_addr(signal self : inout i2c_handler;  sda : std_logic) is
	begin 
		if self.counter >= 1 then 
			self.regaddr(self.counter-1) <= sda;
		else 
			self.wr <= sda;
		end if;
		self.addr(self.counter) <= sda;
		self.counter <= self.counter - 1;					
	end procedure;

	procedure pull(signal self : inout i2c_handler; sda : in std_logic ; scl : std_logic; start : std_logic ) is
	begin 
		self.addr_seen <= '0';
		self.sda_out<= '1';
		self.write_enable <= '0';
        self.prev_scl <= self.scl;
		self.scl <= scl;
		self.sda <= sda;
		self.rising_edge_scl  <= start and not self.prev_scl and  self.scl;
		self.falling_edge_scl <= self.prev_scl and not self.scl;

		if start = '0' then 
			self <= i2c_handler_init;
		end if;

        if  self.state = READ_DATA then 
		    self.write_enable <= '1';
    		self.sda_out <= self.data_out(self.counter);
	    end if;

	    if self.rising_edge_scl = '1' then 
		    self.sda_out<= '1';
		    self.write_enable <= '0';
	        case(self.state) is
	      	    when READ_ADDR => 
			  	    push_addr(self, sda);
    				if self.counter = 0 then  
    					self.counter <= 7;
    					self.state <= SEND_ACK;
    				end if;
		    when SEND_ACK => 
		 		if self.addr_seen ='1' and self.addr(0) = '1' then 
					self.state <= READ_DATA;
				else  
					self.state <= WRITE_DATA;
				end if;

	      	when WRITE_DATA => 
		 		self.data_in(self.counter) <= sda;
				self.counter <= self.counter - 1;
				
				if self.counter = 0 then  
					self.counter <= 7;
					self.state <= SEND_ACK2;
				end if;
	      
	      	when SEND_ACK2 =>
		 		self.state <= READ_ADDR;					
				self.sda_out<= '0';
				self.write_enable <= '1';

	      	when READ_DATA =>
			  	self.counter <= self.counter - 1;

				if self.counter = 0 then  
					self.counter <= 7;
					self.state <= SEND_ACK3;
				end if;

	      	when SEND_ACK3=> 
		 		self.state <= READ_ADDR;	
				self.sda_out<= '0';
				self.write_enable <= '1';
	    end case;

        end if;


	end procedure;
	procedure push(signal self : inout i2c_handler; signal sda_out : out std_logic ; signal write_enable : out std_logic ) is
	begin 
    if self.falling_edge_scl = '1' then 
		sda_out <= self.sda_out;	
		write_enable <= self.write_enable;
	end if;  --// falling scl case

    end procedure;


	procedure send_data_1(signal self : inout i2c_handler;  addr  : in std_logic_vector ; data_out: in std_logic_vector ) is
	begin 
		if self.state =  SEND_ACK and self.regaddr = addr and self.wr = '1'  then
			self.data_out <= data_out;
			self.addr_seen <= '1';
			self.sda_out<= '0';
			self.write_enable <= '1';
		end if;
	end procedure;


	procedure read_data(signal self : inout i2c_handler;  addr  : in std_logic_vector ;signal data_out: out std_logic_vector ;signal data_out_trig: out std_logic ) is
	begin 
        data_out_trig <= '0';
		if self.regaddr = addr and self.wr = '0'  then
			if self.state =  SEND_ACK then 
				self.addr_seen    <= '1';
				self.sda_out      <= '0';
				self.write_enable <= '1';
			elsif self.state =  SEND_ACK2 then 
				data_out          <= self.data_in;
                data_out_trig     <= '1';
				self.addr_seen    <= '1';
				self.sda_out      <= '0';
				self.write_enable <= '1';
			end if;
		end if;
	end procedure;
begin

   process(clk) is 
   begin 

   if rising_edge(clk) then
        clk1MHz <= clk1MHz + 1;
        prev_sda <= sda;
        if(Sync = '1') then
    	    clk1MHz <=  (others => '0');
    	    start <= '0';
        elsif sda = '0' and start = '0' and  scl = '1'then 
	        start <= '1';	-- Start detect
	    elsif sda = '1' and prev_sda = '0' and  scl = '1'then
            start <= '0'; -- // Stop detect
        end if;
   end if;
   end process;      
   

process(clk1MHz(4)) is
begin 
      
	if rising_edge(clk1MHz(4)) then 
    	pull(i2c_handler_s, sda, scl, start);
		if(DReset = '1')  then 
	    	reset_s(sda_out);
	    	reset_s(write_enable);
        	reset_s(i2c_data_out_trig);
        	reset_s(i2c_data_out);
			i2c_handler_s <= i2c_handler_init;
		end if;
 	
        for i in i2c_address_in'range loop 
      	    send_data_1(i2c_handler_s, i2c_address_in(i), i2c_data_in(i));
    	end loop;
        for i in i2c_address_out'range loop 
    	   read_data(i2c_handler_s, i2c_address_out(i), i2c_data_out(i), i2c_data_out_trig(i));
        end loop;
    	
    	push(i2c_handler_s, sda_out, write_enable);
    end if;
end process;

end architecture;