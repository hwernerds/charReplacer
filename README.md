# Character Replacer

## Overview

This project implements a simple text-processing tool using assembly language. The program reads lines of text from the input, processes the text to count characters, words, and lines, 
and performs character replacement based on specified input and output characters. The tool then prints the processed text along with a summary of the counts.

## Features

- Counts the number of characters, words, and lines in the input text.
- Supports character replacement based on user-defined input and output characters.
- Prints the processed text and a summary of the counts.

## Compilation and Execution

1. Assemble the program using an assembler:

        as -o translator.o translator.c

2. Link the object file:

        ld -o text_processor text_processor.o -lc -dynamic-linker /lib64/ld-linux-x86-64.so.2

3. Run the program in one of two different ways:

     I) Execute the program from the command line and provide text directly, pressing "CTRL+D" when you are finished providing input to signal EOF:

         ./translator

     II) Execute the program and redirect input from an existing ".txt" file:

         ./translator < input.txt

4. Exit the program:

     Press "CTRL+D" 
