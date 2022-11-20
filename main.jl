module main
include("interfaces.jl")

using .interfaces: BxRule
using Gumbo

function checkNodeName(node::HTMLElement, name::Symbol)::Bool
    return tag(node) == name
end

function generateExtractionRules(
    document::HTMLDocument, 
    extractionTagName::String
)::BxRule
    rootRule = BxRule(
        next=searchBxTag(document.root, extractionTagName),
        nodeSymbol=Symbol("root"),
        nodeAttrs = Dict()
    )
    return rootRule
end

function searchBxTag(
    current::HTMLText, 
    extractionTagName::String
)::Union{BxRule, Nothing}
    return nothing
end

function searchBxTag(
    current::HTMLElement, 
    extractionTagName::String,
)::Union{BxRule, Nothing}
    newRule::BxRule = BxRule(
        nodeSymbol=tag(current),
        nodeAttrs=attrs(current)
        # TODO: get index
    )
    if tag(current) == Symbol("bx-extraction") && getattr(current, "name") == extractionTagName
        return newRule
    end
    for child in current.children
        result = searchBxTag(child, extractionTagName)
        if result !== nothing
            newRule.next = result
            return newRule
        end
    end
    return nothing    
end


function executeRule(
    rule::BxRule, currentNode::HTMLElement
)::HTMLElement
    namedNodes::Vector{HTMLElement} = [
        n for n in currentNode.children 
            if 
            (
                checkNodeName(n, rule.nodeSymbol)
                &&
                (
                    n.attributes == rule.nodeAttrs
                    ||
                    index
                )
        )    
    ]
    
end

end
