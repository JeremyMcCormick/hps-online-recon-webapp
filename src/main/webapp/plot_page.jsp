<%@page contentType="text/html" import="org.freehep.graphicsio.gif.GIFImageWriteParam,org.freehep.graphicsio.raw.RawImageWriteParam"%>
<%@page pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="aida" uri="http://aida.freehep.org/jsp20"%>
<%@page isELIgnored="false"%>

<head>
<title>AIDA Plot Frame</title>
<base target="_self">
</head>
<body>

    <!-- If nothing to plot (empty path) -->
    <c:if test="${empty param.plotHref && empty aidaPath}">
        <h3>
            <b>Select Plots from the Tree</b>
        </h3>
    </c:if>

    <!-- Do plotting only if path is non-empty -->
    <c:if test="${!empty param.plotHref || !empty aidaPath}">

        <!--
            Get remote AIDA tree
        -->
        <aida:tree storeName="${treeBindName}" storeType="${storeType}" options="${aidaOptions}"/>

        <c:if test="${!empty param.plotHref}">
            <c:set var="aidaPath" value="${param.plotHref}" scope="session" />
        </c:if>
        <c:set var="ref" value="plot_page.jsp?plotHref=${aidaPath}" />

        <!-- Get data from the AIDA Tree and put into "aidaObjects" variable -->
        <aida:objects storeName="${treeBindName}" path="${aidaPath}" var="aidaObjects">
        </aida:objects>

        <c:set value="${fn:contains(aidaObjects[0], 'Histogram2D')}" var="isHistogram2D"/>
        <h3>
            <b>Path:</b> ${aidaPath}<br/>
        </h3>

        <!-- Create clickable Image Map for multiple data only (optional) -->
        <c:set var="imgMap" value="false" />
        <c:if test="${!empty aidaObjects && fn:length(aidaObjects) > 1}">
            <c:set var="imgMap" value="true" />
        </c:if>

        <!-- Plot single or multiple data using "plotset" tag -->
        <aida:plotset statusvar="status" nplots="${fn:length(aidaObjects)}" createImageMap="${imgMap}"
            allowDownload="true" format="png">

            <!-- Display the default navigation bar inside the Table (optional) -->
            <aida:plotsetbar var="barVar" url="${ref}">
                <c:if test="${barVar.npages > 1}">
                    <table bgcolor="D0D0D0" border="1">
                        <tr>
                            <td>&nbsp;${barVar.defaultbar}&nbsp;</TD>
                        </tr>
                    </table>
                    <br/>
                </c:if>
            </aida:plotsetbar>

            <!-- plotter style -->
            <aida:style>
                <aida:attribute name="hist2DStyle" value="colorMap"/>
                <aida:style type="statisticsBox">
                <aida:attribute name="isVisible" value="${!isHistogram2D && fn:length(aidaObjects) == 1}"/>
                </aida:style>
                <aida:style type="legendBox">
                    <aida:attribute name="isVisible" value="false"/>
                </aida:style>
                <aida:style type="data">
                    <aida:style type="errorBar">
                        <aida:attribute name="isVisible" value="true"/>
                    </aida:style>
                    <aida:style type="fill">
                        <aida:attribute name="color" value="blue"/>
                        <aida:attribute name="colorMapScheme" value="rainbow"/>
                        <aida:attribute name="showZeroHeightBins" value="false"/>
                    </aida:style>
                    <aida:style type="line">
                        <aida:attribute name="color" value="black"/>
                    </aida:style>
                    <aida:style type="marker">
                        <aida:attribute name="isVisible" value="true"/>
                        <aida:attribute name="size" value="1"/>
                        <aida:attribute name="color" value="blue"/>
                    </aida:style>
                </aida:style>
                <c:if test="${fn:length(aidaObjects) == 1}">
                    <aida:style type="title">
                        <aida:style type="text">
                            <aida:attribute name="fontSize" value="20"/>
                        </aida:style>
                    </aida:style>
                </c:if>
            </aida:style>

            <aida:region href="${ref}/${aida:objectName(aidaObjects[status.index])}">
                <aida:plot var="${aidaObjects[status.index]}">
                </aida:plot>
            </aida:region>

        </aida:plotset>
    </c:if>

</body>
</html>
