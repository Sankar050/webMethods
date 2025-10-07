<html>
	<head>
		<title>Configure Listener</title>
		<script type="text/javascript" src="js/jquery-min.js"></script>
		<LINK REL="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css">
		</LINK>
		<link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>		
		<SCRIPT SRC="../WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/messages.js" type="text/javascript"></SCRIPT>
		<script src="js/csConnection.js" type="text/javascript"></script>
		<SCRIPT SRC="js/oauth-util-functions.js" type="text/javascript"></SCRIPT>
		
		<SCRIPT style="text/javascript">
		$(document).ready(function() {
			$("#replayIDField").on("keydown", function (e) {
				if (e.keyCode === 13) {  
					testFunction();
					e.preventDefault();
				}
			});
			errorMessageToggle("", "hide");
		});	

		function testFunction(element, targetElement, lookupService, form) {		
			var replayID = $("#replayIDField").val();
			var listenerAlias = $("#listenerId").val();
			var providerName = $("#providerNameId").val();
			var groupName = $("#groupNameId").val();
			var connectorID = $("#connectorIDId").val();
			var connectorName = $("#connectorNameId").val();
			var authenticationType = $("#authenticationTypeId").val();
				
			if(authenticationType.search('.dsp') != -1 ){
				authenticationType = authenticationType.substring(0, authenticationType.indexOf('.dsp'));
			}
				
				
			var preparedUrl = "WmCloudStreams/connector-admin-nodes.dsp?" + 
								 "providerName="+providerName+ "&" +
								 "action=none&"+
								 "groupName="+groupName+ "&" +
								 "connectorID="+connectorID+ "&" +
								 "connectorName="+ connectorName +"&" +
								 "providerConnectionType="+ authenticationType + "#tabs-2";
										 
				
			var map = {userInputReplayID : replayID};
			
			var requestParams = { runtimeVariables: map, listenerAlias: listenerAlias};
					
			$.ajax({
				type: 'POST',
				url: '/invoke/pub.cloudstreams.admin.listener:enable',
				data: JSON.stringify(requestParams),
				dataType: 'json',
				contentType: 'application/json',
				async: false,
				success: function(data) {						
				
						var closeOnSuccess = false;
						var isError = false;
						var error = "something went wrong";
						$.each(data, function(key, value) {
							if (key == 'status' && value == 'true') {	
							    //alert('success');
								closeOnSuccess = true;
							}
							if (key == 'JSONResponse') {
								try{
									response = JSON.parse(value);
								}
								catch(e){
									error = {'error':"Something went wrong...",
												'error_description': e}
								}
							}
							if(key == 'status' && value == 'false'){
								isError = true;
							}
							if(isError){
								if(key == 'statusMessage'){
									error = value;
								}
							}
								
						});
						
						if (closeOnSuccess) {
							errorMessageToggle("", "hide");
							parent.document.getElementById("closeIFrameWindow").click();
							
							var urlTarget = window.parent.location.href;
							var index = urlTarget.search("WmCloudStreams");
							urlTarget = urlTarget.substring(0,index);
							urlTarget = urlTarget.concat(preparedUrl);
																						
							parent.reloadPage(urlTarget);														
						} else {
							errorMessageToggle(error, "show");						
						}
					},
					error: function(xhr, status) {
						var err = {'error' : status, 'error_description' : xhr.responseText};
						errorMessageToggle(err, "show");
					}
				});
			}			
			
		</SCRIPT>
		
		<style type="text/css">
			td:first-child { text-align: right };
		</style>
	</head>
	<body style="border-spacing: 0; border-width:0">
	
	<!--<form action="#">-->
	 <form name="form" method="POST" >
			<table id="EndPointTable" width="100%" >
				<tr id='status'><td colspan=8 name='err_message_span' class='error' style='text-align: left; padding-left: 35pt;' id='err_message_span'></td></tr>
				<tr>
					<td valign="middle" align="center"> 
					<div align="left"><strong>If you provide a Replay ID here all the events past that 
					Replay ID will be replayed and the action cannot be undone.</strong> </div>
					 <div align="left">If you just enable without providing any Replay ID 
						then the one derived from Replay Option setting will take effect.</div>	 </td>
				</tr>
			</table>
			<table id="mainTable" class="tableView" width="100%" />			
							
				<table class="tableView" width="100%">							
					<tr>
						<td class="heading" colspan=2></td>
					</tr>
					%invoke wm.cloudstreams.service.common:listRuntimeFields%
						%ifvar fields -notempty%
							%loop fields%
							<tr>
								<td nowrap>%value displayName%</td>
								<td style="padding-top: 0.5em; padding-right: 0.5em; padding-bottom: 0.5em; padding-left: 1em;">
									<input type="text" id="replayIDField" value="">
								</td>
							</tr>									
							%endloop%
						%endif%						
				</table>			
				
				<table style="margin-top: 10px" width=100%>
					<tr>
						<td class="action" colspan="3" style="text-align: left">
							<input type="button" id="enable" value="Enable" onclick="testFunction()" width="100%"/>
						</td>
					</tr>
				</table>
			</table>	

			<input type="hidden" id="listenerId" value="%value alias%">			
			<input type="hidden" id="providerNameId" value="%value providerName%">			
			<input type="hidden" id="groupNameId" value="%value groupName%">			
			<input type="hidden" id="connectorIDId" value="%value connectorID%">			
			<input type="hidden" id="connectorNameId" value="%value connectorName%">			
			<input type="hidden" id="authenticationTypeId" value="%value authenticationType%">			
		</form>
	</body>
</html>