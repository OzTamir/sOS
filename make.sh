#!/usr/bin/env bash

# Make sure we have a dist folder
if [ ! -d "dist" ]; then
	echo 'No dist directory, running mkdir'
	mkdir dist
fi

echo '(Running NASM) Creatin BIN file...'
nasm main.asm -i ./libs/ -f bin -o ./dist/sos.bin

echo '(Running mkfs) Creating IMG file...'
sudo mkfs.msdos -C ./dist/floppy.img 1440

echo '(Running chown) Changing the owner of the floppy from root to' $USER
sudo chown $USER ./dist/floppy.img

echo '(Running dd) Copying the content of the BIN file to the IMG file...'
dd if=./dist/sos.bin of=./dist/floppy.img

echo 'IMG File created, now run it with VirtualBox or something like it.'