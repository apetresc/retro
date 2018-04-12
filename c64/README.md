# 6502 Chip

## Registers
  - Program Counter
    - 16-bit register points to the next instruction
    - Modified automatically and can only be "set" by jumps, branches,
      subroutines or returns.

  - Stack Pointer
    - There is a stack between 0x0100 and 0x01ff
    - Stack pointer is 8 bits and stores the low-order address of the
      next free locatio on the stack
    - Push/pop instructions automatically increment/decrement

  - Accumulator
    - 8 bits
    - Most ALU operations take only one operand and implicitly modify
      the accumulator

  - X/Y Register
    - Used for whatever you want, no special meaning

  - Status register
    - 8-bit bitmap describing the state of the last instruction
      - Carry flag set if a 1-bit overflow/underflow occured. Can be set/cleared
        with SEC/CLC
      - Zero flag set if the last operation returned 0
      - Interrupt disable set if interrupts are disabled with SEI until
        CLI
      - Decimal mode uses binary arithmetic instead of 2's-complement I
        suppose? Set/cleared with SED/CLD
      - Break is set when BRK is run
      - Overflow is set if overflow of more than 1 bit occurred
      - Negative flag is set of the result was negative in 2s-complement
        (bit 7 was 1)

# Memory

## Memory Map

  - 0x000 to 0x00FF are "Page 0", several instructions implicitly index
    against the lower 8 bits to use as a sort of extended set of
    registers
  - 0x0100 to 0x01FF contains the stack
    - Stack pointer starts at 0x01FF and grows downwards
  - 0x0200 to 0xFFFF is addressable memory, minus the memory-mapped I/O
    stuff

# Instruction Set

The C64 only has 56 instructions (was supposed to be 57 but one of them
couldn't be debugged fully in time so it was never documented).

  - Load/Store
    - LDA/STA loads/stores the accumulator with a byte of memory
    - LDX/LDY/STX/STY loads/stores the X/Y accumulators respectively

  - Register operations
    - Lets you copy one register to another without having to write it
      to memory first.
    - TAX/TAY transfer the accumulator to X/Y
    - TXA/TYA transfer X/Y to the accumulator

  - Stack operations
    - You can only push/pull A or P onto the stack (PHA, PHP, PLA, PLP)
    - You can only push/pull the stack pionter to X (TSX, TXS)

  - Logical/Arithmetic operations
    - AND/EOR (exclusive or)/ORA (inclusive or)
    - BIT applies a bitmask in A against a value in memory to set the
      Zero flag in P. And it copies over the two low-order bits into N V
      in P too, for some reason...?
    - ADC/SBC to add/subtract with carry
    - CMP/CPX/CPY compares A/X/Y to M and sets C if >= M, Z if = M
    - INC/INX/INY/DEC/DEX/DEY increments/decrements A/X/Y respectively
    - ASL/LSR/ROL/ROR do arithmetic shifts or rotations, using the carry
      flag for overflow

  - Control Flow operations
    - JMP just sets the PC
    - JSR/RTS store/retrieve the old PC on the stack
    - There are branch instructions for carry/zero/negative/overflow
      processor flags being either clear or set
    - Since branch instruction operands are relative 8-bit addresses,
      you can only branch up to 128 bytes in either direction!

  - Status Flag operations
    - You can set or clear most status flags

  - System functions
    - BRK forces an interrupt, RTI returns from an interrupt. In either
      case the PC and P register are stored on the stack and the IRQ
      interrupt vector at 0xFFFE is loaded to PC
    - NOP does nothing
    - RTI returns from an interrupt

# Programming the SID Chip

- The SID chip supports up to three voices (i.e, three tones playing at
  once)
- Each voice has three properties:
  - Its oscillator, its envelope, and its filter
- The envelope of a voice determines how its volume rises, sustains, and
  falls
    - For example, a cymbal would rise sharply and then fade slowly
- We set the envelope with four parameters:
  - The ATTACK is the time taken to go from silence to MAX volume
  - The DECAY is the time taken to go from maximum volume to a
    "mid-point" volume
  - The SUSTAIN is the volume to stay at after ATTACK and DECAY have
    elapsed
  - The RELEASE is the time value taken to go from the midpoint back to
    silence
- The memory layout of the SID chip is at https://www.c64-wiki.com/wiki/SID
- How does the SID chip know when to stop SUSTAIN-ing? Through the GATE
  control bit.

10 sid=54272
20 for i = 0 to 28 : poke sid + i, 0 : next
30 poke sid + 24, 15
40 poke sid + 1, 20
50 poke sid + 5, 0*16+0
60 poke sid + 6, 15*16+9
70 poke sid + 4, 16 + 1
80 poke sid + 4, 16

- Line 10 just sets the constant offset for the SID chip memory
- Line 20 clears the SID memory from any old settings
- Line 30 sets the volume to max
- Line 40 sets the high-order byte of the frequency to 20
- Line 50 sets the attack duration (high order bit) to 0 and decay
  duration both to 0 to make it really fast
    - If we increase them, we have to introduce a loop at 75!
- Line 60 sets the sustain level to max (15) and release to 9 (roughly
  0.75 seconds according to
  https://www.atarimagazines.com/compute/issue49/424_1_Programming_64_Sound.php)
- Line 70 sets the voice to the triangular wave form and turns the gate
  ON.
- Line 80 immediately turns the gate back off, triggering the decay.

- Now let's do two voices!!! We'll just duplicate everything except for
  the pitch into the next block.

10 sid=54272
20 for i = 0 to 28 : poke sid + i, 0 : next
30 poke sid + 24, 15
40 poke sid + 1, 20
41 poke sid + 1 + 7, 80
50 poke sid + 5, 0*16+0
51 poke sid + 5 + 7, 0*16+0
60 poke sid + 6, 15*16+9
61 poke sid + 6 + 7, 15*16+9
70 poke sid + 4, 16 + 1
71 poke sid + 4 + 7, 16 + 1
80 poke sid + 4, 16
81 poke sid + 4 + 7, 16

- Putting it all together, here's a program that just randomizes
  everything

10 s = 54272: w = 17: on int(rnd(ti)*4)+1 goto 12,13,14,15
12 w = 33: goto 15
13 w = 65: goto 15
14 w = 129
15 poke s+24,15: poke s+5,97: poke s+6,200: poke s+4,w
16 for x = 0 to 255 step (rnd(ti)*15)+1
17 poke s,x :poke s+1,255-x
18 for y = 0 to 33: next y,x
19 for x = 0 to 200: next: poke s+24,0
20 for x = 0 to 100: next: goto 10

# Graphics Chip

## Memory Map

  - 0xD020 is the frame color
  - 0xD021 is the background color
  - 0x0286 (646) is the "current" text color
  - 0x0400 (1024) is the beginning of Screen RAM
  - 0xD800 (55296) is the beginning of Color RAM
  - Characters in the 128-255 range are 'reversed' versions of the ones
    in the 0-127 range. So 32 is a space and 128+32 is the foreground
    color
