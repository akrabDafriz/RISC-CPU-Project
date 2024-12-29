library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity REG is
    Port (
        PRG_CNT : IN INTEGER;
        REG_ADDR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
        REG_WR : IN STD_LOGIC;
        REG_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
        REG_DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
end REG;

architecture rtl of REG is
    signal AX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal BX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal CX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal DX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal EX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal FX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal GX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal HX : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

begin
    process(PRG_CNT)
    begin
        if REG_WR = '1' then
            case REG_ADDR is
                when "000" => AX <= REG_DATA_IN;
                when "001" => BX <= REG_DATA_IN;
                when "010" => CX <= REG_DATA_IN;
                when "011" => DX <= REG_DATA_IN;
                when "100" => EX <= REG_DATA_IN;
                when "101" => FX <= REG_DATA_IN;
                when "110" => GX <= REG_DATA_IN;
                when "111" => HX <= REG_DATA_IN;
                when others => HX <= "UUUUUUUUUUUUUUUU";
            end case;
        elsif REG_WR = '0' then
            case REG_ADDR is
                when "000" => REG_DATA_OUT <= AX;
                when "001" => REG_DATA_OUT <= BX;
                when "010" => REG_DATA_OUT <= CX;
                when "011" => REG_DATA_OUT <= DX;
                when "100" => REG_DATA_OUT <= EX;
                when "101" => REG_DATA_OUT <= FX;
                when "110" => REG_DATA_OUT <= GX;
                when "111" => REG_DATA_OUT <= HX;
                when others => REG_DATA_OUT <= "UUUUUUUUUUUUUUUU";
            end case;
        end if;
    end process;
end rtl;
