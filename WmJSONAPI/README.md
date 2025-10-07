# WmJSONAPI
The WmJSONAPI package improves resource usage by providing JSON API support that 
allows the representation of resources in API definitions. The JSON API reduces 
the need to redundantly define resource attributes across different services 
serving different APIs for the same resource. With JSON API support, you can
use the resources directly in all required API definitions. For more information, 
see [Configuring REST V2 Resources as JSON API Compliant](https://documentation.softwareag.com/webmethods/designer/sdf10-15/webhelp/sdf-webhelp/#page/sdf-webhelp%2Fto-rest_api_descriptor_2.html).

The WmJSONAPI package enables you to configure a REST V2 resource based 
on JSON API. With this approach, you define a JSON API-based REST V2 resource, 
and JSON API-specific URL templates are automatically generated. Then, the URLs 
can be used to invoke and utilize the resources. For more information on JSON API 
specification, see http://jsonapi.org/format/
If you disable the WmJSONAPI package, then the resource remains as a regular 
REST resource.

All JSON API functionality is accessible only when the package is enabled. 
When selecting a resource, only those with JSON API support enabled are listed.

For more information on the API capabilities and samples, see [Examples of Configuring REST Resources Based on JSON API](https://documentation.softwareag.com/webmethods/designer/sdf10-15/webhelp/sdf-webhelp/#page/sdf-webhelp%2Fesb.rest.un.jsonAPI.html).

## How to use?
http://hostname:port/WmJSONAPI/




