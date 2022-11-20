include("main.jl")

using .main
using Test
using Gumbo


function test_e2e_mini()
    a = open("mini.html") do file
        read(file, String)
    end

    document = parsehtml(a)
    ruleRoot::main.BxRule = main.generateExtractionRules(document, "world")
    rule = ruleRoot
    while rule.next !== nothing
        rule = rule.next
    end
    return rule.nodeSymbol
end

@testset "Bx Tests" begin
    @test test_e2e_mini() == Symbol("bx-extraction")
end