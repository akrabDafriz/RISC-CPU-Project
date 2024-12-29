library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity FREG is
    PORT(
        PRG_CNT : IN INTEGER;
        FREG_WR : IN STD_LOGIC;
        FREG_DATA_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        FREG_DATA_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
end entity FREG;

architecture rtl of FREG is
    signal flags : STD_LOGIC_VECTOR(1 DOWNTO 0):= "00";
begin
    process(PRG_CNT)
    begin
        if FREG_WR = '1' then
            flags <= FREG_DATA_IN;
        else
            FREG_DATA_OUT <= flags;
        end if;
    end process;
end architecture rtl;