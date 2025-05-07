LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY alu IS
    PORT (
        rs1_v : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        rs2_v : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        isALUreg : IN STD_LOGIC;
        isBranch : IN STD_LOGIC;
        isAluSubstraction : IN STD_LOGIC;
        isCustom : IN STD_LOGIC;
        func3 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        func7 : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
        imm_v : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

        aluOut_v : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        aluPlus_v : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        takeBranch : OUT STD_LOGIC
    );
END alu;

ARCHITECTURE arch OF alu IS

signal operande_1 : STD_LOGIC_VECTOR (31 downto 0);
signal operande_2 : STD_LOGIC_VECTOR (31 downto 0);
signal s_aluOut_v : STD_LOGIC_VECTOR (31 downto 0);
signal shift_value_select : STD_LOGIC_VECTOR (4 downto 0);

function to_stdl(L: BOOLEAN) return std_ulogic is
    begin
        if L then
            return('1');
        else
            return('0');
        end if;
    end;

function repeat_bit(B: std_logic; N: natural) return std_logic_vector is
        variable result: std_logic_vector(1 to N);
    begin
        for i in 1 to N loop
            result(i) := B;
        end loop;
        return result;
    end; 

BEGIN

    operande_1 <= rs1_v;
    operande_2 <= rs2_v when isALUreg = '1' or isBranch = '1' else imm_v;

    aluPlus_v <= std_logic_vector(signed(operande_1) + signed(operande_2));
    aluOut_v <= s_aluOut_v;

    shift_value_select <= rs2_v(4 downto 0) when isALUreg = '1' or isBranch = '1'else imm_v(4 downto 0);

    PROCESS (operande_1, operande_2, isALUreg, isBranch, isAluSubstraction, isCustom, func3, func7, imm_v)
    variable shift_value : integer;
    BEGIN

        CASE func3 IS
            WHEN "000" => -- ADD/SUB
                s_aluOut_v    <= STD_LOGIC_VECTOR(signed(operande_1) - signed(operande_2)) WHEN isAluSubstraction = '1' and isALUreg = '1' ELSE
                                STD_LOGIC_VECTOR(signed(operande_1) + signed(operande_2)); -- 👍

            WHEN "001" => -- SLL
                s_aluOut_v    <= STD_LOGIC_VECTOR(signed(operande_1) sll to_integer(unsigned(operande_2(4 DOWNTO 0))));

            WHEN "010" => -- SLT        
                s_aluOut_v   <= STD_LOGIC_VECTOR(to_signed(1, 32)) WHEN signed(operande_1) < signed(operande_2) ELSE (others => '0');
        
            WHEN "011" => -- SLTU
                s_aluOut_v   <= STD_LOGIC_VECTOR(to_signed(1, 32)) WHEN unsigned(operande_1) < unsigned(operande_2) ELSE (others => '0');
    
            WHEN "100" => -- XOR
                s_aluOut_v    <= STD_LOGIC_VECTOR(operande_1 xor operande_2);-- 👍
    
            WHEN "101" => -- SRL/SRA
                s_aluOut_v    <=  STD_LOGIC_VECTOR(signed(operande_1) srl to_integer(unsigned(operande_2(4 DOWNTO 0)))) WHEN func7(5) = '0' ELSE
                               STD_LOGIC_VECTOR(signed(operande_1) sra to_integer(unsigned(operande_2(4 DOWNTO 0))));

            WHEN "110" => -- OR
                s_aluOut_v    <= STD_LOGIC_VECTOR(operande_1 or operande_2);-- 👍

            WHEN "111" => -- AND
                s_aluOut_v    <= STD_LOGIC_VECTOR(operande_1 and operande_2);-- 👍

            WHEN OTHERS =>
                s_aluOut_v    <= (OTHERS => '0');
        END CASE;

        --Branch evaluation 
        IF isBranch = '1' THEN
            CASE func3 IS
                WHEN "000" => -- BEQ
                    takeBranch <= '1' WHEN rs1_v = rs2_v ELSE '0';
                WHEN "001" => -- BNE
                    takeBranch <= '1' WHEN rs1_v /= rs2_v ELSE '0';
                WHEN "100" => -- BLT
                    takeBranch <= '1' WHEN signed(rs1_v) < signed(rs2_v) ELSE '0';
                WHEN "101" => -- BGE
                    takeBranch <= '1' WHEN signed(rs1_v) >= signed(rs2_v) ELSE '0';
                WHEN "110" => -- BLTU
                    takeBranch <= '1' WHEN unsigned(rs1_v) < unsigned(rs2_v) ELSE '0';
                WHEN "111" => -- BGEU
                    takeBranch <= '1' WHEN unsigned(rs1_v) >= unsigned(rs2_v) ELSE '0';
                WHEN OTHERS =>
                    takeBranch <= '0';
            END CASE;
        END IF;
    END PROCESS;
END arch;








-- --
--     --
--     --
    
--     signal s_aluOut_v : STD_LOGIC_VECTOR (31 downto 0);
--     signal operande_1 : STD_LOGIC_VECTOR (31 downto 0);
--     signal operande_2 : STD_LOGIC_VECTOR (31 downto 0);
--     signal shift_value_select : STD_LOGIC_VECTOR (4 downto 0);

--     --
--     --
--     --
--     aluOut_v <= s_aluOut_v;

--     operande_1 <= rs1_v;
--     operande_2 <= rs2_v when isALUreg = '1' or isBranch = '1'else 
--                   imm_v;

--     shift_value_select <= rs2_v(4 downto 0) when isALUreg = '1' or isBranch = '1'else 
--                     imm_v(4 downto 0);


    
--     calcul : process(operande_1, operande_2, func3, isAluSubstraction, isBranch, isALUreg, shift_value_select)
--     variable func3_on_4_bits : std_logic_vector (3 downto 0);
--     variable shift_value : integer;
--     begin
--         func3_on_4_bits := "0" & func3;
--         if isBranch = '0' then 
--             case func3_on_4_bits is
--                 when x"0" =>
--                             if isAluSubstraction = '1' and isALUreg = '1' then
--                                 s_aluOut_v <= std_logic_vector(signed(operande_1) - signed(operande_2));
--                             else
--                                 s_aluOut_v <= std_logic_vector(signed(operande_1) + signed(operande_2));
--                             end if;
--                 when x"4" => 
--                             s_aluOut_v <= operande_1 xor operande_2;
--                 when x"6" => 
--                             s_aluOut_v <= operande_1 or operande_2;
--                 when x"7" => 
--                             s_aluOut_v <= operande_1 and operande_2;
--                 when x"1" => 
--                             --s_aluOut_v <= operande_1(31 - to_integer(signed(operande_2)) downto 0) & repeat_bit('0',to_integer(signed(operande_2)));
--                             shift_value := to_integer(unsigned(shift_value_select));
                            
--                             s_aluOut_v <= (operande_1 sll shift_value);



--                 when x"5" =>
--                             shift_value := to_integer(unsigned(shift_value_select));
                            
--                             if isAluSubstraction = '0' then
--                                 --s_aluOut_v <= repeat_bit('0', to_integer(signed(operande_2))) & operande_1(31 downto to_integer(signed(operande_2)));
--                                 s_aluOut_v <=  (operande_1 srl shift_value);
--                             else 
--                                 --s_aluOut_v <= repeat_bit(operande_1(31), to_integer(signed(operande_2))) & operande_1(31 downto to_integer(signed(operande_2)));
--                                 s_aluOut_v <= std_logic_vector(signed(operande_1) sra shift_value);   
--                             end if;
--                 when x"2" =>
--                             if  signed(operande_1) < signed(operande_2) then
--                                 s_aluOut_v <= repeat_bit('0',31) & '1' ;
--                             else
--                                 s_aluOut_v <= repeat_bit('0',32) ;
--                             end if;
--                 when x"3" =>
--                             if unsigned(operande_1) < unsigned(operande_2) then
--                                 s_aluOut_v <= repeat_bit('0',31) & '1';  
--                             else
--                                 s_aluOut_v <= repeat_bit('0',32) ;
--                             end if;
--                 when others => 
--                             s_aluOut_v <= (others => '0');
                    

                

--             end case;
--         end if;
--     end process;

--     takeBranch <=               to_stdl(operande_1  = operande_2) when isBranch = '1' and func3 = "000" else
--                                 to_stdl(operande_1 /= operande_2) when isBranch = '1' and func3 = "001" else
--                                 to_stdl(     signed(operande_1) < signed(operande_2 )) when isBranch = '1' and func3 = "100" else  
--                                 to_stdl(not (signed(operande_1) < signed(operande_2))) when isBranch = '1' and func3 = "101" else  
--                                 to_stdl(    (unsigned(operande_1) < unsigned(operande_2))) when isBranch = '1' and func3 = "110" else
--                                 to_stdl(not  (unsigned(operande_1) < unsigned(operande_2))) when isBranch = '1' and func3 = "111" else 
--                                 '0';

    
   