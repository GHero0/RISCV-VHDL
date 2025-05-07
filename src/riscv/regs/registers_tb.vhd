-- Testbench created online at:
--   https://www.doulos.com/knowhow/perl/vhdl-testbench-creation-using-perl/
-- Copyright Doulos Ltd

library IEEE;
use IEEE.Std_logic_1164.all;
use IEEE.Numeric_Std.all;

entity registers_tb is
end;

architecture bench of registers_tb is

  component registers
  Port ( 
     CLOCK    : in   STD_LOGIC;
     RS1_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RS2_id   : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RD_id    : IN   STD_LOGIC_VECTOR( 4 DOWNTO 0);
     RD_id_we : IN   STD_LOGIC;
     DATA_rd  : IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
     DATA_rs1 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
     DATA_rs2 : OUT  STD_LOGIC_VECTOR(31 DOWNTO 0)
   );
  end component;

  signal CLOCK: STD_LOGIC;
  signal RESET: STD_LOGIC;
  signal RS1_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RS2_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RD_id: STD_LOGIC_VECTOR( 4 DOWNTO 0);
  signal RD_id_we: STD_LOGIC;
  signal DATA_rd: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal DATA_rs1: STD_LOGIC_VECTOR(31 DOWNTO 0);
  signal DATA_rs2: STD_LOGIC_VECTOR(31 DOWNTO 0) ;

  constant clock_period: time := 10 ns;
  signal stop_the_clock: boolean;

begin

  uut: registers port map ( CLOCK    => CLOCK,
                            RS1_id   => RS1_id,
                            RS2_id   => RS2_id,
                            RD_id    => RD_id,
                            RD_id_we => RD_id_we,
                            DATA_rd  => DATA_rd,
                            DATA_rs1 => DATA_rs1,
                            DATA_rs2 => DATA_rs2 );

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

