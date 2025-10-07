<html>
<head>

<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<meta http-equiv="Expires" content="-1">

<link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css">
%ifvar webMethods-wM-AdminUI%
  <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods-wM-AdminUI.css"></link>
  <script>webMethods_wM_AdminUI = 'true';</script>
%endif%  
<script src="../WmRoot/webMethods.js"></script>

%invoke wm.server.streaming:getEventSourceReport%

<script language ="javascript">

/**
 * displaySettings
 */
function displaySettings(object) {

    if (object.options[object.selectedIndex].value == "0") {
        document.all.div1.style.display = 'block';
        document.all.div2.style.display = 'none';
    }else if (object.options[object.selectedIndex].value == "1") {
        document.all.div1.style.display = 'none';
        document.all.div2.style.display = 'block';
    }else {
        document.all.div1.style.display = 'none';
        document.all.div2.style.display = 'none';
    }
}

/**
 * loadDocument
 */
function loadDocument() {

    setNavigation('streaming.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingAliasEditScrn');

    %switch eventSourceData/keyCoder/type%
	  %case 'NONE'%	     
		document.getElementById('keyType_charset').style.display = 'none';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = 'none';
	  %case 'none'%	     
		document.getElementById('keyType_charset').style.display = 'none';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = 'none';
	  %case 'RAW'%	     
		document.getElementById('keyType_charset').style.display = 'none';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = 'none';
	  %case 'STRING'%     
	    document.getElementById('keyType_charset').style.display = '';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = 'none';
	  %case 'XML'%
	    document.getElementById('keyType_charset').style.display = '';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = '';
	  %case 'JSON'%
	    document.getElementById('keyType_charset').style.display = '';
		document.getElementById('keyType_decodeAsString').style.display = 'none';
	    document.getElementById('keyType_documentType').style.display = '';
	  %case%
		document.getElementById('keyType_charset').style.display = 'none';
		document.getElementById('keyType_decodeAsString').style.display = '';
	    document.getElementById('keyType_documentType').style.display = 'none';
	%end%
	
	%switch eventSourceData/valueCoder/type%
	  %case 'NONE'%	     
		document.getElementById('valueType_charset').style.display = 'none';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = 'none';
	  %case 'none'%	     
		document.getElementById('valueType_charset').style.display = 'none';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = 'none';
	  %case 'RAW'%	     
		document.getElementById('valueType_charset').style.display = 'none';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = 'none';
	  %case 'STRING'%     
	    document.getElementById('valueType_charset').style.display = '';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = 'none';
	  %case 'XML'%
	    document.getElementById('valueType_charset').style.display = '';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = '';
	  %case 'JSON'%
	    document.getElementById('valueType_charset').style.display = '';
		document.getElementById('valueType_decodeAsString').style.display = 'none';
	    document.getElementById('valueType_documentType').style.display = '';
	  %case%
		document.getElementById('valueType_charset').style.display = 'none';
		document.getElementById('valueType_decodeAsString').style.display = '';
	    document.getElementById('valueType_documentType').style.display = 'none';
	%end%

  /*  for (i=0; i<document.editform.classLoader.options.length; i++) {
      if ("package: %value classLoader encode(javascript)%" == document.editform.classLoader.options[i].text) {
        document.editform.classLoader.selectedIndex=i;
      }
    }*/
}

/**
 * validateForm
 */
function validateForm(obj) { 

    var topic = obj.topicName.value;
	if (isEmpty(topic)) {
		alert("Topic Name must be specified.");
		return false;
	}else {
		var result = /^([A-Za-z][._A-Za-z0-9$]*)$/.test(topic);
		if (!result) {
			alert("Topic name must start with a letter and contain only letters, digits, and underscores.");
			return false;
		}
	}
	
	//if (obj.keyType.value == "JSON" && isEmpty(obj.keyType_documentType.value)) {
	//	alert("Document Type Name must be specified when type is JSON.");
	//	return false;
	//}
	//if (obj.valueType.value == "JSON" && isEmpty(obj.valueType_documentType.value)) {
	//	alert("Document Type Name must be specified when type is JSON.");
	//	return false;
	//}	
	i//f (obj.keyType.value == "XML" && isEmpty(obj.keyType_documentType.value)) {
	//	alert("Document Type Name must be specified when type is XML.");
	//	return false;
	//}
	//if (obj.valueType.value == "XML" && isEmpty(obj.valueType_documentType.value)) {
	//	alert("Document Type Name must be specified when type is XML.");
	//	return false;
	//}
	return true;
}

// To show and hide rows depending on useSSL radio button
function toggleSSL() {

				var ssl = document.getElementsByName('useSSL');

				for(var i=0, length=ssl.length; i<length; i++){
					if(ssl[i].checked ){
						if(ssl[i].value == 'No'){
							document.getElementById('sslTSRow').style.display = 'none';
							document.getElementById('sslKSRow').style.display = 'none'
							document.getElementById('sslKeyRow').style.display = 'none';
						}else{
							document.getElementById('sslTSRow').style.display = '';
							document.getElementById('sslKSRow').style.display = ''
							document.getElementById('sslKeyRow').style.display = '';
						}
					}
				}
			}

			// To show and hide rows depending on useSSL radio button
function onLoadSSL() {
                var selectedSSL = '%value useSSL encode(html)%';
				var ssl = document.getElementsByName('useSSL');


						if(selectedSSL == 'Yes'){
							ssl[1].checked=true;
							document.getElementById('sslTSRow').style.display = '';
							document.getElementById('sslKSRow').style.display = ''
							document.getElementById('sslKeyRow').style.display = '';
						}else{
						    ssl[0].checked = true;
							document.getElementById('sslTSRow').style.display = 'none';
							document.getElementById('sslKSRow').style.display = 'none'
							document.getElementById('sslKeyRow').style.display = 'none';
						}


			}

			//certificate based
			var hiddenOptions = new Array();
			var hiddenOptionsTs = new Array();

			function loadKeyStoresOptions()
			{
			    var ks = document.editform.keystoreAlias.options
				var ts = document.editform.truststoreAlias.options
	      		%invoke wm.server.security.keystore:listKeyStoresAndConfiguredKeyAliases%
	      			   ks[ks.length] = new Option("","");
				       hiddenOptions[ks.length-1] = new Array();

			       	   %loop keyStoresAndConfiguredKeyAliases%
			       			ks.length=ks.length+1;
				       		ks[ks.length-1] = new Option("%value encode(javascript) keyStoreName%","%value encode(javascript) keyStoreName%");
			           		var aliases = new Array();
			    	   		%loop keyAliases%
			       				aliases[%value $index%] = new Option("%value%","%value%");
			       			%endloop%
			       			if (aliases.length == 0)
			       			{
								aliases[0] = new Option("","");
							}
				       		hiddenOptions[ks.length-1] = aliases;
		       	   %endloop%
			    %endinvoke%

				//list trust store aliases
				%invoke wm.server.security.keystore:listTrustStores%
	      			   ts[ts.length] = new Option("","");
				       hiddenOptionsTs[ts.length-1] = new Array();
			       	   %loop trustStores%
			       			ts.length=ts.length+1;
				       		ts[ts.length-1] = new Option("%value encode(javascript) keyStoreName%","%value encode(javascript) keyStoreName%");
			           		var aliases = new Array();
				       		hiddenOptionsTs[ts.length-1] = aliases;
		       	   %endloop%
			    %endinvoke%

				var keyOpts = document.editform.truststoreAlias.options;
    			var key = "%value encode(javascript) truststoreAlias%";
				if ( key != "")
				{
	       			for(var i=0; i<keyOpts.length; i++)
	       			{
				    	if(key == keyOpts[i].value) {
				    		keyOpts[i].selected = true;
		    			}
			      	}
				}

			    var keyOpts = document.editform.keystoreAlias.options;
    			var key = "%value encode(javascript) keystoreAlias%";
				if ( key != "")
				{
	       			for(var i=0; i<keyOpts.length; i++)
	       			{
				    	if(key == keyOpts[i].value) {
				    		keyOpts[i].selected = true;
		    			}
			      	}
				}

				changeval();

				var aliasOpts = document.editform.keystoreKeyAlias.options;
    			var alias = '%value encode(javascript) keystoreKeyAlias%';
				if ( alias != "")
				{
	       			for(var i=0; i<aliasOpts.length; i++)
	       			{
				    	if(alias == aliasOpts[i].value) {
				    		aliasOpts[i].selected = true;
		    			}
			      	}
				}
	      }

			function changeval() {
				var ks = document.editform.keystoreAlias.options;
				var selectedKS = document.editform.keystoreAlias.value;
				for(var i=0; i<ks.length; i++) {
					if(selectedKS == ks[i].value) {
						var aliases = hiddenOptions[i];
						document.editform.keystoreKeyAlias.options.length = aliases.length;
						for(var j=0;j<aliases.length;j++) {
							var opt = aliases[j];
							document.editform.keystoreKeyAlias.options[j] = new Option(opt.text, opt.value);
						}
					}
				}
			}

/**
 * isInt
 */
function isInt(value) {

    var strValidChars = "0123456789";
    var strChar;
    var blnResult = true;

    for (i = 0; i < value.length && blnResult == true; i++) {
        strChar = value.charAt(i);
        if (strValidChars.indexOf(strChar) == -1) {
            blnResult = false;
        }
    }
    return blnResult;
}

		
	  /**
       *
       */	   
      function displayTypeData(object) {

	    if(object.name == "keyType") {
		  switch(object.options[object.selectedIndex].value) {
	        case "none":	     
	          document.getElementById('keyType_charset').style.display = 'none';
		      document.getElementById('keyType_decodeAsString').style.display = 'none';
	          document.getElementById('keyType_documentType').style.display = 'none'; 
		  	  break;
			case "RAW":	     
	          document.getElementById('keyType_charset').style.display = 'none';
		      document.getElementById('keyType_decodeAsString').style.display = 'none';
	          document.getElementById('keyType_documentType').style.display = 'none';
		  	  break;
		    case "STRING":	     
	          document.getElementById('keyType_charset').style.display = '';
		      document.getElementById('keyType_decodeAsString').style.display = 'none';
	          document.getElementById('keyType_documentType').style.display = 'none';
		  	  break;
	        case "XML":
	        case "JSON":
	          document.getElementById('keyType_charset').style.display = '';
		      document.getElementById('keyType_decodeAsString').style.display = 'none';
	          document.getElementById('keyType_documentType').style.display = '';
		  	  break;
		    default:
		      document.getElementById('keyType_charset').style.display = 'none';
		      document.getElementById('keyType_decodeAsString').style.display = '';
	          document.getElementById('keyType_documentType').style.display = 'none';
	      }
		}else {
		  switch(object.options[object.selectedIndex].value) {
	        case "none":	     
	          document.getElementById('valueType_charset').style.display = 'none';
		      document.getElementById('valueType_decodeAsString').style.display = 'none';
	          document.getElementById('valueType_documentType').style.display = 'none';
		  	  break;
			case "RAW":	     
	          document.getElementById('valueType_charset').style.display = 'none';
		      document.getElementById('valueType_decodeAsString').style.display = 'none';
	          document.getElementById('valueType_documentType').style.display = 'none';
		  	  break;
		    case "STRING":	     
	          document.getElementById('valueType_charset').style.display = '';
		      document.getElementById('valueType_decodeAsString').style.display = 'none';
	          document.getElementById('valueType_documentType').style.display = 'none';
		  	  break;
	        case "XML":
	        case "JSON":
	          document.getElementById('valueType_charset').style.display = '';
		      document.getElementById('valueType_decodeAsString').style.display = 'none';
	          document.getElementById('valueType_documentType').style.display = '';
		  	break;
		      default:
		      document.getElementById('valueType_charset').style.display = 'none';
		      document.getElementById('valueType_decodeAsString').style.display = '';
	          document.getElementById('valueType_documentType').style.display = 'none';
	      }
		}
      }

</script>

</head>

<body onLoad="loadDocument(); onLoadSSL(); loadKeyStoresOptions();">  

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing Settings &gt; Event Specification &gt; Edit</TD>
    </tr>
    <tr>
      <td colspan="2">
        <ul class="listitems">
		  <script>
		  createForm("htmlform_settings_jms_detail", "streaming-subjects-detail.dsp", "POST", "BODY");
		  setFormProperty("htmlform_settings_streaming_detail", "aliasName", "%value aliasName encode(url)%");
		  setFormProperty("htmlform_settings_streaming_detail", "referenceId", "%value referenceId encode(url)%");
		  </script>
          <li class="listitem">
		  <script>getURL("streaming-subjects-detail.dsp?aliasName=%value aliasName encode(url)%&referenceId=%value referenceId encode(url)%","javascript:document.htmlform_settings_streaming_detail.submit();","Return to Event Specification Details")</script>
		  </li>
        </ul>
      </td>
    </tr>
    <tr>

    <form name="editform" action="streaming-subjects-detail.dsp?aliasName=%value aliasName encode(url)%&referenceId=%value referenceId encode(url)%" METHOD="POST">
      %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%

      <td>
        <table class="tableView" width="100%">

          <tr>
            <td class="heading" colspan=2>Event Specification</td>
          </tr>

          <!-- Alias Name -->
          <tr>
            <td width="40%" class="oddrow-l" nowrap="true"><label for="aliasName">Connection Alias Name</label></td>
            <td class="oddrowdata-l"><INPUT name="aliasName" id="aliasName" size="50" value="%value aliasName encode(htmlattr)%" DISABLED></td>
          </tr>
		  
          <tr>
            <td width="40%" class="oddrow-l" nowrap="true"><label for="referenceId">Event Specification Name</label></td>
            <td class="oddrowdata-l"><INPUT name="referenceId" id="referenceId" size="50" value="%value referenceId encode(htmlattr)%" DISABLED></td>
          </tr>
		  
		  <tr>
            <td class="subheading" colspan=2>Topic</td>
          </tr>
		  
		  <tr>
            <td width="40%" class="oddrow-l" nowrap="true"><label for="topicName">Topic Name</label></td>
            <td class="oddrowdata-l"><INPUT name="topicName" id="topicName" size="50" value="%value eventSourceData/topicName encode(html)%"></td>
          </tr>

          <tr>
            <td class="subheading" colspan=2>Key</td>
          </tr>		  
		  <tr>
            <td width="40%" class="oddrow-l" nowrap="true"><label for="keyType">Type</label></td>
            <td>
			  <select name="keyType" ID="keyType" onchange="displayTypeData(this)">
			    <option value="none" %ifvar eventSourceData/keyCoder/type -isNull%selected%endif%>none</value>
				<option value="RAW" %ifvar eventSourceData/keyCoder/type equals('RAW')%selected%endif%>raw</value>
				<option value="DOUBLE" %ifvar eventSourceData/keyCoder/type equals('DOUBLE')%selected%endif%>Double</value>
				<option value="FLOAT" %ifvar eventSourceData/keyCoder/type equals('FLOAT')%selected%endif%>Float</value>
				<option value="INTEGER" %ifvar eventSourceData/keyCoder/type equals('INTEGER')%selected%endif%>Integer</value>
				<option value="LONG" %ifvar eventSourceData/keyCoder/type equals('LONG')%selected%endif%>Long</value>
				<option value="STRING" %ifvar eventSourceData/keyCoder/type equals('STRING')%selected%endif%>String</value>
				<option value="JSON" %ifvar eventSourceData/keyCoder/type equals('JSON')%selected%endif%>JSON</value>
				<option value="XML" %ifvar eventSourceData/keyCoder/type equals('XML')%selected%endif%>XML</value>
			  </select>
			</td>
          </tr>	
		  <tbody id="keyType_decodeAsString" STYLE="display: none">
            <tr>
              <td><label for="keyType_decodeAsString">Decode as String</label></td>
              <td><INPUT TYPE="checkbox" NAME="keyType_decodeAsString" id="keyType_decodeAsString" size="50" %ifvar eventSourceData/keyCoder/decodeAsString equals('true')%checked=true%endif%></td>
            </tr>
          </tbody>
		  <tbody id="keyType_documentType" STYLE="display: none">
            <tr>
              <td><label for="keyType_documentType">Document Type Name</label></td>
              <td><INPUT NAME="keyType_documentType" id="keyType_documentType" size="50" value="%value eventSourceData/keyCoder/documentTypeName encode(html)%"></td>
            </tr>
		  </tbody>
		  <tbody id="keyType_charset" STYLE="display: none">
            <tr>
              <td><label for="keyType_charset">Charset Name</label></td>
              <td><INPUT NAME="keyType_charset" id="keyType_charset" size="50" value="%value eventSourceData/keyCoder/charsetName encode(html)%"></td>
            </tr>
          </tbody>
		  
		  <tr>
            <td class="subheading" colspan=2>Value</td>
          </tr>		  
		  <tr>
            <td width="40%" class="oddrow-l" nowrap="true"><label for="valueType">Type</label></td>
			<td>
			  <select name="valueType" ID="valueType" onchange="displayTypeData(this)">
			    <option value="none" %ifvar eventSourceData/valueCoder/type -isNull%selected%endif%>none</value>
				<option value="RAW" %ifvar eventSourceData/valueCoder/type equals('RAW')%selected%endif%>raw</value>
				<option value="DOUBLE" %ifvar eventSourceData/valueCoder/type equals('DOUBLE')%selected%endif%>Double</value>
				<option value="FLOAT" %ifvar eventSourceData/valueCoder/type equals('FLOAT')%selected%endif%>Float</value>
				<option value="INTEGER" %ifvar eventSourceData/valueCoder/type equals('INTEGER')%selected%endif%>Integer</value>
				<option value="LONG" %ifvar eventSourceData/valueCoder/type equals('LONG')%selected%endif%>Long</value>
				<option value="STRING" %ifvar eventSourceData/valueCoder/type equals('STRING')%selected%endif%>String</value>
				<option value="JSON" %ifvar eventSourceData/valueCoder/type equals('JSON')%selected%endif%>JSON</value>
				<option value="XML" %ifvar eventSourceData/valueCoder/type equals('XML')%selected%endif%>XML</value>
			  </select>
			</td>
          </tr>		  
		  <tbody id="valueType_decodeAsString" STYLE="display: none">
            <tr>
              <td><label for="valueType_decodeAsString">Decode as String</label></td>
              <td><INPUT TYPE="checkbox" NAME="valueType_decodeAsString" id="valueType_decodeAsString" size="50" %ifvar eventSourceData/valueCoder/decodeAsString equals('true')%checked=true%endif%></td>
            </tr>
          </tbody>
		  <tbody id="valueType_documentType" STYLE="display: none">
            <tr>
              <td><label for="valueType_documentType">Document Type Name</label></td>
              <td><INPUT NAME="valueType_documentType" id="valueType_documentType" size="50" value="%value eventSourceData/valueCoder/documentTypeName encode(html)%"></td>
            </tr>
		  </tbody>
          <tbody id="valueType_charset" STYLE="display: none">
            <tr>
              <td><label for="valueType_charset">Charset Name</label></td>
              <td><INPUT NAME="valueType_charset" id="valueType_charset" size="50" value="%value eventSourceData/valueCoder/charsetName encode(html)%"></td>
            </tr>
          </tbody>
		  
	    </table>
        <!-- Submit Button -->
        <table class="tableView" width="100%">
          <tr>
              <td class="action" colspan=2>
                <input name="aliasName" type="hidden" value="%value aliasName encode(htmlattr)%">
				<input name="referenceId" type="hidden" value="%value referenceId encode(htmlattr)%">
                <input name="action" type="hidden" value="edit">
                <input type="submit" value="Save Changes" onClick="javascript:return validateForm(this.form)">
              </td>
            </tr>
        </table>
      </td>
    </tr>
    </form>
  </table>

%onerror%
%value errorService encode(html)%<br>
%value error encode(html)%<br>
%value errorMessage encode(html)%<br>

</body>

%endinvoke%

</html>