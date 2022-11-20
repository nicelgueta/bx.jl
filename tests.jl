include("main.jl")

using .main
using Test
using Gumbo


function test_e2e_generate(file_name::String, tagName::String)::Symbol
    a = open("$file_name.html") do file
        read(file, String)
    end

    document = parsehtml(a)
    ruleRoot::main.BxRule = main.generateExtractionRules(document, tagName)
    rule = ruleRoot
    while rule.next !== nothing
        rule = rule.next
    end
    return rule.nodeSymbol
end

function test_e2e_exe(file_name::String, tagName::String)::String
    untagged = open("$file_name.html") do file
        read(file, String)
    end
    tagged = open(file_name * "_tagged.html") do file
        read(file, String)
    end
    tagged_document = parsehtml(tagged)
    untagged_document = parsehtml(untagged)
    ruleRoot::main.BxRule = main.generateExtractionRules(tagged_document, tagName)
    text = main.executeRule(ruleRoot, untagged_document)
    return text

end


@testset "Bx e2e rule generation tests" begin
    @test test_e2e_generate("mini_tagged", "world") == Symbol("bx-tag")
    @test test_e2e_generate("test_tagged", "complexField") == Symbol("bx-tag")
end

@testset "Bx e2e rule execution tests" begin
    @test test_e2e_exe("mini", "world") == "world"
    @test test_e2e_exe("test", "complexField") == "In this repository"
end