using Parameters


@doc """
Linked-list of rules to be executed sequentially
""" ->
@with_kw struct BxRule 
    nextRule::Union{BxRule, Nothing} = nothing
    nodeSymbol::Symbol
    nodeAttrs::Dict{AbstractString, AbstractString}
    nodeIndex::Union{Int, Nothing} = nothing
end

