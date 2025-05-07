library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_types.all;

entity decoder_5stg is
Port ( 
    instr_i       : in  STD_LOGIC_VECTOR (31 downto 0);
    isLoad_o      : out STD_LOGIC;
    isStore_o     : out STD_LOGIC;
    isALUreg_o    : out STD_LOGIC;
    isBranch_o    : out STD_LOGIC;
    isSYSTEM_o    : out STD_LOGIC;
    isJAL_o       : out STD_LOGIC;
    isJALR_o      : out STD_LOGIC;
    isJALorJALR_o : out STD_LOGIC;
    isAuipc_o     : out STD_LOGIC;
    isLui_o       : out STD_LOGIC;
    isCustom_o    : out STD_LOGIC; -- custom instruction

    isCSRRS_o     : out STD_LOGIC;
    isEBreak_o    : out STD_LOGIC;

    isByte_o      : out STD_LOGIC;
    isHalf_o      : out STD_LOGIC;

    isRV32M_o     : out STD_LOGIC;
    isMUL_o       : out STD_LOGIC;
    isDIV_o       : out STD_LOGIC;

    -- sign extension pour le load 

    funct3_o      : out STD_LOGIC_VECTOR ( 2 downto 0);
    funct7_o      : out STD_LOGIC_VECTOR ( 6 downto 0);

    csrId_o       : out STD_LOGIC_VECTOR ( 1 downto 0);

    rs1_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs1Used_o   : out STD_LOGIC;
    rs2_o         : out STD_LOGIC_VECTOR ( 4 downto 0);
    isRs2Used_o   : out STD_LOGIC;
    rdId_o        : out STD_LOGIC_VECTOR ( 4 downto 0)
 );
end decoder_5stg;

architecture arch of decoder_5stg is

    SIGNAL isJAL_s    : STD_LOGIC;
    SIGNAL isJALR_s   : STD_LOGIC;
    SIGNAL isALUreg_s : STD_LOGIC;
    SIGNAL isAuipc_s  : STD_LOGIC;
    SIGNAL isLui_s    : STD_LOGIC;
    SIGNAL isBranch_s : STD_LOGIC;
    SIGNAL isStore_s  : STD_LOGIC;
    SIGNAL isSystem_s : STD_LOGIC;

begin

   --
   --
   --
   --
   --
   --
   --
   --
   --
    
end arch;
 
