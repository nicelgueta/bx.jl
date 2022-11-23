module interfaces

using Parameters


function foo(test::Vector{Int64} = Int64[])
    append!(test, 1)
    println(test)
end

@doc """
Linked-list of rules to be executed sequentially
""" ->
@with_kw mutable struct BxRule 
    next::Union{BxRule, Nothing} = nothing
    nodeSymbol::Symbol
    nodeAttrs::Dict{AbstractString, AbstractString}
    nodeIndex::Union{Int, Nothing} = nothing
end

end # module