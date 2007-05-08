<%--
- Displays the Bookmark form for the specified options Command object.
- 
-  TODO - move as much of the code into parameters as possible
--%>
<%@ include file="include.jsp" %>
<%@ tag dynamic-attributes="attributes" isELIgnored="false" %>
<%@ attribute name="commandName"   required="true" %>
<%@ attribute name="formName"      required="true" %>
<%@ attribute name="entries"       required="true" type="java.util.Collection" %>
<%@ attribute name="hidden"        required="false" %>
<%@ attribute name="namespace"     required="false" %>
<%@ attribute name="actionInput"       required="false" %>
<%@ attribute name="idPathInput"       required="false" %>
<%@ attribute name="folderActionLabel" required="false" %>
<%@ attribute name="isErrorForm"       required="false" %>
    
    
<%--
For the errors
    setting the action, idPath, & type
    setting the folder action label
    populating the folder options
--%>
    
<c:if test="${hidden}">
    <c:set var="formClass" value="hidden" scope="page"/>
</c:if>
<c:if test="${empty folderActionLabel}">
    <c:set var="folderActionLabel"><spring:message code="portlet.entry.form.folder"/></c:set>
</c:if>

<portlet:actionURL var="formUrl"/>
<form:form id="${namespace}${formName}" name="${namespace}${formName}" method="POST" action="${formUrl}" commandName="${commandName}" cssClass="${formClass}">
    <input name="action" type="hidden" value="${actionInput}"/>
    <input name="idPath" type="hidden" value="${idPathInput}"/>

    <table padding="0">
        <c:if test="${isErrorForm}">
            <tr>
                <td colspan="3"><span class="portlet-msg-error"><spring:message code="portlet.entry.form.error.banner"/></span></td>
            </tr>
        </c:if>
        <tr>
            <td class="portlet-form-field-label" align="right"><spring:message code="portlet.entry.form.name"/></td>
            <td><form:input path="name" cssStyle="width: 250px;" cssClass="portlet-form-input-field"/></td>
            <td><form:errors cssClass="portlet-msg-error" path="name"/></td>
        </tr>
        <tr>
            <td class="portlet-form-field-label" align="right"><spring:message code="portlet.bookmark.form.url"/></td>
            <td><form:input path="url" cssStyle="width: 250px;" cssClass="portlet-form-input-field"/></td>
            <td><form:errors cssClass="portlet-msg-error" path="url"/></td>
        </tr>
        <tr>
            <td class="portlet-form-field-label" align="right" valign="top"><spring:message code="portlet.entry.form.note"/></td>
            <td><form:textarea path="note" cssStyle="width: 250px;" cssClass="portlet-form-input-field"></form:textarea></td>
            <td><form:errors cssClass="portlet-msg-error" path="note"/></td>
        </tr>
        
        <%-- Check to see if a folder exists in the list of children so the folder drop down is only displayed when a folder is availabe --%>
        <c:set var="folderRowClass" value="hidden" scope="page"/>
        <c:forEach items="${entries}" var="entry">
            <c:if test="${uwfn:instanceOf(entry, 'edu.wisc.my.portlets.bookmarks.domain.Folder')}">
                <c:set var="folderRowClass" value="" scope="page"/>
            </c:if>
        </c:forEach>
        <tr class="${folderRowClass}">
            <td class="portlet-form-field-label" id="${namespace}${formName}folderActionLabel" align="right" valign="top">${folderActionLabel}</td>
            <td>
                <select name="folderPath" style="width: 250px;">
                </select>
                
                <select name="referenceFolderPath" class="hidden" disabled="true">
                    <option cssClass="portlet-form-input-field" value="${bookmarkSet.id}"><spring:message code="portlet.entry.form.folder.none"/></option>
                    <bm:folderOptions depth="0" entries="${entries}" parentIdPath="${bookmarkSet.id}"/>
                </select>
            </td>
        </tr>
        
        <tr>
            <td/>
            <td>
                <form:checkbox id="newWindow" path="newWindow" cssClass="portlet-form-field"/>
                <label class="portlet-form-field-label" for="newWindow"><spring:message code="portlet.bookmark.form.newWindow"/></label>
            </td>
            <td><form:errors cssClass="portlet-msg-error" path="newWindow"/></td>
        </tr>
        <tr>
            <td align="right" colspan="2">
                <spring:message code="portlet.entry.form.save" var="portletFormSave"/>
                <input class="portlet-form-button" value="${portletFormSave}" type="submit"/>
                <spring:message code="portlet.entry.form.cancel" var="portletFormCancel"/>
                <input class="portlet-form-button" value="${portletFormCancel}" type="reset" onclick="cancelBookmark('${namespace}', '${formName}');"/>
            </td>
        </tr>
    </table>
</form:form>
