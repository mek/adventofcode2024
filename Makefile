.PHONY: all
all:
	@echo "Choose a target"
	@echo " day01"

.PHONY: day01
day01: bin/day01
	@$< < data/day01/input

day02: bin/day02
	@$< -1 < data/day02/input
	@$< -2 < data/day02/input

.PHONY: clean
clean:
	@rm -f *~
	@rm -f src/*~
	@rm -f lib/aoc.a
	@rm -f obj/*

src/day%.c: src/day%.y
	@echo Making $@ from $<
	@$(YACC) $<
	@mv -f y.tab.c $@

bin/day%: src/day%.c
	@echo compiling $@
	@$(CC) $< -o $@

obj/aoc.o: src/aoc.c
	@$(CC) -Wall -c $< -o $@

lib/aoc.a: obj/aoc.o
	@rm -rf $@
	@ar cr $@ $<
	@ranlib $@ 

obj/test.o: src/test.c
	@$(CC) -Wall -c $< -o $@

.PHONY: test
test: bin/test
	@bin/test < testdata/test/input

bin/test: obj/test.o lib/aoc.a include/aoc.h
	@gcc -g -s -o bin/test obj/test.o lib/aoc.a
