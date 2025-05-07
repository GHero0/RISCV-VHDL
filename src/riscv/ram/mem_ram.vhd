library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use std.textio.all;
use ieee.std_logic_textio.all;

use work.riscv_config.all;

entity mem_ram is
    Port ( 
        CLOCK   : IN  STD_LOGIC;
        ADDR_RW : IN  STD_LOGIC_VECTOR(RAM_ADDR-1  DOWNTO 0);
        ENABLE  : IN  STD_LOGIC;
        WRITE_M : IN  STD_LOGIC_VECTOR(          3 DOWNTO 0);
        DATA_W  : IN  STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0);
        DATA_R  : OUT STD_LOGIC_VECTOR(RAM_WIDTH-1 DOWNTO 0)
     );
end mem_ram;


architecture arch of mem_ram is 

    TYPE   ram_type IS ARRAY (0 TO (RAM_DEPTH-1)) OF STD_LOGIC_VECTOR (RAM_WIDTH-1 DOWNTO 0);

   impure function InitRomFromFile(RamFileName : in string)
      return ram_type is
         file RamFile         : text open read_mode is RamFileName;
         variable RamFileLine : line;
         variable RAM         : ram_type;
    begin
        REPORT "-- PROGRAM MEMORY RAM";
        REPORT "-- RAM_ADDR  = " & integer'image(RAM_ADDR);
        REPORT "-- RAM_DEPTH = " & integer'image(RAM_DEPTH);
        REPORT "-- RAM_WIDTH = " & integer'image(RAM_WIDTH);
        REPORT "-- RAM_FILE  = " & RAM_FILE;
        for I in ram_type'range loop
            readline(RamFile, RamFileLine);
            hread(RamFileLine, RAM(I));
        end loop;
        REPORT "-- FIN DE CHARGEMENT";
        return RAM;
   end function;

   SIGNAL memory : ram_type := InitRomFromFile( RAM_FILE );
   SIGNAL R_ADDR : STD_LOGIC_VECTOR(RAM_ADDR-2-1 DOWNTO 0); -- -2 bits because 32b words and not bytes

begin
    -- Convert byte address to word address (assuming 32-bit words)
    R_ADDR <= ADDR_RW(RAM_ADDR-1 DOWNTO 2);

    -- Memory read process (separate from write to avoid read-during-write issues)
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            if ENABLE = '1' then
                DATA_R <= memory(to_integer(unsigned(R_ADDR)));
            end if;
        end if;
    end process;
    
    -- Memory write process
    process(CLOCK)
    begin
        if rising_edge(CLOCK) then
            if ENABLE = '1' then
                -- Handle write operations based on write mask (WRITE_M)
                if WRITE_M(0) = '1' then
                    memory(to_integer(unsigned(R_ADDR)))(7 downto 0) <= DATA_W(7 downto 0);
                end if;
                
                if WRITE_M(1) = '1' then
                    memory(to_integer(unsigned(R_ADDR)))(15 downto 8) <= DATA_W(15 downto 8);
                end if;
                
                if WRITE_M(2) = '1' then
                    memory(to_integer(unsigned(R_ADDR)))(23 downto 16) <= DATA_W(23 downto 16);
                end if;
                
                if WRITE_M(3) = '1' then
                    memory(to_integer(unsigned(R_ADDR)))(31 downto 24) <= DATA_W(31 downto 24);
                end if;
            end if;
        end if;
    end process;

end arch;