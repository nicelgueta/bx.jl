.PHONY: test
test:
	julia --project=./Bx tests.jl

.PHONY: run
run:
	julia --project=./Bx mytest.jl
