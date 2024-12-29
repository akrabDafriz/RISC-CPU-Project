LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY CPU IS
    PORT (
        CPU_CLK : IN STD_LOGIC;
        ENABLE : IN STD_LOGIC;
        INSTRUCTION_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0)
    );
END ENTITY CPU;

ARCHITECTURE rtl OF CPU IS
    COMPONENT DECODER IS
        PORT (
            PRG_CNT : IN INTEGER;
            INSTRUCTION : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            OPCODE : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  
            CBIT : OUT STD_LOGIC; -- conditional bit
            OP1_ADDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0); 
            OP2_ADDR : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT DECODER;

    COMPONENT RAM IS
        PORT (
            PRG_CNT : IN INTEGER; 
            RAM_ADDR : IN STD_LOGIC_VECTOR(2 DOWNTO 0); 
            RAM_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0); 
            RAM_WR : IN STD_LOGIC; --enabler write
            RAM_DATA_OUT: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT RAM;

    COMPONENT ALU IS
        PORT (
            PRG_CNT : IN INTEGER;
            ALU_EN : IN STD_LOGIC;
            CBIT: IN STD_LOGIC; --conditional bit
            OPCODE : IN STD_LOGIC_VECTOR (6 DOWNTO 0); 
            OPERAND1 : IN STD_LOGIC_VECTOR (15 DOWNTO 0); 
            OPERAND2 : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            ALU_RES : OUT STD_LOGIC_VECTOR (15 DOWNTO 0)
        );        
    END COMPONENT ALU;

    COMPONENT REG IS
        PORT(
            PRG_CNT : IN INTEGER;
            REG_ADDR : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            REG_WR : IN STD_LOGIC;
            REG_DATA_IN : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            REG_DATA_OUT : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT REG;

    COMPONENT FREG IS
        PORT(
            PRG_CNT : IN INTEGER;
            FREG_WR : IN STD_LOGIC;
            FREG_DATA_IN : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            FREG_DATA_OUT : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
        );
    END COMPONENT FREG;

    --signals for decoder
    SIGNAL instructionsig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL opcodesig : STD_LOGIC_VECTOR(6 DOWNTO 0) := (OTHERS => '0');
    SIGNAL con_bit : STD_LOGIC := '0';
    SIGNAL op1_decode : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL op2_decode : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');

    --signals for ram
    SIGNAL ram_address_to_access : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ram_datatowrite : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL ram_wrsig : STD_LOGIC := '0';
    SIGNAL ram_data_out_sig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    --signals for register
    SIGNAL reg_address_to_access : STD_LOGIC_VECTOR(2 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_datatowrite : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');
    SIGNAL reg_wrsig : STD_LOGIC := '0';
    SIGNAL reg_data_out_sig : STD_LOGIC_VECTOR(15 DOWNTO 0) := (OTHERS => '0');

    --signals for flag registers
    SIGNAL freg_wrsig : STD_LOGIC := '0';
    SIGNAL freg_datatowrite : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
    SIGNAL freg_data_out_sig : STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');

    --signals for alu
    SIGNAL alu_en_sig : STD_LOGIC := '0';
    SIGNAL alu_value1 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_value2 : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL alu_res_signal : STD_LOGIC_VECTOR(15 DOWNTO 0);

    --signals for general
    TYPE stateType IS (IDLE, FETCH, READD, EXECUTE1, EXECUTE2, COMPLETE); --DECODE udah gaada, gabung ke fetch
    SIGNAL currentState : stateType := IDLE;
    SIGNAL counterProg : INTEGER := 0;
    SIGNAL temp_address : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL temp_value : STD_LOGIC_VECTOR(15 DOWNTO 0);
    
BEGIN

    -- Port Map components
    decoderMain : DECODER PORT MAP(counterProg, instructionsig, opcodesig, con_bit, op1_decode, op2_decode);
    ramMain : RAM PORT MAP(counterProg, ram_address_to_access, ram_datatowrite, ram_wrsig, ram_data_out_sig);
    aluMain : ALU PORT MAP(counterProg,alu_en_sig, con_bit, opcodesig, alu_value1, alu_value2, alu_res_signal);
    regMain : REG PORT MAP(counterProg, reg_address_to_access, reg_wrsig, reg_datatowrite, reg_data_out_sig);
    fregMain : FREG PORT MAP(counterProg, freg_wrsig, freg_datatowrite, freg_data_out_sig);

    PROCESS (CPU_CLK)
    BEGIN
        IF rising_edge(CPU_CLK) THEN
            CASE currentState IS
                WHEN IDLE =>
                    counterProg <= counterProg + 1;
                    IF ENABLE = '1' THEN
                        currentState <= FETCH;
                    ELSE
                        currentState <= IDLE;
                    END IF;

                WHEN FETCH =>
                    counterProg <= counterProg + 1;
                    instructionsig <= INSTRUCTION_IN;
                    currentState <= READD;

                WHEN READD =>
                    counterProg <= counterProg + 1;
                    IF con_bit = '0' THEN 
                        reg_address_to_access <= op1_decode;
                        ram_address_to_access <= op2_decode;
                    ELSE
                        reg_address_to_access <= op2_decode;
                        ram_address_to_access <= op1_decode;
                    END IF;
                    reg_wrsig <= '0'; -- Read
                    ram_wrsig <= '0'; -- Read
                    currentState <= EXECUTE1;

                WHEN EXECUTE1 =>
                    counterProg <= counterProg + 1;
                    CASE opcodesig IS
                        WHEN "0000000" => -- XADD instruction, handled by ALU and directly
                            reg_datatowrite <= ram_data_out_sig;
                            ram_datatowrite <= reg_data_out_sig;
                            reg_wrsig <= '1';
                            ram_wrsig <= '1';
                            alu_value1 <= ram_data_out_sig;
                            alu_value2 <= reg_data_out_sig;
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000001" => -- XCHG instruction, handled directly here
                            reg_datatowrite <= ram_data_out_sig;
                            ram_datatowrite <= reg_data_out_sig;
                            reg_wrsig <= '1';
                            ram_wrsig <= '1';
                            currentState <= COMPLETE;

                        WHEN "0000010" => -- MUL instruction, handled by ALU
                            alu_value1 <= ram_data_out_sig;
                            alu_value2 <= reg_data_out_sig;
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000011" => -- DIV instruction, handled by ALU
                            alu_value1 <= ram_data_out_sig;
                            alu_value2 <= reg_data_out_sig;
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000100" => -- SHR instruction handled by ALU
                            alu_value1 <= reg_data_out_sig;
                            alu_value2 <= ("0000000000000"& op2_decode);
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000101" => -- SHL instruction handled by ALU
                            alu_value1 <= ram_data_out_sig;
                            alu_value2 <= ("0000000000000"& op2_decode);
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000110" => -- TEST instruction handled by ALU
                            alu_value1 <= ram_data_out_sig;
                            alu_value2 <= reg_data_out_sig;
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0000111" => -- TSTI instruction handled by ALU
                            IF (con_bit = '0') THEN
                                alu_value1 <= reg_data_out_sig;
                                alu_value2 <= ("0000000000000" & op2_decode);
                            ELSE
                                alu_value1 <= ("0000000000000" & op1_decode);
                                alu_value2 <= reg_data_out_sig;    
                            END IF;
                            alu_en_sig <= '1';
                            --counterProg <= counterProg + 1;
                            currentState <= EXECUTE2;

                        WHEN "0001000" => -- MOV instruction handled directly here
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= ram_data_out_sig;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= reg_data_out_sig;
                                ram_wrsig <= '1';
                            END IF;
                            currentState <= COMPLETE;

                        WHEN "0001001" => -- LDI instruction handled directly here
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= ("0000000000000" & op2_decode);
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= ("0000000000000" & op2_decode);
                                ram_wrsig <= '1';
                            END IF;
                            currentState <= COMPLETE;

                        WHEN OTHERS =>
                            instructionsig <= (others => 'U');
                    END CASE;
                    --currentState <= COMPLETE;

                WHEN EXECUTE2 =>
                    counterProg <= counterProg + 1;
                    CASE opcodesig IS
                        WHEN "0000000" => -- XADD instruction, handled by ALU and directly
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= alu_res_signal;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= alu_res_signal;
                                ram_wrsig <= '1';
                            END IF;
                        WHEN "0000010" => -- MUL instruction, handled by ALU
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= alu_res_signal;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= alu_res_signal;
                                ram_wrsig <= '1';
                            END IF;
                        WHEN "0000011" => -- DIV instruction, handled by ALU
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= alu_res_signal;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= alu_res_signal;
                                ram_wrsig <= '1';
                            END IF;
                        WHEN "0000100" => -- SHR instruction handled by ALU
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= alu_res_signal;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= alu_res_signal;
                                ram_wrsig <= '1';
                            END IF;
                        WHEN "0000101" => -- SHL instruction handled by ALU
                            IF (con_bit = '0') THEN
                                reg_datatowrite <= alu_res_signal;
                                reg_wrsig <= '1';
                            ELSE 
                                ram_datatowrite <= alu_res_signal;
                                ram_wrsig <= '1';
                            END IF;
                        WHEN "0000110" => -- TEST instruction handled by ALU
                            IF (alu_res_signal = ram_data_out_sig) THEN
                                freg_datatowrite <= "01";
                                freg_wrsig <= '1';
                            ELSE 
                                freg_datatowrite <= "00";
                            END IF;
                        WHEN "0000111" => -- TSTI instruction handled by ALU
                            IF (alu_res_signal = ram_data_out_sig) THEN
                                freg_datatowrite <= "01";
                                freg_wrsig <= '1';
                            ELSE 
                                freg_datatowrite <= "00";
                            END IF;
                        WHEN others => instructionsig <= "UUUUUUUUUUUUUUUU";
                    END CASE;
                    currentState <= COMPLETE;

                WHEN COMPLETE =>
                    counterProg <= counterProg + 1;
                    alu_en_sig <= '0';
                    reg_wrsig <= '0';
                    ram_wrsig <= '0';
                    freg_datatowrite <= "00";
                    freg_wrsig <= '1'; -- Enable flag register write
                    currentState <= IDLE;  
            END CASE;
        END IF;
    END PROCESS;
END ARCHITECTURE rtl;