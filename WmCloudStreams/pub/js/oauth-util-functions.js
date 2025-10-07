/*
 * Copyright (c) 2020 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
 *
 * Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG. 
 */

// validates form inputs and throws error if any input missing for required fields

var hostname = "";
const HTTPS_PROTOCOL = "https://";
var tableName = "";

function isValidForm(table) {
	setTableName(table);
	if(parent.requiredFields.findIndex(element => element.includes("oauth_v20.iss")) != -1) {
		parent.requiredMetaFields.push("jwt.claim.iss");
	}
	
	if(parent.requiredFields.findIndex(element => element.includes("oauth_v20.sub")) != -1) {
		parent.requiredMetaFields.push("jwt.claim.sub");
	}
    updateParametersValue();
    if (missingFields.length > 0) {
		var missingRequiredFieldsError = getmsg("missing.required.field");
        var err = getErrorMessage(getmsg("missing.input.caption"), missingRequiredFieldsError + fieldsDisplayName(paramsDisplayNameArray, missingFields));
        errorMessageToggle(err, "show");
        return false;
    } else
        return true;
}
function setTableName(table) {
	this.tableName = (table == undefined || table == true || table == false )? "mainTable" : table;
}
// Resize the IFrame according to the contents of the popup
function resizeFrame() {
    var body = document.body,
        html = document.documentElement;
    var height = Math.max(body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight);
    if (height > 380) {
        height = 380;
    }
    parent.resizeIframe(height);
}

function isEmpty(value) {
	return (isUndefinedOrNULL(value) || value === '')? true : false;
}

function closeIFrame(parent) {
    parent.showSuccessInfo();
    parent.document.getElementById("closeIFrameWindow").click();
}

function getParentPageElementByName(elementName) {
  //  return parent.document.getElementsByName(elementName)[0];
	var elem = parent.document.getElementsByName(elementName)[0];
	if(elem === undefined) {
		elem = parent.$("input[name*='"+ elementName+ "']")[0];
    } 
	if(elem === undefined) {
		console.debug("Unable to find the field '" + elementName + "'");
	}
	else
		return elem;
}

function fieldsDisplayName(paramsDisplayNameArray, missingFields) {
    var missingRequiredFields = [];
	
	var reqFields = parent.requiredMetaFields.concat(parent.requiredFields);

    missingFields.forEach(function(missingField) {
        const match = reqFields.find(element => {
			if (element.includes(missingField)) {
				return true;
			}
		});
        if (!isUndefinedOrNULL(match)) {
            var displayName = paramsDisplayNameArray[missingField].replace(/\*$/, '');
			missingRequiredFields.push(displayName);

        } else if (missingField.startsWith("jwt")) {
			reqFields.forEach( function(reqField) {
				if (reqField.endsWith(missingField)) {
					var displayName = paramsDisplayNameArray[missingField].replace(/\*$/, '');
					missingRequiredFields.push(displayName);
				}
			});
		} else if (typeof paramsDisplayNameArray[missingField] !== 'undefined') {
		    missingRequiredFields.push(paramsDisplayNameArray[missingField]);
		}
        else{
			missingRequiredFields.push(missingField);
		}
    });
	return missingRequiredFields.join(", ");
}

function setParentFormFieldValue(fieldName, val) {
    if (val != undefined || val != 'undefined' || val != '') {

		var parentElement = getParentPageElementByName(fieldName);
		if($(parentElement).is("select")) {
			if($(parentElement).attr("multiple") == "multiple"){
				var valuesArray = [];
				for (const c of val) {
					valuesArray.push(c);
				}
				$(parentElement).val(valuesArray);
			} else {
				$(parentElement).val(val);
				$(parentElement).trigger('change');
			}
		} else {
			$(parentElement).val(val);
		}
		$(parentElement).trigger("change");
    }
}

function triggerPasswordChangeEvent(passwordElement) {
    passwordElement.dispatchEvent(new Event('change'));
}

function errorMessageToggle(htmlText, cmd) {
    if (cmd == "hide") {
        $("#err_message_span").html("");
        $("#err_message_span").hide();
    } else {
        $("#err_message_span").html(htmlText);
        $("#err_message_span").show();
		$("html, body").animate({scrollTop : 0}, 200, 'swing');
    }
}

function getErrorMessage(error, error_description) {
    var error_description_html = "<b>"  + getmsg("error.response.received") + "<br />" + getmsg("error.caption") + error;
	if(error_description != undefined && !isEmptyOrSpaces(error_description)) {
		error_description_html +=  error.endsWith(".") == false? ". " : " ";
		error_description_html +=  getmsg("description.caption") + error_description;
	}
	error_description_html += "</b>";
	return error_description_html;
}

function getErrorRowTR() {
    return "<tr id='status'><td colspan=8 name='err_message_span' class='error' style='text-align: left; padding-left: 35pt; word-break: break-word;' id='err_message_span'></td></tr>";
}

function setHostname(hostname) {
	this.hostname = hostname.toLowerCase();
}

// construct Redirect URI; HTTPS port preferred, fallback to HTTP port if no HTTPS port available.
function getRedirectUri() {
	var protocol = location.protocol + "//";
	var hostnameWithPort = location.host;
	try {
		if(!protocol.startsWith("https")) {
			$.ajax({
				url: "/invoke/wm.server.portAccess:portList",
				dataType: 'json',
				contentType: 'application/x-www-form-urlencoded',
				accepts: {
					text: "application/json"
				},
				async: false,
				success: function(data, status) {
					$.each(data['ports'], function(key, value) {
						var portValue = value['port'];
						var typeValue = value['type'];
						if(!isUndefinedOrNULL(portValue) && portValue.startsWith("HTTPS")
								&& !isUndefinedOrNULL(typeValue) && typeValue.includes("include")) {
							protocol = HTTPS_PROTOCOL;
							hostnameWithPort = location.hostname +  ":" + portValue.substring(portValue.indexOf('@') + 1);
						}
					});
				}
			});
		}
	} catch(err) {
		console.error("[getRedirectUri()] Caught error: " + err);
	} finally {
		redirect_uri = protocol + hostnameWithPort + "/WmCloudStreams/oauth-redirect.dsp";
	}
	console.debug("[Redirect URI] : " + redirect_uri);
    return redirect_uri;
}

function isUndefinedOrNULL(value) {
	return value === undefined || value === null;
}

function pushFieldValue(map, key, value, fieldName) {
    if (value == null || value == "") {
		var reqFields = parent.requiredMetaFields.concat(parent.requiredFields);
		
		var isRequired = reqFields.find(function(element) {
			return element.endsWith(fieldName);
		});

		if(isRequired) {
			var fieldNameOrKey = (fieldName != null || fieldName != "")? fieldName : key;
			
			if(tableName == $("input[name$='" + fieldNameOrKey + "']").closest('table')[0].id) {
				missingFields.push(key);//visibleMissingFields.push(fieldName != ""? fieldName : key);
			}
        }
    } else {
        map.push({
            'name': key,
            'value': value
        });
    }
}

function replaceServerURLInstance(sourceUrl, targetUrl) {
	var finalUrl = "";
    if (sourceUrl && targetUrl) {
        if (isUrlValid(sourceUrl)) {
			finalUrl = sourceUrl + targetUrl.substring(getPosition(targetUrl, "/", 3), targetUrl.length);
        }
    }
	if(isUrlValid(finalUrl))
		return finalUrl;
    
	return targetUrl;
}

function getPosition(string, subString, index) {
   return string.split(subString, index).join(subString).length;
}

function getAnchorElement(href) {
    var loc = document.createElement("a");
    loc.href = href;
    return loc;
}

function isUrlValid(urlInput) {
    var res = urlInput.match(/(http(s)?:\/\/.)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:%_\+.~#?&//=]*)/g);
    if (res == null)
        return false;
    else
        return true;
}

function toggle2WaySSLControls() {
	if($("#enable2WaySSL").is(":checked")) {
		$(".2way-ssl-row").show();
	} else {
		$(".2way-ssl-row").hide();
	}
}

function get2WaySSLRow() {
	var twoWaySSLRows = "<tr><td colspan=2 style='text-align: left'><input type='checkbox' id='enable2WaySSL' name='enable2WaySSL' onchange='toggle2WaySSLControls();' /><label for='enable2WaySSL'>" + getmsg("ssl.connection") + "</label></td></tr>";
	
	twoWaySSLRows += "<tr style='display: none' class='2way-ssl-row'><td>" + getmsg("keystore.alias") + "</td><td><select id='2WaySSLKeystoreAlias' onchange='getKeyAliasList();'>" + getKeystoreOptionsList() + "</select></td></tr>";
	
	twoWaySSLRows += "<tr style='display: none' class='2way-ssl-row'><td>" + getmsg("key.alias") + "</td><td><select id='2WaySSLKeyAlias'></select></td></tr>";
	
	twoWaySSLRows += "<tr style='display: none' class='2way-ssl-row'><td>" + getmsg("truststore.alias") + "</td><td><select id='2WaySSLTruststoreAlias'>" + getTruststoreOptionsList() + "</select></td></tr>";
	
	return twoWaySSLRows;
}

function getKeystoreOptionsList() {
	
	var optionsList = "<option />";
	$.ajax({
        url: "/invoke/cloudstreams.UIConfig:getKeyStoreNames",
        dataType: 'json',
        contentType: 'application/x-www-form-urlencoded',
        accepts: {
            text: "application/json"
        },
        async: false,
        success: function(data, status) {
			var keystoreNames = data['keyStoreNames'];
			var connectionKeyStoreName = "";
			if(parent.$("input[name$='cn.keystoreAlias']").val()) {
				connectionKeyStoreName = parent.$("input[name$='cn.keystoreAlias']").val();
			}
			$.each(keystoreNames, function(key, value) {
				if(connectionKeyStoreName == value['name']) {
					optionsList += "<option selected>" + value['name'] + "</option>";
				} else {
					optionsList += "<option>" + value['name'] + "</option>";
				}
            });
        },
        error: function(xhr) {
            $("#err_message_span").html("Error: " + xhr.responseText);
        }
    });
	
	return optionsList;
}

function getKeyAliasList() {

	var keystoreName = $("#2WaySSLKeystoreAlias").val();
	var optionsList = "";
	
	if(keystoreName) {
		
		$.ajax({
			url: "/invoke/cloudstreams.UIConfig:getAliases",
			dataType: 'json',
			type: "POST",
			data: {
				keyStore: keystoreName
			},
			contentType: 'application/x-www-form-urlencoded',
			accepts: {
				text: "application/json"
			},
			async: false,
			success: function(data, status) {
				var aliasNames = data['aliasNames'];
				var connectionKeyAlias = "";
				if(parent.$("input[name$='cn.clientKeyAlias']").val()) {
					connectionKeyAlias = parent.$("input[name$='cn.clientKeyAlias']").val();
				}
				$.each(aliasNames, function(key, value) {
					if(connectionKeyAlias == value['name']) {
						optionsList += "<option selected>" + value['name'] + "</option>";
					} else {
						optionsList += "<option>" + value['name'] + "</option>";
					}
				});
			},
			error: function(xhr) {
				$("#err_message_span").html("Error: " + xhr.responseText);
			}
		});
	}
	$("#2WaySSLKeyAlias").html(optionsList);
}

function getTruststoreOptionsList() {
	var optionsList = "<option />";
	$.ajax({
        url: "/invoke/cloudstreams.UIConfig:getTrustStoreNames",
        dataType: 'json',
        contentType: 'application/x-www-form-urlencoded',
        accepts: {
            text: "application/json"
        },
        async: false,
        success: function(data, status) {
			var truststoreNames = data['trustStoreNames'];
			var connectionTruststoreAlias = "";
			if((parent.$("input[name$='cn.truststoreAlias']").val())) {
				connectionTruststoreAlias = parent.$("input[name$='cn.truststoreAlias']").val();
			}
			$.each(truststoreNames, function(key, value) {
				if(connectionTruststoreAlias == value['name']) {
					optionsList += "<option selected>" + value['name'] + "</option>";
				} else {
					optionsList += "<option>" + value['name'] + "</option>";
				}
            });
        },
        error: function(xhr) {
            $("#err_message_span").html("Error: " + xhr.responseText);
        }
    });
	return optionsList;
}

function getProxyAliasList () {
	var optionsList = "<option />";
	$.ajax({
        url: "/invoke/wm.server.proxy:getProxyServerList",
        dataType: 'json',
        contentType: 'application/x-www-form-urlencoded',
        accepts: {
            text: "application/json"
        },
        async: false,
        success: function(data, status) {
			var proxyServerList = data['proxyServerList'];
			var connectionProxyServerAlias = "";
			if((parent.$("input[name$='cn.proxyAlias']").val())) {
				connectionProxyServerAlias = parent.$("input[name$='cn.proxyAlias']").val();
			}
			$.each(proxyServerList, function(key, value) {
				if(value['isDefault'] == 'Y' || connectionProxyServerAlias == value['proxyAlias']) {
					optionsList += "<option selected>" + value['proxyAlias'] + "</option>";
				} else {
					optionsList += "<option>" + value['proxyAlias'] + "</option>";
				}
            });
        },
        error: function(xhr) {
            $("#err_message_span").html("Error: " + xhr.responseText);
        }
    });
	return optionsList;
}

function isEmptyOrSpaces(value, fieldName) {
	if($.isArray(value) && value.length < 1) 
		return true; 
	else if(!$.isArray(value))
		return value === null || value.match(/^ *$/) !== null;
}

function getDisplayName(inputField) {
	return	$(inputField).closest('tr').find("td:first").html().replace(/\*/g, "");
}

// UUID generator function
function uuid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1);
    }
    state = s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
    return state;
}

// Retrieve Authorization Code from Cache, key is state (generated UUID in authorization step)
function getStateCode(state) {
    var codeValue = {};
    $.ajax({
        url: "/invoke/cloudstreams.oauth:cacheCode",
        dataType: 'json',
        data: {
            action: "get",
            state: state
        },
        contentType: 'application/x-www-form-urlencoded',
        accepts: {
            text: "application/json"
        },
        async: false,
        success: function(data, status) {
            $.each(data, function(key, value) {

                if (key == 'code') {
                    codeValue['code'] = value;
                }
                if (key == 'error') {
                    codeValue['error'] = value;
                }
                if (key == 'error_description') {
                    codeValue['error_description'] = value;
                }
            });
        },
        error: function(xhr) {
            $("#err_message_span").html("Error: " + xhr.responseText);
        }
    });

    return codeValue;
}

function getFieldNameByElementName(elementName) {
	var inputField = parent.$("input[name*='" + elementName + "']")[0];
	var selectField = parent.$("select[name*='" + elementName + "']")[0];
    if(inputField || selectField) {
        if(inputField) {
            return inputField.name;
        } else {
            return selectField.name;
        }
    }
	console.error(getmsg("connection.field.not.found", elementName));
}

function setGrantType(grantType) {
	if(grantType.equals("client_credentials")) {
		toggleOAuthRefreshControls("hide");
	} else if(grantType.equals("authorization_code")) {
		toggleOAuthRefreshControls("show");
	}
}