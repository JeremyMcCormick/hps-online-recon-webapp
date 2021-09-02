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
    <c:if test="${not empty param.plotHref || not empty aidaPath}">

        <!--
            Get remote AIDA tree
        -->
        <aida:tree storeName="${storeName}" storeType="${storeType}" options="${options}"/>

        <c:if test="${!empty param.plotHref}">
            <c:set var="aidaPath" value="${param.plotHref}" scope="session" />
        </c:if>
        <c:set var="ref" value="plot_page.jsp?plotHref=${aidaPath}" />

        <!-- Get data from the AIDA Tree and put into "aidaObjects" variable -->
        <aida:objects storeName="${storeName}" path="${aidaPath}" var="aidaObjects"/>

        <c:set value="${fn:length(aidaObjects) == 1}" var="isSingle"/>
        <c:set value="${fn:length(aidaObjects) > 1}" var="isMultiple" />
        <c:set value="${fn:contains(aidaObjects[0], 'Histogram2D')}" var="isHistogram2D"/>
        <c:set value="${fn:contains(aidaObjects[0], 'DataPointSet')}" var="isDataPointSet"/>

        <!-- Create clickable Image Map for multiple data only (optional) -->
        <c:set var="imgMap" value="false" />
        <c:if test="${!empty aidaObjects && isMultiple eq true}">
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
                <aida:style type="zAxis">
                    <aida:attribute name="scale" value="log"/>
                </aida:style>
                <aida:style type="statisticsBox">
                    <aida:attribute name="isVisible" value="${not isHistogram2D && isSingle eq true}"/>
                </aida:style>
                <aida:style type="legendBox">
                    <aida:attribute name="isVisible" value="false"/>
                </aida:style>
                <aida:style type="data">
                    <aida:style type="errorBar">
                        <aida:attribute name="isVisible" value="false"/>
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
                <c:if test="${isSingle eq true}">
                    <aida:style type="title">
                        <aida:style type="text">
                            <aida:attribute name="fontSize" value="20"/>
                        </aida:style>
                    </aida:style>
                </c:if>
            </aida:style>

            <aida:region href="${ref}/${aida:objectName(aidaObjects[status.index])}">
                <aida:plot var="${aidaObjects[status.index]}">
                    <aida:style type="plotter">
                        <aida:style type="yAxis">
                            <aida:attribute name="allowZeroSuppression" value="false"/>
                        </aida:style>
                        <c:if test="${isDataPointSet eq true}">
                            <aida:style type="data">
                                <aida:style type="marker">
                                    <aida:attribute name="color" value="blue" />
                                    <aida:attribute name="size" value="5" />
                                    <aida:attribute name="shape" value="diamond" />
                                </aida:style>
                                <aida:style type="errorBar">
                                    <aida:attribute name="isVisible" value="false" />
                                </aida:style>
                                <aida:style type="outline">
                                    <aida:attribute name="isVisible" value="true" />
                                    <aida:attribute name="color" value="black" />
                                    <aida:attribute name="lineType" value="solid" />
                                    <aida:attribute name="thickness" value="1" />
                                </aida:style>
                            </aida:style>
                            <aida:style type="xAxis">
                                <aida:attribute name="type" value="date"/>
                            </aida:style>
                        </c:if>
                    </aida:style>
                </aida:plot>
            </aida:region>
        </aida:plotset>
    </c:if>

</body>
</html>
