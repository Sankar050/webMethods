%comment%----- Displays adapter type deployment data -----%endcomment%

<HTML>
<head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta http-equiv="Expires" CONTENT="-1">
    <title>About</title>
    <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods.css"></link>
	
    <SCRIPT SRC="../WmRoot/webMethods.js"></SCRIPT>
	<script>
		function frameload()
			{
				window.parent.location.reload(true);
				
			}
			</script>
</head>


%invoke wm.art.admin:getAdapterTypeOnlineHelp%
%onerror%
%endinvoke%
<BODY onLoad="setNavigation('About.dsp', '%value encode(javascript) helpsys%', 'foo');">
    %invoke wm.art.admin:retrieveAdapterTypeData%
    <table width="100%">
    <tr>
       <td class="breadcrumb" colspan=5>Adapters &gt; %value displayName% &gt; About</td>
    </tr>
    <tr>
    <td colspan=2>
        <ul>
        <li><a href="ListResources.dsp?adapterTypeName=%value -urlencode adapterTypeName%&dspName=.LISTRESOURCES" onClick="frameload();">Return to %value displayName% Connections
        </a></ul>
    </td>
    </tr>
        <tr>
            <td>
<table class="tableView">
    <tr>
        <td class="heading" colspan=5>About %value displayName%</td>
    </tr>        
    
    <tr>
        <td class="subheading" colspan=5>Copyright</td>
    </tr>
     %ifvar THIRDPARTYCOPYRIGHTURL -isnull%
      %ifvar vendorName equals('IBM')%
      <tr>
      <script>writeTDnowrap('row');</script>
      <img src="../WmRoot/images/SAG_emblem_79x31.gif" border=0></td>
      <script>writeTD('rowdata-l');swapRows();</script>
      <p>
		Copyright Super iPaaS Integration LLC, an IBM Company 2024. </p>
		</td>
      %else%
      <script>writeTDnowrap('row');</script>
      Copyright
      <script>writeTD('rowdata-l');swapRows();</script>
       %comment%
        The adapter is not a webMethods adapter and
        they didn't provide any copyright information.
       %end%
      </td>
      %endif%
    %else%
    <script>writeTDnowrap('row');</script>
    Copyright
    <script>writeTD('rowdata-l');swapRows();</script>
    %value THIRDPARTYCOPYRIGHTURL none%
    %endif%
  
    </td>
	</tr>
    <tr>
    <script>writeTDnowrap('row');</script>
    Description</td>
    <script>writeTD('rowdata-l');swapRows();</script>          
    %value description%</td>
    </tr>
    <tr>
    <script>writeTDnowrap('row');</script>
    Adapter Version</td>
    <script>writeTD('rowdata-l');swapRows();</script>          
    %value adapterVersion%
    </td>
    </tr>
    <tr>
    <script>writeTDnowrap('row');</script>Updates</td>
    <script>writeTD('rowdata-l');swapRows();</script>
    %ifvar installedUpdates%
       %loop installedUpdates%
          %value%<br>
       %endloop%
    %else%
       None
    %endif%
    </td>
    </tr>
    <tr>
    <script>writeTD('row');</script>
    Vendor Name</td>
    <script>writeTD('rowdata-l');swapRows();</script>          
    %value vendorName%</td>
    </tr>
    %endinvoke%
   </table>
   </table>
</body>
</HTML>
