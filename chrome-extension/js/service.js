chrome.runtime.onInstalled.addListener(() => {
    chrome.contextMenus.create({
      "id": "tagElement",
      "title": "Tag element",
      "contexts": ["selection"],
    });
})
chrome.runtime.onInstalled.addListener(() => {
    chrome.contextMenus.create({
      "id": "downloadSource",
      "title": "Download page for bx",
      "contexts": ["page"],
    });
})

const tagElement = () => {
    const selection = document.getSelection()
    const node = selection.anchorNode;
    const wrapper = document.createElement("bx-tag")
    node.parentNode.appendChild(wrapper)
    wrapper.setAttribute("name", "test_tag")
    wrapper.appendChild(node)
    wrapper.style.backgroundColor = "#6ff542"
}

const downloadPage = () => {
    const download = (filename, text) => {
        const element = document.createElement('a');
        element.setAttribute('href', 'data:text/plain;charset=utf-8,' + encodeURIComponent(text));
        element.setAttribute('download', filename);
      
        element.style.display = 'none';
        document.body.appendChild(element);
      
        element.click();
      
        document.body.removeChild(element);
    }
    const htmlNode = document.getElementsByTagName("html")[0]
    const htmlNodeCopy = htmlNode.cloneNode(true)
    const wrapper = document.createElement("bx-wrapper")
    wrapper.appendChild(htmlNodeCopy)
    const htmlText = wrapper.innerHTML
    const pageTitle = document.title
    download(`${pageTitle}_bx_source.html`, htmlText)
}
chrome.contextMenus.onClicked.addListener(function(info, tab) {
    switch (info.menuItemId) {
        case "tagElement":
            chrome.scripting.executeScript({
                target: { tabId: tab.id },
                func: tagElement
            });
            break;
        case "downloadSource":
            chrome.scripting.executeScript({
                target: { tabId: tab.id },
                func: downloadPage
            });
            break;
        default:
            throw Error("Not a valid option")
    }
});
