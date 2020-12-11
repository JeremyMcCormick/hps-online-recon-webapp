<%@page contentType="text/html"%>
<%@page pageEncoding="UTF-8"%>

<head>
<title>Show Plots</title>
<style type="text/css">
    label { margin-right: 20px; }
    input { margin-top:   5px;  }
</style>
<base target="_self">
</head>
<body>
    <h4>Connect to a Remote AIDA Server</h4>
    <form action="show_plots" method="GET" target="_blank">
        <fieldset>
	        <label for="host">Host</label><input type="text" name="host"/><br/>
	        <label for="port">Port</label><input type="text" name="port"/><br/>
	        <label for="name">Name</label><input type="text" name="name"/><br/>
        </fieldset>
        <input type="submit" value="Show Plots" />
    </form>
</body>
</html>
