build/logo.prg: index.asm
	acme index.asm

build/logo_compressed.prg: build/logo.prg
	cd build/ && exomizer sfx basic logo.prg -o logo_compressed.prg

run: build/logo_compressed.prg
	cd build/ && x64 logo_compressed.prg

run_uncompressed: build/logo.prg
	cd build/ && x64 logo.prg

all: run

clean:
	rm -f build/*
	
