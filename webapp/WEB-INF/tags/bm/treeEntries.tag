<%--
- Renders a list of entries in LI tags
- 
-  TODO - move as much of the code into parameters as possible
--%>
<%@ include file="include.jsp" %>
<%@ tag dynamic-attributes="attributes" isELIgnored="false" %>
<%@ attribute name="treeName"      required="true" %>
<%@ attribute name="entries"       required="true" type="java.util.Collection" %>
<%@ attribute name="parentIdPath"  required="true" %>
<%@ attribute name="namespace"     required="false" %>

<c:forEach items="${entries}" var="bookmarkEntry">
    <c:set var="entryIdPath" value="${parentIdPath}.${bookmarkEntry.id}"/>
   
    <portlet:actionURL var="deleteEntryUrl">
        <portlet:param name="action" value="deleteEntry"/>
        <portlet:param name="entryIndex" value="${entryIdPath}"/>
    </portlet:actionURL>
    
    <%-- Need to zero out page scoped parameters since they seem to be scoped to more than just the .tag file --%>
    <c:set var="entryUrlOnClick"/>
    <c:set var="folderImgSufix"/>
    
    <c:set var="isFolder" value="${uwfn:instanceOf(bookmarkEntry, 'edu.wisc.my.portlets.bookmarks.domain.Folder')}"/>
    <c:choose>
        <c:when test="${isFolder}">
            <c:choose>
                <c:when test="${options.saveFolderState}">
                    <portlet:actionURL var="entryUrl">
                        <portlet:param name="action" value="toggleFolder"/>
                        <portlet:param name="folderIndex" value="${entryIdPath}"/>
                    </portlet:actionURL>
                </c:when>
                <c:otherwise>
                    <c:set var="entryUrl"    value="#"/>
                    <c:set var="entryUrlOnClick" >onclick="toggleFolder('${namespace}', '${entryIdPath}', '${pageContext.request.contextPath}');return false;"</c:set>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${options.saveFolderState && bookmarkEntry.minimized}">
                    <c:set var="folderImgSufix" >closed</c:set>
                </c:when>
                <c:otherwise>
                    <c:set var="folderImgSufix" >opened</c:set>
                </c:otherwise>
            </c:choose>
            <c:set var="entryImg"      value="${pageContext.request.contextPath}/img/folder-${folderImgSufix}.gif"/>

            <spring:message code="portlet.entry.folder.desc" arguments="${bookmarkEntry.name}" var="entryDescText"/>
            <spring:message code="portlet.entry.folder.edit" arguments="${bookmarkEntry.name}" var="entryEditText"/>
            <spring:message code="portlet.entry.folder.delete" arguments="${bookmarkEntry.name}" var="entryDeleteText"/>
            
            <c:set var="entryType"     value="folder"/>
        </c:when>
        <c:otherwise>
            <c:set var="entryUrl"        value="${bookmarkEntry.url}"/>
            <c:if test="${uwfn:isState(renderRequest.windowState, 'EXCLUSIVE') || bookmarkEntry.newWindow}">
                <c:set var="entryTarget" >target="_blank"</c:set>
            </c:if>
            <c:set var="entryImg"      value="${pageContext.request.contextPath}/img/bookmark.gif"/>

            <spring:message code="portlet.entry.bookmark.desc" arguments="${bookmarkEntry.name}" var="entryDescText"/>
            <spring:message code="portlet.entry.bookmark.edit" arguments="${bookmarkEntry.name}" var="entryEditText"/>
            <spring:message code="portlet.entry.bookmark.delete" arguments="${bookmarkEntry.name}" var="entryDeleteText"/>
            
            <c:set var="entryType"     value="bookmark"/>
        </c:otherwise>
    </c:choose>
        
    <li id="${namespace}${treeName}TreeItem" class="bookmarkListItem">
        <a id="${namespace}url_${entryIdPath}" 
            href="${entryUrl}" ${entryUrlOnClick} ${entryTarget} 
            title="${bookmarkEntry.noteLines[0]}"><img id="${namespace}entryImg_${entryIdPath}" src="${entryImg}" border="0" alt="${entryDesc}"/>
            <span id="${namespace}name_${entryIdPath}" class="portlet-font">${bookmarkEntry.name}</span></a>
        
        <span class="padding"></span>
        
        <%-- Need both ID (for IE) and NAME (for FF/Opera) --%>
        <span id="${namespace}entryEditButtons" name="${namespace}entryEditButtons" class="hidden">
            <a href="javascript:void(0);" onclick="editEntry('${namespace}', '${entryType}', '${parentIdPath}', '${entryIdPath}');return false;"
                title="${entryEditText}"><img src="${pageContext.request.contextPath}/img/edit.gif" alt="${entryEditText}"/></a>
            
            <a href="javascript:void(0);"
                onclick="deleteEntry('${namespace}', '${entryType}', '${entryIdPath}', '${deleteEntryUrl}');return false;" 
                title="${entryDeleteText}"><img src="${pageContext.request.contextPath}/img/delete.gif" alt="${entryDeleteText}"/></a>
        </span>

        <span id="${namespace}note_${entryIdPath}" class="hidden">${bookmarkEntry.note}</span>
        
        <c:if test="${isFolder && (!options.saveFolderState || (options.saveFolderState && !bookmarkEntry.minimized))}">
            <c:if test="${options.saveFolderState && bookmarkEntry.minimized}">
                <c:set var="childrenHiddenClass" value="hidden"/>
            </c:if>

            <bm:treeFolder treeName="${treeName}" folderIdSuffix="ChildFolder" entries="${bookmarkEntry.sortedChildren}" parentIdPath="${entryIdPath}" namespace="${portletNamespace}" cssClass="subBookmarkList ${childrenHiddenClass}"/>
        </c:if>
    </li>
</c:forEach>
