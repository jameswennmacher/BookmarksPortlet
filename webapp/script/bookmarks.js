var knownEntryTypes = new Array()
knownEntryTypes[0] = 'folder';
knownEntryTypes[1] = 'bookmark';


/***** Public Methods *****/
function newEntry(type, namespace) {
    showForm(type, namespace);
}

function cancelEntry(namespace) {
    hideForm(namespace);
}

function editEntry(type, namespace, parentFolderIndexPath, entryIndexPath) {
    showForm(type, namespace);
    
    var form = getForm(namespace);
    
    form.elements['indexPath'].value = entryIndexPath;
    form.elements['type'].value = type;

    form.elements['name'].value = getNamespacedElement(namespace, 'name_' + entryIndexPath).innerHTML;
    form.elements['note'].value = getNamespacedElement(namespace, 'note_' + entryIndexPath).innerHTML;;
    
    if (type == 'bookmark') {
        var entryUrl = getNamespacedElement(namespace, 'url_' + entryIndexPath);
        form.elements['url'].value = entryUrl.href;
        form.elements['newWindow'].checked = (entryUrl.target != "");
    }

    //Select the folder the entry is in
    var folderOpts =  form.elements['folderPath'].options;
    for (var index = 0; index < folderOpts.length; index++) {
        if (folderOpts[index].value == parentFolderIndexPath) {
            folderOpts[index].selected = true;
        }
        else {
            folderOpts[index].selected = false;
        }

        if (folderOpts[index].value.indexOf(entryIndexPath) == 0) {
            folderOpts[index].disabled = true;
        }
        else {
            folderOpts[index].disabled = false;
        }
    }
}




/***** Internal Methods *****/
function getForm(namespace) {
    return document.forms[namespace + 'bookmarksForm'];
}
function getNamespacedElement(namespace, elementId) {
    return document.getElementById(namespace + elementId);
}
function hideElement(namespace, elementId) {
    var element = getNamespacedElement(namespace, elementId);
    element.style.display = 'none';
}
function showDiv(namespace, elementId) {
    var element = getNamespacedElement(namespace, elementId);
    element.style.display = 'block';
}
function showTableRow(namespace, elementId) {
    var element = getNamespacedElement(namespace, elementId);
    element.style.display = '';
}

function showForm(type, namespace) {
    var form = getForm(namespace);
    form.reset();
    
    //Reset doesn't seem to affect hidden fields: 
    form.elements['indexPath'].value = "";
    form.elements['type'].value = "";
    form.elements['action'].value = "";

    if (type == 'bookmark') {
        form.elements['action'].value = 'saveBookmark';
        
        form.elements['url'].disabled = false;
        form.elements['newWindow'].disabled = false;
        showTableRow(namespace, 'urlRow');
        showTableRow(namespace, 'newWindowRow');
    }
    else {
        form.elements['action'].value = 'saveFolder';
        
        form.elements['url'].disabled = true;
        form.elements['newWindow'].disabled = true;
        hideElement(namespace, 'urlRow');
        hideElement(namespace, 'newWindowRow');
    }

    showDiv(namespace, 'bookmarksDiv');
}

function hideForm(namespace) {
    hideElement(namespace, 'bookmarksDiv');
    getForm(namespace).reset();
}
