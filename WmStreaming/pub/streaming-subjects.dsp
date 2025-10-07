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

<script language ="javascript">

  /**
   * loadDocument
   */ 
  function loadDocument() {
    setNavigation('streaming-detail.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingAliasDetailsScrn');
	var selectAlianNameVar = document.getElementById("selectAlianName");
	for (i=0; i<selectAlianNameVar.options.length; i++) {
      if ("%value aliasName encode(javascript)%" == selectAlianNameVar.options[i].text) {
        selectAlianNameVar.options[i].selected = true;
      }
    }
  }

  /**
   * confirmDelete
   */ 
  function confirmDelete(id) {
	return confirm('Are you sure you want to delete Event Specification ' + id + '?');
  }
  
  /**
   * displaySettings
   */ 
  function displaySettings(object) {  
	window.location.href = "streaming-subjects.dsp?aliasName=" + object.options[object.selectedIndex].value + "%ifvar webMethods-wM-AdminUI%&webMethods-wM-AdminUI=true%endif%";
  }
</script>

<style>

.disabledLink
{
   color:#0D109B;
}

</style>

</head>

<body onLoad="loadDocument();">

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Event Specifications</TD>
    </tr>
	
	%switch action%   
	%case 'create'% 
	  %invoke wm.server.streaming:createEventSourceFlat%
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td class="message" colspan=2>%value message encode(html)%</td>
        </tr>
	  %onerror%
	    <tr>
          <td class="message" colspan=2>%value errorMessage encode(html)%</td>
        </tr>
      %endinvoke%
	  %rename referenceId createdReferenceId%
	%case 'delete'%
	  %invoke wm.server.streaming:deleteEventSource%
        <tr>
          <td colspan="2">&nbsp;</td>
        </tr>
        <tr>
          <td class="message" colspan=2>%value message encode(html)%</td>
        </tr>
      %onerror%
	    <tr>
          <td class="message" colspan=2>%value errorMessage encode(html)%</td>
        </tr>
      %endinvoke%
	  %rename referenceId deletedreferenceId%

	%endswitch%

    %invoke wm.server.streaming:getEventSourceReport%
	
	  <tr>
        <td colspan="2">
	      <script>
	  	    createForm("htmlform_settings_streaming_create", "streaming-subjects-create.dsp", "POST", "BODY");
	  	    setFormProperty("htmlform_settings_streaming_create", "aliasName", "%value aliasName encode(url)%");
	  	    createForm("htmlform_settings_streaming", "streaming.dsp", "POST", "BODY");
	  	    createForm("htmlform_settings_streaming_trigger", "streaming-trigger-management.dsp", "POST", "BODY");
	        createForm("htmlform_settings_streaming_subjects", "settings-streaming-subjects.dsp", "POST", "BODY");
	      </script>
	      %ifvar webMethods-wM-AdminUI% 
	        <ul class="listitems"> 
	          <li class="listitem">
	  	      <script>getURL("streaming-subjects-create.dsp?aliasName=%value aliasName encode(url)%","javascript:document.htmlform_settings_streaming_create.submit();","Create Event Specification")</script>
	  	    </li>	
	  		<li class="listitem">
	  		  <script>getURL("streaming-subjects.dsp", "javascript:document.htmlform_settings_streaming.submit();", "Refresh Page");</script>
	  		</li>
	        </ul>
          %else%
	  	    <ul class="listitems"> 
              <li class="listitem">
	            <script>getURL("streaming.dsp","javascript:document.htmlform_settings_streaming.submit();","View Connection Alias Settings")</script>
	          </li>
	          <li class="listitem">
	            <script>getURL("streaming-trigger-management.dsp","javascript:document.htmlform_settings_streaming_trigger.submit();","View Trigger Management")</script>
	          </li>
	          <li class="listitem">
	            <script>getURL("streaming-subjects.dsp","javascript:document.htmlform_settings_streaming_subjects.submit();","View Event Specifications (Refresh Page)")</script>
	          </li>   
            </ul>
            <ul class="listitems"> 			  
              <li class="listitem">
	  	        <script>getURL("streaming-subjects-create.dsp?aliasName=%value aliasName encode(url)%","javascript:document.htmlform_settings_streaming_create.submit();","Create Event Specification")</script>
	  	      </li>	
            </ul>				
	  	%endif%
        </td>
      </tr>
	
      <td>
        <table class="tableView" width="100%">

          <form>
          %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%

          <tr>
            <td class="heading" colspan=8>
			  Event Specifications for Connection Alias&nbsp;
			  %invoke wm.server.streaming:getConnectionAliasList%
			    <select name="selectAlianName" id="selectAlianName" onChange="displaySettings(this)">
				  <option value="*">--- all aliases ---</option>
			      %loop aliasList%
                    <option value="%value%">%value%</option>  
				  %endloop%
				</select>
			  %onerror%
	            <tr>
                  <td class="message" colspan=2>%value errorMessage encode(html)%</td>
                </tr>
              %endinvoke%
			</td>
          </tr>
		  
          <tr>
		    <th class="subheading" scope="col" width="25%">Name</th>
		    <th class="subheading" scope="col" nowrap>Connection Alias</th>
			<th class="subheading" scope="col">Topic</th>
            <th class="subheading" scope="col">Key</th>
            <th class="subheading" scope="col">Value</th>
			<th class="subheading-c" scope="col">Delete</th>
          </tr> 
		  
		  %loop eventSourceDataList%
		    <tr>
			  <script>
	  		    createForm("htmlform_settings_streaming_subjects_detail_%value $index%", "streaming-subjects-detail.dsp", "POST", "BODY");
  		      	setFormProperty("htmlform_settings_streaming_subjects_detail_%value $index%", "referenceId", "%value referenceId encode(url)%");
				setFormProperty("htmlform_settings_streaming_subjects_detail_%value $index%", "aliasName", "%value ../aliasName encode(url)%");
  	      	  </script> 
              <td>
                <script>
		          if(is_csrf_guard_enabled && needToInsertToken) {
		  	        document.write('<a href="javascript:document.htmlform_settings_streaming_subjects_detail_%value $index%.submit();"  >%value referenceId encode(html)%</a>');
		          }else {
		            %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		            var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
					if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
				      document.write('<a href="streaming-subjects-detail.dsp?aliasName=%value aliasName encode(url)%&referenceId=%value referenceId encode(url)%&webMethods-wM-AdminUI=true">%value referenceId encode(html)%</a>');
					}else {
					  document.write('<a href="streaming-subjects-detail.dsp?aliasName=%value aliasName encode(url)%&referenceId=%value referenceId encode(url)%">%value referenceId encode(html)%</a>');
					}
		          }
                </script> 
              </td>
			  
			  <script>
	  		    createForm("htmlform_alias_detail_%value $index%", "streaming-detail.dsp", "POST", "BODY");
				setFormProperty("htmlform_alias_detail_%value $index%", "name", "%value aliasName encode(url)%");
  	      	  </script> 
              <td>
                <script>
		          if(is_csrf_guard_enabled && needToInsertToken) {
		  	        document.write('<a href="javascript:document.htmlform_alias_detail_%value $index%.submit();"  >%value aliasName encode(html)%</a>');
		          }else {
		            %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		            var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
					if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
				      document.write('<a href="streaming-detail.dsp?name=%value aliasName encode(url)%&webMethods-wM-AdminUI=true">%value aliasName encode(html)%</a>');
					}else {
					  document.write('<a href="streaming-detail.dsp?name=%value aliasName encode(url)%">%value aliasName encode(html)%</a>');
					}
		          }
                </script> 
              </td>
			  
              <td>%value topicName%</td>
			  
		      %ifvar keyCoder/type -notempty%
			    <td>%value keyCoder/type_display%</td>
			  %else%
				<td>none</td>
			  %endif%
			  
			  %ifvar valueCoder/type -notempty%
			    <td>%value valueCoder/type_display%</td>
			  %else%
				<td>none</td>
			  %endif%
			  
			  <td class="oddrowdata">
                <script>
	  		      createForm("htmlform_settings_streaming_delete_%value $index%", "streaming-subjects.dsp", "POST", "BODY");
	  		      setFormProperty("htmlform_settings_streaming_delete_%value $index%", "action", "delete");
		          setFormProperty("htmlform_settings_streaming_delete_%value $index%", "aliasName", "%aliasName name encode(url)%");
			      setFormProperty("htmlform_settings_streaming_delete_%value $index%", "referenceId", "%referenceId name encode(url)%");
		  	    </script>
                <script>
		          if(is_csrf_guard_enabled && needToInsertToken) {
		  	     	document.write('<a href="javascript:document.htmlform_settings_streaming_delete_%value $index%.submit();" onClick="return confirmDelete(\'%value referenceId encode(html)%\')"><img style="width: 13px; height: 13px;" alt="Streaming Connection Alias %value name encode(html)%" border="0" src="../WmRoot/icons/delete.png"></a>');
	  		      }else {
	  		        %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
	  		        var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
			        if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || webMethods_wM_AdminUI) {
			          document.write('<a href="streaming-subjects.dsp?action=delete&delete_aliasName=%value aliasName encode(url)%&aliasName=%value ../aliasName encode(url)%&delete_referenceId=%value referenceId encode(url)%&webMethods-wM-AdminUI=true" onClick="return confirmDelete(\'%value referenceId encode(html)%\')"><img style="width: 13px; height: 13px;" alt="Streaming Connection Alias %value name encode(html)%" border="0" src="../WmRoot/icons/delete.png"></a>');
			        }else {
			          document.write('<a href="streaming-subjects.dsp?action=delete&delete_aliasName=%value aliasName encode(url)%&aliasName=%value ../aliasName encode(url)%&delete_referenceId=%value referenceId encode(url)%" onClick="return confirmDelete(\'%value referenceId encode(url)%\')"><img style="width: 13px; height: 13px;" alt="Streaming Connection Alias %value name encode(html)%" border="0" src="../WmRoot/icons/delete.png"></a>');
			        }
  			      }
  			    </script>
              </td>
            </tr>
		  %endloop%
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
