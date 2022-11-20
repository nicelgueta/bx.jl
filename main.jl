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
    if tag(current) == Symbol("bx-tag") && getattr(current, "name") == extractionTagName
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
    rootRule::BxRule, document::HTMLDocument
)::AbstractString
    if rootRule.nodeSymbol !== Symbol("root")
        throw("Rule linked list must begin with rule 'root'")
    end
    rootNode::HTMLElement = document.root
    return executeRule(rootRule.next, rootNode)
end 

function executeRule(
    rule::BxRule, currentElement::HTMLElement
)::AbstractString
    # TODO fix logic with the root vs HTML starter node
    if rule.nodeSymbol == Symbol("HTML")
        rule = rule.next        
    end
    for child in currentElement.children
        if tag(child) == rule.nodeSymbol
            if child.attributes == rule.nodeAttrs
                if rule.next.nodeSymbol == Symbol("bx-tag")
                    return text(child)
                else
                    return executeRule(rule.next, child)                
                end
            end
        end
    end
    eleToFind = string(rule.nodeSymbol)
    attrs = rule.nodeAttrs
    throw("Could not find element $eleToFind with attrs $attrs")
    
end


end


