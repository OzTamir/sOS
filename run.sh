#!/usr/bin/env bash

# Make sure we have a dist folder
if [ ! -d "dist" ]; then
	echo 'No dist directory, running mkdir'
	mkdir dist
fi

echo 'Creatin BIN file...'
nasm main.asm -i ./libs/ -f bin -o ./dist/sos.bin

echo 'Running using QEMU'
qemu-system-i386 ./dist/sos.bin