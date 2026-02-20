AVR Assembly Programming (ČVUT FIT)
Implementation of multiple low-level programs written during the Computer Structures and Architectures course at Czech Technical University in Prague (ČVUT FIT).
The repository demonstrates practical understanding of AVR microcontroller architecture, low-level computation, and embedded programming principles.
________________________________________
Course Overview
The course focuses on programming directly in AVR assembly language, emphasizing how software interacts with hardware without compiler abstraction.
Main learning goals:
•	Understanding CPU register architecture
•	Working with program vs data memory
•	Implementing arithmetic operations manually
•	Handling interrupts and hardware events
•	Performing character and numeric processing
•	Writing structured assembly programs
________________________________________
🧩 Repository Structure
.
├── Task1.X        # Arithmetic expression evaluation
├── lab2.X         # Hexadecimal ASCII conversion
├── Task3.X        # Signed arithmetic & precision handling
├── Task4.X        # Character classification and counting
└── fin.X          # Interrupt-driven embedded application
________________________________________
⚙️ Implemented Programs
________________________________________
🔹 Task 1 — Arithmetic Evaluation
Goal:
Evaluate a mathematical expression using only AVR instructions.
Concepts
•	Bit-shift multiplication/division
•	Signed arithmetic
•	Overflow detection
•	Register manipulation
Demonstrates how high-level arithmetic maps to CPU instructions.
________________________________________
🔹 Lab 2 — Hexadecimal Display Conversion
Goal:
Convert a byte value into hexadecimal ASCII characters and display it.
Concepts
•	Bit masking and shifting
•	Nibble extraction
•	ASCII encoding
•	Subroutine implementation
•	Hardware display output
Example output:
5A
________________________________________
🔹 Task 3 — Signed Arithmetic & Precision
Goal:
Perform correct arithmetic using sign extension and multi-register operations.
Concepts
•	8-bit → 16-bit sign extension
•	Hardware multiplier usage
•	Precision preservation
•	Multi-register result storage
Shows why compilers widen operands before calculations.
________________________________________
🔹 Task 4 — Character Analysis Program
Goal:
Process a string and count character categories.
Features
•	Digit counting (1–9)
•	Uppercase letter counting (A–Z)
•	Lowercase letter counting (a–z)
Concepts
•	Program memory access
•	Pointer registers (Z)
•	SRAM arrays
•	Text processing in assembly
________________________________________
🔹 Final Project — Interrupt-Driven System
Goal:
Implement an event-based embedded application using timer interrupts.
Architecture
Initialization
      ↓
Main Loop (Idle)
      ↓
Interrupt Occurs
      ↓
ISR sets flag
      ↓
Main loop reacts
Concepts
•	Interrupt vectors
•	Timer configuration
•	ISR design
•	Synchronization via shared memory
Represents a realistic embedded firmware structure.
________________________________________
🧠 Technical Skills Demonstrated
•	AVR Assembly Language
•	Microcontroller Architecture
•	Register-Level Programming
•	Bitwise Operations
•	Signed Numeric Representation
•	Memory Segmentation (Flash vs SRAM)
•	Interrupt Handling
•	Embedded System Design
________________________________________
🛠️ Environment
•	Target: AVR Microcontrollers
•	IDE: MPLAB X / AVR Toolchain
•	Language: AVR Assembly
•	Course:  Computer Structures and Architectures
•	University: ČVUT FIT (Faculty of Information Technology)
________________________________________
📚 Educational Context
These programs were developed as laboratory assignments progressing from:
Arithmetic → Data Representation → Precision → Data Processing → Interrupt Systems
The repository documents the transition from simple instruction usage to complete embedded application design.
________________________________________
👨‍💻 Author
Student coursework completed at ČVUT FIT as part of the Bachelor program.

