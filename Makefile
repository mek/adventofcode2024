.PHONY: all
all:
	@echo "Choose a target"
	@echo " day01"

.PHONY: day01
day01: bin/day01
	@$< < data/day01/input

.PHONY: day02
day02: bin/day02
	@$< -1 < data/day02/input
	@$< -2 < data/day02/input

.PHONY: day03
day03: bin/day03

bin/day03: src/day03.l src/day03.y
	@flex -l -o obj/day03.yy.c src/day03.l
	@yacc -d src/day03.y 
	@mv y.tab.c obj/day03.tab.c
	@mv y.tab.h obj/day03.tab.h
	@cc -lfl -o bin/day03 obj/day03.yy.c obj/day03.tab.c
	@echo test data 1
	@bin/day03  < testdata/day03/input
	@echo test data 2
	@bin/day03  < testdata/day03/input2
	@echo data
	@bin/day03  < data/day03/input

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
