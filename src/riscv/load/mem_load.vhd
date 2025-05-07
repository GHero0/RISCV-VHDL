library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_types.all;

entity mem_load is 
    Port ( 
        ADDR_R      : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
        DATA_R      : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        is_byte     : IN  STD_LOGIC;
        is_half     : IN  STD_LOGIC;
        is_sign_ext : IN  STD_LOGIC;
        data_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
end mem_load;


architecture arch of mem_load is
   
   function repeat_bit(B: std_logic; N: natural) return std_logic_vector is
      variable result: std_logic_vector(1 to N);
      begin
         for i in 1 to N loop
            result(i) := B;
         end loop;
      return result;
   end; 
   
   SIGNAL M_LOAD_H    : STD_LOGIC_VECTOR (15 downto 0);
   SIGNAL M_LOAD_B    : STD_LOGIC_VECTOR ( 7 downto 0);
   SIGNAL M_LOAD_sign : STD_LOGIC;

begin

   M_LOAD_H <=    DATA_R(15 downto  0) when (ADDR_R(1) = '0') else
                  DATA_R(31 downto 16) when (ADDR_R(1) = '1') else
                  (others => '0');

                  
   M_LOAD_B <=    DATA_R( 7 downto  0) when (ADDR_R = "00") else
                  DATA_R(15 downto  8) when (ADDR_R = "01") else
                  DATA_R(23 downto 16) when (ADDR_R = "10") else
                  DATA_R(31 downto 24) when (ADDR_R = "11") else
                  (others => '0');
   
   M_LOAD_sign <= M_LOAD_B( 7)   when (is_byte = '1' and is_half = '0' and is_sign_ext = '1') else
                  M_LOAD_H(15)   when (is_byte = '0' and is_half = '1' and is_sign_ext = '1') else
                  '0';

   data_value  <= DATA_R                                    when (is_byte = '0' and is_half = '0') else
                  (repeat_bit('0',24) & M_LOAD_B)           when (is_byte = '1' and is_half = '0' and is_sign_ext = '0') else
                  (repeat_bit('0',16) & M_LOAD_H)           when (is_byte = '0' and is_half = '1' and is_sign_ext = '0') else
                  (repeat_bit(M_LOAD_sign,24) & M_LOAD_B)   when (is_byte = '1' and is_half = '0' and is_sign_ext = '1') else 
                  (repeat_bit(M_LOAD_sign,16) & M_LOAD_H)   when (is_byte = '0' and is_half = '1' and is_sign_ext = '1') else 
                  (others => '0'); 
            
end arch;
