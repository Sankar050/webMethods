<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
        "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <title>Integration Server - CloudStreams Settings</title>
    <link rel="stylesheet" href="/WmRoot/webMethods.css" type="text/css"/>
    <link rel="stylesheet" href="css/jquery-ui.min.css" type="text/css"/>
    <link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>
    <link rel="stylesheet" href="css/services.css" type="text/css"/>
    <link rel="stylesheet" href="css/messages.css" type="text/css"/>

    <script src="js/jquery-min.js" type="text/javascript"></script>
    <script src="js/jquery-ui.min.js" type="text/javascript"></script>
    <script src="js/cloudstreams.js" type="text/javascript"></script>
    <script src="js/services.js" type="text/javascript"></script>
	<script LANGUAGE="JavaScript" >
		function changeTab(str)
		{
			document.getElementById(str).click();
		}
	</script>
	<style>
		.ui-tabs .ui-tabs-nav li{
			height: 2em;
		}
		.ui-tabs .ui-tabs-nav
		{
			background-color: #666666;
		}
		.ui-state-active a, .ui-state-active a:link
		{
			color: #212121;
		}

		.ui-tabs .ui-tabs-panel /* just in case you want to change the panel */
		{
			background: white;
			border-color: grey;
		}
		.ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited, .ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active
		{
			background: #ffffff;
			background-color: #ffffff;
			color: #212121;
		}
	</style>
</head>
<body>

<div id="heading" class="breadcrumb">
    CloudStreams &gt; Administration &gt; Virtual Services
</div>


<div id="container">
    <div id="tabs">
        <ul class="listitems">
            <li onclick="changeTab('tab1')" ><a id="tab1" href="#tabs-1">Connector Virtual Services</a></li>
            <li onclick="changeTab('tab2')" ><a id="tab2" href="#tabs-2">Virtual Services</a></li>
        </ul>
        <div id="tabs-1">
            %invoke cloudstreams.services:getConnectorServices%
            %ifvar packagesWithConnectorServices%
                %loop packagesWithConnectorServices%
                <div class="packageDetails">
                    <div class="pkgHeader">
                        <img src="images/ns_package.gif" alt="IS package"/>
                        <span class="pkgName">%value packageName%</span>
                    </div>
                    %ifvar connectorServices -notempty%
                        %loop connectorServices%
                        <div class="virtualServices">
                            <div class="vsHeader" margin-bottom=5px>
                                <img src="images/Service16.gif" alt="Virtual Service">
                                <span class="vsName">%value virtualServiceName%</span>
                            </div>
                            %ifvar keys -notempty%
                            <table class="connectorServicesAndKeys tableView">
                                <thead>
                                <tr>
                                    <td>Connector Service</td>
                                    <td>Collection Key</td>
                                </tr>
                                </thead>
                                <tbody>
                                %loop keys%
                                    <tr>
                                        <td>%value connectorServiceName%</td>
                                        <td>%value key%</td>
                                    </tr>
                                %endloop%
                                </tbody>
                            </table>
                            %else%
                            <div class="noKeys">No Connector Services using this Virtual Service</div>
                            %endif%
                        </div>
                        %endloop%
                    %else%
                    <div class="noVS">No Virtual Services in this package</div>
                    %endif%
                </div>

                %endloop%
            %else%
                <div class="info">No Connector Virtual Services found!</div>
            %endif%
            %onerror%
                <div class="error">
                    <div>Error retrieving Connector Virtual Services! Please check the server log!</div>
                    <div>%value errorMessage%</div>
                </div>
            %endinvoke%
        </div>
        <div id="tabs-2">
            %include virtual-services.dsp%
        </div>
    </div>
</div>


</body>
</html>