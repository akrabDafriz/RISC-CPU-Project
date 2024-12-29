library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    port (
        PRG_CNT : IN INTEGER;
        ALU_EN : IN STD_LOGIC;
        CBIT: IN STD_LOGIC; --conditional bit
        OPCODE : IN STD_LOGIC_VECTOR (6 DOWNTO 0); 
        OPERAND1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); 
        OPERAND2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        ALU_RES : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
    );       
end ALU;

architecture rt1 of ALU is
begin
    process(PRG_CNT)
    begin
        if ALU_EN = '1' then
            case OPCODE is
                when "0000000" => ALU_RES <= std_logic_vector(unsigned(OPERAND1) + unsigned(OPERAND2)); --XADDD
                when "0000010" => ALU_RES <= std_logic_vector(unsigned(OPERAND1(7 DOWNTO 0)) * unsigned(OPERAND2(7 DOWNTO 0))); -- MUL
                when "0000011" => ALU_RES <= std_logic_vector(unsigned(OPERAND1) / unsigned(OPERAND2)); -- DIV
                when "0000100" => ALU_RES <= std_logic_vector(shift_right(unsigned(OPERAND1), to_integer(unsigned(OPERAND2)))); -- SHR
                when "0000101" => ALU_RES <= std_logic_vector(shift_left(unsigned(OPERAND1), to_integer(unsigned(OPERAND2)))); -- SHL
                when "0000110" => ALU_RES <= std_logic_vector(unsigned(OPERAND1) and unsigned(OPERAND2)); -- TEST
                when "0000111" => ALU_RES <= std_logic_vector(unsigned(OPERAND1) and unsigned(OPERAND2)); -- TSTI
                when others => ALU_RES <= (others => '0'); -- Default case: all zeros
            end case;
        end if;
    end process;
end rt1;
