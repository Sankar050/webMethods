/*
 * Copyright (c) 2020 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
 *
 * Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG.
 */
var listClientTypesServiceName = "cloudstreams.oauthV21:listClientTypes";
var apiMetadataServiceName = "cloudstreams.oauthV21:describeAPIMetadata";
var connection_client_id_name = "CPROP$oauth_v21$Basic$oauth.consumerId";
var connection_client_secret_name = "CPROP$oauth_v21$Basic$oauth.consumerSecret";
var timer = null;
var missingFields = [];
var pkceRequired = true;
var codeVerifier;
var codeChallenge;
var mandatoryFields = {};
var paramsDisplayNameArray = {};
var apiMetadataDetails = {};
var redirect_uri = "";
var state = "";
var authorizationCode;
var onlyTokenCall = false;

$(document).ready(function() {
    errorMessageToggle("", "hide");
    var customListClientTypesServiceName = parent.$("input[name$='META$cx.listClientTypesServiceName']").val();
    if (typeof customListClientTypesServiceName !== "undefined" && !isEmptyOrSpaces(customListClientTypesServiceName)) {
       listClientTypesServiceName = customListClientTypesServiceName;
    }
    var customApiMetadataServiceName = parent.$("input[name$='META$cx.describeAPIMetadataServiceName']").val();
    if (typeof customApiMetadataServiceName !== "undefined" && !isEmptyOrSpaces(customApiMetadataServiceName)) {
        apiMetadataServiceName = customApiMetadataServiceName;
    }

    getAccountTypes();
    // enable 2-way SSL if it's configured in connection
	if(parent.$("input[name$='cn.keystoreAlias']").val()) {
		$("#enable2WaySSL").prop('checked', true).change();
		$("#2WaySSLKeystoreAlias").change();
	}
    bindAuthorizeButtonClick();
});

function bindAuthorizeButtonClick() {
    $("#authorize").click(function() {
        var childWindow = null;
        clearTimeout(timer);
        errorMessageToggle("", "hide");

        if (isValidForm(false)) {
            if(apiMetadataDetails["authCodeAPIMetadata"]) {
                if(pkceRequired) {
                    codeVerifier = $("#code_verifier").val();
                    var codeChallengeMethod = $("#code_challenge_method").val();
                    if(codeChallengeMethod === "plain") {
                        codeChallenge = codeVerifier;
                        makeAuthorizationCall();
                    } else {
                        // https://stackoverflow.com/questions/63309409/creating-a-code-verifier-and-challenge-for-pkce-auth-on-spotify-api-in-reactjs
                        createCodeChallenge(codeVerifier).then(function(value) {
                            codeChallenge = value;
                            makeAuthorizationCall();
                        });
                    }
                } else {
                    makeAuthorizationCall();
                }
            } else {
                makeTokenCall();
            }
        }
    });
}

function getAccountTypes() {
    var requestParams = {
        connectionType	: parent.$("#connectionType").val(),
        connectorId		: parent.$("input[name='connectorID']").val()
    }
    var select_client_types = document.getElementById("client_types");

    $.ajax({
        type: 'POST',
        url: '/invoke/' + listClientTypesServiceName,
        data: JSON.stringify(requestParams),
        dataType: 'json',
        contentType: 'application/json',
        async: false,
        success: function(data) {
            $.each(data, function(key, value) {
                if (key == 'clientTypes') {
                    $.each(value, function(index, clientType) {
                        var el = document.createElement("option");
                        el.textContent = clientType["displayName"];
                        el.value = clientType["name"];
                        select_client_types.appendChild(el);
                    });
                    var selectedClientType = value[0]["name"];
                    select_client_types.value = selectedClientType;
                    select_client_types.onchange();
                    if(value.length == 1) {
                        // for just one value hide client type selection
                        $("#select_client_header").hide();
                        $("#select_client_row").hide();
                    }
                }
            });
        },
        error: function(xhr, status) {
            errorMessageToggle("Error: " + xhr.responseText, "show");
        }
    });
}

function getClientDetails(value) {
    errorMessageToggle("", "hide");
    mandatoryFields = {};
    paramsDisplayNameArray = {};

	var requestParams = {
        connectionType		: parent.$("#connectionType").val(),
		connectorId			: parent.$("input[name='connectorID']").val(),
		clientType 	        : value
    }

	$.ajax({
		type: 'POST',
		url: '/invoke/' + apiMetadataServiceName,
		data: JSON.stringify(requestParams),
		dataType: 'json',
		contentType: 'application/json',
		async: false,
		success: function(data) {
			$.each(data, function(key, value) {
				if (key == 'apiMetadataDetails') {
					populateClientDetails(value);
					apiMetadataDetails = value;
				}
			});
		},
		error: function(xhr, status) {
			errorMessageToggle("Error: " + xhr.responseText, "show");
		}
	});
}

function populateClientDetails(apiMetadataDetails) {

	displayPKCETable(apiMetadataDetails);

	buildRequestEndpointsTable(apiMetadataDetails);

	buildRequestParameterTable(apiMetadataDetails);
}

function displayPKCETable(apiMetadataDetails) {
    if(typeof apiMetadataDetails["pkceRequired"] !== 'undefined') {
        pkceRequired = apiMetadataDetails["pkceRequired"];
    } else {
        pkceRequired = true;
    }
    if(pkceRequired) {
        $("#PKCETable").show();
        mandatoryFields["code_verifier"] = "Code Verifier";
    } else {
        $("#PKCETable").hide();
    }
}

function buildRequestEndpointsTable(apiMetadataDetails) {

    var authCodeAPIMetaData = apiMetadataDetails["authCodeAPIMetadata"];
    var tokenAPIMetaData = apiMetadataDetails["tokenAPIMetadata"];

    if(typeof authCodeAPIMetaData === "undefined") {
        onlyTokenCall = true;
    }

    if(authCodeAPIMetaData || tokenAPIMetaData) {
        var requestEndpointRows = "<tr><td class=heading colspan=2>" + getmsg("request.endpoints") + "</td></tr>";
        if(authCodeAPIMetaData && authCodeAPIMetaData["url"]) {
            requestEndpointRows += buildInputFieldRow(authCodeAPIMetaData["url"]);
        }
        if(tokenAPIMetaData && tokenAPIMetaData["url"]) {
            requestEndpointRows += buildInputFieldRow(tokenAPIMetaData["url"]);
        }
        // add 2-way SSL input rows
        requestEndpointRows += get2WaySSLRow();

        var headerTableRef = document.getElementById('EndPointTable');
        headerTableRef.innerHTML =	requestEndpointRows;
    }
}

function buildRequestParameterTable(apiMetadataDetails) {
    var tableRows = "<tr><td class=heading colspan=2>" + getmsg("request.parameters") + "</td></tr>";
    tableRows += buildClientIdSecretRows();
    var authCodeCustomParameterNames = [];

    if(apiMetadataDetails["authCodeAPIMetadata"]) {
        // auth code metadata
        var authCodeAuthHeader = {
            userIdFieldName : null,
            passwordFieldName : null
        };

        var authCodeAuthHeader = apiMetadataDetails["authCodeAPIMetadata"]["authHeader"];
        if(authCodeAuthHeader) {
            var useClientIdAndSecret = authCodeAuthHeader["useClientIdAndSecret"];
            if(useClientIdAndSecret === false) {
                tableRows += buildInputFieldRow(authCodeAuthHeader["username"]);
                tableRows += buildInputFieldRow(authCodeAuthHeader["password"]);
                authCodeAuthHeader["userIdFieldName"] = authCodeAuthHeader["username"]["name"];
                authCodeAuthHeader["passwordFieldName"] = authCodeAuthHeader["password"]["name"];
            } else {
                authCodeAuthHeader["userIdFieldName"] = "oauth.consumerId";
                authCodeAuthHeader["passwordFieldName"] = "oauth.consumerSecret";
            }
        }

        var authCodeRequestParams = apiMetadataDetails["authCodeAPIMetadata"]["requestParams"];
        if(authCodeRequestParams) {
            for(var i=0; i<authCodeRequestParams.length; i++) {
                var customField = authCodeRequestParams[i];
                tableRows += buildInputFieldRow(customField);
                authCodeCustomParameterNames.push(customField["name"]);
            }
        }
    }

    if(apiMetadataDetails["tokenAPIMetadata"]) {
        // token metadata
        var tokenAuthHeader = {
            userIdFieldName : null,
            passwordFieldName : null
        };
        var tokenCustomParameterNames = [];
        var tokenAuthHeader = apiMetadataDetails["tokenAPIMetadata"]["authHeader"];
        if(tokenAuthHeader) {
            var useClientIdAndSecret = tokenAuthHeader["useClientIdAndSecret"];
            if(useClientIdAndSecret === false) {
                if(tokenAuthHeader["username"]["name"] === authCodeAuthHeader["userIdFieldName"]) {
                    // considering if user id matches then password field will also be same as auth code
                    tokenAuthHeader["userIdFieldName"] = authCodeAuthHeader["userIdFieldName"];
                    tokenAuthHeader["passwordFieldName"] = authCodeAuthHeader["passwordFieldName"];
                } else {
                    // auth header is not client id/secret, neither same as auth code header
                    tableRows += buildInputFieldRow(tokenAuthHeader["username"]);
                    tableRows += buildInputFieldRow(tokenAuthHeader["password"]);
                    tokenAuthHeader["userIdFieldName"] = tokenAuthHeader["username"]["name"];
                    tokenAuthHeader["passwordFieldName"] = tokenAuthHeader["password"]["name"];
                }
            } else {
                tokenAuthHeader["userIdFieldName"] = "oauth.consumerId";
                tokenAuthHeader["passwordFieldName"] = "oauth.consumerSecret";
            }
        }

        var tokenRequestParams = apiMetadataDetails["tokenAPIMetadata"]["requestParams"];
        if(tokenRequestParams) {
            for(var i=0; i<tokenRequestParams.length; i++) {
                var customField = tokenRequestParams[i];
                // do not display duplicate parameter
                if(!authCodeCustomParameterNames.includes(customField["name"])) {
                    tableRows += buildInputFieldRow(customField);
                }
                tokenCustomParameterNames.push(customField["name"]);
            }
        }
    }

    if(!onlyTokenCall) {
        // Redirect URI
        tableRows += "<tr><td>" + getmsg("redirect.uri") + "</td><td><input id=\"oauth.redirect_uri\" size=60 name=\"oauth.redirect_uri\" value=\""+getRedirectUri()+"\"><br><small>"
                + getmsg("redirect.uri.note") +"</small></td></tr>";
    }
	var tableRef = document.getElementById('mainTable');
    tableRef.innerHTML = tableRows;
}

function buildClientIdSecretRows() {
    var clientIdLabel = getParentPageElementByName(connection_client_id_name).parentNode.parentNode.cells[0].innerHTML;
    var clientSecretLabel = getParentPageElementByName(connection_client_secret_name).parentNode.parentNode.cells[0].innerHTML;

    if(clientIdLabel.endsWith("*")) {
        mandatoryFields["consumerId"] = clientIdLabel.substring(0, clientIdLabel.length -1);
    }
    if(clientSecretLabel.endsWith("*")) {
        mandatoryFields["consumerSecret"] = clientSecretLabel.substring(0, clientSecretLabel.length -1);
    }

    var tableRows = "<tr><td width=\"35%\">" + clientIdLabel + "</td><td width=\"65%\"><input id=\"consumerId\" size=60 name=\"consumerId\"";
    tableRows += " value=\"" + parent.$("input[name='" + connection_client_id_name + "']").val() + "\"";
    tableRows += "></td></tr>";
    tableRows += "<tr><td width=\"35%\">" + clientSecretLabel + "</td><td width=\"65%\"><input id=\"consumerSecret\" type=password size=60 name=\"consumerSecret\"></td></tr>";
    return tableRows;
}

function buildInputFieldRow(parameterDetails) {
    var tableRow = "";
    if(parameterDetails["isHidden"]) {
        tableRow += "<tr style=\"display:none;\" colspan=\"2\"><td>";
        tableRow += "<input id=\"" + parameterDetails["name"] + "\" name=\"" + parameterDetails["name"] + "\" value=\"" + parameterDetails["defaultValue"] + "\" />";
        tableRow += "</td></tr>"
    } else {
        tableRow += "<tr><td width=\"35%\">" + parameterDetails["displayName"];
        if(parameterDetails["isRequired"]) {
            tableRow += "*";
            mandatoryFields[parameterDetails["name"]] = parameterDetails["displayName"];
        }
        tableRow += "</td><td width=\"65%\"><input id=\"" + parameterDetails["name"] + "\" size=60 name=\"" + parameterDetails["name"] + "\"";
        if(parameterDetails["isEncrypted"]) {
            tableRow += "type=password";
        }
        if(typeof parameterDetails["defaultValue"] !== "undefined") {
            tableRow += " value=\"" + parameterDetails["defaultValue"] + "\"";
        }
        if(parameterDetails["isFixed"]) {
            tableRow += " readonly";
        }
        tableRow +=  " /></td></tr>";
    }
    return tableRow;
}

function generatePKCECodeVerifier() {
	var randomSequence = generateRandomSequence();
	var base64UrlString = base64UrlEncode(randomSequence);
	document.getElementById('code_verifier').value = base64UrlString;
}

// Function to generate a random 32-octet sequence
function generateRandomSequence() {
    return window.crypto.getRandomValues(new Uint8Array(32));
}

// Function to encode the sequence into base64url format
function base64UrlEncode(sequence) {
    var base64 = btoa(String.fromCharCode.apply(null, sequence)); // Converting to base64
    var base64Url = base64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=/g, ''); // URL safe encoding
    return base64Url;
}

function sha256(plain) {
    const encoder = new TextEncoder();
    const data = encoder.encode(plain);
    return window.crypto.subtle.digest('SHA-256', data);
}

function base64urlencode(a) {
    return btoa(String.fromCharCode.apply(null, new Uint8Array(a)))
        .replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

async function createCodeChallenge(v) {
    hashed = await sha256(v);
    base64encoded = base64urlencode(hashed);
    return base64encoded;
}

// puts all form values to key/value paramsMap which will be sent in request body
function updateParametersValue() {
    missingFields = new Array();
    paramsMap = new Array();

    for(var field in mandatoryFields) {
        if(isEmptyOrSpaces($("#"+field).val())) {
            missingFields.push(field);
            paramsDisplayNameArray[field] = mandatoryFields[field];
        }
    }
}

function makeAuthorizationCall() {

    var httpMethod = "GET";
    if(apiMetadataDetails["authCodeAPIMetadata"]["requestMethod"]) {
        httpMethod = apiMetadataDetails["authCodeAPIMetadata"]["requestMethod"];
    }
    var authEndPoint = makeAuthorizationURL();
    var winName='MyWindow';
    var windowOption='resizable=yes,height=600,width=800,location=0,menubar=0,scrollbars=1';
    var childWindow;

    if(apiMetadataDetails["authCodeAPIMetadata"]["authHeader"]) {
        var authHeaderUser, authHeaderPassword;
        var useClientIdAndSecret = apiMetadataDetails["authCodeAPIMetadata"]["authHeader"]["useClientIdAndSecret"];
        if(useClientIdAndSecret && useClientIdAndSecret === true) {
            authHeaderUser = $("#consumerId").val();
            authHeaderPassword = $("#consumerSecret").val();
        } else {
            authHeaderUser = $("#" + apiMetadataDetails["authCodeAPIMetadata"]["authHeader"]["username"]["name"]).val();
            authHeaderPassword = $("#" + apiMetadataDetails["authCodeAPIMetadata"]["authHeader"]["password"]["name"]).val();
        }
        var authHeader = "Basic " + window.btoa(authHeaderUser + ":" + authHeaderPassword);

        var auth = { type : "Basic", user : authHeaderUser, pass : authHeaderPassword };

        var requestParams = {
            endpoint    	: authEndPoint,
            httpMethod      : httpMethod,
            auth            : auth,
            followRedirect  : "no"
        }
        var proxyAlias = $("#proxyAlias").val();
        if(!isEmpty(proxyAlias)) {
            requestParams["proxyAlias"] = proxyAlias;
        }
        // add only if the SSL is enabled.
        if($("#enable2WaySSL").prop('checked')) {
            requestParams["sslKeyStoreAlias"] 	= $("#2WaySSLKeystoreAlias").val(),
            requestParams["sslKeyAlias"] 		= $("#2WaySSLKeyAlias").val(),
            requestParams["sslTrustStoreAlias"]	= $("#2WaySSLTruststoreAlias").val()
        }

        var headers = new Array();
        headers.push({ "name" : "Host", "value" : new URL(authEndPoint).hostname });
        headers.push({ "name" : "Content-Type", "value" : "application/x-www-form-urlencoded" });
        requestParams["headers"] = headers;

        $.ajax({
            type: 'POST',
            url: '/invoke/cloudstreams.oauthV21:invokePubClientHttp',
            data: JSON.stringify(requestParams),
            dataType: 'json',
            contentType: 'application/json',
            async: false,
            success: function(data) {
                var location = data["headers"]["Location"];
                if(location) {
                    childWindow = window.open(location, winName, windowOption);
                    onChildWindowClose();
                } else {
                    var response = JSON.parse(data["JSONResponse"]);
                    if(response["message"]) {
                        errorMessageToggle(response["message"], "show");
                    } else if(response["error_description"]) {
                        errorMessageToggle(response["error_description"], "show");
                    } else {
                        errorMessageToggle(getmsg("error.response.received") , "show");
                    }
                }
            },
            error: function(xhr, status) {
                errorMessageToggle("Error: " + xhr.responseText, "show");
            }
        });
    } else {
        if(httpMethod === "POST") {
            // https://stackoverflow.com/questions/3951768/window-open-and-pass-parameters-by-post-method
            var form = document.createElement("form");
            form.setAttribute("method", "post");
            form.setAttribute("action", authEndPoint);
            form.setAttribute("target", winName);

            document.body.appendChild(form);
            childWindow = window.open('', winName, windowOption);
            onChildWindowClose();
            form.target = winName;
            form.submit();
            document.body.removeChild(form);
        } else {
            childWindow = window.open(authEndPoint, winName, windowOption);
            onChildWindowClose();
        }
    }
}

function onChildWindowClose() {
    var error = false;
    var response = getStateCode(state);
    authorizationCode = "";

    if (response['code']) {
        authorizationCode = response['code'];
    } else if (response['error']) {
        var err = getErrorMessage(response['error'], response['error_description']);
        errorMessageToggle(err, "show");
        error = true;
        clearTimeout(timer);
        return;
    }

    if (!authorizationCode && !error && timer < 10000) {
        timer = setTimeout(onChildWindowClose, 1000);
    } else if (!error) {
        // found code
        clearTimeout(timer);
        if (isValidForm(true)) {
            makeTokenCall();
        }
    }
}

function makeAuthorizationURL() {
    var authEndPoint = $("#" + apiMetadataDetails["authCodeAPIMetadata"]["url"]["name"]).val();
    authEndPoint += "?client_id=" + $("#consumerId").val();
    authEndPoint += "&redirect_uri=" + redirect_uri;
    authEndPoint += "&state=" + uuid();

    if(pkceRequired) {
        authEndPoint += "&code_challenge=" + codeChallenge;
        authEndPoint += "&code_challenge_method=" + $("#code_challenge_method").val();
    }

    if(apiMetadataDetails["authCodeAPIMetadata"]["requestParams"]) {
        var authCodeRequestParams = apiMetadataDetails["authCodeAPIMetadata"]["requestParams"];
        for(var i=0; i<authCodeRequestParams.length; i++) {
            var customField = authCodeRequestParams[i];
            var value = $("#" + customField["name"]).val();
            if(!isEmptyOrSpaces(value)) {
                authEndPoint += "&" + customField["name"] + "=" + value;
            }
        }
    }
    return authEndPoint;
}

function makeTokenCall() {
    var requestParams = prepareAndGetTokenRequestObject();
    console.log(JSON.stringify(requestParams));
    $.ajax({
        type: 'POST',
        url: '/invoke/cloudstreams.oauthV21:invokePubClientHttp',
        data: JSON.stringify(requestParams),
        dataType: 'json',
        contentType: 'application/json',
        async: false,
        success: function(data) {
            var closeOnSuccess = false;
            var nonJsonResponse = "";
            var accessTokenJSONResponse;
            $.each(data, function(key, value) {
                if (key == 'status' && value == 200) {
                    closeOnSuccess = true;
                }
                if (key == 'JSONResponse') {
                    try{
                        accessTokenJSONResponse = JSON.parse(value);
                        if(accessTokenJSONResponse["scope"]) {
                            console.debug("scope : " + accessTokenJSONResponse["scope"]);
                        } else {
                            console.debug("No scope returned by the server");
                        }
                    } catch(e) {
                        nonJsonResponse = value;
                    }
                }
            });

            if (closeOnSuccess) {
                updateResponseFieldValues(accessTokenJSONResponse);
                closeIFrame(parent);
            } else {
                if(accessTokenJSONResponse){
                    var errorDescription = accessTokenJSONResponse['error_description'] === undefined ? "" : accessTokenJSONResponse['error_description'];
                    var err = getErrorMessage(accessTokenJSONResponse['error'], errorDescription);
                    errorMessageToggle(err, "show");
                } else {
                    errorMessageToggle("Error: " + data['statusMessage'] + "<br>" + nonJsonResponse, "show");
                }
            }
        },
        error: function(xhr, status) {
            errorMessageToggle("Error: " + xhr.responseText, "show");
        }
    });
}

function prepareAndGetTokenRequestObject() {
    var httpMethod = "POST";
    if(apiMetadataDetails["tokenAPIMetadata"]["requestMethod"]) {
        httpMethod = apiMetadataDetails["tokenAPIMetadata"]["requestMethod"];
    }
    var authCodeMapping = onlyTokenCall ? "none" : "body";
    if(apiMetadataDetails["authCodeMapping"]) {
        authCodeMapping = apiMetadataDetails["authCodeMapping"];
    }
    var endPoint = $("#" + apiMetadataDetails["tokenAPIMetadata"]["url"]["name"]).val();

    var requestParams = {
        endpoint    	: endPoint,
        httpMethod      : httpMethod,
    }

    var proxyAlias = $("#proxyAlias").val();
    if(!isEmpty(proxyAlias)) {
        requestParams["proxyAlias"] = proxyAlias;
    }
    // add only if the SSL is enabled.
	if($("#enable2WaySSL").prop('checked')) {
		requestParams["sslKeyStoreAlias"] 	= $("#2WaySSLKeystoreAlias").val(),
		requestParams["sslKeyAlias"] 		= $("#2WaySSLKeyAlias").val(),
		requestParams["sslTrustStoreAlias"]	= $("#2WaySSLTruststoreAlias").val()
	}

    var bodyParams = new Array();
    if(!onlyTokenCall) {
        bodyParams.push({ "name" : "redirect_uri", "value" : redirect_uri });
    }

    if(authCodeMapping === "body") {
        bodyParams.push({ "name" : "code", "value" : authorizationCode });
    }
    if(pkceRequired) {
        bodyParams.push({ "name" : "code_verifier", "value" : codeVerifier });
    }
    if(!ifClientIdPassedInTokenCallHeader()) {
        bodyParams.push({ "name" : "client_id", "value" : $("#consumerId").val() });
        if(mandatoryFields["consumerSecret"] || !isEmpty($("#consumerSecret").val())) {
            bodyParams.push({ "name" : "client_secret", "value" : $("#consumerSecret").val() });
        }
    }
    if(apiMetadataDetails["tokenAPIMetadata"]["requestParams"]) {
        var tokenRequestParams = apiMetadataDetails["tokenAPIMetadata"]["requestParams"];
        for(var i=0; i<tokenRequestParams.length; i++) {
            var customField = tokenRequestParams[i];
            var value = $("#" + customField["name"]).val();
            if(!isEmptyOrSpaces(value)) {
                bodyParams.push({ "name" : customField["name"], "value" : value });
            }
        }
    }
    requestParams["bodyParams"] = bodyParams;

    if(apiMetadataDetails["tokenAPIMetadata"]["authHeader"]) {
        var authHeaderUser, authHeaderPassword;
        var useClientIdAndSecret = apiMetadataDetails["tokenAPIMetadata"]["authHeader"]["useClientIdAndSecret"];
        if(useClientIdAndSecret && useClientIdAndSecret === true) {
            authHeaderUser = $("#consumerId").val();
            authHeaderPassword = $("#consumerSecret").val();
        } else {
            authHeaderUser = $("#" + apiMetadataDetails["tokenAPIMetadata"]["authHeader"]["username"]["name"]).val();
            authHeaderPassword = $("#" + apiMetadataDetails["tokenAPIMetadata"]["authHeader"]["password"]["name"]).val();
        }
        requestParams["auth"] = { type : "Basic", user : authHeaderUser, pass : authHeaderPassword };
    } else if(authCodeMapping === "header") {
        requestParams["auth"] = { type : "Bearer", token : authorizationCode };
    }

    var headers = new Array();
    headers.push({ "name" : "Host", "value" : new URL(endPoint).hostname });
    headers.push({ "name" : "Content-Type", "value" : "application/x-www-form-urlencoded" });
    requestParams["headers"] = headers;

    return requestParams;
}

function ifClientIdPassedInTokenCallHeader() {
    if(apiMetadataDetails["tokenAPIMetadata"]["authHeader"]) {
        var useClientIdAndSecret = apiMetadataDetails["tokenAPIMetadata"]["authHeader"]["useClientIdAndSecret"];
        if(useClientIdAndSecret && useClientIdAndSecret === true) {
            return true;
        }
    }
    return false;
}

function updateResponseFieldValues(accessTokenJSONResponse) {
    setParentFormFieldValue(connection_client_id_name, $("#consumerId").val());

    setParentFormFieldValue(connection_client_secret_name, $("#consumerSecret").val());
    triggerPasswordChangeEvent(getParentPageElementByName(getFieldNameByElementName('oauth.consumerSecret')));

    setParentFormFieldValue(getFieldNameByElementName("oauth.accessToken"), accessTokenJSONResponse['access_token']);
    triggerPasswordChangeEvent(getParentPageElementByName(getFieldNameByElementName('oauth.accessToken')));

    setParentFormFieldValue(getFieldNameByElementName("oauth_v21.authorizationHeaderPrefix"), accessTokenJSONResponse['token_type']);
    setParentFormFieldValue(getFieldNameByElementName("oauth_v21.refreshAccessToken"), "true");
    if (accessTokenJSONResponse['refresh_token']) {
        setParentFormFieldValue(getFieldNameByElementName("oauth_v21.refreshToken"), accessTokenJSONResponse['refresh_token']);
        triggerPasswordChangeEvent(getParentPageElementByName(getFieldNameByElementName('oauth_v21.refreshToken')));
        setParentFormFieldValue(getFieldNameByElementName("oauth_v21.accessTokenRefreshGrantType"), "refresh_token");
    } else {
        setParentFormFieldValue(getFieldNameByElementName("oauth_v21.accessTokenRefreshGrantType"), "client_credentials");
        setParentFormFieldValue(getFieldNameByElementName("oauth_v21.accessTokenRefreshURL"), $("#" + apiMetadataDetails["tokenAPIMetadata"]["url"]["name"]).val());
    }
    if($("#enable2WaySSL").prop('checked')) {
        setParentFormFieldValue(getFieldNameByElementName("cn.keystoreAlias"), $("#2WaySSLKeystoreAlias").val());
        setParentFormFieldValue(getFieldNameByElementName("cn.clientKeyAlias"), $("#2WaySSLKeyAlias").val());
        setParentFormFieldValue(getFieldNameByElementName("cn.truststoreAlias"), $("#2WaySSLTruststoreAlias").val());
    }
}