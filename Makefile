.PHONY: all
all:
	@echo "Choose a target"
	@echo " day01"

.PHONY: day02
day02: bin/day02
	@$< -1 < data/$@/input
	@$< -2 < data/$@/input

.PHONY: day03
day03: bin/day03
	@echo $@ test data 1
	@$< < testdata/$@/input
	@echo $@ test data 2
	@$< < testdata/$@/input2
	@echo $@ data
	@$< < data/$@/input

bin/day03: src/day03.l src/day03.y
	@flex -l -o obj/day03.yy.c src/day03.l
	@yacc -d src/day03.y 
	@mv y.tab.c obj/day03.tab.c
	@mv y.tab.h obj/day03.tab.h
	@cc -lfl -o bin/day03 obj/day03.yy.c obj/day03.tab.c

bin/day05: src/day05.tcl
	@echo copy $< to $@
	@cp $< $@
	@chmod 0755 $@

bin/day08: src/day08.tcl
	@echo copy $< to $@
	@cp $< $@
	@chmod 0755 $@

# day 06 using the aoc library
obj/day06.o: src/day06.c
	@$(CC) -Wall -c $< -o $@

bin/day06: obj/day06.o lib/aoc.a include/aoc.h
	@$(CC) $(CCFLAGS) -O0 -g -s -o $@ obj/day06.o lib/aoc.a
	
# day 07 using the aoc library
obj/day07.o: src/day07.c
	@$(CC) -Wall -c $< -o $@

bin/day07: obj/day07.o lib/aoc.a include/aoc.h
	$(CC) $(CCFLAGS) -O0 -g -s -o $@ obj/day07.o lib/aoc.a

.PHONY: clean
clean:
	@rm -f *~
	@rm -f src/*~
	@rm -f lib/aoc.a
	@rm -f include/*~
	@rm -f obj/*

src/day%.c: src/day%.y
	@echo Making $@ from $<
	@$(YACC) $<
	@mv -f y.tab.c $@

bin/day%: src/day%.c
	@echo compiling $@
	@$(CC) $(CCFLAGS) -Wall $< -o $@

day%: bin/day%
	@echo $@ test data
	@$< < testdata/$@/input
	@echo $@ data
	@$< < data/$@/input

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
