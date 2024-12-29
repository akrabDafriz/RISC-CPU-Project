library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RAM is
    PORT (
        PRG_CNT : IN INTEGER; 
        RAM_ADDR : IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
        RAM_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
        RAM_WR : IN STD_LOGIC; --enabler write
        RAM_DATA_OUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end RAM;

architecture rt1 of RAM is
    type ram_type is array (0 to 127) of STD_LOGIC_VECTOR (15 downto 0); -- 128 addresses, each 16-bit wide
    signal RAM : ram_type := (others => (others => '0'));
begin
    process(PRG_CNT)
    begin
        if RAM_WR = '1' then
            RAM(to_integer(unsigned(RAM_ADDR))) <= RAM_DATA_IN;
        else
            RAM_DATA_OUT <= RAM(to_integer(unsigned(RAM_ADDR)));
        end if;
    end process;
end rt1;