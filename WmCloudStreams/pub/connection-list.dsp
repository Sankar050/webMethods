<HTML>
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <meta http-equiv="Expires" CONTENT="-1">
        <title>List Connections</title>
        <link rel="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css"></link>
        <link rel="stylesheet" TYPE="text/css" HREF="css/messages.css"></link>
        <link rel="stylesheet" TYPE="text/css" HREF="css/cloudstreams.css"></link>
        <!--script src="js/connectionfilter.js" type="text/javascript"></script-->		
		<script src="js/messages.js" type="text/javascript"></script>        
        <SCRIPT SRC="/WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<script src="js/connectionfilter.js" type="text/javascript"></script>
		<link rel="stylesheet" type="text/css" href="../WmRoot/subUserLookup.css" />
		<script type="text/javascript" src="js/modal.js"></script>
		<!--script type="text/javascript" src="js/jquery-min.js"></script-->
		<SCRIPT LANGUAGE="JavaScript">
			var disabledConnectionRowNumber = -1;
			var disabledConnectionRow = null;
            function confirmConnectionDisable (aliasName)
            {                 
				var s1 = getmsg("confirm.connection.disable", aliasName);
                var isConfirmed = confirm (s1);
				if(isConfirmed){
					$("form[name='form']")[0].submit();
				}
                return isConfirmed;
            }
           
            function confirmConnectionEnable (aliasName)
            {      
                var s1 = getmsg("confirm.connection.enable", aliasName);
                var isConfirmed = confirm (s1);
				if(isConfirmed){
					$("form[name='form']")[0].submit();
				}
                return isConfirmed;
            }
            function confirmConnectionDelete (aliasName)
            {
                var s1 = getmsg("confirm.connection.delete", aliasName);
                var isConfirmed = confirm (s1);
				if(isConfirmed){
					$("form[name='form']")[0].submit();
				}
                return isConfirmed;
            }
			function confirmConnectionTest (aliasName)
            {
                var s1 = getmsg("confirm.connection.test", aliasName);
                var isConfirmed = confirm (s1);
				if(isConfirmed){
					$("form[name='form']")[0].submit();
				}
                return isConfirmed;
            }
			function disableTest(connectionType,connectorName,authenticationType){		
				var val=$(`#${connectionType}`).val()
				if(val=='false'){
					$(`.testLink-${connectionType}`).removeAttr('href');
					$(`.testLink-${connectionType}`).removeAttr('onClick');
					$(`.imageLink-${connectionType}`).css('filter','grayscale(1.0)');
					$(`.imageLink-${connectionType}`).attr("title",getmsg("test.not.available", connectorName,authenticationType));
				}
			}
			
			$.urlParam = function(href, name){
				var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(href);
				return results[1] || 0;
			}

			// fetches runtime state reasons for the connection
			function getRuntimeStateReasons(element) {
				var connectionAlias = $.urlParam($(element).attr('href'), "connectionAlias");

				$.ajax({
					type: 'GET',
					url: '/invoke/wm.cloudstreams.connection:listRuntimeDetails?connectionAlias=' + connectionAlias,
					dataType: 'json',
					contentType: 'application/json',
					async: false,
					success: function(data) {
						var closeOnSuccess = false;
						$.each(data, function(key, value) {
							if (key == 'status' && value == 200) {
								closeOnSuccess = true;
							}
							if (key == 'stateDetails') {
								var stateDetails = value[0];
								if(stateDetails) {
									$(element).attr('title', stateDetails['stateMsg']);
								}
							}
						});
					},
					error: function(xhr, status) {
						// handle error if required.
					}
				});
			}
			
			$(document).ready(function(){
				showHideFilterCriteriaConnection('searchConnectionName');
				$('#connTable tr').removeClass('oddrow');
				$('#connTable tr').removeClass('evenrow');
				$('#connTable tr td').removeClass('left');
				
				// below code to add onclick() function to rows of connection list table 
				// which is required to get the clicked/current row selected.
				if (!document.getElementsByTagName || !document.createTextNode) return;
				var rows = document.getElementsByClassName('tableView')[0].getElementsByTagName('tbody')[0].getElementsByTagName('tr');
				for (i = 0; i < rows.length; i++) {
					rows[i].onclick = function() {
						disabledConnectionRow = this;
					}
				}
			});

            function reloadConnections() {
				var urlParams = new URLSearchParams(window.location.search);
				var sortCriteria = urlParams.get('sortCriteria');
				var sortOrder = urlParams.get('sortOrder');
				var locationStr = '/WmCloudStreams/connector-admin-nodes.dsp?providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%&providerConnectionType=%value connectionType%';
				if(sortCriteria && sortCriteria.length > 0 && sortOrder && sortOrder.length > 0) {
					locationStr += '&sortCriteria=' + sortCriteria + '&sortOrder=' + sortOrder;
				}
				location.href = locationStr;
			}
    </SCRIPT>
    </head>

    <BODY>
	<form name="form" action="connector-admin-nodes.dsp#tabs-1" method="POST">
	<div class="service">
        <table id="connTable" width="100%">

        <!-- action processing -->
        %ifvar action%
            %switch action%
                %case 'enableConnection'%
                    %invoke pub.cloudstreams.admin.connection:enableConnection%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value statusMessage%</td></tr>
						%endif%
                    %endinvoke%

                %case 'testConnection'%
                    %invoke wm.cloudstreams.connection.ui:test%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value connectionAlias% :%value statusMessage%</td></tr>
						%endif%
                    %endinvoke%

				%case 'disableConnection'%
                    %invoke pub.cloudstreams.admin.connection:disableConnection%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value statusMessage%</td></tr>
						%endif%
                    %endinvoke%

				%case 'deleteConnection'%
                    %invoke wm.cloudstreams.connection.ui:remove%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value statusMessage%</td></tr>
						%endif%
					%endinvoke%

				%case 'saveConnection'%
                    %invoke wm.cloudstreams.connection.ui:create%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value statusMessage%</td></tr>
						%endif%
					%endinvoke%

				%case 'updateConnection'%
                    %invoke wm.cloudstreams.connection.ui:update%
						%ifvar statusMessage%
							  <tr><td class=%ifvar status equals('true')% "success" %else% "error" %endif% colspan = 8>%value statusMessage%</td></tr>
						%endif%
					%endinvoke%
            %endswitch%
        %endif%

		<!-- Filter UI -->

	   <tr>
            <td colspan=2>
                <ul class="listitems">
					<li><a href="connector-list.dsp?groupName=%value groupName%">Return to Connectors </a></li>
                    <li>
                        <a href="/WmCloudStreams/connection-properties.dsp?providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%&connectionType=sagcloud&includeDevFields=true">Configure New Connection</a>
                    </li>
					<li id="showfewConnection" name="showfewConnection">
						<a href="javascript:showFilterPanelConnection(true)">Filter Connections</a>
					</li>
                    <li style="display:none" id="showallConnection" name="showallConnection">
						<a href="/WmCloudStreams/connector-admin-nodes.dsp?providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%&providerConnectionType=%value connectionType%#tabs-1" onClick="showAll(this.form, 'connection');">Show All Connections</a>
					</li>

					<DIV id="filterContainerConnection" name="filterContainerConnection" style="display:none;padding-top=2mm;">
					 <br>
					  <table>
					  <tr valign="top">
						<td>
							<span>Filter criteria</span><br>
							<input id="searchConnectionName" name="searchConnectionName" value="%value searchConnectionName%" onkeydown="return processKey(event, 'submitButtonConnection')" />
						</td>
						<td>
						 <br>
							<input id="submitButtonConnection" name="Search" type="submit" value="Search" width="15" height="15" onClick="validateSearchCriteria('searchConnectionName');return false;"/>
						 </br>
						</td>
					  </tr>
					  </table>
					 </br>
					</DIV>
                </ul>
            </td>
         </tr>

		<!-- Invalidate the connectionType while listing Connections -->
        %ifvar connectionType%
            %rename connectionType DUMMYVARIABLE%;
        %endif%
        <!-- connection display -->
		%invoke wm.cloudstreams.connection.ui:list%
		<TR>
			<TD style="padding-left: 0px;">
				<TABLE class="tableView" WIDTH=100% id="head" name="head">
					<TR>
						<TD CLASS="heading" COLSPAN=9>
						    <div style="float: left;">Connections</div>
                            <div align="right" style="padding-right:0.5em; cursor:pointer;"><img src="images/update.gif" title="Refresh all Connections" border=0 onClick="return reloadConnections();"></div>
						</TD>
					</TR>
					<tr class="subheading2">
						<td class="oddcol">Connection&nbsp;Name
						<a id="ascCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=connectionAlias&sortOrder=ASC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" style="float: middle" src="images/arrow_up.gif" width="15" height="15">
						</a>
						<a id="desCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=connectionAlias&sortOrder=DESC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_down.gif" style="float: middle" width="15" height="16">
						</a>
						</td>
						<td class="oddcol">Package&nbsp;Name
						<a id="ascCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=packageName&sortOrder=ASC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_up.gif" align="baseline" width="15" height="15">
						</a>
						<a id="desCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=packageName&sortOrder=DESC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_down.gif" align="baseline" width="15" height="16">
						</a>
						</td>

                        <td class="oddcol">Connection&nbsp;Type
						<a id="ascCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=authenticationType&sortOrder=ASC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_up.gif" align="baseline" width="15" height="15">
						</a>
						<a id="desCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=authenticationType&sortOrder=DESC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%">
							<img border="0" src="images/arrow_down.gif" align="baseline" width="15" height="16">
						</a>
						</td>

						<td class="oddcol">Status
						<a id="ascCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=connectionState&sortOrder=ASC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_up.gif" align="baseline" width="15" height="15">
						</a>
						<a id="desCN" href="/WmCloudStreams/connector-admin-nodes.dsp?connectorID=%value connectorID%&searchConnectionName=%value searchConnectionName%&sortCriteria=connectionState&sortOrder=DESC&groupName=%value groupName%&connectorName=%value connectorName%&providerName=%value providerName%#tabs-1">
							<img border="0" src="images/arrow_down.gif" align="baseline" width="15" height="16">
						</a>
						</td>


						<td class="oddcol">Test</td>
						<td class="oddcol">Edit</td>
						<td class="oddcol">View</td>
						<td class="oddcol">Copy</td>
						<td class="oddcol">Delete</td>
					</tr>

		%ifvar connectionInfo -notempty%
			%loop connectionInfo%
					<input type="hidden" id="%value connectionType%" value="%value isTestable%">
			%endloop%
		%endif%
        %ifvar connectionAliasList -notempty%
            %loop connectionAliasList%

                <tr class="row">
                    <script>writeTD('row-l');</script>%value connectionAlias%</td>
                    <script>writeTD('row-l');</script>%value packageName%</td>
                    <script>writeTD('row-l');</script>%value authenticationType%</td>

					<script>writeTD('rowdata');</script>


                    %switch connectionState%
						%case 'enabled'%
						%ifvar connectionRuntimeState equals('SUSPENDED')%
							<span class="imagelink" style="color:red;" href="/WmCloudStreams/connector-admin-nodes.dsp?action=enableConnection&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&providerConnectionType=%value connectionType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%#tabs-1" onmouseenter="javascript:getRuntimeStateReasons(this)">
							<a class="submodal" href="/WmCloudStreams/connection-runtime-state.dsp?connectionAlias=%value connectionAlias%">Suspended</a></span>
						%else%
                            <a class="imagelink" style="color:green;" href="/WmCloudStreams/connector-admin-nodes.dsp?action=disableConnection&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&providerConnectionType=%value connectionType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%#tabs-1"
							ONCLICK="return confirmConnectionDisable('%value connectionAlias%');">Enabled
                                </a>
						%endif%
                        %case 'disabled'%
	                        <a class="imagelink" style="color:red;" href="/WmCloudStreams/connector-admin-nodes.dsp?action=enableConnection&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&providerConnectionType=%value connectionType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%#tabs-1"
							ONCLICK="return confirmConnectionEnable('%value connectionAlias%');">Disabled
                            </a>
                    %endswitch%


					%ifvar connectionState equals('enabled')%
						<script>writeTD('rowdata');</script>
							<a id="testLink-%value connectionType%" class="imagelink testLink-%value connectionType%" href="/WmCloudStreams/connector-admin-nodes.dsp?action=testConnection&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&providerConnectionType=%value connectionType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%#tabs-1"
							ONCLICK="return confirmConnectionTest('%value connectionAlias%');">
									<img id="imageLink-%value connectionType%" class="imageLink-%value connectionType%" src="/WmRoot/icons/checkdot.gif" border=0 alt="Test">
							</a>
						</td>
					%else%
						<script>writeTD('rowdata');</script>
                            <a id="testLink-%value connectionType%" class="imagelink testLink-%value connectionType%">
									<img id="imageLink-%value connectionType%" class="imageLink-%value connectionType%" src="/WmRoot/icons/checkdot.gif" border=0 alt="Test" title="Enable Connection to Test" style="filter:grayscale(1.0);">
							</a>
                        </td>
                    %endif%


					%ifvar connectionState equals('disabled')%
                        <script>writeTD('rowdata');</script>
                            <a href="/WmCloudStreams/connection-details.dsp?readOnly=false&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&connectionType=%value connectionType%&authenticationType=%value authenticationType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%&basic=true&includeDevFields=true">
                                <img src="/WmCloudStreams/icons/config_edit.gif" alt="Edit" border=0>
                            </a>
                        </td>
                    %else%
                        <script>writeTD('rowdata');</script>
                            <img src="/WmCloudStreams/icons/disabled_edit.gif" title="Disable Connection to Edit" border=0>
                        </td>
                    %endif%

                    <script>writeTD('rowdata');</script>
                       <a href="/WmCloudStreams/connection-details.dsp?readOnly=true&connectionAlias=%value connectionAlias%&providerName=%value /providerName%&groupName=%value /groupName%&connectionType=%value connectionType%&authenticationType=%value authenticationType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%&basic=true&includeDevFields=true">
                        <img src="/WmRoot/icons/file.gif" alt="View" border=0>
                        </a>
                    </td>

                    <script>writeTD('rowdata');</script>

                        <a href="/WmCloudStreams/connection-details-copy.dsp?connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&basic=true&providerName=%value /providerName%&groupName=%value /groupName%&connectionType=%value connectionType%&authenticationType=%value authenticationType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%&includeDevFields=true">
                            <img src="/WmCloudStreams/icons/copy.gif" alt="Copy" border=0>
                        </a>
                    </td>

                    <script>writeTD('rowdata');swapRows();</script>
                        %ifvar connectionState equals('disabled')%
                            <a href="/WmCloudStreams/connector-admin-nodes.dsp?action=deleteConnection&connectionAlias=%value connectionAlias%&searchConnectionName=%value ../searchConnectionName%&providerName=%value /providerName%&groupName=%value /groupName%&providerConnectionType=%value connectionType%&connectorID=%value /connectorID%&connectorName=%value /connectorName%#tabs-1"
                               ONCLICK="return confirmConnectionDelete('%value connectionAlias%');">
                                <img src="/WmRoot/icons/delete.gif" alt="Delete" border=0>
                            </a>
                        %else%
                            <img src="/WmRoot/icons/delete_disabled.gif" alt="Disable Connection to Delete" border=0>
                        %endif%
                    </td>
                </tr>
            %endloop%
			%ifvar connectionInfo -notempty%
			%loop connectionInfo%
				<script>disableTest('%value connectionType%','%value /connectorName%', '%value authenticationType%');</script>
			%endloop%
			%endif%
        %else%
            <tr><td class="info" colspan=9>No connections found</td></tr>
        %endif%

        %onerror%
            %ifvar localizedMessage%
                <tr><td class="error">%value localizedMessage%</pre></td></tr>
            %else%
                %ifvar error%
                    <tr><td class="error">%value errorMessage%</pre></td></tr>
                %endif%
            %endif%
        %endinvoke%
		</table>
		</td>
		</tr>
        </table>

	  <input type="hidden" name="connectorID" value="%value connectorID%">
      <input type="hidden" name="searchConnectionName" value="%value searchConnectionName%">
	  <input type="hidden" name="groupName" value="%value groupName%">
	  <input type="hidden" name="connectorName" value="%value connectorName%">
	  <input type="hidden" name="providerName" value="%value providerName%">
	  </div>
	</form>
    </body>
</HTML>
