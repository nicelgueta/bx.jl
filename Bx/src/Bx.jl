module Bx

include("./algorithm.jl")

using .algorithm
using Gumbo
using HTTP


Base.@ccallable function julia_main()::Cint
    try
        real_main()
    catch
        Base.invokelatest(Base.display_error, Base.catch_stack())
        return 1
    end
    return 0
end

function real_main()
    # training

    tagged = open("../test_htmls/teset_bx.html") do file
        read(file, String)
    end
    tagged_doc = parsehtml(tagged)
    rules = algorithm.generateExtractionRules(tagged_doc, "test_tag")
    
    println("Precompiling HTTP")
    HTTP.request("GET", "https://google.com")
    println("Ready")
    while true
        println("\nEnter url: ")
        url = readline()
        untagged::String = String(HTTP.request("GET", url).body)
        untagged_doc = parsehtml(untagged)
        result = algorithm.executeRule(rules, untagged_doc, "test_tag")
        
        println("\nCaptured: \n$result\n")
    end
    
    return 0
end

if abspath(PROGRAM_FILE) == @__FILE__
    real_main()
end


end # module Bx
