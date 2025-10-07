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
<SCRIPT SRC="../WmRoot/webMethods.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
  function enableChannel(name, op) {
             if(op == 'enable') {
                var msg = "OK to enable channel "+name;
            } else {
                var msg = "OK to disable channel "+name;
            }
            if ( confirm(msg) ) {
				document.enableform.channelName.value = name;
				document.enableform.enabled.value = (op == 'enable');
				document.enableform.submit();
                return true;
            } else {
                return false;
            }
  }
</SCRIPT>
</HEAD>

<BODY onLoad="setNavigation('settings-gRPC.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_gRPC');">
<TABLE width="100%">
<TR>
    <TD class="breadcrumb" colspan="2">
    Settings &gt;
    gRPC </TD>
</TR>

%value message encode(html)%

%ifvar action%
%switch action%
%case 'edit'%
  %invoke wm.server.grpc:updateProviderChannel%
        %ifvar message%
      <tr><td colspan="2">&nbsp;</td></tr>
          <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
        %endif%
  %endinvoke%
%case 'enable'%
  %invoke wm.server.grpc:enableProviderChannel%
        %ifvar message%
      <tr><td colspan="2">&nbsp;</td></tr>
          <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
        %endif%
  %endinvoke%
%endswitch%
%endif%

<tr>
    <td colspan="2">
        <ul class="listitems">
			<script>
			createForm("htmlform_settings_alias_addedit_assoc_dev", "settings-gRPC-Descriptors.dsp", "POST", "BODY");
			</script>
            <li class="listitem">
			<script>getURL("settings-gRPC-Descriptors.dsp", "javascript:document.htmlform_settings_alias_addedit_assoc_dev.submit();", "gRPC Descriptors");</script>
			
			</li>
        </ul>
    </td>
</tr>
<TR>
    <TD>
    <TABLE class="tableView" width=100%>

    <TR>
        <TD class="heading" colspan=10>gRPC Channel List</TD>
    </TR>
%invoke wm.server.grpc:listProviderChannels%
<TR>
   <TH class="oddcol-l" scope="col">Name</TH>
   <TH class="oddcol" scope="col">Description</TH>
   <TH class="oddcol" scope="col">Port</TH>
   <TH class="oddcol" scope="col">Default</TH>
   <TH class="oddcol" scope="col">Package</TH>
   <TH class="oddcol" scope="col">Enabled</TH>
</TR>

%loop channels%
<TR>
    <script>writeTD("rowdata-l");</script>
	<script>
		if(is_csrf_guard_enabled && needToInsertToken) {
			createForm("htmlform_settings_gRPC_channel_addedit", "settings-gRPC-channel-addedit.dsp", "POST", "BODY");

			setFormProperty("htmlform_settings_gRPC_channel_addedit", "action", "edit");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "returnHSMBasedKS", "true");

			setFormProperty("htmlform_settings_gRPC_channel_addedit", "channelName", "%value name encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "name", "%value name encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "description", "%value description encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "port", "%value port encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "package", "%value packageName encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "default", "%value isDefault encode(url)%");
			setFormProperty("htmlform_settings_gRPC_channel_addedit", "enabled", "%value enabled encode(url)%");

			getURL("htmlform_settings_gRPC_channel_addedit?webMethods-wM-AdminUI=true", "javascript:document.htmlform_settings_gRPC_channel_addedit.submit();", "%value name encode(html)%");
		} else {
			%rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
			var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
			if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
				document.write("<a href='settings-gRPC-channel-addedit.dsp?action=edit&returnHSMBasedKS=true&channelName=%value name encode(url)%&webMethods-wM-AdminUI=true'> %value name encode(html)%</a>");
			}
			else {
				document.write("<a href='settings-gRPC-channel-addedit.dsp?action=edit&returnHSMBasedKS=true&channelName=%value name encode(url)%'> %value name encode(html)%</a>");
			}
		}
	</script>
	
	</TD>
    <script>writeTD("rowdata");</script>%value description encode(html)%</TD>
    <script>writeTD("rowdata");</script>%value port encode(html)%</TD>
    <script>writeTD("rowdata");</script>
	%ifvar isDefault equals('true')%
        <img src="../WmRoot/images/green_check.png" border="no">Yes
    %else%
         &nbsp;&nbsp;&nbsp;No
    %endif%
	
	</TD>
    <script>writeTD("rowdata");</script>%value packageName encode(html)%</TD>
    <script>writeTD("rowdata");</script>
	<script>
	 createForm("htmlform_settings_gRPC_%value $index%", "settings-gRPC.dsp", "POST", "BODY");
	 </script>
    %ifvar enabled equals('true')%
        <a class="imagelink" href="javascript:document.channel.submit();" onClick="return enableChannel('%value name encode(javascript)%', 'disable');"><img src="../WmRoot/images/green_check.png"  border="no">Yes</a>
    %else%
        &nbsp;&nbsp;&nbsp;<a href="javascript:document.channel.submit();" onClick="return enableChannel('%value name encode(javascript)%', 'enable');">No</a>
    %endif%
	</TD>

</TR>

    <script>swapRows();</script>
%endloop%
%endinvoke%
</TABLE>
</TD>
</TR>
<TR>
    <TD>
    <TABLE class="tableView" width=100%>

    <TR>
        <TD class="heading" colspan=10>Registered gRPC Services</TD>
    </TR>
%invoke wm.server.grpc:getProviderChannelRegistries%
<TR>
   <TH class="oddcol-l" scope="col">gRPC Service Name</TH>
   <TH class="oddcol" scope="col">gRPC Methods</TH>
   <TH class="oddcol" scope="col">gRPC Descriptor</TH>
</TR>

%loop channels%
%loop services%
<TR>
    <script>writeTD("rowdata-l");</script>
	<script>
	createForm("htmlform_settings_alias_addedit_%value $index%", "../WmRoot/settings-alias-addedit.dsp", "POST", "BODY");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "action", "edit");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "alias", "%value alias encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "urlPath", "%value urlPath encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "portList", "%value portList encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "package", "%value packageName encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "association", "%value association encode(url)%");
	</script>
	
        
	%value serviceName encode(html)%</TD>
	<script>writeTD("rowdata");</script>%loop methods% %value name encode(html)%<br>%endloop%</TD>
    <script>writeTD("rowdata");</script>%value providerDescriptor encode(html)%</TD>
</TR>

    <script>swapRows();</script>
%endloop%
%endloop%
%endinvoke%
</TABLE>
</TD>
</TR>

</TABLE>

<FORM name="enableform" action="settings-gRPC.dsp" method="POST">
  %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%
  <INPUT type="hidden" name="action" value="enable">
  <INPUT type="hidden" name="channelName">
  <INPUT type="hidden" name="enabled">
</FORM>

</BODY>
</HTML>
