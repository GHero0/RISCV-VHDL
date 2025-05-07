-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity mem_ram_tb is
end;

architecture bench of mem_ram_tb is

  constant RAM_ADDR_BITS : integer := 14;

  component mem_ram
      GENERIC(
          RAM_ADDR_BITS : INTEGER := 14;
          filename      : STRING  := "../../soft/DATARAM.mem"
      );
      Port ( 
          CLOCK   : IN  STD_LOGIC;
          ADDR_RW : IN  STD_LOGIC_VECTOR(RAM_ADDR_BITS-1 DOWNTO 0);
          ENABLE  : IN  STD_LOGIC;
          WRITE_M : IN  STD_LOGIC_VECTOR( 3 DOWNTO 0);
          DATA_W  : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
          DATA_R  : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
       );
  end component;

  signal CLOCK: STD_LOGIC;
  signal ADDR_RW: STD_LOGIC_VECTOR(RAM_ADDR_BITS-1 DOWNTO 0);
  signal ENABLE: STD_LOGIC;
  signal WRITE_M: STD_LOGIC_VECTOR( 3 DOWNTO 0);
  signal DATA_W: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal DATA_R: STD_LOGIC_VECTOR(31 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  -- Insert values for generic parameters !!
  uut: mem_ram generic map ( RAM_ADDR_BITS => RAM_ADDR_BITS,
                             filename      => "../../soft/DATARAM.mem")
                  port map ( CLOCK         => CLOCK,
                             ADDR_RW       => ADDR_RW,
                             ENABLE        => ENABLE,
                             WRITE_M       => WRITE_M,
                             DATA_W        => DATA_W,
                             DATA_R        => DATA_R );

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

