# CPU Documentation

This CPU is a simple processing unit associated with Decoder, ALU, Memory, Flag Register, and Register unit. This CPU recognizes 10 simple instructions and executes them according to their purpose.

## Components
### CPU
The CPU acts as control unit, and as a FSM. The states used are IDLE, FETCH, READD, EXECUTE1, EXECUTE2, and COMPLETE. The CPU recognizes and handles each instruction with logic needed accordingly. 
### RAM
RAM acts as a memory unit that can be used to store data. It consists of 128 addresses of 16-bit data medium, measuring 256 byte in total.
### REG
REG functions as a general purpose register that stores temporary data to be used in operations. REG consists of 8 16-bit data media addresses.
### FREGISTER
FREG functions as a flag register consisting 2-bits of data that acts as flag to be recognized by other potential instructions.
### DECODER
DECODER functions as a decoder that splits the 16-bit instruction into opcode, operands, and conditional bit. Those information will be used by other components to determine the CPU work.
### ALU
ALU functions as an accumulator that does arithmetic and logical operations.

## Instruction Set
### ISA (Instruction Set Architecture)

Format:
| U (2 bit) | R/M(3 bit) | R/M/I (3 bit) | Conditional (1 bit) | Opcode (7 bit)|
|-----------|------------|---------------|---------------------|---------------|

```
Legend:
- R = Register
- M = Memory
- I = Immediate
- C = Conditional Flag
- U = Unused

Format is Operand1-Operand2
```
| Instruksi | Format | Operand1 | Operand2 | C | Opcode| Deskripsi | 
| --------- | :------: | :------------: | :---------: | ------ | --------- |---------|
| XADD | RM | 000 – 111  | 000 – 111 | 0 | XXX0000 | Exchanges the value of Operand1 and Operand2, adds them, and stores the result in Operand1. Operand1 is recognized as register address, Operand2 is recognized as memory address.|
| XADD | MR | 000 – 111  | 000 – 111 | 1 | XXX0000 | Exchanges the value of Operand1 and Operand2, adds them, and stores the result in Operand1. Operand1 is recognized as memory address, Operand2 is recognized as register address. |
| XCHG | RM | 000 – 111  | 000 – 111 | 0 | XXX0001 | Exchanges the value of Operand1 and Operand2. |
| XCHG | MR | 000 – 111  | 000 – 111 | 1 | XXX0001 | Exchanges the value of Operand1 and Operand2. |
| MUL | RM | 000 – 111  | 000 – 111 | 0 | XXX0010| Multiplies the value inside Operand1 by the value inside Operand2 and stores the result in Operand1. Operand1 is recognized as register address, Operand2 is recognized as memory address. |
| MUL | MR | 000 – 111  | 000 – 111 | 1 | XXX0010| Multiplies the value inside Operand1 by the value inside Operand2 and stores the result in Operand1. Operand1 is recognized as memory address, Operand2 is recognized as register address. |
| DIV | RM | 000 – 111  | 000 – 111 | 0 | XXX0011 | Divides the value inside Operand1 by the value inside Operand2 and stores the result in Operand1. Operand1 is recognized as register address, Operand2 is recognized as memory address. |
| DIV | MR | 000 – 111  | 000 – 111 | 1 | XXX0011 | Divides the value inside Operand1 by the value inside Operand2 and stores the result in Operand1. Operand1 is recognized as memory address, Operand2 is recognized as register address.  |
| SHR | R(3) | 000 – 111  | 000 – 111 | 0 | XXX0100 | Logically shifts the bits in Operand1 to the right by the immediate value of Operand2. Operand1 is recognized as register address, Operand2 is recognized as immediate value.|
| SHR | M(3) | 000 – 111  | 000 – 111 | 1 | XXX0100 | Logically shifts the bits in Operand1 to the right by the immediate value of Operand2. Operand1 is recognized as memory address, Operand2 is recognized as immediate value. |
| SHL | R(3) | 000 – 111  | 000 – 111 | 0 | XXX0101 |  Logically shifts the bits in Operand1 to the left by the immediate value of Operand2. Operand1 is recognized as register address, Operand2 is recognized as immediate value.  |
| SHL | M(3) | 000 – 111  | 000 – 111 | 1 | XXX0101 |  Logically shifts the bits in Operand1 to the left by the immediate value of Operand2. Operand1 is recognized as memory address, Operand2 is recognized as immediate value.  |
| TEST | RM | 000 – 111  | 000 – 111 | 0 | XXX0110 | Compares the value inside Operand1 and the value inside Operand2 by using bitwise AND operation. If equal, the equal flag in Flag Register will be set. Operand1 is recognized as register address, Operand2 is recognized as memory address. |
| TEST | MR | 000 – 111  | 000 – 111 | 1 | XXX0110 | Compares the value inside Operand1 and the value inside Operand2 by using bitwise AND operation. If equal, the equal flag in Flag Register will be set. Operand1 is recognized as memory address, Operand2 is recognized as register address. |
| TSTI | R(3) | 000 – 111  | 000 – 111 | 0 | XXX0111 | Compares the value inside Operand1 and the immediate value of Operand2. Operand1 is recognized as register address, Operand2 is recognized as immediate value.  |
| TSTI | M(3) | 000 – 111  | 000 – 111 | 1 | XXX0111 | Compares the value inside Operand1 and the immediate value of Operand2. Operand1 is recognized as memory address, Operand2 is recognized as immediate value.  |
| MOV | RM | 000 – 111  | 000 – 111 | 0 | XXX1000 | Moves the value inside Operand1 to Operand2, and vice versa. Operand1 is recognized as register address, Operand2 is recognized as memory address. |
| MOV | MR | 000 – 111  | 000 – 111 | 1 | XXX1000 | Moves the value inside Operand1 to Operand2, and vice versa. Operand1 is recognized as memory address, Operand2 is recognized as register address. |
| LDI | R(3) | 000 – 111  | 000 – 111 | 0 | XXX1001 | Loads immediate value of Operand2 into Operand1. Operand1 is recognized as register address, Operand2 is recognized as immediate value.  |
| LDI | M(3) | 000 – 111  | 000 – 111 | 1 | XXX1001 | Loads immediate value of Operand2 into Operand1. Operand1 is recognized as memory address, Operand2 is recognized as immediate value.  |