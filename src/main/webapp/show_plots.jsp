<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<html>
<head>
<title>HPS Online Reconstruction</title>
</head>
<script>
ws = new WebSocket('${notifier}');
ws.onmessage = function(event) {
    try {
    	plotFrame = document.getElementById('plotFrame').contentWindow;
    	if (plotFrame.document.getElementsByTagName('img').length >= 1) {
    		console.log(event.data);
    		console.log(plotFrame.location.href);
    		plotFrame.location.reload(true);
    	}
    } catch (e) {
    }
}
</script>
<body>
    <iframe id="treeFrame" src="tree_page.jsp" name="treeFrame" height="100%" width="30%"></iframe>
    <iframe id="plotFrame" src="plot_page.jsp" name="plotFrame" height="100%" width="68%"></iframe>
</body>
</html>
