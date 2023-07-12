# Project_LSD

### About the project 
This project involves the development of a system on FPGAs (DE2-115 kit) that emulates the operation of a coffee vending machine <br>
The system progresses through three distinct functional phases, with each phase building upon the functionalities implemented in the previous phase, while also introducing new features

The [final phase](Fase_III) is the most complete and contains the [main system](Fase_III/Maquina_Fase_III.vhd) of the project, incorporating 10 components:

  - [**Adder**](Fase_III/Adder.vhd)
  - [**Register**](Fase_III/Registo.vhd)
  - [**Accumulator**](Fase_III/Acc.vhd)
  - [**Timer**](Fase_III/timer.vhd)
  - [**Frequency Divider**](Fase_III/FreqDivider.vhd)
  - [**Binary to BCD**](Fase_III/BIN2BCD.vhd)
  - [**7 Segment Display Decoder**](Fase_III/Bin7SegDecoder.vhd)
  - [**Debounce Unit**](Fase_III/DebounceUnit.vhd)
  - [**Finite State Machine**](Fase_III/FSM.vhd)
  - [**System to manage change**](Fase_III/TrocoCounter.vhd)

### Detailed description/usage 
Read the project report -> [**LSD_Relatorio_P6_89078_95057.pdf**](LSD_Relatorio_P6_89078_95057.pdf)
