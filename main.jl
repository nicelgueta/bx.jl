include("./interfaces.jl")
using .interfaces
using Gumbo

function checkNodeName(node::HTMLElement, name::Symbol)::Bool
    return tag(node) == name
end

function generateRules(htmlContent::String)::BxRule

end

function executeRule(rule::BxRule, currentNode::HTMLElement)::HTMLElement
    namedNodes::Vector{HTMLElement} = [
        n for n in currentNode.children if checkNodeName(n, rule.nodeSymbol)
    ]
    
end