#!/usr/bin/env bash

echo 'Creatin BIN file...'
nasm main.asm -f bin -o ./dist/nops.bin
echo 'Running using QEMU'
qemu-system-i386 ./dist/nops.bin