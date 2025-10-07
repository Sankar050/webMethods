
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
    <SCRIPT SRC="../WmRoot/webMethods.js">
    </SCRIPT>
    <base target="_self">
    <style>
      .listbox  { width: 100%; }
    </style>
  </HEAD>
  <BODY onLoad="setupData();setNavigation('settings-alias.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_gRPC_Channels');">
    <TABLE width="100%">
      <TR>
        <TD class="breadcrumb" colspan="2">
            Settings &gt;
            gRPC &gt;
                %value channelName encode(html)% &gt; Edit gRPC Channel
        </TD>
      </TR>
      <TR>
        <TD colspan="2">
          <ul class="listitems">
		  <script>
			createForm("htmlform_settings_alias", "settings-gRPC.dsp", "POST", "BODY");
			</script>
            <li class="listitem"><script>getURL("settings-gRPC.dsp", "javascript:document.htmlform_settings_alias.submit();", "Return to gRPC Settings");</script>
			</li>
          </UL>
        </TD>
      </TR>
      <TR>
        <TD>
      <TABLE class="tableView">
        <TR>
            <TD colspan="3" class="heading">gRPC Channel Properties</TD>
        </TR>
          <SCRIPT LANGUAGE="JavaScript">
          
          var originalChannelName = "%value name%";
		  var hiddenOptions = new Array();
      
        function setupData() {
          setupKeystoreData(document.addform);
        }

		  function confirmEdit ()
          {
            if (!confirmRequiredFields())
            {
              return false;
            }
			
			if (!confirmEnableChannel())
            {
              return false;
            }
                
             document.addform.submit();
             return true;
           }
          
        function confirmRequiredFields(){
            
            if (document.addform.port.value == "" )
            {
              alert ("You must specify the port for the gRPC Channel.");
              return false;
            }
			
			if (!checkPort()){
			  return false;
			}
			
            return true;
        }
        
          function checkPort()
          {
            port = document.addform.port.value;			
			portNum = Number(port)
			
			if (Number.isInteger(portNum))
			{
				return true;
			}
			
			alert ("Port number " + port + " is not numeric.")
			return false;
          }
		  
		  function confirmEnableChannel() {
			channel = document.addform.channelName.value;
			oldenable = document.addform.oldenabled.value;
			isEnabled = (oldenable == "true");
			enable1 = document.addform.enable1.checked;
			disable = document.addform.enable2.checked;			
			var msg =""
			
			if (enable1 && isEnabled){
			   return true;
			}
			
    		if (disable && !isEnabled){
			   return true;
			}
			
            if(enable1 && !isEnabled) {
                msg = "OK to enable channel "+channel;
            } 
			if  (disable && isEnabled){
                msg = "OK to disable channel "+channel;
            }
            if ( confirm(msg) ) {
				document.addform.enabled.value = !isEnabled;
                return true;
            } else {
                return false;
            }
          }
                    
          </SCRIPT>
	   %invoke wm.server.grpc:getProviderChannel% 
		 
          <FORM id="addform" NAME="addform" ACTION="settings-gRPC.dsp" METHOD="POST">
          %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%


          <TR>
            <TD class="oddrow" ><label for="name">Name</label></TD>
            <script>writeTD("rowdata-l");</script>%value name encode(html)%</TD></TD>
          </TR>
		  <TR>
            <TD class="evenrow" ><label for="description">Description</label></TD>
            <script>writeTD("rowdata-l");</script>%value description encode(html)%</TD></TD>
          </TR>
          <TR>
            <TD class="oddrow"><label for="port">Port</label></TD>
            <TD class="oddrow-l" colspan="2">
              <INPUT NAME="port" id="port" size=100 VALUE="%value port encode(htmlattr)%"> </TD>
          </TR>
          <TR>
            <TD class="evenrow"><label for="package">Package</label></TD>
            <script>writeTD("rowdata-l");</script>%value packageName encode(html)%</TD></TD>
          </TR>
          <TR>
            <TD class="oddrow" ><label for="default">Default</label></TD>
            <script>writeTD("rowdata-l");</script>%value isDefault encode(html)%</TD>
          </TR>
		  <TR>
            <TD class="evenrow" ><label for="enabled">Enabled</label></TD>
            <TD class="evenrow-l" colspan="2">
			   %ifvar enabled equals('true')% 
				<input type="radio" name="enable" id="enable1" value="yes" checked><label for="enable1">Yes</label></input>
				<input type="radio" name="enable" id="enable2" value="no"><label for="enable2">No</label></input>
			   %else%
				<input type="radio" name="enable" id="enable1" value="yes" ><label for="enable1">Yes</label></input>
				<input type="radio" name="enable" id="enable2" value="no" checked><label for="enable2">No</label></input>			   
			   %endif%
			</TD>
          </TR>
          <!-- Include Common KeyStore section --->
          %include config-keystore-common.dsp%
          <TR>
            <TD colspan=3 class="action">
              <INPUT TYPE="hidden" NAME="action" VALUE="edit">
              <INPUT TYPE="hidden" NAME="channelName" VALUE="%value name encode(name)%">
              <INPUT TYPE="hidden" NAME="oldport" VALUE="%value port encode(port)%">
              <INPUT TYPE="hidden" NAME="oldenabled" VALUE="%value enabled encode(enabled)%">
			  <INPUT TYPE="hidden" NAME="enabled" VALUE="%value enabled encode(enabled)%">
              <INPUT TYPE="hidden" NAME="packageName" VALUE="%value packageName encode(packageName)%">
              <INPUT TYPE="hidden" NAME="oldKeystoreAlias" VALUE="%value keystoreAlias encode(keystoreAlias)%">
              <INPUT TYPE="hidden" NAME="oldKeystoreEntry" VALUE="%value keystoreEntry encode(keystoreEntry)%">
			  <INPUT TYPE="hidden" NAME="oldTruststoreAlias" VALUE="%value truststoreAlias encode(truststoreAlias)%">
              <INPUT type="button" value="Save Changes" onclick="return confirmEdit();">
            </TD>
          </TR>
        </FORM>
	%endinvoke%
      </TABLE>
    </TD>
  </TR>
</TABLE>

</BODY>
</HTML>
