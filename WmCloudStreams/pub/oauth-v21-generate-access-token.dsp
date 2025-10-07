<html>
	<head>
		<title>OAuth 2.1 - Generate Access Token</title>
		<script type="text/javascript" src="js/jquery-min.js"></script>
		<LINK REL="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css">
		</LINK>
		<link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>
		<SCRIPT SRC="../WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/messages.js" type="text/javascript"></SCRIPT>
		<script src="js/csConnection.js" type="text/javascript"></script>
		<SCRIPT SRC="js/oauth-util-functions.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/oauth-v21-generate-access-token.js" type="text/javascript"></SCRIPT>
		<style type="text/css">
			td:first-child { text-align: right };
		</style>
	</head>
	<body style="border-spacing: 0; border-width:0">
		<form action="#">
			<input type="hidden" name="passwordChange" value="false">


			<table class="tableView" width="100%">
				<tr id='status'>
					<td colspan=8 name='err_message_span' class='error' style='text-align: left; padding-left: 35pt; word-break: break-word; height:32px; display:none;' id='err_message_span'></td>
				</tr>
				<tr id="select_client_header"><td class="heading" colspan="2">Client Type</td></tr>
				<tr id="select_client_row">
					<td width="35%">Types</td>
					<td width="65%"><select id="client_types" onchange="getClientDetails(this.value);"></select></td>
				</tr>
			</table>
			<table id="PKCETable" class="tableView" width="100%" style="display:none;">
				<tr>
					<td class="heading" colspan="2">Proof Key Code Exchange (PKCE)</td>
				</tr>
				<tr>
					<td>Code Verifier</td>
					<td>
						<input id="code_verifier" size="60" name="code_verifier" value=""> &nbsp;&nbsp;
						<input type="button" id="generate_code_verifier" value="Generate" width="100%" onclick="generatePKCECodeVerifier();"/>
					</td>
				</tr>
				<tr>
                    <td width="35%">Code Challenge Method</td>
                    <td width="65%">
                        <select id="code_challenge_method">
                            <option value="plain">plain</option>
                            <option value="S256">SHA-256</option>
                        </select>
                    </td>
                </tr>
			</table>

			<table id="EndPointTable" class="tableView" width="100%" />


			<table id="mainTable" class="tableView" width="100%"/>
				<!-- all rows dynamically updated -->

				<table class="tableView" width="100%">
					<tr>
						<td class="heading" colspan=2>Proxy</td>
					</tr>
					<tr>
						<td nowrap width="35%">Proxy Server Alias</td>
						<td width="65%" style="padding-top: 0.5em; padding-right: 0.5em; padding-bottom: 0.5em; padding-left: 1em;">
							<select name="proxyAlias" id="proxyAlias">
								<option value=""></option>
								%invoke wm.server.proxy:getProxyServerList%
									%loop -struct proxyServerList%
									%scope #$key%
										<option %ifvar isDefault equals('Y')% selected %endif% >%value proxyAlias%</option>
									%endloop%
								%endinvoke%
							</select>
						</td>
					</tr>
				</table>
				<table style="margin-top: 10px" width=100%>
					<tr>
						<td class="action" colspan="3" style="text-align: left">
							<input type="button" id="authorize" value="Authorize" width="100%"/>
							<!--input type="button" id="next" value="Next" style="padding: 0px 15px;" width="100%" /-->
						</td>
					</tr>
				</table>
			</table>
			
		</form>
	</body>
</html>