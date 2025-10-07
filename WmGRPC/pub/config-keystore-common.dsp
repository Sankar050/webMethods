<script language="Javascript">
      // KeyStore related functions  
      
      function setupKeystoreData(formObj)
      {
            formObj.enclosedFormName.value = formObj.name;
            %ifvar action equals('edit')%
                var ks = formObj.keystoreAlias.options;
                %invoke wm.server.security.keystore:listKeyStoresAndConfiguredKeyAliases%
                    
                   %loop keyStoresAndConfiguredKeyAliases%
                        ks.length=ks.length+1;
                        ks[ks.length-1] = new Option("%value keyStoreName encode(javascript)%","%value keyStoreName encode(javascript)%");
                        var aliases = new Array();
                        %loop keyAliases%
                            aliases["%value $index encode(javascript)%"] = new Option("%value encode(javascript)%","%value encode(javascript)%");
                        %endloop%
                        if (aliases.length == 0)
                        {
                            aliases[0] = new Option("","");     
                        }
                        hiddenOptions[ks.length-1] = aliases;
                   %endloop%
                %endinvoke%
                
                var keyOpts = formObj.keystoreAlias.options;
                var key = formObj.selectedKS.value;
                if ( key != "") 
                {
                    for(var i=0; i<keyOpts.length; i++) 
                    {
                        if(key == keyOpts[i].value) {
                            keyOpts[i].selected = true;
                        }
                    }
                }
                
                changeval(formObj.name);
                
                var aliasOpts = formObj.keystoreEntry.options;
                var alias = formObj.selectedAlias.value;
                if ( alias != "") 
                {
                    for(var i=0; i<aliasOpts.length; i++) 
                    {
                        if(alias == aliasOpts[i].value) {
                            aliasOpts[i].selected = true;
                        }
                    }
                }
                
            %endif%
            return true;
       }
       
       function changeval(formName) {
            var f = document.getElementsByName(formName);
            var formObj = f[0];
            var ks = formObj.keystoreAlias.options;
            var selectedKS = formObj.keystoreAlias.value;
            for(var i=0; i<ks.length; i++) {
                if(selectedKS == ks[i].value) {
                    var aliases = hiddenOptions[i];
                    formObj.keystoreEntry.options.length = aliases.length;
                    for(var j=0;j<aliases.length;j++) {
                        var opt = aliases[j];
                        formObj.keystoreEntry.options[j] = new Option(opt.text, opt.value);
                    }
                }
            }
        }
</script>

<input type="hidden" name="enclosedFormName" value=""/>
<input type="hidden" name="selectedKS" value="%value ../keystoreAlias encode(htmlattr)%"/>
<input type="hidden" name="selectedAlias" value="%value ../keystoreEntry encode(htmlattr)%"/>

    <!-- Other Listener Port's LookNFeel -->

    <tr>
        <td class="heading" colspan="2">gRPC Channel Credentials</td>
    </tr>
    
    
     <tr>
		<td class="evenrow"><label for="keystoreAlias">Keystore Alias</label></td>
        <td class="oddrow-l">
				 <SELECT id="keystoreAlias" NAME="keystoreAlias" class="listbox" onchange="changeval(enclosedFormName.value)"></SELECT>
        </td>
     </tr>
     
     <tr>
		<td class="oddrow" valign="top"><label for="keystoreEntry">Key Alias</label></td>
        <td class="evenrow-l">
				<select id="keystoreEntry" name="keystoreEntry" class="listbox"></select>
        </td>
     </tr>
         <tr>
		<td class="evenrow"><label for="trustStore">Truststore Alias</label></td>
            <td class="oddrow-l">
				<select id="truststoreAlias" name="truststoreAlias" class="listbox">
                        %invoke wm.server.security.keystore:listTrustStores%
                            %loop trustStores%
                                %ifvar isLoaded equals('true')%
                                    <option name="%value keyStoreName encode(htmlattr)%" value="%value keyStoreName encode(htmlattr)%" %ifvar ../truststoreAlias vequals(keyStoreName)%selected%endif%>%value keyStoreName encode(html)%</option>
                                %endif%
                           %endloop%
                        %endinvoke%
                    </select>
            </td>
         </tr>
