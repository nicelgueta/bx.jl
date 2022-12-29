.PHONY: test
test:
	julia --project=./bx tests.jl

.PHONY: run
run:
	julia --project=./bx mytest.jl
