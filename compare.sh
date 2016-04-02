#!/bin/sh
# Compares baserom.gbc and tcg.gbc

# create baserom.txt if necessary
if [ ! -f baserom.txt ]; then
        hexdump -C baserom.gbc > baserom.txt
fi

hexdump -C tcg.gbc > tcg.txt

diff -u baserom.txt tcg.txt | less
