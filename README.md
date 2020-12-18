# Project_LSD

### About the project 
A system designed to replicate the functioning of a coffee vending machine on FPGAs (DE2-115 kit). 
It consists of three functional phases, each implementing all the functionalities of the previous phases while also adding new ones. 

The [final phase](Fase_III) contains the [main system](Fase_III/Maquina_Fase_III.vhd) of this project and it incorporates 10 components:


  - [**Adder**](Fase_III/Adder.vhd)
  - [**Register**](Fase_III/Registo.vhd)
  - [**Accumulator**](Fase_III/Acc.vhd)
  - [**Timer**](Fase_III/timer.vhd)
  - [**Frequency Divider**](Fase_III/FreqDivider.vhd)
  - [**Binary to BCD**](Fase_III/BIN2BCD.vhd)
  - [**7 Segment Display Decoder**](Fase_III/Bin7SegDecoder.vhd)
  - [**Debounce Unit**](Fase_III/DebounceUnit.vhd)
  - [**Change Counter**](Fase_III/TrocoCounter.vhd)
  - [**Finite State Machine**](Fase_III/FSM.vhd)

### Detailed description/usage 
Read the project report -> [**LSD_Relatorio_P6_89078_95057.pdf**](LSD_Relatorio_P6_89078_95057.pdf).

### Programming/Scripting/Markup Languages
`VHDL`

