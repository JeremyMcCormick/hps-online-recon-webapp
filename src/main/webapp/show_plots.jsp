<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<%@taglib prefix="aida" uri="http://aida.freehep.org/jsp20"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<html>
<body>
    <h3>Remote AIDA Server: <c:out value="${treeBindName}"/><br/>
        Options: <c:out value="${aidaOptions}"/>
    </h3>
    <iframe src="tree_page.jsp" name="treeFrame" height="100%" width="30%"></iframe>
    <iframe src="plot_page.jsp" name="plotFrame" height="100%" width="68%"></iframe>
</body>
</html>
