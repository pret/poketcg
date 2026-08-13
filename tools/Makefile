.PHONY: all clean

CC := gcc
CFLAGS := -O3 -std=c17 -Wall -Wextra -pedantic

tools := bgmap compressor gfx make_patch scan_includes

all: $(tools)
	@:

clean:
	rm -f $(tools)

%: %.c common.h
	$(CC) $(CFLAGS) -o $@ $<
