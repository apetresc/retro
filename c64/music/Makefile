build/music.prg: music.asm
	acme music.asm

build/music_compressed.prg: build/music.prg
	cd build/ && exomizer sfx basic music.prg -o music_compressed.prg

run: build/music_compressed.prg
	cd build/ && x64 music_compressed.prg

run_uncompressed: build/music.prg
	cd build/ && x64 music.prg

all: run

clean:
	rm -f build/*
	
