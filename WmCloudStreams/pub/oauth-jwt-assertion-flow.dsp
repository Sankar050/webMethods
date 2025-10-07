<html>
	<head>
		<title>OAuth 2.0 JWT Assertion Flow</title>
		<script type="text/javascript" src="js/jquery-min.js"></script>
		<LINK REL="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css">
		</LINK>
		<link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>
		<SCRIPT SRC="../WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/messages.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/csConnection.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/oauth-util-functions.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/oauth-jwt-assertion-flow.js" type="text/javascript"></SCRIPT>
		<!--SCRIPT SRC="js/general-config.js"></SCRIPT-->
		<meta name="viewport" content="width=device-width, initial-scale=1">

		<style type="text/css">
			td:first-child { text-align: right }
		</style>
	</head>
	<body style="border-spacing: 0; border-width:0">
		<form action="#">
		
			<input type="hidden" name="passwordChange" value="false">
			<table id="ErrorTable" class="tableView" width="100%" />
				<tr id='status'>
					<td colspan=8 name='err_message_span' class='error' 
						style='text-align: left; padding-left: 35pt; word-break: break-word;' id='err_message_span'/>
				</tr>
			</table>
			<table id="EndPointTable" class="tableView" width="100%" />
			<table id="mainTable" class="tableView" width="100%" />
				<!-- all rows dynamically updated -->
					<!--table class='tableView' summary="Table to input CloudStreams Keystore runtime config information"-->
				<tbody>
					<tr>
						<td class="action" colspan="3" style="text-align: left">
							<input type="button" id="getAccessToken" value="Generate Access Token" width="100%"/>
						</td>
					</tr>
				</tbody>
			</table>
		</form>
	</body>
</html>