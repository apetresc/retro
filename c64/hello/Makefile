build/hello.prg: hello.asm
	acme hello.asm

build/hello_compressed.prg: build/hello.prg
	cd build/ && exomizer sfx basic hello.prg -o hello_compressed.prg

run: build/hello_compressed.prg
	cd build/ && x64 hello_compressed.prg

run_uncompressed: build/hello.prg
	cd build/ && x64 hello.prg

all: run

clean:
	rm -f build/*
	
