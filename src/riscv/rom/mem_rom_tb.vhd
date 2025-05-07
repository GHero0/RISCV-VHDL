-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mem_rom_tb is
end;

architecture bench of mem_rom_tb is

  constant RAM_ADDR_BITS : integer := 14;

  component mem_rom 
      GENERIC(
          RAM_ADDR_BITS : INTEGER := 14;
          filename      : STRING  := "../../soft/PROGROM.mem"
      );
      Port ( 
          CLOCK   : IN  STD_LOGIC;
          ENABLE  : IN  STD_LOGIC;
          ADDR_R  : IN  STD_LOGIC_VECTOR(RAM_ADDR_BITS-1 DOWNTO 0);
          DATA_O  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
  end component;

  signal CLOCK: STD_LOGIC;
  signal ENABLE: STD_LOGIC;
  signal ADDR_R: STD_LOGIC_VECTOR(RAM_ADDR_BITS-1 DOWNTO 0);
  signal DATA_O: STD_LOGIC_VECTOR(31 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: mem_rom generic map ( RAM_ADDR_BITS => RAM_ADDR_BITS,
                             filename      =>  "../../soft/PROGROM.mem")
                  port map ( CLOCK         => CLOCK,
                             ENABLE        => ENABLE,
                             ADDR_R        => ADDR_R,
                             DATA_O        => DATA_O );

  stimulus: process
  begin
  
    -- Put initialisation code here


    -- Put test bench stimulus code here

    stop_the_clock <= true;
    wait;
  end process;

  clocking: process
  begin
    while not stop_the_clock loop
      CLOCK <= '0', '1' after clock_period / 2;
      wait for clock_period;
    end loop;
    wait;
  end process;

end;

