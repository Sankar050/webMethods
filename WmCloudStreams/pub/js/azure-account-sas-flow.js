/*
 * Copyright (c) 2022 Software AG, Darmstadt, Germany and/or Software AG USA Inc., Reston, VA, USA, and/or its subsidiaries and/or its affiliates and/or their licensors.
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
	setCSSForMultiSelect();
	fetchParentTableFields();
    resizeFrame();
	errorMessageToggle("", "hide");

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

// function which builds the table form with meta fields from Azure Account SAS connection group
function buildTableContent() {
	var finalTableRows = getErrorRowTR(); // add error row
	var tableRows = "";
	
    finalTableRows += "<tr><td class=heading colspan=2>" + getmsg("azure.account.sas.parameters") + "</td></tr>";
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
        } else if (elementName.startsWith("cx.")) {
            customFields.push(elementName.replace("META$", ""));
        }

        // add only if meta field user input is required
        if ($(element).attr('type') == 'hidden') {
            tableRows += '<tr style="display: none;">' + elements[i].innerHTML + '</tr>';
        
		} else if (elementName.startsWith("cx.")) {
			tableRows += '<tr>' + elements[i].innerHTML + '</tr>';
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
	
	tableRef.innerHTML =  tableRows; 
	
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
        url: '/invoke/cloudstreams.azure.sas:azureAccountSAS',
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
                closeIFrame(parent, "Azure Account SAS token is successfully generated.");
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

	for(let fieldName of customFields) {
		setParentFormFieldValue(getElementFullName(fieldName), customFieldsMap[fieldName]);
    }
}

// gets issuer and subject field values from connection page
function fetchParentTableFields() {
	for(let fieldName of sasParameters) {
		var parentElement = getParentPageElementByName(getElementFullName(fieldName));
		var value = $(parentElement).val();
		$("*[name$='" + fieldName + "']").val(value);
    }
	
	for(let fieldName of customFields) {
		$("*[name$='" + fieldName + "']").val(getParentPageElementByName(getElementFullName(fieldName)).value);
    }
}

function updateParametersValue() {
     // clear arrays
    missingFields = new Array();
    sasParametersMap = {};
	customFieldsMap = {};
	
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
		if(sasParameters[i] == "azure.signedExpiry" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("input[name$='azure.signedExpiry']")));
		}
		if(sasParameters[i] == "azure.signedPermission$SelectMultiple" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("select[name$='META$azure.signedPermission$SelectMultiple']")));
		}
		if(sasParameters[i] == "azure.signedServices$SelectMultiple" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("select[name$='META$azure.signedServices$SelectMultiple']")));
		}
		if(sasParameters[i] == "azure.signedResourceTypes$SelectMultiple" && isEmptyOrSpaces(value)) {
			missingFields.push(getDisplayName($("select[name$='META$azure.signedResourceTypes$SelectMultiple']")));
		}
		sasParametersMap[sasParameters[i]] = value;
    }
	
    for (var i = 0; i < customFields.length; i++) {
        var value = $("[name$='" + customFields[i] + "']").val();
        customFieldsMap[customFields[i]] =  value;
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
