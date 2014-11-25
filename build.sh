#!/usr/bin/env bash

echo 'Building...'
nasm main.asm -f bin -o nops.bin
echo 'Running...'
qemu-system-i386 nops.bin