function insertLink() { 
    var title = document.forms["link"].title.value;
    var prefix = '/' + PUBLICATION_ID + '/' + AREA;
    var url = document.forms["link"].url.value;
    if (url.charAt(0) == "/") {
     // prepend hostname etc for internal links
     url = prefix + url;
    }
    window.opener.SetUrl(url); 
    window.opener.document.getElementById('txtAttTitle').value = title ; 
    window.close();
}

function setLink(src) { 
    url = src;
    document.forms["link"].url.value = url;
}

function LinkTree(doc, treeElement) {
    this.doc = doc;
    this.treeElement = treeElement;
    this.selected = null;
}

LinkTree.prototype = new NavTree;

LinkTree.prototype.handleItemClick = function(item, event) {
    setLink('/' + item.href);
}

function buildTree() {
    var placeholder = document.getElementById('tree');
    var tree = new LinkTree(document, placeholder);
    tree.init(PUBLICATION_ID);
    tree.render();
    tree.loadInitialTree(AREA, DOCUMENT_ID);
}
