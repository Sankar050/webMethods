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
		toggleSSL();
      }

      /**
       * Validation logic
       */
       function validateForm(obj) {

		  if (isEmpty(obj.baseName.value)) {
			alert("Connection Alias Base Name must be specified.");
			return false;
		  }else {
			var str = obj.baseName.value;
			var result = /^([A-Za-z][_A-Za-z0-9]*)$/.test(str);
			if (!result) {
			  alert("Connection Alias Name must contain only letters, digits, and underscores; and it must start with a letter.");
			  return false;
			}
		  }
		  
		  if (isEmpty(obj.name.value)) {
			alert("Connection Alias Name must be specified.");
			return false;
		  }

		  if (isEmpty(obj.description.value)) {
			alert("Description must be specified.");
			return false;
		  }

		  if (isEmpty(obj.type.value) || obj.type.value == 'empty') {
			alert("Provider Type must be specified.");
			return false;
		  }

		  if (isEmpty(obj.package.value)) {
			alert("Package must be specified.");
			return false;
		  }

		  if (isEmpty(obj.host.value)) {
			alert("Provider URI must be specified.");
			return false;
		  }

		  if (isEmpty(obj.clientId.value)) {
			alert("Client Prefix must be specified.");
			return false;
		  }else {
			var str = obj.clientId.value;
			var str2 = str.replace("system:", "na");
			var result = /^([A-Za-z$][{}._A-Za-z0-9$]*)$/.test(str2);
			if (!result) {
			  alert("Client Prefix must contain only letters, digits, underscores and dollar characters; and it must start with a letter.");
			  return false;
			}
		  }

			var securityProtocol = obj.securityProtocol.value;
			var host = obj.host.value.toLowerCase();

			if (ssl == 'Yes') {
				var ks = obj.keystoreAlias.value;
				var ts = obj.truststoreAlias.value;
				if (ts == "") {
					alert(" Truststore alias is mandatory if Use SSL is Yes.");
					return false;
				}
				//keystore is optional, only needed for 2-way SSL.
			}

		  return true;
		}

			// To show and hide rows depending on  whether SSL-based protocol is selected.
			function toggleSSL() {
				var protocol = document.getElementsByName('securityProtocol');
				if(protocol[0].value == 'SSL' || protocol[0].value == 'SASL_SSL'){
					document.getElementById('sslTSRow').style.display = '';
					document.getElementById('sslKSRow').style.display = ''
					document.getElementById('sslKeyRow').style.display = '';
				}
				else{
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
			    var ks = document.createform.keystoreAlias.options
				var ts = document.createform.truststoreAlias.options
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

			    var keyOpts = document.createform.keystoreAlias.options;
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

				var aliasOpts = document.createform.keystoreKeyAlias.options;
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
         * displaySettings used to change the URI after setting the provider type
         */ 
        function displaySettings(object) {
		     	
          if (object.options[object.selectedIndex].value == "Kafka") {
            document.getElementById("host").value = "http://localhost:9092";
          }else {
            document.getElementById("host").value = "";
          }
        }
		
    </script>
  </head>

  <body onLoad="loadDocument(); loadKeyStoresOptions();">

  <table width="100%">
    <tr>
      <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Connection Alias Settings &gt; Create</td>
    </tr>
    <tr>
      <td colspan="2">
        <ul class="listitems">
		  <script>createForm("htmlform_settings_streaming", "streaming.dsp", "POST", "BODY");</script>
          <li class="listitem">
		    <script>getURL("streaming.dsp","javascript:document.htmlform_settings_streaming.submit();","Return to Connection Alias Settings")</script>
		  </li>
        </ul>
      </td>
    </tr>
    <tr>
      <td><form name='createform' action="streaming.dsp" method="post" autocomplete="off">
        %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%
        <table class="tableView" width="100%">

          <!--                  -->
          <!-- General Settings -->
          <!--                  -->	  
          <tr>
            <td class="heading" colspan=2>General Settings</td>
          </tr> 
		  
		  <!-- Connection Alias Base Name -->
		  <tr>
			<td width="40%"><label for="baseName">Connection Alias Base Name</label></td>
			<td>
		      <input id="baseName" name="baseName" size="50">
            </td>
          </tr>
		  
		  <!-- Connection Alias Name -->
          <tr>
		    <td width="40%"><label for="name">
		      <script>
          	    var usePackagePrefix = "%sysvar property(watt.server.streaming.connection.usePackagePrefix)%";
			    if (usePackagePrefix !== null && usePackagePrefix.toLowerCase() == "false") {
                  usePackagePrefix = "false";
			    }else {
				  usePackagePrefix = "true";
				}
				if (usePackagePrefix == "false") {
				  document.write("<label>Connection Alias Name (package prefix is disabled)</label>");
				}else {
				  document.write("<label>Connection Alias Name (incorporates package as a prefix)</label>");
				}
		      </script>
			</td>
		    <td>
			  <input id="name" size="50" disabled>
			</td>
		  </tr>
		  
	      <!-- Description -->
          <tr>
            <script>writeTD("row-l");</script><label for="description">Description</label></td>
            <script>writeTD("row-l");</script><INPUT NAME="description" ID="description"size="50"></td>
          </tr>
		  
		  <!-- Connection Client ID -->
          <tr>
            <script>writeTD("row-l");</script><label for="clientId">Client Prefix</label></td>
            %invoke wm.server.streaming:generateClientId%
              <script>writeTD("row-l");</script><INPUT NAME="clientId" ID="clientId" size="50" value="%value generatedClientId%"></td>
            %endinvoke%
          </tr>
		  
		  <!-- Provider Type --> 
          <tr>
            <script>writeTDWidth("row-l", "40%");</script><label for="type">Provider Type</label></td>
            %invoke wm.server.streaming:getAvailableProviders%
            <script>writeTD("row-l");</script>
			  <select name="type" ID="type" onchange="displaySettings(this.form.type)">
			    <option value="empty"></option>
                %loop availableProviders%
                    <option value="%value name encode(htmlattr)%">%value name encode(html)%</option>
                %endloop%
              </select></td>
			%onerror%
			  <td>
			    No provider implementations loaded in the classpath:<br>%value errorMessage encode(html)%
			  </td>
            %endinvoke%
          </tr>
		  
		  <!-- Package --> 
		  <tr>
		    <td width="40%"><label for="package">Package</label></td>
			<td>
			  %invoke wm.server.packages:packageList%
              <select name="package" ID="package">
			    <option selected value=""></option>
                %loop packages%
                  %ifvar enabled equals('true')%
                      <option value="%value name encode(htmlattr)%">%value name encode(html)%</option>
                  %endif%
                %endloop%
              </select>
			  %endinvoke%
			</td>
		  </tr>
		  
		  <script>
			let base = document.querySelector('#baseName');
		    let select = document.getElementById('package');		
			let result = document.querySelector('#name');
            base.addEventListener('input', function () {
		      let selValue = select.options[select.selectedIndex].value;
			  if (usePackagePrefix == "true") {
                result.value = selValue + "_" + base.value;
			  }else {
                result.value = base.value;	
              }				
            });
			if (usePackagePrefix == "true") {
		      select.addEventListener('input', function () {
		        let selValue = select.options[select.selectedIndex].value;
		        result.value = selValue + "_" + base.value;
		      });
			}
          </script>

          <!--                              -->
          <!-- Connection Settings -->
          <!--                              -->
          <tr>
            <td class="heading" colspan=2>Connection Settings</td> 
          </tr>

          <!-- Host -->
          <tr>
            <script>writeTD("row-l");</script><label for="host">Provider URI</label></td>
            <script>writeTD("row-l");</script><INPUT NAME="host" ID="host"size="50" value=""></td>
          </tr>

		  <!-- Publish Mode 
          <tr>
            <td class="evenrow-l"><label for="clientId">Publish Mode</label></td>
            <td class="evenrowdata-l">
			  <select name="publishMode" ID="publishMode" length="50">
				<option value="Asynchronous">Asynchronous</option>
				<option value="Synchronous">Synchronous</option>
			</td>
          </tr> -->
		  
		  <!-- Configuration Parameters -->
		  <tr>
            <td class="evenrow-l"><label for="other_properties">Configuration Parameters</label></td> 
			<td class="oddrow-l">One (name=value) entry per line<br>
              <textarea wrap="off" rows="5" name="other_properties" id="other_properties" cols="50"></textarea>
            </td>
          </tr>
         
          <!--                        -->
          <!-- Security Settings      -->
          <!--                        -->
          <tr>
            <td class="heading" colspan=2>Security Settings</td>
          </tr>

          <tr>
            <td width="40%" class="oddrow-l"><label for="securityProtocol">Security Protocol</label></td>
            <td class="oddrowdata-l">
              <select name="securityProtocol" ID="securityProtocol" onchange="toggleSSL()">
                        %ifvar securityProtocol equals('none')%
                            <option value="none" selected>None</option>
                        %else%
                            <option value="none">None</option>
                        %endif%

                        %ifvar securityProtocol equals('SSL')%
                            <option value="SSL" selected>SSL</option>
                        %else%
                            <option value="SSL">SSL</option>
                        %endif%

                        %ifvar securityProtocol equals('SASL_SSL')%
                            <option value="SASL_SSL" selected>SASL_SSL</option>
                        %else%
                            <option value="SASL_SSL">SASL_SSL</option>
                        %endif%

                        %ifvar securityProtocol equals('SASL_PLAINTEXT')%
                            <option value="SASL_PLAINTEXT" selected>SASL_PLAINTEXT</option>
                        %else%
                            <option value="SASL_PLAINTEXT">SASL_PLAINTEXT</option>
                        %endif%
                      </select>
            </td>
          </tr>

		  <!-- Truststore Alias -->
		  <tr id="sslTSRow">
			<script>writeTD("row-l");</script><label for="truststoreAlias" id="truststoreAliasLabel">Truststore Alias</label></td>
			<script>writeTD("row-l");</script><SELECT  name="truststoreAlias" id="truststoreAlias" style="width: 270px;"></SELECT></td>
		  </tr>

		  <!-- Keystore Alias -->
		  <tr id="sslKSRow">
		    <script>writeTD("row-l");</script><label for="keystoreAlias" id="keystoreAliasLabel">Keystore Alias</label></td>
			<script>writeTD("row-l");</script><SELECT name="keystoreAlias" id="keystoreAlias"  onchange="changeval()" style="width: 270px;"></SELECT></td>
		  </tr>

		  <!-- Key Alias : will be populated when Keystore Alias is selected -->
		  <tr id="sslKeyRow">
			<script>writeTD("row-l");</script><label for="keystoreKeyAlias" id="keystoreKeyAliasLabel">Key Alias</label></td>
			<script>writeTD("row-l");</script><select name="keystoreKeyAlias" id="keystoreKeyAlias" style="width: 270px;"></select></td>
		  </tr>

        </table>
               
        <table class="tableView" width="100%">
          <tr>
              <td class="action" colspan=2>

                <input name="action" type="hidden" value="create">
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
