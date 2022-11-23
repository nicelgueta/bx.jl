module algorithm


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
    extractionTagName::String,
    currentIndex::Int64
)::Union{BxRule, Nothing}
    return nothing
end

function searchBxTag(
    current::HTMLElement, 
    extractionTagName::String,
    currentIndex::Int64 = 0
)::Union{BxRule, Nothing}
    newRule::BxRule = BxRule(
        nodeSymbol=tag(current),
        nodeAttrs=attrs(current),
        nodeIndex=currentIndex
    )
    if tag(current) == Symbol("bx-tag") && getattr(current, "name") == extractionTagName
        return newRule
    end
    for (childIndex, child) in enumerate(current.children)
        result = searchBxTag(child, extractionTagName, childIndex)
        if result !== nothing
            newRule.next = result
            return newRule
        end
    end
    return nothing    
end


function executeRule(
    rootRule::BxRule, document::HTMLDocument, field:: String
)::AbstractString
    if rootRule.nodeSymbol !== Symbol("root")
        throw("Rule linked list must begin with rule 'root'")
    end
    rootNode::HTMLElement = document.root
    return executeRule(rootRule.next, rootNode, field)
end 


function executeRule(
    rule::BxRule, currentElement::HTMLElement, field::String
)::AbstractString
    # TODO fix logic with the root vs HTML starter node
    # remove the not pretty workaround below
    if rule.nodeSymbol == Symbol("HTML")
        rule = rule.next        
    end
    winningChild::Union{HTMLElement, Nothing} = nothing
    for (childIndex, child) in enumerate(currentElement.children)
        if tag(child) == rule.nodeSymbol
            if child.attributes == rule.nodeAttrs
                if childIndex == rule.nodeIndex
                    if rule.next.nodeSymbol == Symbol("bx-tag")
                        return text(child)
                    else
                        return executeRule(rule.next, child, field)                
                    end
                else
                    # matches attrs but not index
                    # carry on loop to check if any do match index
                    winningChild = child
                end
            end
        end
    end
    if winningChild !== nothing
        # none matched on index but we do have one that matched on
        # attrs so proceed with that one
        if rule.next.nodeSymbol == Symbol("bx-tag")
            return text(winningChild)
        else
            return executeRule(rule.next, winningChild, field)                
        end
    end
    eleToFind = string(rule.nodeSymbol)
    attrs = rule.nodeAttrs
    throw("$field: Could not find element $eleToFind with attrs $attrs")
    
end


end # module


