# WmUnitTestManager

The WmUnitTestManager package helps you streamline the process of setting up the test
execution environment within the server, executing tests, and gathering test reports.

The WmUnitTestManager package mainly performs the following:
- Enables mocking of Integration Server services during tests. For more 
information, see Using Mocks.
 
- Generates Code Coverage reports for test executions. For more information, see Code Coverage Analysis.
 
- Provides an alternative method for executing tests through REST APIs, allowing you to test Integration Server services by running webMethods TestSuites deployed on the target server.

With the APIs, you can locate webMethods TestSuites from the deployed packages, initiate the test execution, and retrieve the reports in the archived (zipped) form. Additionally, you can retrieve standard JUnit reports in both text and XML formats when the test execution is completed.
For more information on REST endpoints and samples for request and response formats, see Using WmUnitTestManager REST Endpoints.
 
You can access the Swagger documentation of the REST API endpoints using:

```
http://hostname:port/admin/swagger/unitTestFramework/
```


**Important**:
For the design and development of Test Suites, you must use Integration Test Suite in IBM webMethods Designer, which is an Eclipse-based testing tool.


For more information on executing tests in a Continuous Integration setup, see [webMethods Integration Test Suite Continuous Integration](https://docs.webmethods.io/on-premises/webmethods-designer/11.1.0/webhelp/index.html#page/sdf-webhelp/_test_designer_webhelp.1.3072.html).