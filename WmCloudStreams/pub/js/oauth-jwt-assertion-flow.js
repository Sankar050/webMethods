/*
 * Copyright (c) 2020 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
 *
 * Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG. 
 */
var CONNECTION_PROVIDER_URL_NAME = "CPROP$connection$Basic$cn.providerUrl";
var CONNECTION_JWT_ISSUER = "CPROP$oauth_v20_jwt_client_assertion$Basic$oauth_v20.iss";
var CONNECTION_JWT_SUBJECT = "CPROP$oauth_v20_jwt_client_assertion$Basic$oauth_v20.sub";
var JWT_CLAIM_ISSUER = "jwt.claim.iss";
var JWT_CLAIM_SUBJECT = "jwt.claim.sub";
var KEYSTORE_ALIAS_FIELD = "pg.keystore.keyStoreHandle";
var KEY_ALIAS_FIELD = "pg.rampartdeploymenthandler.signingCertAlias";
var PROXY_ALIAS_FIELD = "proxyAlias";
var AUTHENTICATION_SERVER_URL_NAME = 'jwt.authenticationServerUrl';
var KEYSTORE_ALIAS_NAME = 'jwt.keystoreAlias';
var KEY_ALIAS_NAME = 'jwt.keyAlias';
var	PROXY_ALIAS_NAME = 'jwt.proxyAlias';
var	JWT_OMIT_PADDING = 'jwt.omitPadding';
var FIELD_NAME_CLIENT_ASSERTION = "jwt.client.assertion.client_assertion";

var JWT_HEADERS_LABEL = "jwt.headers";
var JWT_CLAIMS_LABEL = "jwt.claims";
var JWT_CUSTOM_FIELDS_LABEL = "jwt.custom.fields";

var issuerLabel = "";
var authenticationServerUrl = "";
var jwtTokenRefreshCustomESBService = "";
var missingFields = [];
var headers = [];
var headersMap = [];
var claims = [];
var claimsMap = [];
var customFields = [];
var customFieldsMap = [];
var clientAssertionFields = [];
var clientAssertionFieldsMap = [];
var paramsDisplayNameArray = {};
var keyStoreAlias = "";
var keyAlias = "";
var proxyAlias = "";
var base64EncodingOmitPadding = false;
var accessTokenJSONResponse = null;

$(document).ready(function() {

    buildTableContent();
    resizeFrame();
    errorMessageToggle("", "hide");

    //make an Ajax POST call to get the list of aliases for the chosen keystore
    $("select[name='" + KEYSTORE_ALIAS_FIELD + "']").bind('change', function() {
		var sel = ""
		if(this.selectedIndex >= 0) {
			sel = this.options[this.selectedIndex].text;
        }

        if (sel !== "") {
            $('div#busy').css('display', 'inline'); //show busy

            $.post("getAliases.dsp", {
                "action": "getAliases",
                "keyStore": sel
            }, function(data) {
                var options = data.substr(data.indexOf("<option>"));
                $("select[name='" + KEY_ALIAS_FIELD + "']").html(options);
                $('div#busy').css('display', 'none'); //hide busy
            });
        } else {
            //remove the alias select options
            $("select[name='" + KEY_ALIAS_FIELD + "'] > option").each(function() {
                if ($(this).val() !== "") $(this).remove();
            });
        }
    });
	
	fetchParentTableOAuthFields();

	// enable 2-way SSL if it's configured in connection
	if(parent.$("input[name$='cn.keystoreAlias']").val()) {
		$("#enable2WaySSL").prop('checked', true).change();
		$("#2WaySSLKeystoreAlias").change();
	}

    // Access Token
    $("#getJwtToken").click(function() {
        if (isValidForm('mainTable')) {
            getJWTToken();
        }
    });
    // Access Token
    $("#getAccessToken").click(function() {
        if (isValidForm('mainTable')) {
			invokeAsserionService();
        }
    });
    // Calculate X5T
  /*   $("#calculateX5T").click(function() {
        if (isValidForm('JWTAssertionTable')) {
			calculateX5T();
        }
    }); 
	$('input[type="file"]').change(function() {
		calculateX5T();
    });*/
});

function calculateX5T() {

	if($('#certFile').val() == '' || $('#certFile').val() == undefined) {
		$("#err_message_span").html("Please select a valid certificate file.");
		$("#err_message_span").show();
		$("html, body").animate({scrollTop : 0}, 200, 'swing');
		
		return;
	}
	var x5tAlgorithm = $("input[name$='jwt.client.assertion.x5t.algorithm'").val();
	console.debug("x5tAlgorithm = " + x5tAlgorithm);
	if(!x5tAlgorithm)
		x5tAlgorithm = "SHA-1";
	
	var x5tRemovePadding = $("input[name$='jwt.client.assertion.x5t.removePadding'").val();
	console.debug("x5tRemovePadding = " + x5tRemovePadding);
	if(x5tRemovePadding == undefined)
		x5tRemovePadding = false;
	
	var formData = new FormData();
	var files = $('#certFile')[0].files[0];
	formData.append('certFile', files);
	formData.append('algorithm', x5tAlgorithm);
	formData.append('removePadding', x5tRemovePadding);

	$.ajax({
		type: 'POST',
		url: '/invoke/pub.cloudstreams.util.services.x5t:x5tWrapper',
		data: formData,
		processData: false,
		contentType: false,
		accepts: {
			text: "application/json"
		},
		timeout: 180000,
		async: false,
		cache: false,
		success: function(data) {
			console.debug(data);
			errorMessageToggle(err, "hide");
			if(data['value'] != undefined) {
				$("input[name$='jwt.header.x5t']").val(data['value']);
			} else {
				if(data['error']){
					var errorDescription = data['error_description'] === undefined?  "" : data['error_description'];
					var err = getErrorMessage(data['error'], errorDescription);
					errorMessageToggle(err, "show");
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				} else {
					$("#err_message_span").html("Error: " + data['statusMessage'] + "<br>" + xhr.responseText);
					$("#err_message_span").show();
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				}
			}
		},
		error: function(xhr, status) {
			$("#err_message_span").html("Error: " + xhr.responseText);
			$("html, body").animate({scrollTop : 0}, 200, 'swing');
		}
	});
}


function validCertFile() {
    var path = $("#certFile").val();
    if ($.trim(path).length != 0) {
        $.post('consumer-checkcert.dsp', {'certFile': path}, function (data) {
            var result = $(data.substr(data.indexOf("<result>"))); //get the <result> element that holds the status
            var isValidCert = $(result).find("certValid");
            return isValidCert.text();
        });
    }
}

function getLabel(key) {
	var customFieldLabel = getmsg(key);
	if(!customFieldLabel.startsWith("Missing message key")) {
		return customFieldLabel;
	}
	switch(key) {
		case JWT_HEADERS_LABEL:
			customFieldLabel = "Headers";
			break;
		case JWT_CLAIMS_LABEL:
			customFieldLabel = "Claims";
			break;
		case JWT_CUSTOM_FIELDS_LABEL:
			customFieldLabel = "Custom Fields";
			break;
	}
	return customFieldLabel;
}

function getFileUploadControl() {
	return '<input type="file" id="certFile" name="certFile" accept=".crt, .cer, .ca-bundle, .p7b, .p7c, .p7s, .pem" />';
}

function handleX5THeaderInput() {
	console.debug("called handleX5THeaderInput();");
	var x5tHeaderInput = $("input[name$='jwt.header.x5t']");
	if(x5tHeaderInput != undefined && x5tHeaderInput.length > 0) {
		$(x5tHeaderInput).insertAfter(x5tHeaderInput).after(getFileUploadControl());
	}
}

// function which builds the table form with meta fields to get input for JWT token creation.
function buildTableContent() {
	
    issuerLabel = getParentPageElementByName(CONNECTION_JWT_ISSUER).parentNode.parentNode.cells[0].innerHTML;
    var subjectLabel = getParentPageElementByName(CONNECTION_JWT_SUBJECT).parentNode.parentNode.cells[0].innerHTML;
    paramsDisplayNameArray[JWT_CLAIM_ISSUER] = issuerLabel;
    paramsDisplayNameArray[JWT_CLAIM_SUBJECT] = subjectLabel;
	
	var additionalFieldsRows = "<tr><td class='heading' colspan=2>" + getLabel(JWT_CUSTOM_FIELDS_LABEL) + "</td></tr>";
    var finalTableRows = "";//getErrorRowTR(); // add error row
    var headersRows = "<tr><td class=heading colspan=2>" + getLabel(JWT_HEADERS_LABEL) + "</td></tr>";
    var tableRows = "<tr><td class=heading colspan=2>" + getLabel(JWT_CLAIMS_LABEL) + "</td></tr>";
    tableRows += "<tr><td>" + issuerLabel + "</td><td><input id='" + JWT_CLAIM_ISSUER + "' size=60 name='" + JWT_CLAIM_ISSUER + "' ></td></tr>";
    tableRows += "<tr><td>" + subjectLabel + "</td><td><input id='" + JWT_CLAIM_SUBJECT + "' size=60 name='" + JWT_CLAIM_SUBJECT + "' ></td></tr>";

    var elements = parent.document.getElementsByClassName('meta');
    for (var i = 0; i < elements.length; i++) {
		// extract display name
        var elementDisplayName = $(elements[i]).find(':first-child')[0];	
		// extract input field
		columns = elements[i].getElementsByTagName('td');
		var element = $(columns[columns.length-1]).find(':input')[0];
		// since it is a flat structure, assuming first element to be the input field.
		if(element == undefined) {
			console.debug("Element undefined for field '" + elementDisplayName.innerHTML + "'");
			continue;
		}
		var elementName = element.name.replace("META$", ""); 

        paramsDisplayNameArray[elementName] = elementDisplayName.innerHTML;
		if(elementName.endsWith(KEYSTORE_ALIAS_NAME) || elementName.endsWith(KEY_ALIAS_NAME))
			continue;

		if ($(element).attr("name").endsWith(AUTHENTICATION_SERVER_URL_NAME)) {
            continue;
		}
		
		if ($(element).attr("name").endsWith('jwt.omitPadding')) {
            base64EncodingOmitPadding = $(element).val();
			if($(element).attr("isHidden")) {
				continue; // no need to add the field to the form table
			}
		}
		
		var tempRows = "";
        // add only if meta field user input is required
        if ($(element).attr('type') == 'hidden') {
            tempRows += '<tr style="display: none;">' + elements[i].innerHTML + '</tr>';
		} else {
            tempRows += '<tr>' + elements[i].innerHTML + '</tr>';
        }
		
		// clear password field
		if ($(element).attr('type') == 'password') {
            $(element).val('');
			$(element).on("change", function(event) { 
				passwordChanged(this.form, '%value propertyKey%');
			});
        }
		
		if (elementName.startsWith("jwt.header")) {
            headers.push(elementName.replace("META$", ""));
			headersRows += tempRows;
        } else if (elementName.startsWith("jwt.claim")) {
            claims.push(elementName.replace("META$", ""));
			tableRows += tempRows;
        } else if (elementName.startsWith("jwt.cx")) {
            customFields.push(elementName.replace("META$", ""));
			additionalFieldsRows += tempRows;
        }

    }
	
	tableRows += getKeystoreRows();

    var tableRef = document.getElementById('mainTable');
	// Add fields into table rows
	if(customFields.length > 0) {
		tableRef.innerHTML =  headersRows + tableRows + buildJWTAssertionTable() + additionalFieldsRows;
	} else {
		tableRef.innerHTML = headersRows + tableRows + buildJWTAssertionTable() + tableRef.innerHTML; 
	}
	
	var headerTableRef = document.getElementById('EndPointTable');
    headerTableRef.innerHTML =	finalTableRows;
}

function buildJWTAssertionTable() {
	
	//TODO: refer from messagedb getmsg("JWT.Assertion.Request.Parameters")
	var endpointRows = "<tr><td class=heading colspan=2>" + getmsg("request.endpoints")+ " and Proxy</td></tr>";
	var tableRows =  "<tr><td class=heading colspan=2>Request Parameters</td></tr>";
    var requestEndpoints = new Array();
    var requestParameters = {};
    var elements = parent.document.getElementsByClassName('meta');
    for (var i = 0; i < elements.length; i++) {
		// extract display name
        var elementDisplayName = $(elements[i]).find(':first-child')[0];	
		// extract input field
		columns = elements[i].getElementsByTagName('td');
		var element = $(columns[columns.length-1]).find(':input')[0];
		// since it is a flat structure, assuming first element to be the input field.
		if(element == undefined) {
			console.debug("Element undefined for field '" + elementDisplayName.innerHTML + "'");
			continue;
		}
		var elementName = element.name.replace("META$", ""); 

        paramsDisplayNameArray[elementName] = elementDisplayName.innerHTML;
		if(elementName.endsWith(KEYSTORE_ALIAS_NAME) || elementName.endsWith(KEY_ALIAS_NAME))
			continue;

		if ($(element).attr("name").endsWith('jwt.authenticationServerUrl')) {
            authenticationServerUrl = $(element).val();
            endpointRows += "<tr><td>" + getmsg("token.endpoint").replace(/ /g, '\u00a0') + "</td><td><input id='" 
				+ AUTHENTICATION_SERVER_URL_NAME + "' size=60 name='" 
				+ AUTHENTICATION_SERVER_URL_NAME + "' value='" + authenticationServerUrl +"' ></td></tr>";
            requestEndpoints.push(elementName);
            continue;
		}
		
		if ($(element).attr("name").endsWith('jwt.omitPadding'))
			continue;
		
		var tempRows = "";
        // add only if meta field user input is required
        if ($(element).attr('type') == 'hidden') {
            tempRows += '<tr style="display: none;">' + elements[i].innerHTML + '</tr>';
		} else {
            tempRows += '<tr>' + elements[i].innerHTML + '</tr>';
        }
		
		// clear password field
		if ($(element).attr('type') == 'password') {
            $(element).val('');
			$(element).on("change", function(event) { 
				passwordChanged(this.form, '%value propertyKey%');
			});
        }
		
		if (elementName.startsWith("jwt.client.assertion")) {
			clientAssertionFields.push(elementName.replace("META$", ""));
			tableRows += tempRows;
        }
    }
	// add 2-way SSL input rows
	endpointRows += getProxyServerRow() + get2WaySSLRow();

	// add client assertion field to requiredMetaFields.
	parent.requiredMetaFields.push(FIELD_NAME_CLIENT_ASSERTION);
	paramsDisplayNameArray[FIELD_NAME_CLIENT_ASSERTION] = getmsg(FIELD_NAME_CLIENT_ASSERTION);
	return endpointRows + tableRows;
}

function getKeystoreRows() {
var rows =  "<tr><td class='heading' colspan=2>Keystore</td></tr>"
			+ "<tr><td nowrap>" + paramsDisplayNameArray[KEYSTORE_ALIAS_NAME] + "</td><td>"
			+ "<select name='pg.keystore.keyStoreHandle'>"
			+  getKeystoreOptionsList()
			+ "</select></td></tr>";
	rows += "<tr><td nowrap>" + paramsDisplayNameArray[KEY_ALIAS_NAME]+ "</td><td>"
			+ "<select name='pg.rampartdeploymenthandler.signingCertAlias'></select></td></tr>";
			return rows;
}

function getProxyServerRow() {
	return "<tr><td nowrap>Proxy Server Alias</td><td>"
			+ "<select name='proxyAlias'>" + getProxyAliasList()
			+ "</select></td></tr>";


}
function getIssuer() {
	return $("[name='" + JWT_CLAIM_ISSUER + "']").val();
}

function isEditConnection() {
	if(getParentPageElementByName('connectionAlias'))
		return true;
	else 
		return false;
}

function getAccessTokenRefreshCustomESBService() {
	var customESBService = getElementFullName('oauth_v20.accessTokenRefreshCustomESBService');
	return getParentPageElementByName(customESBService).value;
}

function getAuthenticationServerUrl() {
	if(document.getElementById(AUTHENTICATION_SERVER_URL_NAME)) {
		return document.getElementById(AUTHENTICATION_SERVER_URL_NAME).value;
	}
	return authenticationServerUrl;
}

// invokes service with request body parameters (headers and claims array) with keystore details. 
// The service creates an encrypted token and send it to JWT Token server (authenticationServerUrl)
function getJWTToken() {

    var requestParams = {
        headers					: headersMap,
        claims					: claimsMap,
        customFields			: customFieldsMap,
		omitPadding				: base64EncodingOmitPadding,
        keyStoreAlias			: keyStoreAlias,
        keyAlias				: keyAlias
    }

    $.ajax({
        type: 'POST',
        url: '/invoke/cloudstreams.oauth:getJsonWebToken',
        data: JSON.stringify(requestParams),
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        accepts: {
            text: "application/json"
        },
		timeout: 180000,
        async: false,
		cache: false,
        success: function(data) {
            var closeOnSuccess = false;
            var failureMessage = "";
			var nonJsonResponse = "";
			console.debug(data);
			
			if (data['jwt_token'] != undefined) {
                $("input[name$='"+ FIELD_NAME_CLIENT_ASSERTION + "']").val(data['jwt_token']);
				$("#client_id").val($("input[name='jwt.claim.iss']").val());
				errorMessageToggle(err, "hide");
				$("#jwtContentButton").click();
				//$("#OAuthAssertionContentButton").click();
				if (!$("#OAuthAssertionContentButton").hasClass("active")) {
					$("#OAuthAssertionContentButton").click();
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				}
            } else {
				if(data['error']){
					var errorDescription = data['error_description'] === undefined?  "" : accessTokenJSONResponse['error_description'];
					var err = getErrorMessage(data['error'], errorDescription);
					errorMessageToggle(err, "show");
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				} else {
					$("#err_message_span").html("Error: " + data['statusMessage'] + "<br>" + nonJsonResponse);
					$("#err_message_span").show();
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				}
            }
        },
        error: function(xhr, status) {
            $("#err_message_span").html("Error: " + xhr.responseText);
			$("html, body").animate({scrollTop : 0}, 200, 'swing');
        }
    });
	
}

// invokes service with request body parameters (JWT assertion and other parameters), sends it to server (authenticationServerUrl) 
// and receives OAuth token details.
function invokeAsserionService() {

    var requestParams = {
        authenticationServerUrl	: getAuthenticationServerUrl(),
		headers					: headersMap,
        claims					: claimsMap,
        fields					: clientAssertionFieldsMap,
        customFields			: customFieldsMap,
		omitPadding				: base64EncodingOmitPadding,
        keyStoreAlias			: keyStoreAlias,
        keyAlias				: keyAlias,
		editConnection			: isEditConnection(),
        proxyAlias				: proxyAlias,
        passwordChange			: $('input[name="passwordChange"]').val(),
        passmanFields			: {
									"passmanHandles": parent.passmanFieldsMap,
									"packageName": parent.packageName
								},
		accessTokenRefreshCustomESBService: getAccessTokenRefreshCustomESBService()
    }
	
	// add only if the SSL is enabled.
	if($("#enable2WaySSL").prop('checked')) {
		requestParams["sslKeyStoreAlias"] 	= $("#2WaySSLKeystoreAlias").val(),
		requestParams["sslKeyAlias"] 		= $("#2WaySSLKeyAlias").val(),
		requestParams["sslTrustStoreAlias"]	= $("#2WaySSLTruststoreAlias").val()
	}
	console.debug("requestParams for service invocation:");
	console.debug(requestParams);
    $.ajax({
        type: 'POST',
        url: '/invoke/cloudstreams.oauth:jwtClientAssertionFlow',
        data: JSON.stringify(requestParams),
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        accepts: {
            text: "application/json"
        },
		timeout: 180000,
        async: false,
		cache: false,
        success: function(data) {
			var closeOnSuccess = false;
			var failureMessage = "";
			var nonJsonResponse = "";
			$.each(data, function(key, value) {
				if (key == 'status' && value == 200) {
					closeOnSuccess = true;
				}
				if (key == 'JSONResponse') {
                	try {
						accessTokenJSONResponse = JSON.parse(value);
					}
					catch(e) {
						nonJsonResponse = value;
					}
                }
            });
			if (closeOnSuccess) {
				updateResponseFieldValues();
				closeIFrame(parent);
			} else {
				if(!data['error'] && accessTokenJSONResponse != null) {
					data = accessTokenJSONResponse;
				}
				if(data['error']){
					var errorDescription = data['error_description'] === undefined?  "" : accessTokenJSONResponse['error_description'];
					var err = getErrorMessage(data['error'], errorDescription);
					errorMessageToggle(err, "show");
				} else {
					$("#err_message_span").html("Error: " + data['status'] + ", Description: "+ data['statusMessage'] + "<br>" + nonJsonResponse);
					$("#err_message_span").show();
				}
				
				if (!$("#jwtContentButton").hasClass("active")) {
					$("#jwtContentButton").click();
					$("html, body").animate({scrollTop : 0}, 200, 'swing');
				}
            }
        },
        error: function(xhr, status) {
            $("#err_message_span").html("Error: " + status + ", Description: " + xhr.responseText);
			$("html, body").animate({scrollTop : 0}, 200, 'swing');
        }
    });
}

function getFieldsMap() {
    
   let result = new Array();;
    
    $("#mainTable tbody tr").each(function() {
        $(this).find("*[name^='META$jwt.client.assertion']").each(function( index ) {
            var fieldName = $(this).attr("name");
			console.debug(fieldName);
            if(fieldName !== undefined && fieldName.startsWith("META$jwt.client.assertion")) {
				var nameValue = {};
				nameValue['name'] = fieldName.substring(fieldName.lastIndexOf(".") + 1);
				nameValue['value'] = $(this).val();
				result.push(nameValue);
			}
        });
        
    })
    console.debug(result);
    return result;
}


function updateResponseFieldValues() {
    setParentFormFieldValue(CONNECTION_JWT_ISSUER, $("[name='" + JWT_CLAIM_ISSUER + "']").val());
    setParentFormFieldValue(CONNECTION_JWT_SUBJECT, $("[name='" + JWT_CLAIM_SUBJECT + "']").val());
    setParentFormFieldValue(getElementFullName('oauth.accessToken'), accessTokenJSONResponse['access_token']);
    triggerPasswordChangeEvent(getParentPageElementByName(getElementFullName('oauth.accessToken')));
	
	if(accessTokenJSONResponse['instance_url']) {
		setParentFormFieldValue(getElementFullName('oauth_v20.instanceURL'), accessTokenJSONResponse['instance_url']);
    }
	
	var authHeaderPrefix = accessTokenJSONResponse['token_type'];
	if(authHeaderPrefix && authHeaderPrefix.toLowerCase == "oauth"){
		authHeaderPrefix = 'OAuth';
	} else {
		authHeaderPrefix = 'Bearer';
	}
	setParentFormFieldValue(getElementFullName('oauth_v20.authorizationHeaderPrefix'), authHeaderPrefix);
	
	// set session expire time and 
	var expires_in = accessTokenJSONResponse['expires_in'];
	var isPoolingEnabled = getParentPageElementByName("CMGRPROP$poolable");
	if(isPoolingEnabled) {
		var expiryMins = $("[name$='jwt.claim.exp']").val();
		if(expires_in) {
			expiryMins = Math.floor(expires_in / 60);
		}
		var sessionTimeoutType = getParentPageElementByName("CMGRPROP$timeoutType");
		$(sessionTimeoutType).val("auto").change();
		var sessionExpiryInput = getParentPageElementByName("CMGRPROP$sessionExpiry");
		if($(sessionExpiryInput).is(':disabled')) {
			$(sessionExpiryInput).prop('disabled', false);
		}
		$(sessionExpiryInput).val(expiryMins);
	}
	for(var i = 0 ; i < headersMap.length; i++) {
		setParentFormFieldValue(getElementFullName(headersMap[i].name), headersMap[i].value);
	}
	for(var i = 0 ; i < claimsMap.length; i++) {
		if(!(JWT_CLAIM_ISSUER == claimsMap[i].name || JWT_CLAIM_SUBJECT == claimsMap[i].name)) {
			setParentFormFieldValue(getElementFullName(claimsMap[i].name), claimsMap[i].value);
		}
	}
	for(var i = 0 ; i < customFieldsMap.length; i++) {
		setParentFormFieldValue(getElementFullName(customFieldsMap[i].name), customFieldsMap[i].value);
	}
	for(var i = 0 ; i < clientAssertionFieldsMap.length; i++) {
		setParentFormFieldValue(getElementFullName(clientAssertionFieldsMap[i].name), clientAssertionFieldsMap[i].value);
	}
	
	setParentFormFieldValue(getElementFullName(AUTHENTICATION_SERVER_URL_NAME), authenticationServerUrl);
	setParentFormFieldValue(getElementFullName(KEYSTORE_ALIAS_NAME), keyStoreAlias);
	setParentFormFieldValue(getElementFullName(KEY_ALIAS_NAME), keyAlias);
	setParentFormFieldValue(getElementFullName(PROXY_ALIAS_NAME), proxyAlias);
	
	// set SSL connection fields' value
	// add only if the SSL is enabled.
	if($("#enable2WaySSL").prop('checked')) {
		setParentFormFieldValue(getElementFullName("cn.keystoreAlias"), $("#2WaySSLKeystoreAlias").val());
		setParentFormFieldValue(getElementFullName("cn.clientKeyAlias"), $("#2WaySSLKeyAlias").val());
		setParentFormFieldValue(getElementFullName("cn.truststoreAlias"), $("#2WaySSLTruststoreAlias").val());
	}
}

// gets issuer and subject field values from connection page
function fetchParentTableOAuthFields() {
    $("[name='" + JWT_CLAIM_ISSUER + "']").val(getParentPageElementByName(getElementFullName(CONNECTION_JWT_ISSUER)).value);
    $("[name='" + JWT_CLAIM_SUBJECT + "']").val(getParentPageElementByName(getElementFullName(CONNECTION_JWT_SUBJECT)).value);
	
	if(getParentPageElementByName(getElementFullName(KEYSTORE_ALIAS_NAME))) {
		var storedKeystore = getParentPageElementByName(getElementFullName(KEYSTORE_ALIAS_NAME)).value;
		$("[name='" + KEYSTORE_ALIAS_FIELD + "']").val(storedKeystore).change();
	}
	if(getParentPageElementByName(getElementFullName(KEY_ALIAS_NAME))) {
		var storedKeyAlias = getParentPageElementByName(getElementFullName(KEY_ALIAS_NAME)).value;
		$("[name='" + KEY_ALIAS_FIELD + "']").val(storedKeyAlias);
	}
	if(getParentPageElementByName(getElementFullName("proxyAlias"))) {
		var storedProxyAlias = getParentPageElementByName(getElementFullName("proxyAlias")).value;
		$("[name='" + PROXY_ALIAS_FIELD + "']").val(storedProxyAlias);
	}
}

function updateParametersValue() {
    // clear arrays
    missingFields = new Array();
    claimsMap = new Array();
    headersMap = new Array();
	customFieldsMap = new Array();
	clientAssertionFieldsMap = new Array();
	authenticationServerUrl = getAuthenticationServerUrl();
	if(authenticationServerUrl == null || authenticationServerUrl == ""){
		missingFields.push("Token Endpoint");
	}
    // issuer field 
    var issuer = $("[name='" + JWT_CLAIM_ISSUER + "']").val();
    var subject = $("[name='" + JWT_CLAIM_SUBJECT + "']").val();
    pushFieldValue(claimsMap, JWT_CLAIM_ISSUER, issuer, JWT_CLAIM_ISSUER);
    pushFieldValue(claimsMap, JWT_CLAIM_SUBJECT, subject, JWT_CLAIM_SUBJECT);

    for (var i = 0; i < headers.length; i++) {
        var value = $("[name$='" + headers[i] + "']").val();
        pushFieldValue(headersMap, headers[i], value, headers[i]);
    }
    for (var i = 0; i < claims.length; i++) {
        var value = $("[name$='" + claims[i] + "']").val();
        pushFieldValue(claimsMap, claims[i], value, claims[i]);
    }
    for (var i = 0; i < customFields.length; i++) {
        var value = $("[name$='" + customFields[i] + "']").val();
        pushFieldValue(customFieldsMap, customFields[i], value, customFields[i]);
    }
    for (var i = 0; i < clientAssertionFields.length; i++) {
        var value = $("[name$='" + clientAssertionFields[i] + "']").val();
        pushFieldValue(clientAssertionFieldsMap, clientAssertionFields[i], value, clientAssertionFields[i]);
    }

    keyStoreAlias = $("select[name='" + KEYSTORE_ALIAS_FIELD + "']").val();
	if(keyStoreAlias == null || keyStoreAlias == ""){
		missingFields.push(KEYSTORE_ALIAS_NAME);
	}
    keyAlias = $("select[name='" + KEY_ALIAS_FIELD + "']").val();
	if(keyAlias == null || keyAlias == ""){
		missingFields.push(KEY_ALIAS_NAME);
	}
    proxyAlias = $("select[name='proxyAlias']").val();
	omitPadding = $("select[name='" + JWT_OMIT_PADDING + "']").val();
}

function getElementFullName(elementName, modelType) {
    
	if(modelType) {
		var metaElementName = '' + elementName;
		var metaElement = getParentPageElementByName(metaElementName);
		return metaElement.name;
	
	} else {
		var inputField = parent.$("input[name*='" + elementName + "']")[0];
		var selectField = parent.$("select[name*='" + elementName + "']")[0];
		if(inputField || selectField) {
			if(inputField) {
				return inputField.name;
			} else {
				return selectField.name;
			}
		}
		var basicElementName = 'CPROP$*$Basic$' + elementName;
		var advancedElementName = 'CPROP$*$Advanced$' + elementName;
		var metaElementName = 'META$' + elementName;

		var basicElement = getParentPageElementByName(basicElementName);
		var advancedElement = getParentPageElementByName(advancedElementName);
		var metaElement = getParentPageElementByName(metaElementName);

		if (basicElement != undefined && basicElement != null) {
			return basicElement.name;
		} else if (advancedElement != undefined && advancedElement != null) {
			return advancedElement.name;
		} else if (metaElement != undefined && metaElement != null) {
			return metaElement.name;
		}
	
		console.error(getmsg("connection.field.not.found", elementName));
	}
}
