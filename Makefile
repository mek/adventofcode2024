.PHONY: all
all:
	@echo "Choose a target"
	@echo " day01"

.PHONY: day01
day01: bin/day01

.PHONY: clean
clean:
	@rm -f *~
	@rm -f src/*~

src/day%.c: src/day%.y
	@echo Making $@ from $<
	@$(YACC) $<
	@mv -f y.tab.c $@

bin/day%: src/day%.c
	@echo compiling $@
	@$(CC) $< -o $@

