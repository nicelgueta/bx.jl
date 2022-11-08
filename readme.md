# Automated HTML Scaper - in Julia

I wanted a really lightweight way to generate a set of rules to find a specific HTML node without having to either code the rule for it or parse HTML laboriously to find it.

The idea is that, for a specific HTML document (say a web page), using a web UI, I can "tag" the piece of text I'm looking to extract and then auto-generate a set of rules to find the immediate parent node of that tagged text. That means every new instance of this HTML document, I can simply execute the rule set to find the node I'm looking for, regardless of the new content.

## Illustration

As always, this is probably explained using an example.

Let's say we have the following HTML document containing stock price data that we're looking to extract

```html
<div>
    <section>
        <h6>Stocks</h6>
        <ul class="Stocks">
            <li>GOOG</li>
        <ul>
        <h6>Prices</h6>
        <ul class="prices">
            <li>254.34</li>
        </ul>
    </section>
</div>
```
Let's say we are looking to scrape two data elements from this document: `Stock Name` and `Stock Price`. For our auto-rule generator to work, using an (as yet undeveloped) UI to highlight the relevant data on our HTML document by wrapping the relevant info in an HTML tag.
```html
...
<li><bx-tag name="Stock Name">GOOG</bx-tag></li>
...
<li><bx-tag name="Stock Price">254.34</bx-tag></li>
```
The rule generator will look specifically for `bx-tag` html tags and work up the HTML tree to generate a rule to find it.
For example, for `Stock Price`, a psuedocode version of the rule set could look something like:
```
stock_names = String[]
from root:
    find `section` tag
    find `ul` tag at index 0
    foreach child `li` tag:
        append inner text to stock_names
```
We could generate a rule also for prices, the only difference being the index at which to find the `ul` tag.

`bx.jl` will be smarter than this however, and the rule generator will search for the **first uniquely identifiable tag** as it climbs up the HTML tree using a combination of indexes and HTML element attributes. 

So for our `Stock Name` rule, we could actually be left with something far simpler:
```
from root:
    dfs for `ul` tag with class="stocks"
    foreach child `li` tag:
        append inner text to stock_names
```
This is far more useful for webscraping as page updates are very likely to chop and change HTML element indexes, so finding elements by attribute is far more effective.

## Bx.jl objects

### 