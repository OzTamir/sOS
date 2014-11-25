#!/usr/bin/env bash

echo '(Running NASM) Creatin BIN file...'
nasm main.asm -f bin -o ./dist/nops.bin

echo '(Running mkfs) Creating IMG file...'
sudo mkfs.msdos -C ./dist/floppy.img 1440

echo '(Running chown) Changing the owner of the floppy from root to' $USER
sudo chown $USER ./dist/floppy.img

echo '(Running dd) Copying the content of the BIN file to the IMG file...'
dd if=./dist/nops.bin of=./dist/floppy.img

echo 'IMG File created, now run it with VirtualBox or something like it.'