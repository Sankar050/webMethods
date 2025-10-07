# WmXSLT

The WmXSLT package helps you to transform XML into a byte array, file, or 
XML node, and to maintain the XSLT stylesheet cache. 

## How to use?

http://hostname:port/WmXSLT/

The WmXSLT package also comes with sample services that show you how to use the 
public services. However, the sample.xslt:transformToString service in the 
WmXSLT package is susceptible to XML External Entity (XXE) injection.
To resolve the issue, set the watt.core.xml.loadExternalEntities
server configuration parameter to false, which makes Integration Server ignore 
any external entities referenced in the input.
Additionally, ensure that you select the blockExternalEntity checkbox while 
invoking the sample.xslt:transformToString service to perform transformation.

**Note**: If watt.core.xml.loadExternalEntities is set to true, the service parses 
the external entity references, which makes Integration Server vulnerable to 
XXE injection.

**Important**:
XML transformations that involve external entities pose a security risk.
To address the security risk, the pub.xslt.Transformations:transformSerialXML 
service considers only the loadExternalEntities and the watt.core.xml.allowedExternalEntities
values for XML transformations.

For more information on the services of the WmXSLT package, see [webMethods Integration Server Built-In Services Reference](https://documentation.softwareag.com/webmethods/integration_server/pie10-15/webhelp/pie-webhelp/#page/pie-webhelp%2FXSLT%2520folder2.html%23).
