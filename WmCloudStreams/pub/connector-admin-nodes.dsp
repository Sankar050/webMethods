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
		.ui-state-active a, .ui-state-active a:link, .ui-state-active a:visited
		{
			color: #212121;
		}

		.ui-tabs .ui-tabs-panel /* just in case you want to change the panel */
		{
			background: white;
			border-color: grey;
		}
		.ui-state-active, .ui-widget-content .ui-state-active, .ui-widget-header .ui-state-active
		{
			background: #ffffff;
			background-color: #ffffff;
			color: #212121;
		}
	</style>
</head>

<body>
	<div id="heading" class="breadcrumb">
		CloudStreams &gt; Providers &gt; %value groupName% &gt; %value connectorName%
	
	</div>

	

<div id="container">
    <div id="tabs">
        <ul class="listitems">
            <li onclick="changeTab('tab1')" ><a id="tab1" href="#tabs-1">Connections</a></li>
            <li onclick="changeTab('tab2')" ><a id="tab2" href="#tabs-2">Listeners</a></li>
        </ul>
        <div id="tabs-1">
			<tr>
				%include connection-list.dsp%
			<tr>
        </div>
        <div id="tabs-2">
			<tr>
				%include listener-list.dsp%
			</tr>
        </div>
    </div>
</div>


</body>
</html>
