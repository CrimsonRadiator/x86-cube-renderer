CC = gcc
COMPILER_FLAGS = -Wall -Wextra -g
ASM = nasm
AFLAGS= -f elf64 
LINKER_FLAGS = -lSDL2
OBJ_NAME = renderer

all: main.o renderer.o
	$(CC) $(COMPILER_FLAGS) main.o renderer.o $(LINKER_FLAGS) -o $(OBJ_NAME) 
main.o: main.c
	$(CC) $(COMPILER_FLAGS) -c main.c
renderer.o: renderer.asm
	$(ASM) $(AFLAGS) renderer.asm
