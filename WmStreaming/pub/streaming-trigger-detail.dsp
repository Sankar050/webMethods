<HTML>
<HEAD>

<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<META HTTP-EQUIV="Expires" CONTENT="-1">

<LINK REL="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css">
%ifvar webMethods-wM-AdminUI%
  <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods-wM-AdminUI.css"></link>
  <script>webMethods_wM_AdminUI = 'true';</script>
%endif%
<SCRIPT src="../WmRoot/webMethods.js"></SCRIPT>

<style>

.disabledLink
{
   color:#0D109B;
}

</style>

</head>

<body onLoad="setNavigation('streaming-detail.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingTriggerDetailsScrn');">

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Trigger Management &gt; Details</TD>
    </tr>
    %ifvar action equals('edit')%  
    
      %invoke wm.server.streaming:updateTrigger% 
        <tr>
          <td colspan="2">&nbsp;</td>
          </tr>
        <tr>
          <td class="message" colspan=2>%value message encode(html)%</TD>  
        </tr>
      %endinvoke%
    %endif%

    %invoke wm.server.streaming:getTriggerReport%

    <tr>
      <td colspan="2">
        <ul class="listitems">
		  <script>
		  createForm("htmlform_settings_streaming", "streaming.dsp", "POST", "BODY");
		  </script>
          <li class="listitem">
		  <script>getURL("streaming-trigger-management.dsp","javascript:document.htmlform_settings_streaming.submit();","Return to Trigger Controls")</script>
		  </li>

          <!-- %ifvar enabled equals('false')%
		    <script>
		    createForm("htmlform_settings_streaming_edit", "streaming-edit.dsp", "POST", "BODY");
			setFormProperty("htmlform_settings_streaming_edit", "name", "%value name encode(url)%");
		    </script>
            <li class="listitem">
			<script>getURL("streaming-edit-trigger.dsp?name=%value name encode(url)%","javascript:document.htmlform_settings_streaming_edit.submit();","Edit Streaming Trigger")</script>
			</li>
          %else%
            <li class="listitem"><div class="disabledLink">Edit Event Processing Trigger</div></li>
          %endif% -->
        </ul>
      </td>
    </tr>
    <tr>
      <td>
        <table class="tableView" width="100%">

          <form>
          %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%

          <!--                        -->
          <!-- General Settings       -->
          <!--                        -->

          <tr>
            <td class="heading" colspan=2>General Settings</td>
          </tr>
          
		  <!-- Trigger Name -->
          <tr>
            <td width="40%">Trigger Name</td>
            <td class="oddrowdata-l" width="60%">%value triggerName encode(html)%</td>
          </tr>
          </tr>
          
		  <!-- Package -->
          <tr>
            <td>Package</td>
            <td class="oddrowdata-l">%value triggerData/node_pkg encode(html)%</td>
          </tr>
          
		  <!-- Connection Alias -->
          <tr>
            <td>Connection Alias</td>
            <td class="oddrowdata-l">%value triggerData/trigger/aliasName encode(html)%</td>
          </tr>
		  
		  <!-- Client ID -->
		  <tr>
            <td>Client ID</td>
            <td class="oddrowdata-l">%value triggerData/trigger/clientIdDisplay encode(html)%</td>
          </tr>
		  
          <!-- Enabled -->
          <tr>
            <td>Enabled</td>
            %ifvar triggerData/trigger/enabled equals('true')%
              <td class="oddrowdata-l"><img style="width: 13px; height: 13px;" alt="enabled" border="0" src="../WmRoot/images/green_check.png">Yes</td>
            %else%
              <td class="oddrowdata-l">No</td>
            %endif%
	      </tr>

          <!--                               -->
          <!-- Receive and Decode            -->
          <!--                               -->
        
          <tr>
            <td class="heading" colspan=2>Receive and Decode</td>
          </tr>
		  
		  <!-- Source ID -->
		  <tr>
            <th class="subheading" colspan=2>
			  %loop triggerData/trigger/source%
                %value label encode(html)%&nbsp;
		      %end%
			</th>
          </tr>
		  
		  <!-- Reference ID -->
          <tr>
            <td>Event Specification Name</td>
            <td class="oddrowdata-l">
			  %loop triggerData/trigger/source%
                %value specification/referenceId encode(html)%&nbsp;
		      %end%
			</td> 
          </tr>

          <!-- Topic -->
          <tr>
            <td>Topic</td>
            <td class="oddrowdata-l">
			  %loop triggerData/trigger/source%
                %value specification/topicName encode(html)%&nbsp;
		      %end%
			</td> 
          </tr>
		  
		  <!-- Key -->
          <tr>
		    <td>Key Deserializer</td>
            <td class="oddrowdata-l">
              %loop triggerData/trigger/source%
                %value specification/keyCoder/type_display encode(html)%&nbsp;
		      %end%
		    </td>
          </tr>
		  
		  <!-- Value -->
          <tr>
		    <td>Value Deserializer</td>
            <td class="oddrowdata-l">
              %loop triggerData/trigger/source%
                %value specification/valueCoder/type_display encode(html)%&nbsp;
		      %end%
		    </td>
          </tr>
		  
          <!--                               -->
          <!-- Process                       -->
          <!--                               -->
		  
		  <tr>
            <td class="heading" colspan=2>Process</td>
          </tr>
		  
		  <!-- Window -->
          <tr>
            <td>%value triggerData/trigger/window/type encode(html)%</td>
			<td class="oddrowdata-l">
			  %loop triggerData/trigger/window/parameters/nameValue%
			    %ifvar $index equals('0')%%else%;&nbsp;%endif%
                %value name encode(html)%:&nbsp;%value value encode(html)%
			  %end%
            </td>
          </tr>
		  
		  <!-- Process ID/Label -->
		  %loop triggerData/trigger/process%
		    <tr>
              <th class="subheading" colspan=2>%value processId encode(html)%</th>
            </tr>
			
			<!-- Intermediate Operations -->
			%loop intermediate%
			  <tr>
                <td>
				  %value type encode(html)%
				</td>
				<td class="oddrowdata-l">
			      %loop parameters/nameValue%
				    %ifvar $index equals('0')%%else%;&nbsp;%endif%
					%value name encode(html)%: %value value encode(html)%
		          %endloop%
			    </td>
			  </tr>
			%endloop%

            <!-- Terminal Operations -->
			%loop terminal%
			   <tr>
                <td>
				  %value type encode(html)%
				</td>
				<td class="oddrowdata-l">
			      %loop parameters/nameValue%
                    %ifvar $index equals('0')%%else%;&nbsp;%endif%
					%value name encode(html)%: %value value encode(html)%
		          %endloop%
			    </td>
			  </tr>
			%endloop%			
			
		  %endloop%
		  
		  <!-- Target Operations -->
		  <tr>
            <td>
			  %value triggerData/trigger/target/type encode(html)%
			</td>
            <td class="oddrowdata-l">
		      %loop triggerData/trigger/target/parameters/nameValue% 
			  %ifvar $index equals('0')%%else%;&nbsp;%endif%
			    %value name encode(html)%:&nbsp;%value value encode(html)%
			  %endloop%
			</td>
          </tr>
		  
		  <!--                               -->
          <!-- Properties                    -->
          <!--                               -->
		  
		  <tr>
            <td class="heading" colspan=2>Properties</td>
          </tr>
		  <tr>
            <td>Commit Mode</td>
            <td class="oddrowdata-l">%value triggerData/trigger/commitMode encode(html)%</td>
          </tr>		  
		  <tr>
            <td>Polling Request Size</td>
            <td class="oddrowdata-l">%value triggerData/trigger/pollingRequestSize encode(html)%</td>
          </tr>
		  <tr>
            <td>Polling Interval</td>
			<td class="oddrowdata-l">%value triggerData/trigger/pollingIntervalDisplay encode(html)%</td>
          </tr>
		  <tr>
            <td>On Disconnect</td>
            <td class="oddrowdata-l">%value triggerData/trigger/onDisconnect encode(html)%</td>
          </tr>
		  <tr>
            <td>Consumer Count Minimum</td>
            <td class="oddrowdata-l">%value triggerData/trigger/minConsumers encode(html)%</td> 
          </tr>
		  <tr>
            <td>Consumer Count Maximum</td>
            <td class="oddrowdata-l">%value triggerData/trigger/maxConsumers encode(html)%</td>
          </tr>
		  <tr>
            <td>Add Consumers After</td>
            <td class="oddrowdata-l">%value triggerData/trigger/consumerExpansionDelayDisplay encode(html)%</td>
          </tr>
		  <tr>
            <td>Remove Inactive Consumers After</td>
            <td class="oddrowdata-l">%value triggerData/trigger/consumerCleanupDelayDisplay encode(html)%</td>
          </tr>
		  <tr>
            <td>Use Parallel Streams</td>
            <td class="oddrowdata-l">%value value triggerData/trigger/useParallelStreams(html)%</td>
          </tr>
		  <tr>
            <td>Transient Error Handling</td>
            <td class="oddrowdata-l">%value value triggerData/trigger/transientFailureAction(html)%</td>
          </tr>
		  <tr>
            <td>Fatal Error Handling</td>
            <td class="oddrowdata-l">%value value triggerData/trigger/failureAction(html)%</td>
          </tr>
		  <tr>
            <td>Resource Monitoring Service</td>
            <td class="oddrowdata-l">%value value triggerData/trigger/resourceMonitorSvc(html)%</td>
          </tr>
		  
		</table>
		<br>
		<table class="tableView" width="100%">
		
		  <!--                               -->
          <!-- Configuration Parameters      -->
          <!--                               -->

		  <tr>
            <td class="subheading2" colspan=2>Runtime Configuration Parameters</td>
          </tr>
		  
		  %loop triggerData/trigger/configurationParameters%		  
		    <tr>
              %loop -struct%
                <td width="40%">%value $key%</td>
                <td class="oddrowdata-l" width="60%">%value%</td>
              %end%
            </tr>
		  %end%
		  
		</table>  

      </td>
    </tr>

    %onerror%
      %value errorService encode(html)%<br>
      %value error encode(html)%<br>
      %value errorMessage encode(html)%<br>
    %endinvoke%

  </table>
</body>
</html>
