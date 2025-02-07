---------------------------------------------------  Entity project_reti_logiche -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity project_reti_logiche is
    
    port(
        i_clk      : in std_logic;
        i_rst      : in std_logic;
        i_start    : in std_logic;
        i_add      : in std_logic_vector(15 downto 0);
        i_k        : in std_logic_vector(9 downto 0);
        
        o_done     : out std_logic;
        
        o_mem_addr : out std_logic_vector(15 downto 0);
        i_mem_data : in std_logic_vector(7 downto 0);
        o_mem_data : out std_logic_vector(7 downto 0);
        o_mem_we   : out std_logic;
        o_mem_en   : out std_logic
       
    );
    
end project_reti_logiche;
---------------------------------------------------  End Entity project_reti_logiche -------------------------------------------


---------------------------------------------------  Enitity ALU -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    
    generic(
        N : integer
    );
    port(
        first_operand        : in std_logic_vector(N - 1 downto 0);
        second_operand       : in std_logic_vector(N - 1 downto 0);
        operation            : in std_logic;
        
        result               : out std_logic_vector(N - 1 downto 0)
    );
        
end ALU;
---------------------------------------------------  End Entity ALU -------------------------------------------


---------------------------------------------------  Entity shifter -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity shifter is
    generic(
        N : integer
    );
    port(
        value_in             : in std_logic_vector(N - 1 downto 0);
        
        value_out            : out std_logic_vector(N downto 0)
    );
    
end shifter;
---------------------------------------------------  End Entity shifter -------------------------------------------


---------------------------------------------------  Entity comparator -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
    
    generic(
        N : integer
    );
    port(
        first_operand  : in std_logic_vector(N - 1 downto 0);
        second_operand : in std_logic_vector(N - 1 downto 0);
        
        result         : out std_logic
    );
    
end comparator;
---------------------------------------------------  End Entity comparator -------------------------------------------


---------------------------------------------------  Entity memory_register -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity memory_register is
    
    generic(
        N : integer
    );
    port(
        clock          : in std_logic;
        enable         : in std_logic;
        reset          : in std_logic;
        value_in       : std_logic_vector(N - 1 downto 0);
        
        value_out      : out std_logic_vector(N - 1 downto 0)
    );
    
end memory_register;
--------------------------------------------------  End Entity memory_register -------------------------------------------


--------------------------------------------------  Entity multiplexer -------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplexer is

    generic(
        N : integer
    );
    port(
        control   : in std_logic;
        value_0   : in std_logic_vector(N - 1 downto 0);
        value_1   : in std_logic_vector(N - 1 downto 0);
        
        value_out : out std_logic_vector(N - 1 downto 0)
    );
    
end multiplexer;
--------------------------------------------------  End Entity multiplexer -------------------------------------------


---------------------------------------------------  Architecture ALU -------------------------------------------
architecture ALU_architecture of ALU is
    
    begin        
        process(operation, first_operand, second_operand)          
            begin
                case operation is
                    when '0' =>
                        result <= std_logic_vector(unsigned(first_operand) + unsigned(second_operand));
                    when '1' =>
                        result <= (others => '0');                        
                        if first_operand >= second_operand then
                            result <= std_logic_vector(unsigned(first_operand) - unsigned(second_operand));
                        end if;
                    when others => result <= (others => 'Z');
                end case;
        end process;
        
end ALU_architecture;
---------------------------------------------------  End Architecture ALU -------------------------------------------


--------------------------------------------------- Architecture shifter -------------------------------------------
architecture shifter_architecture of shifter is

    begin
        process(value_in)
            begin
                value_out <= value_in & '0';
        end process;

end shifter_architecture;
---------------------------------------------------  End Architecture shifter -------------------------------------------


---------------------------------------------------  Architecture comparator -------------------------------------------
architecture comparator_architecture of comparator is

    begin
        result <= '1' when first_operand = second_operand else '0';    

end comparator_architecture;
---------------------------------------------------  End Architecture comparator -------------------------------------------


--------------------------------------------------  Architecture memory_register -------------------------------------------
architecture memory_register_architecture of memory_register is

    signal stored_value : std_logic_vector(N - 1 downto 0);

    begin        
        value_out <= stored_value;
        
        process(clock, enable, reset, value_in)
            begin
                if reset = '1' then
                    stored_value <= (others => '0');
                else
                    if rising_edge(clock) and enable = '1' then
                        stored_value <= value_in;
                    end if;
                end if;
        end process;        
        
end memory_register_architecture;
--------------------------------------------------  End Architecture memory_register -------------------------------------------


--------------------------------------------------  Architecture multiplexer -------------------------------------------
architecture multiplexer_architecture of multiplexer is

    begin
    
        process(control, value_0, value_1)
            begin
                case control is
                    when '0' => 
                        value_out <= value_0;
                    when '1' =>
                        value_out <= value_1;
                    when others =>
                        value_out <= (others => 'Z');
                    end case;
        end process;  

end multiplexer_architecture;
--------------------------------------------------  End Architecture multiplexer -------------------------------------------


---------------------------------------------------  Architecture project_reti_logiche ------------------------------------------
architecture project_reti_logiche_architecture of project_reti_logiche is

    type state_type is (IDLE, CHECK_K_ZERO_AND_STORE_I_ADD, CHECK_FINISH, NEXT_ADDRESS_WORD, ASK_MEMORY, CHECK_WORD, WORD_IS_NOT_ZERO, NEXT_ADDRESS_CREDIBILITY, WRITE_CREDIBILITY, READ_ZERO, FIRST_ELEMENT_NOT_ZERO, FIRST_ELEMENT_IS_ZERO, DONE);
    
    signal current_state, next_state : state_type;

    signal enable_data_register, enable_address_register, enable_credibility_register : std_logic;
    
    signal reset_data_register, reset_credibility_register_to_0: std_logic;
    
    signal signal_control_multiplexer_1, signal_control_multiplexer_2, signal_control_multiplexer_3, signal_control_multiplexer_4, signal_control_multiplexer_5, signal_control_multiplexer_6 : std_logic;
    
    signal signal_out_address_comparator, signal_out_data_comparator : std_logic;
    
    signal signal_k_after_alu : std_logic_vector(9 downto 0);
    
    signal value_out_data_register, value_out_credibility_register, signal_credibility_to_insert, signal_next_credibility : std_logic_vector(7 downto 0);
    
    signal signal_base_address, signal_k, shifted_k_16_bit, signal_last_valid_address, signal_current_address, signal_address_to_compare, signal_next_address, signal_address_to_insert, signal_out_multiplexer_5, signal_out_multiplexer_6 : std_logic_vector(15 downto 0); 
    
    signal shifted_k_11_bit : std_logic_vector(10 downto 0);

    component ALU        
        generic(
            N : integer
        );
        port(
            first_operand        : in std_logic_vector(N - 1 downto 0);
            second_operand       : in std_logic_vector(N - 1 downto 0);
            operation            : in std_logic;            
            result               : out std_logic_vector(N - 1 downto 0)
        );
    end component;
    
    component shifter
        generic(
            N : integer
        );
        port(
            value_in  : in std_logic_vector(N - 1 downto 0);
            value_out : out std_logic_vector(N downto 0)
        );
    end component;
    
    component comparator        
        generic(
            N : integer
        );
        port(
            first_operand  : in std_logic_vector(N - 1 downto 0);
            second_operand : in std_logic_vector(N - 1 downto 0);            
            result         : out std_logic
        );        
    end component;
    
    component memory_register        
        generic(
            N : integer
        );
        port(
            clock : in std_logic;
            enable : in std_logic;
            reset  : in std_logic;
            value_in : std_logic_vector(N - 1 downto 0);            
            value_out : out std_logic_vector(N - 1 downto 0)
        );        
    end component;
    
    component multiplexer        
    generic(
        N : integer
    );
    port(
        control   : in std_logic;
        value_0   : in std_logic_vector(N - 1 downto 0);
        value_1   : in std_logic_vector(N - 1 downto 0);            
        value_out : out std_logic_vector(N - 1 downto 0)
    );        
    end component;

begin  

    c_shifter : shifter
    generic map(
        N => 10
    )
    port map(
        value_in => signal_k_after_alu,
        value_out => shifted_k_11_bit
    );
    
    c_alu_k : ALU
    generic map(
        N => 10
    )
    port map(
        first_operand => i_k,
        second_operand => "0000000001",
        operation => '1',
        result => signal_k_after_alu
    );
    
    c_alu_base_address : ALU
    generic map(
        N => 16
    )
    port map(
        first_operand => i_add,
        second_operand => "0000000000000001",
        operation => '0',
        result => signal_base_address
    );
    
    c_alu_last_address : ALU
    generic map(
        N => 16
    )
    port map(
        first_operand => signal_base_address,
        second_operand => shifted_k_16_bit,
        operation => '0',
        result => signal_last_valid_address
    );
    
    c_alu_current_address : ALU
    generic map(
        N => 16
    )
    port map(
        first_operand => signal_current_address,
        second_operand => "0000000000000001",
        operation => '0',
        result => signal_next_address
    );
        
    c_alu_subtractor_credibility : ALU
    generic map(
        N => 8
    )
    port map(
        first_operand => value_out_credibility_register,
        second_operand => "00000001",
        operation => '1',
        result => signal_next_credibility
    );    
    
    c_address_comparator : comparator
    generic map(
        N => 16
    )
    port map(
        first_operand => signal_address_to_compare,
        second_operand => signal_out_multiplexer_6,
        result => signal_out_address_comparator
    );
    
    c_data_comparator : comparator
    generic map(
        N => 8
    )
    port map(
        first_operand => i_mem_data,
        second_operand => "00000000",
        result => signal_out_data_comparator
    );
    
    c_address_register : memory_register
    generic map(
        N => 16
    )
    port map(
        clock => i_clk,
        enable => enable_address_register,
        reset => '0',
        value_in => signal_address_to_insert,
        value_out => signal_current_address
    );
    
    c_data_register : memory_register
    generic map(
        N => 8
    )
    port map(
        clock => i_clk,
        enable => enable_data_register,
        reset => reset_data_register,
        value_in => i_mem_data,
        value_out => value_out_data_register
    );
    
    c_credibility_register : memory_register
    generic map(
        N => 8
     )
    port map(
        clock => i_clk,
        enable => enable_credibility_register,
        reset => reset_credibility_register_to_0,
        value_in => signal_credibility_to_insert,
        value_out => value_out_credibility_register
    );
    
    c_multiplexer_1 : multiplexer
    generic map(
       N => 8
    )
    port map(
        control => signal_control_multiplexer_1,
        value_0 => value_out_credibility_register,
        value_1 => value_out_data_register,
        value_out => o_mem_data
    );
        
    c_multiplexer_2 : multiplexer
    generic map(
        N => 16
    )
    port map(
        control => signal_control_multiplexer_2,
        value_0 => i_add,
        value_1 => signal_out_multiplexer_5,
        value_out => signal_address_to_compare
    );  
    
    c_multiplexer_3 : multiplexer
    generic map(
         N => 16
    )
    port map(
        control => signal_control_multiplexer_3,
        value_0 => i_add,
        value_1 => signal_next_address,
        value_out => signal_address_to_insert
    );   
                
    c_multiplexer_4 : multiplexer
    generic map(
        N => 8
    )
    port map(
        control => signal_control_multiplexer_4,
        value_0 => "00011111",
        value_1 => signal_next_credibility,
        value_out => signal_credibility_to_insert
    );
    
    c_multiplexer_5 : multiplexer
    generic map(
        N => 16
    )
    port map(
        control => signal_control_multiplexer_5,
        value_0 => signal_last_valid_address,
        value_1 => signal_k,
        value_out => signal_out_multiplexer_5
    );
        
    c_multiplexer_6 : multiplexer
    generic map(
        N => 16
    )
    port map(
        control => signal_control_multiplexer_6,
        value_0 => "0000000000000000",
        value_1 => signal_current_address,
        value_out => signal_out_multiplexer_6
    );
    
    shifted_k_16_bit <= "00000" & shifted_k_11_bit;
    
    signal_k  <= "000000" & i_k;
    
    o_mem_addr <= signal_current_address;
    
    delta : process(current_state) 
        begin        
            enable_data_register <= '0';
            enable_address_register <= '0';
            enable_credibility_register <= '0';
            reset_data_register <= '0';
            reset_credibility_register_to_0 <= '0';
            signal_control_multiplexer_1 <= '-';
            signal_control_multiplexer_2 <= '-';
            signal_control_multiplexer_3 <= '-';
            signal_control_multiplexer_4 <= '-';
            signal_control_multiplexer_5 <= '-';
            signal_control_multiplexer_6 <= '-';
            
            o_mem_en <= '0';
            o_mem_we <= '0';                    
            o_done <= '0';
            
            case current_state is
                when IDLE =>
                    reset_data_register <= '1';
                    enable_credibility_register <= '1';
                    signal_control_multiplexer_4 <= '0';
                    
                when CHECK_K_ZERO_AND_STORE_I_ADD =>
                    signal_control_multiplexer_3 <= '0';
                    signal_control_multiplexer_5 <= '1';
                    signal_control_multiplexer_2 <= '1';
                    signal_control_multiplexer_6 <= '0';
                    enable_address_register <= '1';                    
               
                when CHECK_FINISH =>
                    signal_control_multiplexer_2 <= '1';
                    signal_control_multiplexer_5 <= '0';
                    signal_control_multiplexer_6 <= '1';
                    
                when NEXT_ADDRESS_WORD =>
                    enable_address_register <= '1';
                    signal_control_multiplexer_3 <= '1';
                    
                when ASK_MEMORY => 
                    o_mem_en <= '1';
                                        
                when CHECK_WORD => 
                    o_mem_en <= '1';
                    
                when WORD_IS_NOT_ZERO => 
                    enable_data_register <= '1';
                    enable_credibility_register <= '1';
                    signal_control_multiplexer_4 <= '0';
                    
                    o_mem_en <= '1';
                    
                when NEXT_ADDRESS_CREDIBILITY => 
                    enable_address_register <= '1';
                    signal_control_multiplexer_3 <= '1';
                                    
                when WRITE_CREDIBILITY =>
                    signal_control_multiplexer_1 <= '0';
                    
                    o_mem_en <= '1';
                    o_mem_we <= '1';                   
                    
                when READ_ZERO => 
                    signal_control_multiplexer_2 <= '0';
                    signal_control_multiplexer_6 <= '1';
                    
                when FIRST_ELEMENT_NOT_ZERO => 
                    signal_control_multiplexer_1 <= '1'; 
                    enable_credibility_register <= '1';
                    signal_control_multiplexer_4 <= '1';                   
                    
                    o_mem_en <= '1';
                    o_mem_we <= '1';
                                        
                when FIRST_ELEMENT_IS_ZERO => 
                    reset_data_register <= '1';
                    reset_credibility_register_to_0 <= '1';                                  
                    
                when DONE =>
                    o_done <= '1';               
                end case;
                
    end process;
    
    lambda : process(current_state, signal_out_address_comparator, signal_out_data_comparator, i_start)
        begin
            case current_state is
                        
                when IDLE =>
                    if i_start = '1' then
                        next_state <= CHECK_K_ZERO_AND_STORE_I_ADD;
                    else
                        next_state <= IDLE;
                    end if;
                
                when CHECK_K_ZERO_AND_STORE_I_ADD =>
                    if signal_out_address_comparator = '0' then
                        next_state <= ASK_MEMORY;
                    else
                        next_state <= DONE;
                    end if;
                    
                when CHECK_FINISH =>
                    if signal_out_address_comparator = '0' then
                        next_state <= NEXT_ADDRESS_WORD;
                    else
                        next_state <= DONE;
                    end if;
                 
                when NEXT_ADDRESS_WORD => 
                    next_state <= ASK_MEMORY;
                    
                when ASK_MEMORY =>
                    next_state <= CHECK_WORD;
                    
                when CHECK_WORD =>
                    if signal_out_data_comparator = '1' then 
                        next_state <= READ_ZERO;
                    else
                        next_state <= WORD_IS_NOT_ZERO;
                    end if;
               
                when WORD_IS_NOT_ZERO =>
                    next_state <= NEXT_ADDRESS_CREDIBILITY;
                    
                when NEXT_ADDRESS_CREDIBILITY =>
                    next_state <= WRITE_CREDIBILITY;
                    
                when WRITE_CREDIBILITY =>
                    next_state <= CHECK_FINISH;
                    
                when READ_ZERO =>
                    if signal_out_address_comparator = '1' then
                        next_state <= FIRST_ELEMENT_IS_ZERO;
                    else
                        next_state <= FIRST_ELEMENT_NOT_ZERO;
                    end if;
                    
                when FIRST_ELEMENT_NOT_ZERO =>
                    next_state <= NEXT_ADDRESS_CREDIBILITY;
                    
                when FIRST_ELEMENT_IS_ZERO => 
                    next_state <= NEXT_ADDRESS_CREDIBILITY;
                    
               when DONE =>
                    next_state <= DONE;
                    if i_start = '0' then
                        next_state <= IDLE;
                    end if;
            end case;
            
      end process;                         
      
    state_reg : process(i_clk, i_rst)
        begin
            
            if i_rst = '1' then
                current_state <= IDLE;
            else
                if rising_edge(i_clk) then
                    current_state <= next_state;
                end if;
           end if;         
    end process;
    
end project_reti_logiche_architecture;
---------------------------------------------------  End Architecture project_reti_logiche -------------------------------------------