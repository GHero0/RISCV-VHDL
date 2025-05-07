LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY fetch IS
   PORT (
      CLK : IN STD_LOGIC;
      resetn : IN STD_LOGIC;
      enable_f : IN STD_LOGIC;
      enable_m : IN STD_LOGIC;
      jumpOrBranchAddress : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
      jumpOrBranch : IN STD_LOGIC;
      pc_value : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
   );
END fetch;

ARCHITECTURE arch OF fetch IS

   SIGNAL pc_addr : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN

   pc_value <= pc_addr;
    process(CLK, resetn)
    variable add_pc : unsigned(31 downto 0);
    begin
        if(resetn = '0' ) then
            pc_addr <= (others => '0');
        elsif(CLK'event and CLK = '1') then
            if enable_m = '1' and jumpOrBranch = '1' then
                pc_addr <= (jumpOrBranchAddress);
            elsif enable_f = '1' then
                add_pc := unsigned(pc_addr) + to_unsigned(4,32);
                pc_addr <= std_logic_vector(add_pc);
            end if;
        end if;
    end process;


END arch;
