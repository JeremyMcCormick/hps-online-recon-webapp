<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="aida" uri="http://aida.freehep.org/jsp20"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@page isELIgnored="false"%>

<html>
<head>
<title>AIDA Plots - <c:out value="${storeName}" /></title>
<base target="plotFrame">
</head>

<body>

    <aida:tree storeName="${storeName}" storeType="${storeType}" options="${options}"/>

    <c:if test="${empty storeName}">
        <h3>storeName not set</h3>
    </c:if>

    <c:if test="${!empty storeName}">
        <aida:displaytree leafHref="plot_page.jsp?plotHref=%p" folderHref="plot_page.jsp?plotHref=%p" rootLabel="/"
            rootVisible="true" showItemCount="true" showFolderHrefForNodesWithLeavesOnly="true"
            storeName="${storeName}" />
    </c:if>

</body>
</html>
