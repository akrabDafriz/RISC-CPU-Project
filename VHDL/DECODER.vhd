library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DECODER is
    port (
        PRG_CNT : IN INTEGER;
        INSTRUCTION : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        OPCODE : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  
        CBIT : OUT STD_LOGIC; -- conditional bit
        OP1_ADDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
        OP2_ADDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
    );
end entity DECODER;

architecture archi of DECODER is
begin
    process(INSTRUCTION)
    begin 
        OP1_ADDR <= INSTRUCTION(13 downto 11);
        OP2_ADDR <= INSTRUCTION(10 downto 8);
        CBIT <= INSTRUCTION(7);
        OPCODE <= INSTRUCTION(6 downto 0);
    end process;
end architecture;