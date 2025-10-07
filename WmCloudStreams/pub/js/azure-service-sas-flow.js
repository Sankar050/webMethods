/**
 * Copyright (c) 2020 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
 *
 * Use, reproduction, transfer, publication or disclosure is prohibited except as specifically provided for in your License Agreement with Software AG. 
 */
var missingFields = [];
var sasParameters = [];
var sasParametersMap = {};
var customFields = [];
var customFieldsMap = [];
var paramsDisplayNameArray = {};
var sasToken = "";

$(document).ready(function() {

    buildTableContent();
    resizeFrame();
	setCSSForMultiSelect();
	toggleSAPComponents($("select[name='META$azure.useStoredAccessPolicy']").val() == 'true');
	$("select[name='META$azure.signedResource']").trigger('change');
				
	$("select[name='META$azure.useStoredAccessPolicy']").bind("change", function() {
		toggleSAPComponents($(this).val() == 'true');
	});			
	$("select[name='META$azure.signedResource']").bind("change", function() {
		toggleSignedResourceComponents($(this).val());
	});
    errorMessageToggle("", "hide");
	fetchParentTableFields();
	
    // SAS Token
    $("#getToken").click(function() {
        if (isValidForm()) {
            invokeService();
        }
    });
});


function setCSSForMultiSelect() {
	$('select[multiple]').multiselect({
		columns: 1,
		search: true,
		selectAll: true,
		texts: {
			placeholder: 'Select options',
			searchNoResult     : ''
		}
	});
}

function getLabel(key) {
	var customFieldLabel = getmsg(key);
	if(!customFieldLabel.startsWith("Missing message key")) {
		return customFieldLabel;
	}
	switch(key) {
		case JWT_CLAIMS_LABEL:
			customFieldLabel = "Claims";
			break;
		case JWT_CUSTOM_FIELDS_LABEL:
			customFieldLabel = "Custom Fields";
			break;
	}
	return customFieldLabel;
}

// function which builds the table form with meta fields from Azure Service SAS connection group
function buildTableContent() {
	var finalTableRows = getErrorRowTR(); // add error row
	var tableRows = "";
	
    finalTableRows += "<tr><td class=heading colspan=2>" + getmsg("azure.service.sas.parameters") + "</td></tr>";
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
		
        if (elementName.startsWith("azure.")) {
            sasParameters.push(elementName.replace("META$", ""));
        } else if (elementName.startsWith("azure.cx")) {
            customFields.push(elementName.replace("META$", ""));
        }

        // add only if meta field user input is required
        if ($(element).attr('type') == 'hidden') {
            tableRows += '<tr style="display: none;">' + elements[i].innerHTML + '</tr>';
        
		} else if (elementName.startsWith("cx.")) {
			additionalFieldsRows += '<tr>' + elements[i].innerHTML + '</tr>';
		} else {
            tableRows += '<tr>' + elements[i].innerHTML + '</tr>';
        }
		
		// clear password field
		if ($(element).attr('type') == 'password') {
            $(element).val('');
			$(element).on("change", function(event) { 
				passwordChanged(this.form, '%value propertyKey%');
			});
        }

    }

    var tableRef = document.getElementById('mainTable');
	// Add fields into table rows
	if(customFields.length > 0) {
		tableRef.innerHTML =  tableRows + additionalFieldsRows;
	} else {
		tableRef.innerHTML =  tableRows; 
	}
	
	var headerTableRef = document.getElementById('EndPointTable');
    headerTableRef.innerHTML =	finalTableRows;
}

function isEditConnection() {
	if(getParentPageElementByName('connectionAlias'))
		return true;
	else 
		return false;
}

// invokes service with request body parameters and creates an encrypted signature token with azure sas parameters
function invokeService() {
	updateParametersValue();
	console.debug(JSON.stringify(sasParametersMap));
    $.ajax({
        type: 'POST',
        url: '/invoke/cloudstreams.azure.sas:azureServiceSAS',
        data: JSON.stringify(sasParametersMap),
        dataType: 'json',
        contentType: 'application/json; charset=utf-8',
        accepts: {
            text: "application/json"
        },
		timeout: 180000,
        async: false,
		cache: false,
        success: function(data) {
			sasToken = data['sasToken'];
			var error = data['error'];
			
            if (sasToken) {
                updateResponseFieldValues();
                closeIFrame(parent, "Azure Service SAS token is successfully generated.");
            } else if(error) {
				var err = getErrorMessage(error, data['description']);
				errorMessageToggle(err, "show");
				$("html, body").animate({scrollTop : 0}, 200, 'swing');
            }
        },
        error: function(xhr, status) {
            var error = xhr['error'];
			if(error) {
				var err = getErrorMessage(error, "");
				errorMessageToggle(err, "show");
				$("html, body").animate({scrollTop : 0}, 200, 'swing');
            } else {
				errorMessageToggle(xhr.responseText, "show");
				$("html, body").animate({scrollTop : 0}, 200, 'swing');
			}
        }
    });
}

function updateResponseFieldValues() {
	setParentFormFieldValue(getElementFullName('azure.sasToken'), sasToken);
	
	for (const [key, value] of Object.entries(sasParametersMap)) {
		setParentFormFieldValue(getElementFullName(key), sasParametersMap[key]);
    }
	//clear other fields which were not required to generate sas token
	$.each($('form').serializeArray(), function(i, field) {
		var valueExists = false;
		for (const [key, value] of Object.entries(sasParametersMap)) {
			if (field['name'].endsWith(key)) {
				valueExists = true;
			}
		}
		if(!valueExists) {
			setParentFormFieldValue(field['name'], field['value']);
		}
	});
	
	for(let fieldName of customFields) {
		setParentFormFieldValue(getElementFullName(fieldName), customFieldsMap[fieldName]);
    }
}

// gets issuer and subject field values from connection page
function fetchParentTableFields() {
	for(let fieldName of sasParameters) {
		$("*[name$='" + fieldName + "']").val(getParentPageElementByName(getElementFullName(fieldName)).value);
		$("*[name$='" + fieldName + "']").trigger("change");
    }
	
	for(let fieldName of customFields) {
		$("*[name$='" + fieldName + "']").val(getParentPageElementByName(getElementFullName(fieldName)).value);
    }
}

function updateParametersValue() {
     // clear arrays
    missingFields = new Array();
    sasParametersMap = {};
	customFieldsMap = new Array();
	
    for (var i = 0; i < sasParameters.length; i++) {
		var ctrl = $("[name$='" + sasParameters[i] + "']");
		var key = sasParameters[i];
		var value = $(ctrl).val();
		if(ctrl.is('select')) {
			var multipleAttr = $(ctrl).attr('multiple');

			// For some browsers, `attr` is undefined; for others,
			// `attr` is false.  Check for both.
			if (typeof multipleAttr !== 'undefined' && multipleAttr !== false) {
				sasParametersMap[sasParameters[i]] = value; // required to restore in parent page
				if($.isArray(value)) { // convert to string if the value is of array type
					value = Array.from(value).join("");
				}
				key = sasParameters[i].substring(0, sasParameters[i].lastIndexOf('$'));
			}
		}
		
		if(!(value == "" || value == undefined || value == null)) {
			sasParametersMap[key] = value;
		}
		
		if(sasParameters[i] == "azure.accountName" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("input[name$='azure.accountName']")));
		}
		if(sasParameters[i] == "azure.accountKey" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("input[name$='azure.accountKey']")));
		}

		if(sasParameters[i] == "azure.useStoredAccessPolicy" && value == 'true') {
			if(isEmptyOrSpaces($("input[name$='META$azure.signedIdentifier']").val())) {
				missingFields.push(getDisplayName($("input[name$='azure.signedIdentifier']")));
			}
		} else if(sasParameters[i] == "azure.useStoredAccessPolicy" && value == 'false') {
			if(isEmptyOrSpaces($("input[name$='META$azure.signedExpiry']").val(), "signedExpiry")) {
				missingFields.push(getDisplayName($("input[name$='azure.signedExpiry']")));
			}
			if(isEmptyOrSpaces($("select[name$='META$azure.signedPermission$SelectMultiple']").val(), "signedPermission")) {
				missingFields.push(getDisplayName($("select[name$='META$azure.signedPermission$SelectMultiple']")));
			}
		}
		
		if($("select[name='META$azure.signedResource']").val() == 'b') {
			if(sasParameters[i] == "azure.blobName" && isEmptyOrSpaces(value, "blobName")) {
				missingFields.push(getDisplayName($("input[name$='azure.blobName']")));
			}
			if(sasParameters[i] == "azure.containerName" && isEmptyOrSpaces(value, "containerName")) {
				missingFields.push(getDisplayName($("input[name$='azure.containerName']")));
			}
		}
		if($("select[name='META$azure.signedResource']").val() == 'c') {
			if(sasParameters[i] == "azure.containerName" && isEmptyOrSpaces(value, "containerName")) {
				missingFields.push(getDisplayName($("input[name$='azure.containerName']")));
			}
		}
		if($("select[name='META$azure.signedResource']").val() == 'f') {
			if(sasParameters[i] == "azure.fileName" && isEmptyOrSpaces(value, "fileName")) {
				missingFields.push(getDisplayName($("input[name$='azure.fileName']")));
			}
		}
		if($("select[name='META$azure.signedResource']").val() == 'q') {
			if(sasParameters[i] == "azure.queueName" && isEmptyOrSpaces(value, "queueName")) {
				missingFields.push(getDisplayName($("input[name$='azure.queueName']")));
			}
		}
		if($("select[name='META$azure.signedResource']").val() == 's') {
			if(sasParameters[i] == "azure.shareName" && isEmptyOrSpaces(value, "shareName")) {
				missingFields.push(getDisplayName($("input[name$='azure.shareName']")));
			}
		}
		if($("select[name='META$azure.signedResource']").val() == 't') {
			if(sasParameters[i] == "azure.tableName" && isEmptyOrSpaces(value, "tableName")) {
				missingFields.push(getDisplayName($("input[name$='azure.tableName']")));
			}
			
			if(sasParameters[i] == "azure.startPk" && !isEmptyOrSpaces(value)) {
				if(isEmptyOrSpaces($("input[name='META$azure.startRk']").val(), "startRk")) {
					missingFields.push(getDisplayName($("input[name$='azure.startRk']")));
				}
			}
			if(sasParameters[i] == "azure.startRk" && !isEmptyOrSpaces(value)) {
				if(isEmptyOrSpaces($("input[name='META$azure.startPk']").val(), "startPk")) {
					missingFields.push(getDisplayName($("input[name$='azure.startPk']")));
				}
			}
			if(sasParameters[i] == "azure.endPk" && !isEmptyOrSpaces(value)) {
				if(isEmptyOrSpaces($("input[name='META$azure.endRk']").val(), "endRk")) {
					missingFields.push(getDisplayName($("input[name$='azure.endRk']")));
				}
			}
			if(sasParameters[i] == "azure.endRk" && !isEmptyOrSpaces(value)) {
				if(isEmptyOrSpaces($("input[name='META$azure.endPk']").val(), "endPk")) {
					missingFields.push(getDisplayName($("input[name$='azure.endPk']")));
				}
			}
		}
    }
	
    for (var i = 0; i < customFields.length; i++) {
        var value = $("[name$='" + customFields[i] + "']").val();
        customFieldsMap[customFields[i]] = value;
    }
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

/**
	toggle signedStart, signedExpiry & signedPermission fields 
*/
function toggleSAPComponents(usingStoredAccessPolicy) {
	if(usingStoredAccessPolicy) {
		$("input[name$='azure.signedStart']").closest('tr').hide();
		$("input[name$='azure.signedStart']").val('');
		$("input[name$='azure.signedExpiry']").closest('tr').hide();
		$("input[name$='azure.signedExpiry']").val('');
		$("select[name$='azure.signedPermission$SelectMultiple']").closest('tr').hide();
		$("select[name$='azure.signedPermission$SelectMultiple']").val("");
		$("input[name$='azure.signedIdentifier']").closest('tr').show();
	} else {
		$("input[name$='azure.signedStart']").closest('tr').show();
		$("input[name$='azure.signedExpiry']").closest('tr').show();
		$("select[name$='azure.signedPermission$SelectMultiple']").closest('tr').show();
		$("input[name$='azure.signedIdentifier']").closest('tr').hide();
		$("input[name$='azure.signedIdentifier']").val('');
	}
}

function toggleSignedResourceComponents(signedResource) {
	if(signedResource == 'b') {
		show('b');
		hide('d');
		hide('q');
		hide('t');
		hide('f');
		hide('s');
		showResponseHeaders();
	} else if(signedResource == 'c') {
		hide('b');
		show('c');
		hide('d');
		hide('q');
		hide('t');
		hide('f');
		hide('s');
		showResponseHeaders();
	} else if(signedResource == 'd') {
		hide('b');
		hide('c');
		show('d');
		hide('q');
		hide('t');
		hide('f');
		hide('s');
	} else if(signedResource == 'q') {
		hide('b');
		hide('c');
		hide('d');
		show('q');
		hide('t');
		hide('f');
		hide('s');
		hideResponseHeaders();
	}  else if(signedResource == 't') {
		hide('b');
		hide('c');
		hide('d');
		hide('q');
		show('t');
		hide('f');
		hide('s');
		hideResponseHeaders();
	} else if(signedResource == 'f') {
		hide('b');
		hide('c');
		hide('d');
		hide('q');
		hide('t');
		show('f');
		hide('s');
		showResponseHeaders();
	} else if(signedResource == 's') {
		hide('b');
		hide('c');
		hide('d');
		hide('q');
		hide('t');
		hide('f');
		show('s');
		showResponseHeaders();
	}
}

function show(resourceName) {
	switch(resourceName) {
		case 'b':
			$("input[name$='azure.blobName']").closest('tr').show();
			$("input[name$='azure.containerName']").closest('tr').show();
			$("input[name$='azure.signedEncryptionScope']").closest('tr').show();
			break;
		case 'c': 
			$("input[name$='azure.containerName']").closest('tr').show();
			$("input[name$='azure.signedEncryptionScope']").closest('tr').show();
			break;
		case 'd': 
			$("input[name$='azure.signedDirectoryDepth']").closest('tr').show();
			break;
		case 'q': 
			$("input[name$='azure.queueName']").closest('tr').show();
			break;
		case 'f': 
			$("input[name$='azure.fileName']").closest('tr').show();
			$("input[name$='azure.signedEncryptionScope']").closest('tr').show();
			break;
		case 's': 
			$("input[name$='azure.shareName']").closest('tr').show();
			break;
		case 't':
			$("input[name$='azure.tableName']").closest('tr').show();
			$("input[name$='azure.startPk']").closest('tr').show();
			$("input[name$='azure.startRk']").closest('tr').show();
			$("input[name$='azure.endPk']").closest('tr').show();
			$("input[name$='azure.endRk']").closest('tr').show();
		
			break;
	}
}

function hide(resourceName) {
	switch(resourceName) {
		case 'b':
			$("input[name$='META$azure.blobName']").val("");
			$("input[name$='azure.blobName']").closest('tr').hide();
			$("input[name$='azure.signedEncryptionScope']").val("");
			$("input[name$='azure.signedEncryptionScope']").closest('tr').hide();
			break;
		case 'c':
			$("input[name$='azure.containerName']").val('');
			$("input[name$='azure.containerName']").closest('tr').hide();
			$("input[name$='azure.signedEncryptionScope']").val("");
			$("input[name$='azure.signedEncryptionScope']").closest('tr').hide();
			break;
		case 'd':
			$("input[name$='azure.signedDirectoryDepth']").val('');
			$("input[name$='azure.signedDirectoryDepth']").closest('tr').hide();
			break;
		case 'q':
			$("input[name$='azure.queueName']").val('');
			$("input[name$='azure.queueName']").closest('tr').hide();
			break;
		case 'f':
			$("input[name$='azure.fileName']").val('');
			$("input[name$='azure.fileName']").closest('tr').hide();
			break;
		case 's':
			$("input[name$='azure.shareName']").val('');
			$("input[name$='azure.shareName']").closest('tr').hide();
			break;
		case 't':
			$("input[name$='azure.tableName']").val('');
			$("input[name$='azure.tableName']").closest('tr').hide();
			$("input[name$='azure.startPk']").val('');
			$("input[name$='azure.startPk']").closest('tr').hide();
			$("input[name$='azure.startRk']").val('');
			$("input[name$='azure.startRk']").closest('tr').hide();
			$("input[name$='azure.endPk']").val('');
			$("input[name$='azure.endPk']").closest('tr').hide();
			$("input[name$='azure.endRk']").val('');
			$("input[name$='azure.endRk']").closest('tr').hide();
			break;
	}
}
function showResponseHeaders() {
	$("input[name$='azure.responseContentDisposition']").closest('tr').show();
	$("input[name$='azure.responseContentType']").closest('tr').show();
	$("input[name$='azure.responseContentEncoding']").closest('tr').show();
	$("input[name$='azure.responseContentLanguage']").closest('tr').show();
	$("input[name$='azure.responseCacheControl']").closest('tr').show();
}
function hideResponseHeaders() {
	$("input[name$='azure.responseContentDisposition']").val('');
	$("input[name$='azure.responseContentDisposition']").closest('tr').hide();
	$("input[name$='azure.responseContentType']").val('');
	$("input[name$='azure.responseContentType']").closest('tr').hide();
	$("input[name$='azure.responseContentEncoding']").val('');
	$("input[name$='azure.responseContentEncoding']").closest('tr').hide();
	$("input[name$='azure.responseContentLanguage']").val('');
	$("input[name$='azure.responseContentLanguage']").closest('tr').hide();
	$("input[name$='azure.responseCacheControl']").val('');
	$("input[name$='azure.responseCacheControl']").closest('tr').hide();
}
