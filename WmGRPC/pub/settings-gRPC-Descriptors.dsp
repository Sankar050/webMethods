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
	function enableDescriptor(name, op) {
             if(op == 'enable') {
                var msg = "OK to enable gRPC Descriptor "+name;
            } else {
                var msg = "OK to disable gRPC Descriptor "+name;
            }
            if ( confirm(msg) ) {
				document.enableForm.NSName.value = name;
				document.enableForm.enabled.value = (op == 'enable');
				document.enableForm.submit();
                return true;
            } else {
                return false;
            }
	}
</SCRIPT>
</HEAD>

<BODY onLoad="setNavigation('settings-gRPC-Descriptors.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_gRPC_Descriptors');">
<TABLE width="100%">
<TR>
    <TD class="breadcrumb" colspan="2">
    Settings &gt;
    gRPC &gt;
	Descriptors</TD>
</TR>

%value message encode(html)%

%ifvar action%
%switch action%
%case 'enable'%
  %invoke wm.server.grpc:updateGRPCDescriptor%
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
			createForm("htmlform_settings_alias_addedit_assoc_dev", "settings-gRPC.dsp", "POST", "BODY");
			</script>
            <li class="listitem">
			<script>getURL("settings-gRPC.dsp", "javascript:document.htmlform_settings_alias_addedit_assoc_dev.submit();", "Return to gRPC Settings");</script>
			
			</li>
        </ul>
    </td>
</tr>
<TR>
    <TD>
    <TABLE class="tableView" width=100%>

    <TR>
        <TD class="heading" colspan=10>gRPC Descriptor List</TD>
    </TR>
%invoke wm.server.grpc:getGRPCDescriptorServices%
<TR>
   <TH class="oddcol-l" scope="col">Name</TH>
   <TH class="oddcol" scope="col">gRPC Services</TH>
   <TH class="oddcol" scope="col">gRPC Channel</TH>
   <TH class="oddcol" scope="col">Package</TH>
   <TH class="oddcol" scope="col">Enabled</TH>
</TR>

%loop descriptors%
<TR>
    <script>writeTD("rowdata-l");</script>
	<script>
	createForm("htmlform_settings_alias_addedit_%value $index%", "settings-gRPC-Descriptors.dsp", "POST", "BODY");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "action", "edit");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "alias", "%value alias encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "urlPath", "%value urlPath encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "portList", "%value portList encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "package", "%value node_pkg encode(url)%");
	setFormProperty("htmlform_settings_alias_addedit_%value $index%", "association", "%value association encode(url)%");
	</script>
	
        
	%value node_nsName encode(html)%</TD>
	<script>writeTD("rowdata-l");</script>%loop serviceList% %value fullSvcName%<br>%endloop%</TD>
    <script>writeTD("rowdata-l");</script>%value channelName encode(html)%</TD>
    <script>writeTD("rowdata-l");</script>%value node_pkg encode(html)%</TD>    
	<script>writeTD("rowdata");</script>
	<script>
	 createForm("htmlform_settings_gRPC_descriptor_%value $index%", "settings-gRPC-Descriptors.dsp", "POST", "BODY");
	</script>
    %ifvar enabled equals('true')%
        <a class="imagelink" href="javascript:document.htmlform_settings_gRPC_descriptor_%value $index%.submit();" onClick="return enableDescriptor('%value node_nsName encode(javascript)%', 'disable');"><img src="../WmRoot/images/green_check.png"  border="no">Yes</a>
    %else%
        &nbsp;&nbsp;&nbsp;<a href="javascript:document.htmlform_settings_gRPC_descriptor_%value $index%.submit();" onClick="return enableDescriptor('%value node_nsName encode(javascript)%', 'enable');">No</a>
    %endif%
	</TD>

</TR>

    <script>swapRows();</script>
%endloop%
%endinvoke%
</TABLE>
</TD>
</TR>

</TABLE>

<FORM name="enableForm" action="settings-gRPC-Descriptors.dsp" method="POST">
  %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%
  <INPUT type="hidden" name="action" value="enable">
  <INPUT type="hidden" name="NSName">
  <INPUT type="hidden" name="enabled">
</FORM>

</BODY>
</HTML>
