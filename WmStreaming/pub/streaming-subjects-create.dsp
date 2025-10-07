<HTML>
  <HEAD>

    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta http-equiv="Expires" content="-1">
    <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css">
    %ifvar webMethods-wM-AdminUI%
      <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods-wM-AdminUI.css"></link>
      <script>webMethods_wM_AdminUI = 'true';</script>
    %endif%
    <script src="../WmRoot/webMethods.js"></script>

    <script language ="javascript">  
	
      /**
       *
       */
      function loadDocument() {
        setNavigation('settings-streaming.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingCreateAliasScrn');
		var selectAliasNameVar = document.getElementById("create_aliasName");
	    for (i=0; i<selectAliasNameVar.length; i++) {
          if ("%value aliasName encode(javascript)%" == selectAliasNameVar[i].value) {
            selectAliasNameVar[i].selected = true;
          }
        }  
      }
	  
	  /**
       *
       */	   
      function displayTypeData(object) {

	    if(object.name == "keyType") {
		  switch(object.options[object.selectedIndex].value) {
	        case "none":
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

      /**
       * Validation logic
       */
      function validateForm(obj) {
	   	   
	    if (obj.create_aliasName.selectedIndex < 1) {
		  alert("Connection Alias Name must be specified");
          return false;
		}
		
		if (isEmpty(obj.create_referenceId.value)) {
          alert("Event Specification Name must be specified.");
          return false;
        }else {
          var str = obj.create_referenceId.value;
          var result = /^([A-Za-z][_.:A-Za-z0-9]*)$/.test(str);
          if (!result) {
            alert("Event Specification Name must start with a letter and contain only letters, digits, underscores, periods and colons.");
            return false;
          }
        }

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
	    //  alert("Document Type Name must be specified when type is JSON.");
		//  return false;
	    //}
		
		//if (obj.valueType.value == "JSON" && isEmpty(obj.valueType_documentType.value)) {
	    //  alert("Document Type Name must be specified when type is JSON.");
		//  return false;
	    //}
		
		//if (obj.keyType.value == "XML" && isEmpty(obj.keyType_documentType.value)) {
	    //  alert("Document Type Name must be specified when type is XML.");
		//  return false;
	    //}
		
		//if (obj.valueType.value == "XML" && isEmpty(obj.valueType_documentType.value)) {
	    //  alert("Document Type Name must be specified when type is XML.");
		//  return false;
	    //}
		
		return true;
      }

      /**
       * 
       */
	  function changeval() {
	    var ks = document.createform.keystoreAlias.options;
	   	var selectedKS = document.createform.keystoreAlias.value;
	   
	   	for(var i=0; i<ks.length; i++) {
	   	  if(selectedKS == ks[i].value) {
	   	    var aliases = hiddenOptions[i];
	   	    document.createform.keystoreKeyAlias.options.length = aliases.length;
	   		for(var j=0;j<aliases.length;j++) {
	   		  var opt = aliases[j];
	   		  document.createform.keystoreKeyAlias.options[j] = new Option(opt.text, opt.value); 
	   		}
	   	  }
	   	}
	  }
					
      /**
       * onChange to 'Create Connection Using' was made
       */ 
      function displaySettings(object) {
	
	    //if (object.options[object.selectedIndex].value == "Kafka") {
	    //  document.getElementById("host").value = "http://localhost:9092";
	    //}else if (object.options[object.selectedIndex].value == "Mock") {
	    //  document.getElementById("host").value = "file:///c:/WINDOWS/foo.bar";
	    //}else {
	    //  document.getElementById("host").value = ""; 
	    //}
      }
			
    </script>
  </head>

  <body onLoad="loadDocument(); loadKeyStoresOptions();">

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Event Specifications &gt; Create</td>
    </tr>
    <tr>
      <td colspan="2">
        <ul class="listitems">
		  <script>createForm("htmlform_settings_streaming", "streaming-subjects.dsp", "POST", "BODY");</script>
          <li class="listitem"><script>getURL("streaming-subjects.dsp?aliasName=%value aliasName%","javascript:document.htmlform_settings_streaming.submit();","Return to Event Specifications")</script></li>
        </ul>
      </td>
    </tr>
    <tr>
      <td><form name='createform' action="streaming-subjects.dsp" method="post" autocomplete="off">
        %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%
        <table class="tableView" width="100%">

          <!--                  -->
          <!-- General Settings -->
          <!--                  -->	  
          <tr>
            <td class="heading" colspan=2>Event Specification</td>
          </tr> 

          <!-- Connection Alias Name -->
          <tr>
            <td width="40%"><label for="create_aliasName">Connection Alias Name</label></td>
            <td class="oddrow-l">
			  
			  %invoke wm.server.streaming:getConnectionAliasList%
			    <select name="create_aliasName" id="create_aliasName" onChange="displaySettings(this)">
				  <option value="">--- select connection alias ---</option>
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
            <script>writeTD("row-l");</script><label for="create_referenceId">Event Specification Name</label></td>
            <script>writeTD("row-l");</script><INPUT NAME="create_referenceId" ID="create_referenceId"size="50"></td>
          </tr>
		  
		  <tr>
            <td class="subheading" colspan=2>Topic</td>
          </tr> 
		  
		  <!-- Topic Name --> 
		  <tr>
            <td><label for="topicName">Topic Name</label></td>
            <td><INPUT NAME="topicName" ID="topicName" size="50"></td>
          </tr>
		  
		  <tr>
            <td class="subheading" colspan=2>Key</td>
          </tr> 
		  <!-- Key Type --> 
		  <tr>
            <td><label for="keyType">Type</label></td>
			<td>
			  <select name="keyType" ID="keyType" onchange="displayTypeData(this)">
			    <option value="none">none</value>
				<option value="RAW">raw</value>
				<option value="DOUBLE">Double</value>
				<option value="FLOAT">Float</value>
				<option value="INTEGER">Integer</value>
				<option value="LONG">Long</value>
				<option value="STRING">String</value>
				<option value="JSON">JSON</value>
				<option value="XML">XML</value>
			  </select>
			</td>
          </tr>		  
		  <tbody id="keyType_decodeAsString" STYLE="display: none">
            <tr>
              <td><label for="keyType_decodeAsString">Decode as String</label></td>
              <td><INPUT TYPE="checkbox" NAME="keyType_decodeAsString" id="keyType_decodeAsString" size="50" checked=true></td>
            </tr>
          </tbody>
		  <tbody id="keyType_documentType" STYLE="display: none">
            <tr>
              <td><label for="keyType_documentType">Document Type Name</label></td>
              <td><INPUT NAME="keyType_documentType" id="keyType_documentType" size="50"></td>
            </tr>
		  </tbody>
		  <tbody id="keyType_charset" STYLE="display: none">
            <tr>
              <td><label for="keyType_charset">Charset Name</label></td>
              <td><INPUT NAME="keyType_charset" id="keyType_charset" size="50" value="UTF-8"></td>
            </tr>
          </tbody>
		  
		  <tr>
            <td class="subheading" colspan=2>Value</td>
          </tr> 
		  <!-- Value Type --> 
		  <tr>
            <td><label for="valueType">Type</label></td>
			<td>
			  <select name="valueType" ID="valueType" onchange="displayTypeData(this)">
			    <option value="none">none</value>
				<option value="RAW">raw</value>
				<option value="DOUBLE">Double</value>
				<option value="FLOAT">Float</value>
				<option value="INTEGER">Integer</value> 
				<option value="LONG">Long</value>
				<option value="STRING">String</value>
				<option value="JSON">JSON</value>
				<option value="XML">XML</value>
			  </select>
			</td>
          </tr>  
		  <tbody id="valueType_decodeAsString" STYLE="display: none">
            <tr>
              <td><label for="valueType_decodeAsString">Decode as String</label></td>
              <td><INPUT TYPE="checkbox" NAME="valueType_decodeAsString" id="valueType_decodeAsString" size="50" checked=true></td>
            </tr>
          </tbody>  
		  <tbody id="valueType_documentType" STYLE="display: none">
            <tr>
              <td><label for="valueType_documentType">Document Type Name</label></td>
              <td><INPUT NAME="valueType_documentType" id="valueType_documentType" size="50"></td>
            </tr>
		  </tbody>
		  <tbody id="valueType_charset" STYLE="display: none">
            <tr>
              <td><label for="valueType_charset">Charset Name</label></td>
              <td><INPUT NAME="valueType_charset" id="valueType_charset" size="50" value="UTF-8"></td>
            </tr>
          </tbody>

        </table>
               
        <table class="tableView" width="100%">
          <tr>
              <td class="action" colspan=2>

                <input name="action" type="hidden" value="create">
				<input name="aliasName" type="hidden" value="%value aliasName%">
                <input type="submit" value="Save Changes" onClick="javascript:return validateForm(this.form)">
              </td>
            </tr>
        </table>

       </form>

      </td>
    </tr>
  </table>
</body>
</html>
