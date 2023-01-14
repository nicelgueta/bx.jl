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

document.onmousemove = () => {
    
}

const tagElement = () => {
    // const selection = document.getSelection()
    // const node = selection.anchorNode;
    // const wrapper = document.createElement("bx-tag")
    // node.parentNode.appendChild(wrapper)
    // wrapper.setAttribute("name", "test_tag")
    // wrapper.appendChild(node)
    // wrapper.style.backgroundColor = "#6ff542"
    wrapperDiv = document.createElement("div");
    console.log(window.event)
    wrapperDiv.setAttribute(
        "style","position: absolute; left: 0px; top: 0px; background-color: rgb(255, 255, 255); opacity: 0.5; z-index: 2000; height: 1083px; width: 100%;");
    wrapperDiv.setAttribute("id", "bx-modal-wrapper")

    iframeElement = document.createElement("iframe");
    iframeElement.setAttribute("style","width: 100%; height: 100%;");

    wrapperDiv.appendChild(iframeElement);


    modalDialogParentDiv = document.createElement("div");
    modalDialogParentDiv.setAttribute("style","position: absolute; width: 350px; border: 1px solid rgb(51, 102, 153); padding: 10px; background-color: rgb(255, 255, 255); z-index: 2001; overflow: auto; text-align: center; top: 149px; left: 497px;");
    modalDialogParentDiv.setAttribute("id", "bx-modal-dialog")

    modalDialogSiblingDiv = document.createElement("div");

    modalDialogTextDiv = document.createElement("div"); 
    modalDialogTextDiv.setAttribute("style" , "text-align:center");

    modalDialogTextSpan = document.createElement("span"); 
    modalDialogText = document.createElement("strong"); 
    modalDialogText.innerHTML = "Processing...  Please Wait.";

    breakElement = document.createElement("br"); 
    imageElement = document.createElement("img"); 
    imageElement.src = "https://www.gravatar.com/avatar/2758be6ff7a39f2914b24645fae68550?s=64&d=identicon&r=PG&f=1";

    modalDialogTextSpan.appendChild(modalDialogText);
    modalDialogTextDiv.appendChild(modalDialogTextSpan);
    modalDialogTextDiv.appendChild(breakElement);
    modalDialogTextDiv.appendChild(breakElement);
    modalDialogTextDiv.appendChild(imageElement);

    modalDialogSiblingDiv.appendChild(modalDialogTextDiv);
    modalDialogParentDiv.appendChild(modalDialogSiblingDiv);

    document.body.appendChild(wrapperDiv);
    document.body.appendChild(modalDialogParentDiv);
    
}

const removeModal = () => {
    document.getElementById("bx-modal-wrapper").remove()
    document.getElementById("bx-modal-dialog").remove()
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
