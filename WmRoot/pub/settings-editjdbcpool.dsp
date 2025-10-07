<HTML>
<HEAD>
<META http-equiv="Pragma" content="no-cache">
<META http-equiv='Content-Type' content='text/html; charset=UTF-8'>
<META HTTP-EQUIV="Expires" CONTENT="-1">

<TITLE>Integration Server Settings</TITLE>
<LINK REL="stylesheet" TYPE="text/css" HREF="webMethods.css">
%ifvar webMethods-wM-AdminUI%
  <link rel="stylesheet" TYPE="text/css" HREF="webMethods-wM-AdminUI.css"></link>
  <script>webMethods_wM_AdminUI = 'true';</script>
%endif%
<SCRIPT SRC="webMethods.js"></SCRIPT>
<SCRIPT>

      var aliasArray = new Array();
      var keyStoreArray = new Array();
      var truststoreArray = new Array();

      function loadKeyStoresOptions()   {
            %invoke wm.server.security.keystore:listKeyStoresAndConfiguredKeyAliases%
                   var idx = 0;
                   keyStoreArray[idx] = "";
                   aliasArray[idx++] = new Array(0);
                   %loop keyStoresAndConfiguredKeyAliases%
				       	keyStoreArray[idx] = "%value keyStoreName encode(javascript)%";
                        var aliases = new Array();
                        %loop keyAliases%
		       				aliases[%value $index%] = "%value encode(javascript)%";
                        %endloop%
                        aliasArray[idx] = aliases;
                        idx++;
                   %endloop%
            %endinvoke%

            %invoke wm.server.security.keystore:listTrustStores%
                var idx = 0;
                truststoreArray[idx++] = "";
                %loop trustStores%
                    %ifvar isLoaded equals('true')%
                        truststoreArray[idx++] = "%value keyStoreName encode(htmlattr)%";
                    %endif%
                %endloop%
            %endinvoke%
            setupKeystoreData();
			loadTlsVersions();
      }

      function updateSelected(ks, val)  {
        for (var i = 0; i < ks.length; i++)     {
            if ( ks.options[i].value == val)  {
                ks.options[i].selected = true;
            }
        }
      }

      function setupKeystoreData()  {
	      var sslKeyStoreObj = document.getElementById("keystoreAlias");
		  if (sslKeyStoreObj != null)	{
			sslKeyStoreObj.length = keyStoreArray.length;

			for (var i = 0; i < keyStoreArray.length; i++)    {
              sslKeyStoreObj.options[i] = new Option(keyStoreArray[i],keyStoreArray[i]);
			}
		  }

          var sslAliasObj = document.getElementById("keyAlias");
		  if (sslAliasObj != null)	{
			changeval(sslKeyStoreObj , sslAliasObj);
		  }

		  var sslTrustStoreObj = document.getElementById("truststoreAlias");
		  if (sslTrustStoreObj != null)     {
		      sslTrustStoreObj.length = truststoreArray.length;

              for (var i = 0; i < truststoreArray.length; i++)    {
                  sslTrustStoreObj.options[i] = new Option(truststoreArray[i],truststoreArray[i]);
              }
		  }

          var x = document.getElementsByName("tempTruststoreAlias");
          if (x != null) {
        	  updateSelected(sslTrustStoreObj, x[0].value);
          }

          x = document.getElementsByName("tempKeystoreAlias");
          if (x != null) {
        	  updateSelected(sslKeyStoreObj, x[0].value);
        	  changeval(sslKeyStoreObj, sslAliasObj);
          }
            
          x = document.getElementsByName("tempKeyAlias");
	      if (x != null) {
	    	  updateSelected(sslAliasObj, x[0].value);
	      }
 		  
	      return true;
      }

      var tlsVersionArray = new Array();
      function loadTlsVersions()
      {
            %invoke wm.server.securityimpl:getEnabledSSLVersions%
                   var idx = 0;
                   tlsVersionArray[idx++] = "";
                   %loop enabledVersions%
		       			tlsVersionArray[idx] = "%value encode(javascript)%";
                        idx++;
                   %endloop%
            %endinvoke%
            setupTlsVersionData();
      }

      function setupTlsVersionData()  {
          var tlsVersionObj = document.getElementById("tlsVersion");
		  if (tlsVersionObj != null)	{
            for (var i = 0; i < tlsVersionArray.length; i++)    {
              tlsVersionObj.options[i] = new Option(tlsVersionArray[i],tlsVersionArray[i]);
            }
		  }

          var x = document.getElementsByName("tempTlsVersion");
          if (x != null) {
        	  updateSelected(tlsVersionObj, x[0].value);
          }

          return true;
      }


     function changeval(ks, alias) {
          var ksOpts = ks;
          var selectedKS = ks.value;
          for(var i=0; i<ksOpts.length; i++) {
              if(selectedKS == ksOpts.options[i].value) {
                  var aliases = aliasArray[i];
                  alias.length = aliases.length;

                  for(var j=0;j<aliases.length;j++) {
                      alias.options[j] = new Option(aliases[j],aliases[j]);
                  }
              }
          }
      }

    String.prototype.trim = function () {
        return this.replace(/^\s*/, "").replace(/\s*$/, "");
    }
    function update()
    {
      if (!verifyRequiredField("form1","pool"))
      {
         alert("Pool Alias must be specified");
         return false;
      }
      if (document.forms["form1"]["drivers"].value != "Embedded Database Driver")
      {
          if (!verifyPercentageField("form1", "poolThreshold", "Available Connections Warning Threshold"))
          {
             return false;
          }
          if (!verifyRequiredField("form1","url"))
          {
             alert("Database URL must be specified");
             return false;
          }
          if (!verifyRequiredNonNegNumber("form1","mincon"))
          {
             alert("Minimum connections must be a non-negative integer");
             return false;
          }
          if (!verifyRequiredNonNegNumber("form1","maxcon"))
          {
             alert("Maximum connections must be greater than 0");
             return false;
          }
          if (!verifyRequiredNonNegNumber("form1","waitingThread"))
          {
             alert("Waiting Thread Threshold Count must be a non-negative integer");
             return false;
          }
          if (document.forms["form1"]["maxcon"].value < 1)
          {
            document.forms["form1"]["maxcon"].focus;
            alert("Maximum connections must be greater than 0");
            return false;
          }
          var ma = parseInt(document.forms["form1"]["maxcon"].value);
          var mi = parseInt(document.forms["form1"]["mincon"].value);
          if (mi > ma) {
            document.forms["form1"]["maxcon"].focus
            alert("Minimum connections must be <= maximum connections")
            return false;
          }
          if (!verifyRequiredNonNegNumber("form1","idle"))
          {
             alert("Idle timeout must be a non-negative integer");
             return false;
          }
          errMsg = getAvailableConnThresholdError();
          if (errMsg != "") {
            alert(errMsg);
            return false;
          }
		  
		  errMsg = getSSLError();
          if (errMsg != "") {
            alert(errMsg);
            return false;
          }
      }

      // Set the values of the spy and snoop checkboxes to their checked state.
      var spyChecked   = document.forms["form1"]["spyEnabled"].checked;
      var snoopChecked = document.forms["form1"]["snoopEnabled"].checked;
      document.forms["form1"]["spyEnabled"].value = spyChecked;
      document.forms["form1"]["snoopEnabled"].value = snoopChecked;

      if (document.forms["form1"]["funct"].value == "Add")
        document.forms["form1"]["funct"].value = "UpdateAdd";
      if (document.forms["form1"]["funct"].value == "Edit")
        document.forms["form1"]["funct"].value = "Update";
      document.forms["form1"]["url"].value = (document.forms["form1"]["url"].value).trim();
      return true;
    }

    function getAvailableConnThresholdError() {
        error = "";

        var minConns  = parseInt(document.forms["form1"]["mincon"].value);
        var maxConns  = parseInt(document.forms["form1"]["maxcon"].value);
        var threshPct = document.forms["form1"]["poolThreshold"].value / 100;

        if (threshPct > 0 && parseInt(maxConns * threshPct) <= minConns) {
            error = "Available Connections Warning Threshold evaluates to "+ parseInt(maxConns * threshPct)+", which must be greater than Minimum Connections and less than or equal to Maximum Connections.";
        }

        return error;
    }
	
	function getSSLError() {
        error = "";

        var isSSL = document.forms["form1"]["useSSL"].value;
		var tlsVersion = document.forms["form1"]["tlsVersion"].value;
		var trustoreAlias = document.forms["form1"]["truststoreAlias"].value;
		if (isSSL == "true") {
			if (tlsVersion === null || tlsVersion.length === 0) {
				error = "SSL version cannot be empty when when 'Use SSL' is set to 'Yes'.";
			}
			if (trustoreAlias === null || trustoreAlias.length === 0) {
				error = "Truststore alias cannot be empty when 'Use SSL' is set to 'Yes'.";
			}
		}
	
        return error;
    }

    function verifyPercentageField(form, field, name)
    {
        var value = document.forms[form][field].value;

        if (isblank(value)) {
            alert(name + " is required.");
            return false;
        }
        else if (!isNum(value) || parseInt(value) < 0 || parseInt(value) > 100) {
            alert("Value must be an integer between 0 and 100: "+name);
            return false;
        }
        else {
            return true;
        }
    }

    function testConnection()
    {
        if (!verifyRequiredField("form1","drivers"))
        {
            alert("Associated Driver Alias must be selected");
            return false;
        }
        if (!verifyRequiredField("form1","url"))
        {
            alert("Database URL must be specified");
            return false;
        }
        document.forms["form1"]["url"].value = (document.forms["form1"]["url"].value).trim();
        document.forms["form1"]["test"].value = "true";
        return true;
    }

    function added(pool)
    {

        if(is_csrf_guard_enabled && needToInsertToken) {
			createForm("htmlform_settings_jdbcpool_add_pool", "settings-jdbcpool.dsp", "POST", "HEAD");
			setFormProperty("htmlform_settings_jdbcpool_add_pool", "addEditACT", "addPool");
			setFormProperty("htmlform_settings_jdbcpool_add_pool", "message", pool);
			setFormProperty("htmlform_settings_jdbcpool_add_pool", _csrfTokenNm_, _csrfTokenVal_);
			location.href="javascript:document.htmlform_settings_jdbcpool_add_pool.submit();";
        } else {
			var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
			if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
				location.href=encodeURI("settings-jdbcpool.dsp?addEditACT=addPool&message="+pool+"&webMethods-wM-AdminUI=true");
			}
			else {
				location.href=encodeURI("settings-jdbcpool.dsp?addEditACT=addPool&message="+pool);
			}
		}

    }
    function updated(pool)
    {

        if(is_csrf_guard_enabled && needToInsertToken) {
			createForm("htmlform_settings_jdbcpool_update_pool", "settings-jdbcpool.dsp", "POST", "HEAD");
			setFormProperty("htmlform_settings_jdbcpool_update_pool", "addEditACT", "updatePool");
			setFormProperty("htmlform_settings_jdbcpool_update_pool", "message", pool);
            setFormProperty("htmlform_settings_jdbcpool_update_pool", _csrfTokenNm_, _csrfTokenVal_);
			location.href="javascript:document.htmlform_settings_jdbcpool_update_pool.submit();";
        } else {
			var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
			if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
				location.href=encodeURI("settings-jdbcpool.dsp?addEditACT=updatePool&message="+pool+"&webMethods-wM-AdminUI=true");
			}
			else {
				location.href=encodeURI("settings-jdbcpool.dsp?addEditACT=updatePool&message="+pool);
			}
		}

    }
    function updatefailed()
    {
        document.forms["form1"]["funct"].value = "Edit";
    }
    function addfailed()
    {
        document.forms["form1"]["funct"].value = "Add";
    }

    function testCompleted()
    {
        document.forms["form1"]["test"].value = "completed";
    }

    function setSampleUrl()
    {
        if (document.forms["form1"]["drivers"].value == "DataDirect Connect JDBC DB2 Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:wm:db2://<server>:<50000|port>;databaseName=<value>[;<option>=<value>...]";
        }
        if (document.forms["form1"]["drivers"].value == "DataDirect Connect JDBC Oracle Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:wm:oracle://<server>:<1521|port>;serviceName=<value>[;<option>=<value>...]";
        }
        if (document.forms["form1"]["drivers"].value == "DataDirect Connect JDBC SQL Server Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:wm:sqlserver://<server>:<1433|port>;databaseName=<value>[;<option>=<value>...]";
        }
		if (document.forms["form1"]["drivers"].value == "DataDirect Connect JDBC MySQL Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:wm:mysql://<server>:<3306|port>;databaseName=<value>[;<option>=<value>...]";
        }
		if (document.forms["form1"]["drivers"].value == "MySQL Database Java Connector Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:mysql://<server>:<3306|port>/<databaseName>";
        }
		if (document.forms["form1"]["drivers"].value == "DataDirect Connect JDBC PostgreSQL Driver") {
            document.forms["form1"]["sampleUrl"].value = "jdbc:wm:postgresql://<server>:<5432|port>;DatabaseName=<databaseName>";
        }
    }

    function toggleSpyParams() {
        if (document.forms["form1"]["spyEnabled"].checked) {
            document.forms['form1'].spyParms.disabled = false;
        } else {
            document.forms['form1'].spyParms.disabled = true;
        }
    }

    function toggleSnoopParams() {
        if (document.forms["form1"]["snoopEnabled"].checked) {
            document.forms['form1'].snoopParms.disabled = false;
        } else {
            document.forms['form1'].snoopParms.disabled = true;
        }
    }

    function setDatabaseUrl(parms)
    {
        document.forms["form1"]["url"].value = parms;
    }

    previousDriver = "";
    function disableIfDerby()
    {
        if (document.form1.funct.value != "Display") {

			if (document.forms["form1"]["drivers"].value == "MySQL Database Java Connector Driver" || document.forms["form1"]["drivers"].value == "Embedded Database Driver") {
				document.forms["form1"]["spyEnabled"].disabled = true;
                document.forms["form1"]["spyEnabled"].checked = false;
                document.forms["form1"]["snoopEnabled"].disabled = true;
                document.forms["form1"]["snoopEnabled"].checked = false;
                document.forms["form1"]["spyParms"].disabled = true;
                document.forms["form1"]["snoopParms"].disabled = true;

                document.getElementById("ssl1").disabled = true;
                document.getElementById("ssl2").disabled = true;
                document.forms["form1"]["tlsVersion"].disabled = true;
                document.forms["form1"]["truststoreAlias"].disabled = true;
                document.forms["form1"]["keystoreAlias"].disabled = true;
                document.forms["form1"]["keyAlias"].disabled = true;
			} else {
				document.forms["form1"]["spyEnabled"].disabled = false;
                //document.forms["form1"]["spyEnabled"].checked = false;
                document.forms["form1"]["snoopEnabled"].disabled = false;
                //document.forms["form1"]["snoopEnabled"].checked = false;
                document.forms["form1"]["spyParms"].disabled = false;
                document.forms["form1"]["snoopParms"].disabled = false;

                document.getElementById("ssl1").disabled = false;
                document.getElementById("ssl2").disabled = false;
                document.forms["form1"]["tlsVersion"].disabled = false;
                document.forms["form1"]["truststoreAlias"].disabled = false;
                document.forms["form1"]["keystoreAlias"].disabled = false;
                document.forms["form1"]["keyAlias"].disabled = false;
			}
            if (document.forms["form1"]["drivers"].value == "Embedded Database Driver") {
                document.forms["form1"]["url"].value = "---";
                document.forms["form1"]["url"].disabled = true;
                document.forms["form1"]["uid"].value = "---";
                document.forms["form1"]["uid"].disabled = true;
                document.forms["form1"]["idle"].value = "---";
                document.forms["form1"]["idle"].disabled = true;
                //document.forms["form1"]["pwd"].type = "text";
                document.forms["form1"]["pwd"].value = "";
                document.forms["form1"]["pwd"].disabled = true;
                document.forms["form1"]["sampleUrl"].value = "---";
                document.forms["form1"]["sampleUrl"].disabled = true;
                document.forms["form1"]["spyEnabled"].disabled = true;
                document.forms["form1"]["spyEnabled"].checked = false;
                document.forms["form1"]["snoopEnabled"].disabled = true;
                document.forms["form1"]["snoopEnabled"].checked = false;
                document.forms["form1"]["spyParms"].disabled = true;
                document.forms["form1"]["snoopParms"].disabled = true;

                document.getElementById("ssl1").disabled = true;
                document.getElementById("ssl2").disabled = true;
                document.forms["form1"]["tlsVersion"].disabled = true;
                document.forms["form1"]["truststoreAlias"].disabled = true;
                document.forms["form1"]["keystoreAlias"].disabled = true;
                document.forms["form1"]["keyAlias"].disabled = true;
            } else {
                document.forms["form1"]["url"].disabled = false;
                document.forms["form1"]["uid"].disabled = false;
                document.forms["form1"]["pwd"].disabled = false;
                document.forms["form1"]["idle"].disabled = false;
                document.forms["form1"]["sampleUrl"].disabled = false;
                document.getElementById("ssl1").disabled = false;
                document.getElementById("ssl2").disabled = false;
                document.forms["form1"]["tlsVersion"].disabled = false;
                document.forms["form1"]["truststoreAlias"].disabled = false;
                document.forms["form1"]["keystoreAlias"].disabled = false;
                document.forms["form1"]["keyAlias"].disabled = false;

                if (previousDriver == "Embedded Database Driver") {
                    document.forms["form1"]["url"].value = "";
                    document.forms["form1"]["uid"].value = "";
                    document.forms["form1"]["idle"].value = "";
                    document.forms["form1"]["pwd"].value = "";
                    document.forms["form1"]["sampleUrl"].value = "";
                    //document.forms["form1"]["pwd"].type  = "password";
                    document.forms["form1"]["spyEnabled"].disabled = false;
                    document.forms["form1"]["snoopEnabled"].disabled = false;
                }
                if(previousDriver != document.forms["form1"]["drivers"].value) {
                    setSampleUrl();
                }
            }
            previousDriver = document.forms["form1"]["drivers"].value;
        }
    }
</SCRIPT>
</HEAD>


%ifvar funct equals(Add)%
  <BODY onLoad="loadKeyStoresOptions();setNavigation('settings-editjdcbpool.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_CreateJDBC_PoolAliasScrn');">
%else%
    <BODY onLoad="loadKeyStoresOptions();setNavigation('settings-editjdcbpool.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_EditJDBC_PoolAliasScrn');">
%endif%

<FORM NAME="form1" method="post" >
  %ifvar webMethods-wM-AdminUI% <input type="hidden" name="webMethods-wM-AdminUI" value="true"> %endif%
  %ifvar funct equals(Add)%
  %else%
    %ifvar funct equals(UpdateAdd)%
    %else%
         <INPUT NAME="pool" TYPE="hidden" VALUE="%value pool encode(htmlattr)%">
    %endif%
  %endif%
  <INPUT NAME="funct" TYPE="hidden" VALUE="%value funct encode(htmlattr)%">
  %ifvar test equals(true)%
    <INPUT NAME="test" TYPE="hidden" VALUE="true">
  %else%
    %ifvar test equals(completed)%
        <INPUT NAME="test" TYPE="hidden" VALUE="completed">
    %else%
        <INPUT NAME="test" TYPE="hidden" VALUE="false">
    %endif%
  %endif%

  <TABLE width="100%">
    <TR>
      <TD class="breadcrumb" colspan="2">
          Settings &gt;
          JDBC Pools &gt;
          Connection Aliases
          %switch funct%
        %case 'Add'%
          &gt;
          New
        %case 'Edit'%
        &gt Edit
          %endswitch%

      </TD>
    </TR>
    %switch funct%

    %case 'Update'%
      %invoke wm.server.jdbcpool:updatePoolAlias%
      %ifvar message%
        <SCRIPT>updatefailed();</SCRIPT>
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %else%
        <SCRIPT>updated("%value pool encode(javascript)%");</SCRIPT>
      %endif%
      %onerror%
        <SCRIPT>updatefailed();</SCRIPT>
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value errorMessage encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %endinvoke%

    %case 'UpdateAdd'%
      %invoke wm.server.jdbcpool:addPoolAlias%
      %ifvar message%
        <SCRIPT>addfailed();</SCRIPT>
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %else%
        <SCRIPT>added("%value pool encode(javascript)%")</SCRIPT>
      %endif%
      %onerror%
        <SCRIPT>addfailed();</SCRIPT>
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value errorMessage encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %endinvoke%
    %endswitch%

    %ifvar test equals(true)%
      %invoke wm.server.jdbcpool:testPoolAlias%
      <SCRIPT>testCompleted();</SCRIPT>
      %ifvar message%
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %else%
      %endif%
      %onerror%
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value errorMessage encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %endinvoke%
    %endif%

    %ifvar funct equals(Add)%
    	<INPUT NAME="tempTlsVersion" TYPE="hidden" VALUE="%value tlsVersion encode(htmlattr)%">
		<INPUT NAME="tempTruststoreAlias" TYPE="hidden" VALUE="%value truststoreAlias encode(htmlattr)%">
		<INPUT NAME="tempKeystoreAlias" TYPE="hidden" VALUE="%value keystoreAlias encode(htmlattr)%">
		<INPUT NAME="tempKeyAlias" TYPE="hidden" VALUE="%value keyAlias encode(htmlattr)%">
    %else%
    %ifvar test equals(completed)%
	    <INPUT NAME="tempTlsVersion" TYPE="hidden" VALUE="%value tlsVersion encode(htmlattr)%">
		<INPUT NAME="tempTruststoreAlias" TYPE="hidden" VALUE="%value truststoreAlias encode(htmlattr)%">
		<INPUT NAME="tempKeystoreAlias" TYPE="hidden" VALUE="%value keystoreAlias encode(htmlattr)%">
		<INPUT NAME="tempKeyAlias" TYPE="hidden" VALUE="%value keyAlias encode(htmlattr)%">
    %else%
      %invoke wm.server.jdbcpool:getPoolAlias%
	 <SCRIPT>previousDriver = "%value pool.driver encode(javascript)%";</SCRIPT>
    <INPUT NAME="tempTlsVersion" TYPE="hidden" VALUE="%value pool.tlsVersion encode(htmlattr)%">
    <INPUT NAME="tempTruststoreAlias" TYPE="hidden" VALUE="%value pool.truststoreAlias encode(htmlattr)%">
    <INPUT NAME="tempKeystoreAlias" TYPE="hidden" VALUE="%value pool.keystoreAlias encode(htmlattr)%">
    <INPUT NAME="tempKeyAlias" TYPE="hidden" VALUE="%value pool.keyAlias encode(htmlattr)%">
        %ifvar message%
          <TR><TD colspan="2">&nbsp;</TD></TR>
          <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
          <TR><TD colspan="2">&nbsp;</TD></TR>
        %endif%
      %onerror%
        <TR><TD colspan="2">&nbsp;</TD></TR>
        <TR><TD class="message" colspan="2">%value errorMessage encode(html)%</TD></TR>
        <TR><TD colspan="2">&nbsp;</TD></TR>
      %endinvoke%
    %endif%
    %endif%
    <TR>
      <TD colspan="2">
        <ul class="listitems">
		  <script>
		  createForm("htmlform_settings_jdbcpool", "settings-jdbcpool.dsp", "POST", "BODY");
		  </script>
          <li class="listitem">
		  <script>getURL("settings-jdbcpool.dsp","javascript:document.htmlform_settings_jdbcpool.submit();","Return to JDBC Pool Definitions")</script></li>
          %ifvar funct equals(Display)%
		  <script>
		  createForm("htmlform_settings_editjdbcpool", "settings-editjdbcpool.dsp", "POST", "BODY");
		  setFormProperty("htmlform_settings_editjdbcpool", "funct", "Edit");
		  setFormProperty("htmlform_settings_editjdbcpool", "pool", "%value pool%");
		  </script>
          <li class="listitem">
	         <script>getURL("settings-editjdbcpool.dsp?funct=Edit&pool=%value pool encode(url)%","javascript:document.htmlform_settings_editjdbcpool.submit();","Edit this JDBC Connection Pool Alias definition")</script></li>
          %endif%
        </UL>
      </TD>
    </TR>

  </table>
  <table class="tableView" style="width: 50%">
    <TR>
          <TR>
            <TD class="heading" colspan="2">JDBC Connection Pool Alias</TD>
          </TR>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="pool">Alias Name</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
            %ifvar funct equals(Add)%
                %ifvar test equals(completed)%
            		<INPUT NAME="pool" id="pool" TYPE="TEXT" VALUE="%value  pool encode(htmlattr)%" SIZE="60">
                %else%
            		<INPUT NAME="pool" id="pool" TYPE="TEXT" VALUE="" SIZE="60">
                %endif%
            %else%
                %ifvar test equals(completed)%
                  %value pool encode(html)%
                %else%
                  %value pool.name encode(html)%
              %endif%
            %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="description">Alias Description</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.description%
              %else%
                %ifvar test equals(completed)%
              		<INPUT NAME="description" id="description" TYPE="TEXT" VALUE="%value  description encode(htmlattr)%" SIZE="60">
                %else%
                	<INPUT NAME="description" id="description" TYPE="TEXT" VALUE="%value  pool.description encode(htmlattr)%" SIZE="60">
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="drivers">Associated Driver Alias</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.driver encode(html)%
                </TD></TR>
              %else%
                %invoke wm.server.jdbcpool:getDriverDefinitions%
                  %ifvar message%
                    </TD></TR>
                    <TR><TD colspan="2">&nbsp;</TD></TR>
                    <TR><TD class="message" colspan="2">%value message encode(html)%</TD></TR>
                    <TR><TD colspan="2">&nbsp;</TD></TR>
                  %endif%
          <!-- EmbeddedDBCreator.DERBY_POOL -->
		  <SELECT id="drivers" NAME="drivers" ONCHANGE="disableIfDerby()" %ifvar ../pool.name equals('Embedded Database Pool')% DISABLED %endif%>
            %ifvar test equals(completed)%
                <OPTION VALUE="" %ifvar driver notempty% %else% SELECTED %endif%>None
                %loop drivers%
                <OPTION VALUE="%value driver.name encode(htmlattr)%" %ifvar ../driver vequals(driver.name)% SELECTED %endif%>%value driver.name encode(html)%
                %endloop%
                      %else%
                %loop drivers%
                <OPTION VALUE="%value driver.name encode(htmlattr)%" %ifvar ../pool.driver vequals(driver.name)% SELECTED %endif%>%value driver.name encode(html)%
                %endloop%
                      %endif%
                  </SELECT>
                  </TD></TR>
                %onerror%
                    </TD></TR>
                    <TR><TD colspan="2">&nbsp;</TD></TR>
                    <TR><TD class="message" colspan="2">%value errorMessage encode(html)%</TD></TR>
                    <TR><TD colspan="2">&nbsp;</TD></TR>
                %endinvoke%
              %endif%
            <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="url">Database URL</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                <!-- EmbeddedDbCreator.DERBY_DRV_NM -->
                %ifvar pool.driver equals('Embedded Database Driver')% %else% %value pool.url encode(html)% %end%
              %else%
                %ifvar test equals(completed)%
                    <TEXTAREA NAME="url" id="url" cols="60" rows="1">%value url encode(html)%</TEXTAREA>
                %else%
                    <TEXTAREA NAME="url" id="url" cols="60" rows="1">%value pool.url encode(html)%</TEXTAREA>
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
            %ifvar funct equals(Display)%
            %else%
            <TR>
                <SCRIPT>writeTDnowrap("row");</SCRIPT>
                    Sample Database URL</TD>
                <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
                    <TEXTAREA NAME="sampleUrl" TYPE="text" readonly="readonly" STYLE="background-color: #CCCCCC;" VALUE="%value sampleUrl encode(htmlattr)%" cols="60" tabindex="60"></TEXTAREA></TD>
            </TR>
            <SCRIPT>swapRows();</SCRIPT>
            <SCRIPT>setSampleUrl();</SCRIPT>
            %endif%
            <TR>
              <SCRIPT>writeTDnowrap("row");</SCRIPT>
                Diagnostics</TD>
              <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
                  %ifvar funct equals(Display)%
	                  <input type="checkbox" name=spyEnabled  id="spyEnabled" %ifvar pool.spyEnabled   equals('true')% checked %endif% disabled onclick="toggleSpyParams();"><label for="spyEnabled">Spy </label>&nbsp;&nbsp;&nbsp;&nbsp;
	                  <input type="checkbox" name=snoopEnabled id="snoopEnabled" %ifvar pool.snoopEnabled equals('true')% checked %endif% disabled onclick="toggleSnoopParams();"><label for="snoopEnabled">Snoop</label></TD>
                  %else%
                       <!-- EmbeddedDBCreator.DERBY_POOL -->
                       %ifvar pool.name equals('Embedded Database Pool')%
                          <input type="checkbox" name=spyEnabled disabled>Spy &nbsp;&nbsp;&nbsp;&nbsp;
                          <input type="checkbox" name=snoopEnabled disabled>Snoop</TD>
                       %else%
                       		 %ifvar pool.driver equals('MySQL Database Java Connector Driver')%
                          		<input type="checkbox" name=spyEnabled disabled>Spy &nbsp;&nbsp;&nbsp;&nbsp;
                          		<input type="checkbox" name=snoopEnabled disabled>Snoop</TD>
                       		%else%
			                    <input type="checkbox" name=spyEnabled   id="spyEnabled" %ifvar pool.spyEnabled   equals('true')% checked %endif% onclick="toggleSpyParams();"><label for="spyEnabled">Spy </label>&nbsp;&nbsp;&nbsp;&nbsp;
			                    <input type="checkbox" name=snoopEnabled id="snoopEnabled" %ifvar pool.snoopEnabled equals('true')% checked %endif% onclick="toggleSnoopParams();"><label for="snoopEnabled">Snoop</label></TD>
                       		%endif%
                      %endif%
                  %endif%
            </TR>

            <SCRIPT>swapRows();</SCRIPT>
            <TR>
              <SCRIPT>writeTDnowrap("row");</SCRIPT>
			    <label for="spyParms">Spy Attributes</label>
              <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                  <TEXTAREA name="spyParms" id="spyParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.spyParms -isnull%%value defaultSpyParms encode(html)%%else%%value pool.spyParms encode(html)%%endif%</TEXTAREA></TD>
              %else%
                %ifvar funct equals(Add)%
                      <TEXTAREA name="spyParms" id="spyParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%value defaultSpyParms encode(html)%</TEXTAREA></TD>
                %else%
                    %ifvar pool.spyEnabled equals('true')%
                      <TEXTAREA name="spyParms" id="spyParms" type="text" STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.spyParms -isnull%%value defaultSpyParms encode(html)%%else%%value pool.spyParms encode(html)%%endif%</TEXTAREA></TD>
                    %else%
                      <TEXTAREA name="spyParms" id="spyParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.spyParms -isnull%%value defaultSpyParms encode(html)%%else%%value pool.spyParms encode(html)% %endif%</TEXTAREA></TD>
                    %endif%
                  %endif%
             %endif%
            </TR>

            <SCRIPT>swapRows();</SCRIPT>
            <TR>
              <SCRIPT>writeTDnowrap("row");</SCRIPT>
			    <label for="snoopParms">Snoop Logging Parameters</label></TD>
              <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                  <TEXTAREA name="snoopParms" id="snoopParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.snoopParms -isnull%%value defaultSnoopParms encode(html)%%else%%value pool.snoopParms encode(html)% %endif%</TEXTAREA></TD>
              %else%
                %ifvar funct equals(Add)%
				      <TEXTAREA name="snoopParms" id="snoopParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%value defaultSnoopParms%</TEXTAREA></TD>
                %else%
                    %ifvar pool.snoopEnabled equals('true')%
                      <TEXTAREA name="snoopParms" id="snoopParms" type="text" STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.snoopParms -isnull%%value defaultSnoopParms encode(html)%%else%%value pool.snoopParms encode(html)%%endif%</TEXTAREA></TD>
                    %else%
                      <TEXTAREA name="snoopParms" id="snoopParms" type="text" disabled STYLE="background-color: #CCCCCC;" cols="60" rows="1">%ifvar pool.snoopParms -isnull%%value defaultSnoopParms encode(html)%%else%%value pool.snoopParms encode(html)%%endif%</TEXTAREA></TD>
                    %endif%
                  %endif%
             %endif%
          %ifvar funct equals(Add)%
            <SCRIPT>toggleSpyParams();</SCRIPT>
            <SCRIPT>toggleSnoopParams();</SCRIPT>
          %endif%
          </TR>

          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="uid">User ID</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %ifvar pool.driver equals('Embedded Database Driver')% %else% %value pool.uid encode(html)% %end%
              %else%
                %ifvar test equals(completed)%
                	<INPUT NAME="uid" id="uid" TYPE="TEXT" VALUE="%value  uid encode(htmlattr)%" SIZE="12">
                %else%
                	<INPUT NAME="uid" id="uid" TYPE="TEXT" VALUE="%value  pool.uid encode(htmlattr)%" SIZE="12">
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="pwd">Password</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                  %ifvar pool.driver equals('Embedded Database Driver')% %else% ***** %end%
              %else%
                %ifvar test equals(completed)%
					<INPUT NAME="pwd" id="pwd" TYPE="PASSWORD" autocomplete="off" VALUE="%value pwd encode(htmlattr)%" SIZE="12" />
                %else%
                  %ifvar funct equals(Add)%
					<INPUT NAME="pwd" id="pwd" TYPE="PASSWORD" autocomplete="new-password" VALUE="" SIZE="12" />
                  %else%
				    	<INPUT NAME="pwd" id="pwd" TYPE="PASSWORD" autocomplete="off" VALUE="********" SIZE="12" />
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="mincon">Minimum Connections</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.mincon encode(html)%
              %else%
                %ifvar test equals(completed)%
                	<INPUT NAME="mincon" id="mincon" TYPE="TEXT" VALUE="%value  mincon encode(htmlattr)%" SIZE="10">
                %else%
                	<INPUT NAME="mincon" id="mincon" TYPE="TEXT" VALUE="%value  pool.mincon encode(htmlattr)%" SIZE="10">
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="maxcon">Maximum Connections</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.maxcon encode(html)%
              %else%
                %ifvar test equals(completed)%
                	<INPUT NAME="maxcon" id="maxcon" TYPE="TEXT" VALUE="%value  maxcon encode(htmlattr)%" SIZE="10">
                %else%
                	<INPUT NAME="maxcon" id="maxcon" TYPE="TEXT" VALUE="%value  pool.maxcon encode(htmlattr)%" SIZE="10">
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="poolThreshold">Available Connections Warning Threshold</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.poolThreshold encode(html)%
              %else%
                %ifvar test equals(completed)%
                    <INPUT NAME="poolThreshold" id="poolThreshold" TYPE="TEXT" VALUE="%value poolThreshold encode(htmlattr)%" SIZE="10">
                %else%
                    <INPUT NAME="poolThreshold" id="poolThreshold" TYPE="TEXT" VALUE="%value pool.poolThreshold encode(htmlattr)%" SIZE="10">
                %endif%
              %endif%
            %
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="waitingThread">Waiting Thread Threshold Count</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %value pool.waitingThread encode(html)%
              %else%
                %ifvar test equals(completed)%
                    <INPUT NAME="waitingThread" id="waitingThread" TYPE="TEXT" VALUE="%value waitingThread encode(htmlattr)%" SIZE="10">
                %else%
                    <INPUT NAME="waitingThread" id="waitingThread" TYPE="TEXT" VALUE="%value pool.waitingThread encode(htmlattr)%" SIZE="10">
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="idle">Idle Timeout</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %ifvar pool.driver equals('Embedded Database Driver')% %else% %value pool.idle encode(html)% milliseconds %end%
              %else%
                %ifvar test equals(completed)%
                    <INPUT NAME="idle" TYPE="TEXT" VALUE="%value idle encode(htmlattr)%" SIZE="10"> milliseconds
                %else%
                  %ifvar funct equals(Add)%
                      <INPUT NAME="idle" id="idle" TYPE="TEXT" VALUE="60000" SIZE="10"> milliseconds
                  %else%
                      <INPUT NAME="idle" id="idle" TYPE="TEXT" VALUE="%value pool.idle encode(htmlattr)%" SIZE="10"> milliseconds
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
    
         <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="ssl">Use SSL</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %ifvar pool.useSSL equals('true')%
                    Yes
                %else%
                    No
                %endif%
              %else%
				%ifvar test equals(completed)%
                    <input type="radio" name="useSSL" id="ssl1" value="true" %ifvar useSSL equals(true)%checked%endif%><label for="ssl1">Yes</label></input>
                    <input type="radio" name="useSSL" id="ssl2" value="false"  %ifvar useSSL equals(false)%checked%endif%><label for="ssl2">No</label></input>
                %else%
                  %ifvar funct equals(Add)%
                      <input type="radio" name="useSSL" id="ssl1" value="true" ><label for="ssl1">Yes</label></input>
                      <input type="radio" name="useSSL" id="ssl2" value="false" checked ><label for="ssl2">No</label></input>
                  %else%
                      <input type="radio" name="useSSL" id="ssl1" value="true" %ifvar pool.useSSL equals(true)%checked%endif%><label for="ssl1">Yes</label></input>
                      <input type="radio" name="useSSL" id="ssl2" value="false"  %ifvar pool.useSSL equals(false)%checked%endif%><label for="ssl2">No</label></input>
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="idle">SSL Version</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                    %ifvar pool.tlsVersion -isnull%

                    %else%
                        %value pool.tlsVersion encode(html)%
                    %endif%
              %else%
                %ifvar test equals(completed)%
                    <SELECT class="listbox" name="tlsVersion" id="tlsVersion" ></SELECT>
                %else%
                  %ifvar funct equals(Add)%
                      <SELECT class="listbox" name="tlsVersion" id="tlsVersion" ></SELECT>
                  %else%
                      <SELECT class="listbox" name="tlsVersion" id="tlsVersion" ></SELECT>
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="idle">Truststore Alias</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                    %ifvar pool.truststoreAlias -isnull%

                    %else%
                        %value pool.truststoreAlias encode(html)%
                    %endif%
              %else%
                %ifvar test equals(completed)%
                    <select name="truststoreAlias" id="truststoreAlias" />
                %else%
                  %ifvar funct equals(Add)%
                      <select name="truststoreAlias" id="truststoreAlias" />
                  %else%
                      <select name="truststoreAlias" id="truststoreAlias" />
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="idle">Keystore Alias</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %ifvar pool.keystoreAlias -isnull%

                %else%
                    %value pool.keystoreAlias encode(html)%
                %endif%
              %else%
                %ifvar test equals(completed)%
                    <SELECT class="listbox" name="keystoreAlias" id="keystoreAlias" onchange="changeval(this, this.form.keyAlias)"></SELECT>
                %else%
                  %ifvar funct equals(Add)%
                      <SELECT class="listbox" name="keystoreAlias" id="keystoreAlias" onchange="changeval(this, this.form.keyAlias)"></SELECT>
                  %else%
                      <SELECT class="listbox" name="keystoreAlias" id="keystoreAlias" onchange="changeval(this, this.form.keyAlias)"></SELECT>
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
          <SCRIPT>swapRows();</SCRIPT>
          <TR>
            <SCRIPT>writeTDnowrap("row");</SCRIPT>
              <label for="idle">Key Alias</label></TD>
            <SCRIPT>writeTDnowrap("row-l");</SCRIPT>
              %ifvar funct equals(Display)%
                %ifvar pool.keyAlias -isnull%

                %else%
                    %value pool.keyAlias encode(html)%
                %endif%
              %else%
                %ifvar test equals(completed)%
                    <select class="listbox" name="keyAlias" id="keyAlias" ></select>
                %else%
                  %ifvar funct equals(Add)%
                      <select class="listbox" name="keyAlias" id="keyAlias" ></select>
                  %else%
                      <select class="listbox" name="keyAlias" id="keyAlias" ></select>
                  %endif%
                %endif%
              %endif%
            </TD>
          </TR>
     
          <SCRIPT>disableIfDerby();</SCRIPT>
          <SCRIPT>swapRows();</SCRIPT>
          %ifvar funct equals(Display)%
          %else%
            <TR>
              <TD colspan="2" class="action">
                %ifvar pool.driver equals('Embedded Database Driver')%
                %else%
                    <INPUT type="submit" value="Test Connection" onClick="return testConnection();">
                %endif%
                <INPUT type="submit" value="Save Settings" onClick="return update();">
              </TD>
            </TR>
          %endif%
      </TD>
    </TR>
  </TABLE>
</FORM>
</BODY>
</HTML>