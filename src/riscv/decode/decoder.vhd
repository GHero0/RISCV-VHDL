library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.riscv_types.all;

entity decoder is
Port ( 
    instr_i       : in  STD_LOGIC_VECTOR (31 downto 0);
    isLoad_o      : out STD_LOGIC;  -- is load instruction ?
    isStore_o     : out STD_LOGIC;  -- is store instruction ?
    isALUreg_o    : out STD_LOGIC;  -- is using rs1 and rs2 in ALU ?
    isBranch_o    : out STD_LOGIC;  -- is branch instruction ?
    isSYSTEM_o    : out STD_LOGIC;  -- is system instruction ?
    isJAL_o       : out STD_LOGIC;  -- is JAL instruction ?
    isJALR_o      : out STD_LOGIC;  -- is JALR instruction ?
    isJALorJALR_o : out STD_LOGIC;  -- is JAL or JALR instruction ?
    isAuipc_o     : out STD_LOGIC;  -- is AUIPC instruction ?
    isLui_o       : out STD_LOGIC;  -- is LUI instruction ?
    isCustom_o    : out STD_LOGIC;  -- custom instruction (not used yet)

    isCSRRS_o     : out STD_LOGIC;  -- is CSRRS instruction ?
    isEBreak_o    : out STD_LOGIC;  -- is EBREAK instruction ?

    isByte_o      : out STD_LOGIC;  -- load or store instruction with byte access ?
    isHalf_o      : out STD_LOGIC;  -- load or store instruction with half access ?

    -- sign extension pour le load 

    funct3_o      : out STD_LOGIC_VECTOR ( 2 downto 0); -- funct3 field
    funct7_o      : out STD_LOGIC_VECTOR ( 6 downto 0); -- funct7 field

    csrId_o       : out STD_LOGIC_VECTOR ( 1 downto 0); -- CSR register ID

    rs1_o         : out STD_LOGIC_VECTOR ( 4 downto 0); -- rs1 register ID
    rs2_o         : out STD_LOGIC_VECTOR ( 4 downto 0); -- rs2 register ID
    rdId_o        : out STD_LOGIC_VECTOR ( 4 downto 0)  -- rd  register ID
 );
end decoder;

architecture arch of decoder is

    SIGNAL opcode : STD_LOGIC_VECTOR(6 downto 0);
    SIGNAL funct3_s : STD_LOGIC_VECTOR(14 downto 12);
    SIGNAL funct7_s : STD_LOGIC_VECTOR(31 downto 25);

begin

    opcode <= instr_i(6 downto 0);

    isLoad_o      <= '1' when opcode = "0000011" else '0';
    isStore_o     <= '1' when opcode = "0100011" else '0';
    isALUreg_o    <= '1' when opcode = "0110011" else '0';
    isBranch_o    <= '1' when opcode = "1100011" else '0';
    isSYSTEM_o    <= instr_is_system( instr_i );
    isJAL_o       <= '1' when opcode = "1101111" else '0';
    isJALR_o      <= '1' when opcode = "1100111" else '0';
    isJALorJALR_o <= '1' when opcode = "1101111" or opcode = "1100111" else '0';
    isAuipc_o     <= '1' when opcode = "0010111" else '0';
    isLui_o       <= '1' when opcode = "0110111" else '0';

    funct3_s <= instr_i(14 downto 12);
    funct7_s <= instr_i(31 downto 25);
    csrId_o <= instr_csr_id(instr_i);


    funct3_o <= funct3_s;
    funct7_o <= funct7_s;
    isCustom_o      <= '0';

    rs1_o  <= instr_i(19 downto 15);
    rs2_o  <= instr_i(24 downto 20);
    rdId_o <= instr_i(11 downto 7);
    
   
    isCSRRS_o     <= instr_is_csrrs ( instr_i );
    isEBreak_o    <= instr_is_ebreak( instr_i );

    isByte_o <= '1' when funct3_s = "000" or funct3_s = "100" else '0';
    isHalf_o <= '1' when funct3_s = "001" or funct3_s = "101" else '0';

    

    
end arch;
 
-- architecture arch of decoder is

--     SIGNAL isJAL_s  : STD_LOGIC;
--     SIGNAL isJALR_s : STD_LOGIC;
--     SIGNAL opcode : STD_LOGIC_VECTOR(6 downto 0);

-- begin

--     opcode          <= instr_i(6 downto 0);

--     -- ====== REGISTRES ==========
--     rs1_o           <= instr_i(19 downto 15);
--     rs2_o           <= instr_i(24 downto 20);
--     rdId_o          <= instr_i(11 downto 7);
    
--     -- ======= FUNCTION ===========
--     funct3_o        <= instr_i(14 downto 12);
--     funct7_o        <= instr_i(31 downto 25);

--     -- ====== CUSTOM =========
--     isCustom_o      <= '0';

--     -- ======== csrId_o ===========
--     csrId_o         <= instr_csr_id(instr_i);
--     isCSRRS_o       <= instr_is_csrrs(instr_i);
--     -- ======== BYTE ==============

--     isByte_o <= '1' when (isLoad_o = '1' or isStore_o = '1') and instr_i(13) = '0' else '0';
--     isHalf_o <= '1' when (isLoad_o = '1' or isStore_o = '1') and instr_i(13) = '1' else '0';


--     -- ======= is ? ===============

--     isLoad_o        <= '1'  when opcode(6 downto 2) = "00000" else '0';
--     isStore_o       <= '1'  when opcode(6 downto 2) = "01000" else '0';
--     isBranch_o      <= '1'  when opcode(6 downto 2) = "11000" else '0';
--     isSYSTEM_o      <= '1'  when opcode(6 downto 2) = "11100" else '0';
--     isEBreak_o      <= '1'  when opcode(6 downto 2) = "11100" else '0';
--     isJAL_o         <= '1'  when opcode(6 downto 2) = "11011" else '0';
--     isJALR_o        <= '1'  when opcode(6 downto 2) = "11001" else '0';
    
--     isJALorJALR_o   <= '1'  when opcode(6 downto 2) = "11011" 
--                             or   opcode(6 downto 2) = "11001" 
--                             else '0';

--     isAuipc_o       <= '1'  when opcode(6 downto 2) = "00101" else '0';
--     isLui_o         <= '1'  when opcode(6 downto 2) = "01101" else '0';
--     isALUreg_o      <= '1'  when opcode(6 downto 2) = "01100" else '0';

-- end arch;


 
