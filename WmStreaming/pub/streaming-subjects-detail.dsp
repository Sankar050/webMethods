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

<body onLoad="setNavigation('streaming-detail.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingAliasDetailsScrn');">

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Event Specifications &gt; View Details</TD>
    </tr>
    %ifvar action equals('edit')%  
    
      %invoke wm.server.streaming:updateEventSourceFlat% 
        <tr>
          <td colspan="2">&nbsp;</td> 
          </tr>
        <tr>
          <td class="message" colspan=2>%value message encode(html)%</TD>
        </tr>
      %onerror%
	    <tr>
          <td class="message" colspan=2>%value errorMessage encode(html)%</td>
        </tr>
      %endinvoke%
    %endif%

    <tr>
      <td colspan="2">
        <ul class="listitems">
		  <script>
		    createForm("htmlform_settings_streaming", "streaming-subjects.dsp", "POST", "BODY");
			setFormProperty("htmlform_settings_streaming", "aliasName", "%value aliasName% encode(url)%");
		  </script>
          <li class="listitem">
		    <script>getURL("streaming-subjects.dsp?aliasName=%value aliasName%","javascript:document.htmlform_settings_streaming.submit();","Return to Event Specifications")</script>
		  </li>
		  <script>
		    createForm("htmlform_settings_streaming_edit", "streaming-subjects-edit.dsp", "POST", "BODY");
			setFormProperty("htmlform_settings_streaming_edit", "name", "%value name encode(url)%");
		  </script>
          <li class="listitem">
		    <script>getURL("streaming-subjects-edit.dsp?aliasName=%value aliasName encode(url)%&referenceId=%value referenceId encode(url)%","javascript:document.htmlform_settings_streaming_edit.submit();","Edit Event Specification")</script>
		  </li>
        </ul>
      </td>
    </tr>
	
	%invoke wm.server.streaming:getEventSourceReport%
	
    <tr>
      <td>
        <table class="tableView" width="100%">

          <form>
          %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%

          <tr>
            <td class="heading" colspan=2>Event Specification</td>
          </tr>
          <!-- Connection Alias Name -->
          <tr>
            <td width="40%" class="oddrow-l" scope="row" nowrap="true">Connection Alias Name</td>
            <td class="oddrowdata-l">%value aliasName encode(html)%</td> 
          </tr>
          </tr>
          <!-- Event Specification Name -->
          <tr>
            <td class="oddrow-l" scope="row">Event Specification Name</td>
            <td class="oddrowdata-l">%value referenceId encode(html)%</td>
          </tr>
		  <!-- Type -->
		  <tr>
            <td class="subheading" colspan=2>Topic</td>
          </tr>
		  <!-- Topic -->
          <tr>
            <td class="oddrow-l" scope="row">Topic Name</td>
            <td class="oddrowdata-l">%value eventSourceData/topicName encode(html)%</td>
          </tr>
		  <!-- Key -->
		  <tr>
            <td class="subheading" colspan=2>Key</td>
          </tr>
          <tr>
            <td class="oddrow-l" scope="row">Type</td>
            <td class="oddrowdata-l">%value eventSourceData/keyCoder/type_display encode(html)%</td>
          </tr>
		  %switch eventSourceData/keyCoder/type%
	        %case 'NONE'%	 
            %case 'none'%	
            %case 'RAW'%			
			%case 'STRING'%	    
		      <tr>
                <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/charsetName encode(html)%</td>
              </tr>
			%case 'JSON'%	 
              <tr>			
		        <td>Document Type Name</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/documentTypeName encode(html)%</td>
			  </tr>
			  <tr>			
		        <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/charsetName encode(html)%</td>
			  </tr>
			%case 'XML'%	 
              <tr>			
		        <td>Document Type Name</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/documentTypeName encode(html)%</td>
			  </tr>
			  <tr>			
		        <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/charsetName encode(html)%</td>
			  </tr>
			%case%
			  <tr>			
		        <td>Decode as String</td>
                <td class="oddrowdata-l">%value eventSourceData/keyCoder/decodeAsString encode(html)%</td>
			  </tr>
		  %end%
		  <!-- Value -->
		  <tr>
            <td class="subheading" colspan=2>Value</td>
          </tr>
          <tr>
            <td class="oddrow-l" scope="row">Type</td>
            <td class="oddrowdata-l">%value eventSourceData/valueCoder/type_display encode(html)%</td>
          </tr>
		  %switch eventSourceData/valueCoder/type%
	        %case 'NONE'%	 
            %case 'none'%
            %case 'RAW'%			
			%case 'STRING'%	    
		      <tr>
                <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/charsetName encode(html)%</td>
              </tr>
			%case 'JSON'%	 
              <tr>			
		        <td>Document Type Name</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/documentTypeName encode(html)%</td>
			  </tr>
			  <tr>			
		        <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/charsetName encode(html)%</td>
			  </tr>
			%case 'XML'%	 
              <tr>			
		        <td>Document Type Name</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/documentTypeName encode(html)%</td>
			  </tr>
			  <tr>			
		        <td>Charset Name</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/charsetName encode(html)%</td>
			  </tr>
			%case%
			  <tr>			
		        <td>Decode as String</td>
                <td class="oddrowdata-l">%value eventSourceData/valueCoder/decodeAsString encode(html)%</td>
			  </tr>
		  %end%
		</table>  
      </td>
    </tr>

    %onerror%
	  <tr>
        <td>
		  <font color=red>%value errorMessage encode(html)%</font> 
		</td>
	  </tr>
    %endinvoke%

  </table>
</body>
</html>
