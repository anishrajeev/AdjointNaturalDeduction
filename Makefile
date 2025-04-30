all: nd

default: all

nd: always
	install _build/default/bin/$@.exe $@
	strip $@

always:
	dune build --profile=release

clean:
	dune clean
	rm -f nd
	rm -f lab3.zip

SRC_DIRS := ./lib ./bin

FILES := \
	Makefile \
	dune-project \
	.gitignore \
	$(shell find $(SRC_DIRS) -name '*.ml' -or -name '*.mli' -or -name '*.mll' -or -name '*.mly' -or -name 'dune')

handin: lab2.zip

lab1.zip: $(FILES)
	zip $@ $^

.PHONY: nd clean native handin
