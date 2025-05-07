library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity immediate is
Port ( 
   INSTR    : in  STD_LOGIC_VECTOR (31 downto 0);
   isStore  : in  STD_LOGIC;
   isLoad   : in  STD_LOGIC;
   isbranch : in  STD_LOGIC;
   isJAL    : in  STD_LOGIC;
   isAuipc  : in  STD_LOGIC;
   isLui    : in  STD_LOGIC;
   imm      : out STD_LOGIC_VECTOR (31 downto 0)
 );
end immediate;


architecture arch of immediate is

    function repeat_bit(B: std_logic; N: natural) return std_logic_vector is
        variable result: std_logic_vector(1 to N);
    begin
        for i in 1 to N loop
            result(i) := B;
        end loop;
        return result;
    end;  

    function to_stdl(L: BOOLEAN) return std_ulogic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
    end;

   SIGNAL Iimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Simm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Uimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Jimm : STD_LOGIC_VECTOR (31 downto 0);
   SIGNAL Bimm : STD_LOGIC_VECTOR (31 downto 0);

begin
    -- I Format immediate register completion 
    Iimm(11 downto  0)  <= INSTR(31 downto 20);
    Iimm(31 downto 12)  <= repeat_bit(INSTR(31),20);

    -- S Format immediate register completion 
    Simm(11 downto  5)  <= INSTR(31 downto 25);
    Simm(4  downto  0)  <= INSTR(11 downto  7);
    Simm(31 downto 12)  <= repeat_bit(Simm(11), 20); 
    
    -- B Format immediate register completion 
    Bimm(12)            <= INSTR(31);
    Bimm(10 downto  5)  <= INSTR(30 downto 25);
    Bimm(4  downto  1)  <= INSTR(11 downto  8);
    Bimm(11)            <= INSTR(7);
    Bimm(31 downto 13)  <= repeat_bit(Bimm(12), 19);
    Bimm(0)             <= '0';

    -- U Format immediate register completion 
    Uimm(31 downto 12)   <= INSTR(31 downto 12);
    Uimm(11 downto  0)   <= (others => '0');

    -- J Format immediate register completion 
    Jimm(20)            <= INSTR(31);
    Jimm(10 downto 1)   <= INSTR(30 downto 21);
    Jimm(11)            <= INSTR(20);
    Jimm(19 downto 12)  <= INSTR(19 downto 12);
    Jimm(31 downto 21)  <= repeat_bit(Jimm(20),11);
    Jimm(0)             <= '0';

    imm <= Uimm when isLui =    '1' or   isAuipc = '1' else
           Jimm when isJAL =    '1' else
           Bimm when isbranch = '1' else
           Simm when isStore =  '1' else
           Iimm when isLoad =   '1' else
           Iimm;

end arch;
