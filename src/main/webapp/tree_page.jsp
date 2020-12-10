<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="aida" uri="http://aida.freehep.org/jsp20"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<html>
<head>
<title>AIDA Plots - <c:out value="${file}" /></title>
<base target="plotFrame">
</head>

<body>

    <aida:tree storeName="${file}" storeType="${storeType}" />

    <c:if test="${empty file}">
        <h3>file not set</h3>
    </c:if>

    <c:if test="${!empty file}">
        <aida:displaytree leafHref="plot_page.jsp?plotHref=%p" folderHref="plot_page.jsp?plotHref=%p" rootLabel="/"
            rootVisible="false" showItemCount="true" showFolderHrefForNodesWithLeavesOnly="true"
            storeName="${file}" />
    </c:if>

</body>
</html>
