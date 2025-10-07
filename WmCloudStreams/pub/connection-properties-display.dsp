<!-- this javascript handles connection field dropdown closing/hiding -->
<script type="text/javascript">

	$(".dropbtn").click(function(e) {
		e.preventDefault();
	});

	// Close the dropdown if the user clicks outside of it
	$(document).click(function(e) {
		var dropbtn = $(event.target).is("input.dropbtn");
		if (!dropbtn && isDropdownVisible()) {
			clearDropdown();
		}
	});
	
</script>

%comment%----- Displays connection type parameters -----%endcomment%
%ifvar connectionGroupProperties%
    <script>resetRows();</script>

    %loop connectionGroupProperties%
		%ifvar hasBasicField equals('true')% %comment%----- new code: check if this group has any field of modelType as Basic -----%endcomment%
			<tr>
				<td class="heading" colspan=2>Connection Groups: %value groupDisplayName%
					<span style="float: right; margin-right: 10px;">
						<input id="groupType" name="groupType" type="hidden" value="%value groupType%" />
						<script type="text/javascript" src="../WmRoot/webMethods.js"></script>
						<link rel="stylesheet" type="text/css" href="../WmRoot/subUserLookup.css" />
						<script type="text/javascript" src="js/modal.js"></script>
						<script type="text/javascript" src="js/jquery-min.js"></script>
						%ifvar groupType equals('azure_account_sas')%
							<a class="submodal" style="color: #fff;" href="/WmCloudStreams/azure-account-sas-flow">Generate SAS Token</a>
						%endif%
						%ifvar groupType equals('azure_service_sas')%
							<a class="submodal" style="color: #fff;" href="/WmCloudStreams/azure-service-sas-flow">Generate SAS Token</a>
						%endif%
						%ifvar groupType equals('oauth_v20_authorization_code')%
							<a class="submodal" style="color: #fff;" href="/WmCloudStreams/oauth-authorization-code-flow">Generate Access Token</a>
						%endif% 
						%ifvar groupType equals('oauth_v20_jwt')%
							<a class="submodal" style="color: #fff;" href="/WmCloudStreams/oauth-jwt-flow">Generate Access Token</a>
						%endif% 
						%ifvar groupType equals('oauth_v20_jwt_client_assertion')%
							<a class="submodal" style="color: #fff;" href="/WmCloudStreams/oauth-jwt-assertion-flow">Generate Access Token</a>
						%endif%
						%ifvar groupType equals('oauth_v21')%
                            <a class="submodal" style="color: #fff;" href="/WmCloudStreams/oauth-v21-generate-access-token">Generate Access Token</a>
                        %endif%
					</span>
				</td>
			</tr>
		%else%  %comment%----- new code: check if this group has no Basic modelType field -----%endcomment%
			<tr class="HIDDENGROUP" style="display:none">
				<td class="heading" colspan=2>Connection Groups: %value groupDisplayName%</td>
			</tr>					
		%endif%
		
		%loop fields%
			<!-- inside hidden meta fields -->
			%ifvar isHidden equals('true')%
				%ifvar modelType equals('Meta')%
					<script>
						console.log("inside isHidden");
						console.log("%value propertyKey%");
					</script>
					<tr style="display:none" class="meta" >	
						<td class="oddrow">%value displayName%</td>
						<td>
							<input id=input class="meta-field" name="META$%value propertyKey%" value="%value propertyValue%" 
										size=60 type="hidden" /> 
						</td>
					</tr>
				%endif%	
			%endif%	
			   
			%ifvar isHidden equals('false')%
			    %ifvar schemaType equals('int')%
				     <script>populateValidationFields("CPROP$%value ../groupType%$%value modelType%$%value propertyKey%")</script>
				%endif%
				%ifvar isRequired equals('true')%
					<script>
					//TODO: check why multi select attribute is not coming for custom fields
						if("%value modelType%" === "Meta") {
							populateRequiredMetaFields("META$%value propertyKey%");
						} else if("%value modelType%" === "Basic" || "%value modelType%" === "Advanced") {
							populateRequiredFields("CPROP$%value ../groupType%$%value modelType%$%value propertyKey%")
						}
					</script>
				%endif%
				
					<script>
						if("%value propertyKey%".endsWith("jwt.client.assertion.grant_type")) {
							toggleOAuthRefreshControls("%value defaultValue%");
						}
					</script>
			%ifvar modelType equals('Basic')%
				<tr>
					%ifvar isRequired equals('true')%
						<script>writeTD('row');</script>%value displayName%*</td>
					%else%
						<script>writeTD('row');</script>%value displayName%</td>
					%endif%
					
					<script>writeTD('rowdata-l'); swapRows();</script>
					
					%ifvar isEncrypted equals('true')%
						<input id=input size=60 
							   type=password
							   name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%"
							   value="%value defaultValue%" onchange="passwordChanged(this.form, '%value propertyKey%')"></input></td></tr>
		
					%else%
						%ifvar allowedValues% 
		                        <select id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%">
                                %loop allowedValues%
									%ifvar propertyValue -notempty%
										<option %ifvar allowedValues vequals(propertyValue)% selected %endif%>%value allowedValues%</option>
									%else%
										<option %ifvar allowedValues vequals(defaultValue)% selected %endif%>%value allowedValues%</option>
									%endif%
	                            %endloop%
		                        </select>
							%else%

								%ifvar schemaType equals('boolean')%
									<select id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" 
										%ifvar propertyKey equals('oauth_v20.refreshAccessToken')% class="refreshAccessToken" onChange="handleRefreshTokenChange(this.form);"%endif%>
										  <option value="true"  %ifvar propertyValue equals('true')% selected="true" %endif%>true</option>
										  <option value="false" %ifvar propertyValue equals('false')% selected="true" %endif%>false</option>
									</select>
								%else%
									%ifvar propertyValue -notempty%
										<input id=input size=60 name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" 
												value="%value propertyValue%" %ifvar schemaType equals('int')% pattern="^[-+]?[0-9]*[.,]?[0-9]+$" %endif%>
										</input>
									%else%
										<input id=input size=60 name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" 
											value="%value defaultValue%" %ifvar schemaType equals('int')% pattern="^[-+]?[0-9]*[.,]?[0-9]+$" %endif%>
										</input>
									%endif%
									%ifvar lookupService -notempty%
										<input type="button" class="dropbtn" onclick="lookupFunction(this, 'CPROP$%value ../groupType%$%value modelType%$%value propertyKey%', '%value lookupService%', form)" value="Load" />
									%endif%
								%endif%
								
							%endif%
						</td>
					%endif%
				</tr>
			%else%
				%ifvar modelType equals('Advanced')% <!-- if modelType is not Basic -->
				<tr style="display:none">
					%ifvar isRequired equals('true')%
						<script>writeTD('row');</script>%value displayName%*</td>
					%else%
						<script>writeTD('row');</script>%value displayName%</td>
					%endif%
					
					<td>
					%ifvar isEncrypted equals('true')%
								<input id=input
									   size=60
									   type=password
									   name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%"
                                       value="%value defaultValue%" onchange="passwordChanged(this.form, '%value propertyKey%')">
								</input>
								
		
					%else%
					%ifvar allowedValues%
						<select id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" >
							%ifvar propertyValue -notempty%
								%loop allowedValues%
									%ifvar name -notempty%
										<option %ifvar name -notempty% value="%value name%" %endif% %ifvar allowedValues vequals(propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
										<script type="text/javascript">
											$("select[name='CPROP$%value ../groupType%$%value modelType%$%value propertyKey%']").attr("multiple", "multiple");
										</script>
									%else% 
										<option %ifvar allowedValues vequals(propertyValue)% selected %endif%>%value allowedValues%</option>
									%endif%
								%endloop%
							%else%
								%loop allowedValues%
									%ifvar name -notempty%
										<option %ifvar name -notempty% value="%value name%" %endif% %ifvar allowedValues vequals(propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
										<script type="text/javascript">
											$("select[name='CPROP$%value ../groupType%$%value modelType%$%value propertyKey%']").attr("multiple", "multiple");
										</script>
									%else%
										<option %ifvar allowedValues vequals(defaultValue)% selected %endif%>%value allowedValues%</option>
									%endif%
								%endloop%
							%endif%
						</select>
					%else%
					%ifvar dynamicValues% 
						%ifvar isMultiSelect equals('true')%
							<select id=input class="meta-field" name="META$%value propertyKey%$SelectMultiple" multiple="multiple">
						%else%
							<select id=input class="meta-field" name="META$%value propertyKey%">
						%endif%
								
						%loop dynamicValues%
							<option value="%value name%" %ifvar name vequals(../propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
						%endloop%
						</select>
						%ifvar isMultiSelect equals('true')%
							<input name="META$%value propertyKey%" type=hidden value="%value propertyValue%" />
						%endif%
					%else%
						%ifvar schemaType equals('boolean')%
							  <select id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" %ifvar propertyKey equals('oauth_v20.refreshAccessToken')% class="refreshAccessToken" onChange="handleRefreshTokenChange(this.form);"%endif%>
								  <option value="true"  %ifvar propertyValue equals('true')% selected="true" %endif%>true</option>
								  <option value="false" %ifvar propertyValue equals('false')% selected="true" %endif%>false</option>
							  </select>
							%else%						       	
								%ifvar propertyValue -notempty%
									<input id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" 
										value="%value propertyValue%" size=60 %ifvar schemaType equals('int')% pattern="^[-+]?[0-9]*[.,]?[0-9]+$" %endif%> 
									</input>
								%else%
									<input id=input name="CPROP$%value ../groupType%$%value modelType%$%value propertyKey%" 
										value="%value defaultValue%" size=60 %ifvar schemaType equals('int')% pattern="^[-+]?[0-9]*[.,]?[0-9]+$" %endif%> 
									</input>
								%endif%
								
								%ifvar lookupService -notempty%
									<input type="button" class="dropbtn" onclick="lookupFunction(this, 'CPROP$%value ../groupType%$%value modelType%$%value propertyKey%', '%value lookupService%', form)" value="Load" />
								%endif%
							%endif%
						%endif%
					%endif%
								
					</td>
				</tr>	
				%endif%	
			%else% <!-- if modelType is meta -->
				%ifvar modelType equals('Meta')%
				<tr style="display:none" class="%value propertyKey% meta">	
					%ifvar isRequired equals('true')%
						<td class="oddrow">%value displayName%*</td>
					%else%
						<td class="oddrow">%value displayName%</td>
					%endif%
					<td>
					%ifvar isEncrypted equals('true')%
								<input class="meta-field" id=input size=60 type=password name="META$%value propertyKey%"
									   value="" onchange="passwordChanged(this.form, '%value propertyKey%')" />
						%else%
						%ifvar dynamicValues% 
							%ifvar isMultiSelect equals('true')%
								<select id=input class="meta-field" name="META$%value propertyKey%$SelectMultiple" multiple="multiple">
							%else%
								<select id=input class="meta-field" name="META$%value propertyKey%">
							%endif%
							
								%loop dynamicValues%
									<option value="%value name%" %ifvar name vequals(../propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
								%endloop%
							</select>
							%ifvar isMultiSelect equals('true')%
								<input name="META$%value propertyKey%" type=hidden value="%value propertyValue%" />
							%endif%							
						%else%
						%ifvar allowedValues% 
							<select id=input class="meta-field" name="META$%value propertyKey%" %ifvar isMultiSelect equals('true')% multiple="multiple" %endif%>
								%ifvar propertyValue -notempty%
								%loop allowedValues%
									%ifvar name -notempty%
										<option %ifvar name -notempty% value="%value name%" %endif% %ifvar name vequals(propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
									%else%
										<option %ifvar allowedValues vequals(defaultValue)% selected %endif%>%value allowedValues%</option>
									%endif%
								%endloop%
							%else%
								%loop allowedValues%
									%ifvar name -notempty%
										<option %ifvar name -notempty% value="%value name%" %endif% %ifvar allowedValues vequals(propertyValue)% selected %endif%>%ifvar displayName -notempty% %value displayName% %else% %value name% %endif%</option>
									%else%
										<option %ifvar allowedValues vequals(defaultValue)% selected %endif%>%value allowedValues%</option>
									%endif%
								%endloop%
							%endif%
							</select>
							%else%
								%ifvar schemaType equals('boolean')%
									<select id=input class="meta-field" name="META$%value propertyKey%">
										<option value="true"  %ifvar propertyValue equals('true')% selected="true" %endif%>true</option>
										<option value="false" %ifvar propertyValue equals('false')% selected="true" %endif%>false</option>
									</select>
								%else%
								%ifvar lookupService -notempty%
									<script>
										if("%value propertyKey%".endsWith("x5t")) {
											document.write('<input id=input class="meta-field" name="META$%value propertyKey%" size=60 /><input type="file" id="certFile" name="certFile" onchange="calculateX5T()" accept=".crt, .cer, .ca-bundle, .p7b, .p7c, .p7s, .pem" />');
										} else {
											document.write('<input id=input class="meta-field" name="META$%value propertyKey%" value="%value propertyValue%" size=60 /><input type="button" class="dropbtn" onclick="lookupFunction(this, \'CPROP$%value ../groupType%$%value modelType%$%value propertyKey%\', \'%value lookupService%\', form)" value="Load" />');
										}
									</script>
								%else%
									<input id=input class="meta-field" name="META$%value propertyKey%" value="%value propertyValue%" size=60 /> 
								%endif%
						%endif%
					</td>
				</tr>
				%endif%
			%endif%
		%endloop%
	%endloop%
%endif%
