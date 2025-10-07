<html>
    <head>
        <meta http-equiv="Pragma" content="no-cache">
        <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
        <meta http-equiv="Expires" CONTENT="-1">
        <title>Connection Details</title>
        <link rel="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css"></link>    
	    <link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/lookup-dropdown.css" type="text/css"/>
        <SCRIPT SRC="/WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<script src="js/messages.js" type="text/javascript"></script>
        <script src="js/basicAdvanced.js" type="text/javascript"></script>
		<script src="js/jquery-min.js" type="text/javascript"></script>
		<script src="js/csConnection.js" type="text/javascript"></script>
		<script type="text/javascript">
			
			$(document).ready(function() {
			
				// override submit to extract multiple select values into a string a comma separated values.
				$('form').submit(function(event) {
					event.preventDefault(); //this will prevent the default submit
					$("form select[multiple]").each(function () {
						$(this).closest('tr').find('input[type=hidden]').val(Array.from($(this).val()).join(",")); // find the next hidden input and update the value as CSL.
						$(this).remove(); // remove current elemet as we should not send this duplicate form element
					});
					$(this).unbind('submit').submit(); // submit the form
				});
			});
			
			function showSuccessInfo(infoMessage) {
				$("#alert-info").text(infoMessage).show().delay(10000).fadeOut();
			}
			function load()
			{		
				if (document.form.elements["CMGRPROP$poolable"]!=undefined && document.form.elements["CMGRPROP$poolable"].value == "false") {
					setEnabledFields(document.form, false);
				}
				if (document.form.elements["CMGRPROP$timeoutType"]!=undefined && document.form.elements["CMGRPROP$timeoutType"].value == "none") {
					setField(document.form.elements["CMGRPROP$sessionExpiry"], false);
				}
			}
			function test(data){
				if(data){
					window.scrollTo(0,0)
					$('[name=action]').val('testConnection');
					$.ajax({
					    url : "connector-admin-nodes.dsp#tabs-1",
					    type: "POST",
					    data : $('form').serialize(),
					    success: function(data, textStatus, jqXHR)
					    {	
							var item1 = $( "td.error",data)[0];
							if (item1==undefined){
								item1 = $( "td.success",data)[0];
							}
							var el = $( '#errorMsg' );
							el.html(item1)
							$("td.error").css({"height": "3em", "padding-left": "5em"});
							$("td.success").css({"height": "3em", "padding-left": "5em"});
							$('[name=action]').val('updateConnection');
					    },
					    error: function (jqXHR, textStatus, errorThrown)
					    {
					 
					    }
					});
				}
			}
			$(document).ready(function() {
				$("[class^='jwt\\.claim']").hide();
				$("[class^='jwt\\.cx']").show();
			});
			function disableTest(){		
				var connectionType=$('#connectionType').val();
				var authenticationType=$("#authenticationType").val();
				var connectorName=$('input[name="connectorName"]').val();
				var val=$(`#${connectionType}`).val()
				if(val=='false'){
					$(`#testButton`).attr('disabled','true');
					$(`#testButton`).attr("title",getmsg("test.not.available", connectorName,authenticationType));
				}
			}
		</script>

    </head>
    <body onload="onConnectionPageLoad(form)">  
        <form name="form" action="connector-admin-nodes.dsp#tabs-1" method="POST" onSubmit="return validateForm(form)">
			<input type="hidden" name="action" value="updateConnection">
			<input type="hidden" name="passwordChange" value="false">
			<input type="hidden" name="testContext" value="updateConnection">
			<input type="hidden" name="searchConnectionName" value="%value searchConnectionName%">
			<input type="hidden" name="groupName" value="%value groupName%">
			<input type="hidden" name="providerName" value="%value providerName%">
			<input type="hidden" name="connectorID" value="%value connectorID%">
			<input type="hidden" name="connectorName" value="%value connectorName%">
			
			<div id="heading" class="breadcrumb">
						CloudStreams &gt; Providers &gt; %value groupName% &gt; %value connectorName% &gt; %value connectionAlias% &gt; %ifvar readOnly equals('true')%View Connection%else%Edit Connection%endif%    
			</div>
			
            <table id="mainTable" class="tableView" width="100%">
            
            <tr>
				<td colspan=8 class="info" id="alert-info" style="display: none;">OAuth fields are updated from the response.
				</td>
            </tr>
            <tr id="errorMsg">
				
			</tr>
            <tr>
                <td colspan=1 width = "40%" style="border: 0px">
                    <ul class="listitems">
                    <li><A HREF="connector-admin-nodes.dsp?searchConnectionName=%value searchConnectionName%&providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%#tabs-1">Return to %value connectorName% Connections</A>
                    </ul>
                </td>
				
				%invoke wm.cloudstreams.connection.ui:getConfiguration%
				<td id="basicAdvancedTD" style="text-align: right; border: 0px" width = "50%">
					%ifvar readOnly equals('true')%
						%ifvar basic equals('true')% 
							Basic view| <a href="connection-details.dsp?readOnly=true&basic=false&connectionAlias=%value connectionAlias%&providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%&connectionType=%value connectionType%&authenticationType=%value authenticationType%">Advanced view</a>
						%else%
							<a href="connection-details.dsp?readOnly=true&basic=true&connectionAlias=%value connectionAlias%&providerName=%value providerName%&groupName=%value groupName%&connectorID=%value connectorID%&connectorName=%value connectorName%&connectionType=%value connectionType%&authenticationType=%value authenticationType%">Basic view</a>
							 | Advanced view 
						%endif%	
					%else%
						Basic view| <a href="javascript:void(0); showHeading()" onclick="javascript:ShowAllFields()">Advanced view</a>
					%endif%
				</td>
				
            </tr>
           
			<tr>
				<td class="heading" colspan=2>%value connectionAlias% Details </td>
			</tr>	
				
				
			
			
		  
			<tr>
				<script>writeTD('row');</script>Connection Type</td>
				<script>writeTD('rowdata-l');swapRows();</script>%value authenticationType%</td>
			</tr>

			<tr>
				<script>writeTD('row');</script>Package Name</TD>
				<script>writeTD('rowdata-l');swapRows();setPackageName("%value packageName%")</script>%value packageName%</td>
			</tr>    
            
                %include connection-properties-edit.dsp%
                   
                %comment%----------------------ConnectionManagerProperties--------------%endcomment%    
                %include connection-mgr-properties-edit.dsp%
                %comment%----------------------End ConnectionManagerProperties--------------%endcomment%  
            
            </table>
              
			%invoke wm.cloudstreams.connection.ui:listTypes%
            %ifvar connectionInfo -notempty%
                %loop connectionInfo%
					<input type="hidden" id="%value connectionType%" value="%value isTestable%">
				%endloop%
            %endif%
  		
            <table width=100%>
                <tr>
                    <td class="action" colspan="2">
                        %ifvar readOnly equals('false')%
                            <input type="submit" name="SUBMIT" value="Save Changes" width=100></input>
                            <input id="testButton" type="button" onclick="test(validateForm(form,true))" value="Test"/>
                            <input type="hidden" name="connectionAlias" value="%value connectionAlias%">
                        %endif%        
                    </td>    
                </tr>
            </table>
			
			  %onerror%
                %ifvar localizedMessage%
                    <div class="error">%value localizedMessage%</div>
                %else%
                    %ifvar error%
                        <div class="error">%value errorMessage%</div>
                    %endif%
                %endif%
            %endinvoke%

        </form>    
    </body>
</html>