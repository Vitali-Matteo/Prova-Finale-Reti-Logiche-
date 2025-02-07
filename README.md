# README - Prova Finale di Reti Logiche

## Project Overview
This project, developed for the "Prova Finale di Reti Logiche" at Politecnico di Milano (AA 2023-2024), implements a hardware module to process sequences stored in memory. The goal is to update credibility values associated with words according to specific rules.

## Key Features
- **Memory Interface**: 16-bit addressed memory, supporting word and credibility updates.  
- **Datapath Components**: ALU, shifters, comparators, registers, and multiplexers for efficient processing.  
- **Finite State Machine (FSM)**: Controls execution across 13 states for memory interaction and computation.  
- **Optimized Design**: State reduction and minimal memory writes improve performance.  

## Functionality
1. Reads a sequence of words and credibility values from memory.  
2. Updates credibility values and words based on given rules.  
3. Writes results back to memory.  

## Testing & Results
- Validated through multiple testbenches, covering edge cases.  
- Achieved **O(n) time complexity** with **constant space usage (O(1))**.  
- Post-synthesis functional verification confirmed correctness.  

## Optimizations
- Merged states for efficient FSM execution.  
- Reduced unnecessary memory writes.  
- Simplified control logic for improved timing performance.  

## Authors
**Matteo Vitali**  
Politecnico di Milano, AA 2023-2024  
