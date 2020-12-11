<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="aida" uri="http://aida.freehep.org/jsp20"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<html>
<head>
<title>AIDA Plots - <c:out value="${treeBindName}" /></title>
<base target="plotFrame">
</head>

<body>

    <aida:tree storeName="${treeBindName}" storeType="${storeType}" options="${aidaOptions}"/>

    <c:if test="${empty treeBindName}">
        <h3>treeBindName not set</h3>
    </c:if>

    <c:if test="${!empty treeBindName}">
        <aida:displaytree leafHref="plot_page.jsp?plotHref=%p" folderHref="plot_page.jsp?plotHref=%p" rootLabel="/"
            rootVisible="false" showItemCount="true" showFolderHrefForNodesWithLeavesOnly="true"
            storeName="${treeBindName}" />
    </c:if>

</body>
</html>
