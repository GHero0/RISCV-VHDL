library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

entity mem_store is 
    Port ( 
        ADDR_W     : IN  STD_LOGIC_VECTOR( 1 DOWNTO 0);
        DATA_W     : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
        is_byte    : IN  STD_LOGIC;
        is_half    : IN  STD_LOGIC;
        data_mask  : OUT STD_LOGIC_VECTOR( 3 DOWNTO 0);
        data_value : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
     );
end mem_store;


architecture arch of mem_store is

   function repeat_bit(B: std_logic; N: natural) return std_logic_vector is
      variable result: std_logic_vector(1 to N);
   begin
      for i in 1 to N loop
         result(i) := B;
      end loop;
      return result;
   end;  

begin

   data_mask   <= "1111" when (is_byte = '0' and is_half = '0') else 
                  "0011" when (is_byte = '0' and is_half = '1' and ADDR_W(1) = '0') else
                  "1100" when (is_byte = '0' and is_half = '1' and ADDR_W(1) = '1') else
                  "0001" when (is_byte = '1' and is_half = '0' and ADDR_W    = "00") else
                  "0010" when (is_byte = '1' and is_half = '0' and ADDR_W    = "01") else
                  "0100" when (is_byte = '1' and is_half = '0' and ADDR_W    = "10") else
                  "1000" when (is_byte = '1' and is_half = '0' and ADDR_W    = "11") else
                  (others => '0');
                  
   data_value <=  DATA_W when (is_byte = '0' and is_half = '0') else
                  DATA_W(15 downto  0) & DATA_W(15 downto  0) when (is_byte = '0' and is_half = '1') else 
                  DATA_W( 7 downto  0) & DATA_W( 7 downto  0) & DATA_W( 7 downto  0) & DATA_W( 7 downto  0) when (is_byte = '1' and is_half = '0') else
                  (others => '0');
                  
end arch;
