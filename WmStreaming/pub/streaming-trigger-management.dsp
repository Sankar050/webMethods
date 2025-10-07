<html>

  <head>
    <meta http-equiv="Pragma" content="no-cache">
    <meta http-equiv='Content-Type' content='text/html; charset=UTF-8'>
    <meta http-equiv="Expires" content="-1">
    <link rel="stylesheet" type="text/css" href="../WmRoot/webMethods.css">
    %ifvar webMethods-wM-AdminUI%
      <link rel="stylesheet" TYPE="text/css" HREF="../WmRoot/webMethods-wM-AdminUI.css"></link>
      <script>webMethods_wM_AdminUI = 'true';</script>
    %endif%  
    <script src="../WmRoot/webMethods.js"></script>
  
    <script language ="javascript">
  
      /**
       *
       */
      function loadDocument() {
      
        setNavigation('settings-streaming.dsp', 'doc/OnlineHelp/wwhelp.htm?context=is_help&topic=IS_Settings_Messaging_StreamingTriggerMgmtScrn');
      }
     
      /**
       *
       */     
      function refreshDSP() { 
  
        if(is_csrf_guard_enabled && needToInsertToken) {
          var appendStrAmp = '';
          var appendStrQue = '';
          if(is_csrf_guard_enabled && needToInsertToken) {
            appendStrAmp = "&"+_csrfTokenNm_+"="+_csrfTokenVal_ 
            appendStrQue = "?"+_csrfTokenNm_+"="+_csrfTokenVal_ 
          }
          createForm("htmlform_settings_streaming_trigger_management", "streaming-trigger-management.dsp", "POST", "BODY");
  	      setFormProperty("htmlform_settings_streaming_trigger_management", _csrfTokenNm_, _csrfTokenVal_);
          window.location = "javascript:document.htmlform_settings_streaming_trigger_management.submit();";
        }else {
          var appendStrAmp = '';
          var appendStrQue = '';
          if(is_csrf_guard_enabled && needToInsertToken) {
            appendStrAmp = "&"+_csrfTokenNm_+"="+_csrfTokenVal_ 
            appendStrQue = "?"+_csrfTokenNm_+"="+_csrfTokenVal_ 
          }
          %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
          var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
		  if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
		    window.location = "streaming-trigger-management.dsp?webMethods-wM-AdminUI=true";
		  }
		  else {
		    window.location = "streaming-trigger-management.dsp";
		  }
        }
      } 
	  
	  /**
       * showHideConsumers
       */ 
      function showHideConsumers(id, obj) {
	  
	    if (obj.getAttribute("src") == "images/collapsed_blue.gif"){
          obj.src = "images/expanded_blue.gif";
        } else {
          obj.src = "images/collapsed_blue.gif";
        }
		
		var row = document.getElementById(id);
		if (row.style.display == 'none') {
		  row.style.display = '';
		}else {
		  row.style.display = 'none';
		}
      }
	  
    </script>
  </head>
  
  <body onLoad="loadDocument();">
    <table width="100%">
      <tr>
        <td class="breadcrumb" colspan="2">Settings &gt; Messaging &gt; Event Processing &gt; Trigger Management</td>
      </tr>
  
      <!-- Enable/Disable Logic -->
                   
      %switch action%
        <!-- Stop/Suspend/Enable Trigger Logic -->     
        %case 'suspendTrigger'%
          %invoke wm.server.streaming:suspendTriggers%
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td class="message" colspan=2>%value message encode(html)%</td>
            </tr>
          %onerror%
            <tr>
              <td class="message" colspan=2>%value errorMessage encode(html)%</td>
            </tr>
          %endinvoke%  
          %rename triggerName editedTriggerName%
      
        %case 'enableTrigger'%
          %invoke wm.server.streaming:enableTriggers%
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td class="message" colspan=2>%value message encode(html)%</td>
            </tr>
          %onerror%
            <tr>
              <td class="message" colspan=2>%value errorMessage encode(html)%</td>
            </tr>
          %endinvoke%
          %rename triggerName editedTriggerName%
        
        %case 'disableTrigger'%  
          %invoke wm.server.streaming:disableTriggers%
            <tr>
              <td colspan="2">&nbsp;</td>
            </tr>
            <tr>
              <td class="message" colspan=2>%value message encode(html)%</td>
            </tr>
          %onerror%
            <tr>
              <td class="message" colspan=2>%value errorMessage encode(html)%</td>
            </tr>
          %endinvoke%
          %rename triggerName editedTriggerName%
        %case 'filter'% 
      %end%
      
      %invoke wm.server.streaming:getTriggerReport%  

        <!-- Navigation Menu -->
        <tr>
          <td colspan="2">
		    <script>
			  createForm("htmlform_settings_streaming_create", "streaming-create.dsp", "POST", "BODY");
			  createForm("htmlform_settings_streaming", "streaming.dsp", "POST", "BODY");
			  createForm("htmlform_settings_streaming_runtime", "streaming-trigger-management.dsp?perspective=runtime", "POST", "BODY");
			  createForm("htmlform_settings_streaming_trigger", "streaming-trigger-management.dsp", "POST", "BODY");
		      createForm("htmlform_settings_streaming_subjects", "settings-streaming-subjects.dsp", "POST", "BODY");
		    </script>
		    %ifvar webMethods-wM-AdminUI% 
			 %ifvar /perspective equals('runtime')%
			    <ul class="listitems"> 
		          <li class="listitem"><script>getURL("streaming-trigger-management.dsp","javascript:document.htmlform_settings_streaming_trigger.submit();", "Standard Perspective");</script></li>
                </ul>	
                <ul class="listitems">
				  <li class="listitem"><script>getURL("streaming-trigger-management.dsp?perspective=runtime", "javascript:document.htmlform_settings_streaming_runtime.submit();","Refresh Page")</script></li>
		        </ul>	
              %else%
			    <ul class="listitems"> 
		          <li class="listitem"><script>getURL("streaming-trigger-management.dsp?perspective=runtime","javascript:document.htmlform_settings_streaming_runtime.submit();", "Runtime Perspective");</script></li>
                </ul>	
                <ul class="listitems"> 
				  <li class="listitem"><script>getURL("streaming-trigger-management.dsp", "javascript:document.htmlform_settings_streaming_trigger.submit();","Refresh Page")</script></li>  
		        </ul>
              %endif%			
			  
            %else%
			  %ifvar /perspective equals('runtime')%
			    <ul class="listitems"> 
                  <li class="listitem">
		            <script>getURL("streaming.dsp","javascript:document.htmlform_settings_streaming.submit();","View Connection Alias Settings")</script>
		          </li>
		          <li class="listitem">
		            <script>getURL("streaming-trigger-management.dsp?perspective=runtime", "javascript:document.htmlform_settings_streaming_runtime.submit();","View Trigger Management (Refresh Page)")</script>
		          </li>
		          <li class="listitem">
		            <script>getURL("streaming-subjects.dsp","javascript:document.htmlform_settings_streaming_subjects.submit();","View Event Specifications")</script>
		          </li>    
                </ul>	
                <ul class="listitems"> 
		          <li class="listitem"><script>getURL("streaming-trigger-management.dsp","javascript:document.htmlform_settings_streaming_trigger.submit();", "Standard Perspective");</script></li>
		        </ul>	
              %else%
			    <ul class="listitems"> 
                  <li class="listitem">
		            <script>getURL("streaming.dsp","javascript:document.htmlform_settings_streaming.submit();","View Connection Alias Settings")</script>
		          </li>
		          <li class="listitem">
		            <script>getURL("streaming-trigger-management.dsp","javascript:document.htmlform_settings_streaming_trigger.submit();","View Trigger Management (Refresh Page)")</script>
		          </li>
		          <li class="listitem">
		            <script>getURL("streaming-subjects.dsp","javascript:document.htmlform_settings_streaming_subjects.submit();","View Event Specifications")</script>
		          </li>    
                </ul>	
                <ul class="listitems"> 
		          <li class="listitem"><script>getURL("streaming-trigger-management.dsp?perspective=runtime", "javascript:document.htmlform_settings_streaming_runtime.submit();", "Runtime Perspective");</script></li>
		        </ul>
              %endif%			
			%endif%
          </td>
        </tr>
        <tr>
          <td>
            <!-- Streaming Trigger Controls for Runtime -->
			%ifvar /perspective equals('runtime')%
			
              <table width="100%" class="tableView">  
                <tr>
                  <td class="heading" colspan=17>
                    &nbsp;Trigger Controls > Runtime Perspective
                  </td>
                </tr>
			    <tr>
                  <th class="subheading" width="14%">Name</td>
				  <th class="subheading" nowrap width="8%">State</td>
                  <th class="subheading" width="8%">Last Trigger Status&nbsp;Change</th>
				  <th class="subheading" width="14%">Connection Alias</th>
                  <th class="subheading" width="3%">Consumer ID</th> 
				  <th class="subheading" width="14%">Topic Partition</th>
				  <th class="subheading" width="8%">Consumer Status</th>	
				  <th class="subheading" width="8%">Last Consumer Status Change</th>	
                  <th class="subheading" width="3%">Received</th>
				  <th class="subheading" width="3%">Pre-processing</th>
				  <th class="subheading" width="3%">Buffered</th>
				  <th class="subheading" width="3%">Filtered</th>
				  <th class="subheading" width="3%">Error</th>
				  <th class="subheading" width="3%">Dropped</th>
				  <th class="subheading" width="3%">Processing</th>
				  <th class="subheading" width="3%">Processed</th>
				  <th class="subheading" width="8%">Last Received</th>
				  
			<!-- Streaming Trigger Controls for Standard -->	
            %else%
			  <table width="100%" class="tableView">  
                <tr>
                  <td class="heading" colspan=9>
                    &nbsp;Trigger Controls
                  </td>
                </tr>
			    <tr>
                  <th class="subheading" width="15%">Name</td>
				  <th class="subheading" nowrap width="10%">
                    State
                    %ifvar webMethods-wM-AdminUI%
                      <a href="streaming-edit-state.dsp?triggerName=all&webMethods-wM-AdminUI=true" >
                        edit&nbsp;all
                      </a>
                    %else%
                      <a href="streaming-edit-state.dsp?triggerName=all" > 
                        edit&nbsp;all
                      </a>
                    %endif%
                  </td>
                  <th class="subheading" width="10%">Trigger Status</th>
				  <th class="subheading" width="15%">Last Trigger Status&nbsp;Change</th>
			      <th class="subheading" width="15%">Connection Alias</th>
                  <th class="subheading" width="15%">Event Specification</th>
                  <th class="subheading" width="10%">Consumers Min(Max)</th>
                  <th class="subHeading" width="10%">Consumers Running</th>
			%endif%
			    </tr> 

              <!-- For Each Trigger -->
              %loop triggerDataList%
                <tr>
                  
				  <!-- trigger name -->
                  <script>
	  		        createForm("htmlform_settings_streaming_detail_%value $index%", "streaming-trigger-detail.dsp", "POST", "BODY");
  		      	    setFormProperty("htmlform_settings_streaming_detail_%value $index%", "name", "%value node_nsName encode(url)%");
  	      		  </script> 
                  <td>
                    <script>
		                  if(is_csrf_guard_enabled && needToInsertToken) {
		  	                document.write('<a href="javascript:document.htmlform_settings_streaming_detail_%value $index%.submit();"  >%value node_nsName encode(html)%</a>');
		                  } else {
		                  	%rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		                    var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
							if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
								document.write('<a href="streaming-trigger-detail.dsp?triggerName=%value node_nsName encode(url)%&webMethods-wM-AdminUI=true">%value node_nsName encode(html)%</a>');
							}
							else {
								document.write('<a href="streaming-trigger-detail.dsp?triggerName=%value node_nsName encode(url)%">%value node_nsName encode(html)%</a>');
							}
		                  }
                    </script>
                  </td>  
                  
				  <!-- state -->                
                  <td nowrap>
                    %ifvar trigger/triggerRuntimeData/connected equals('true')%
                      <img style="width: 13px; height: 13px;" alt="active" border="0" src="../WmRoot/images/green_check.png">
                    %else%
                      <img style="width: 13px; height: 13px;" alt="inactive" border="0" src="../WmRoot/images/yellow_check.png">
                    %endif%            
                    %switch trigger/triggerRuntimeData/state%      
                      %case 'ENABLED'%   
                        <script>
                          %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
						  var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
						  if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%%ifvar trigger/triggerRuntimeData/connected equals('false')%*%endif%&webMethods-wM-AdminUI=true"> ');
						  }
						  else {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%%ifvar trigger/triggerRuntimeData/connected equals('false')%*%endif%"> ');
						  }
                          document.write('%value trigger/triggerRuntimeData/state_display encode(html)%');
                          document.write('</a>');    
                        </script>  
                      %case 'SUSPENDED'%
                        <script>
                          %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
                          var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
						  if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%&webMethods-wM-AdminUI=true"> ');
						  }
						  else {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%"> ');
						  }
                          document.write('%value trigger/triggerRuntimeData/state_display encode(html)%');
                          document.write('</a>');
                        </script>
                      %case%                      
                        <script>
                          %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
                          var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
						  if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%') {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%&webMethods-wM-AdminUI=true"> ');
						  }
						  else {
							  document.write('<a href="streaming-edit-state.dsp?triggerName=%value node_nsName encode(url)%&startingState=%value trigger/triggerRuntimeData/state encode(url)%"> ');
						  }
                          document.write('%value trigger/triggerRuntimeData/state_display encode(html)%');
                          document.write('</a>');
                        </script>
                    %end%
                  </td> 
				  
                  <!-- status (only for standard perspective) -->
				  %ifvar /perspective equals('runtime')%
				  %else%
				    %ifvar trigger/triggerRuntimeData/lastError_display%  
                      <td nowrap="true">
                        <font color=red>%value trigger/triggerRuntimeData/combinedStatus%</font>
                      </td> 
                    %else%
                      <td nowrap="true">
                        %value trigger/triggerRuntimeData/combinedStatus%
                      </td>
                    %endif%  
                  %endif%				  
        
                  <!-- last status -->
				  <td nowrap="true">
				    %value trigger/lastDispatcherStatusChangeDisplay encode(html)%
                  </td>
				  
				  <!-- alias name -->
				  <script>
	  		        createForm("htmlform_alias_%value $index%", "streaming-detail.dsp", "POST", "BODY");
  		      	    setFormProperty("htmlform_alias_%value $index%", "name", "%value trigger/aliasName encode(url)%");
  	      		  </script> 			  
                  <td>
                    <script>
		              if(is_csrf_guard_enabled && needToInsertToken) {
		  	            document.write('<a href="javascript:document.htmlform_alias_%value $index%.submit();">%value trigger/aliasName encode(html)%</a>');
		              } else {
		                %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		                var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
					    if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
						  document.write('<a href="streaming-detail.dsp?name=%value trigger/aliasName encode(url)%&webMethods-wM-AdminUI=true">%value trigger/aliasName encode(html)%</a>');
						}else {
						  document.write('<a href="streaming-detail.dsp?name=%value trigger/aliasName encode(url)%">%value trigger/aliasName encode(html)%</a>');
						}
		              }
                    </script>
                  </td>
				  
				  <!-- Runtime Perspective Fields -->
				  %ifvar /perspective equals('runtime')%

                    <!-- Runtime Properties with a Consumer -->
				    %ifvar trigger/triggerConsumers -notempty%	
				   	  
					  <!-- For Each Consumer -->
					  %loop trigger/triggerConsumers%
				        
						<!-- First Time Through Loop -->
						%ifvar $index equals(0)%
						
						  <!-- consumer id and partition status (initializing or passive) -->
				          <td>
						    %ifvar partitionsState equals('active')%
							  %value consumerId encode(html)%
							%else%
							  %value consumerId encode(html)% (%value partitionsState encode(html)%)
						    %endif%
						  </td> 
						  <!-- partition -->
					      <td style="white-space;">%value partitionsDisplay encode(html)%</td>
					      <!-- consumer status + inactive polling time (if not active) -->
						  <td>%value consumerStatus% 
					        %ifvar inactivePollingAttempts equals(0)%
						    %else% %ifvar inactivePollingAttempts equals(1)% %else%
						      (%value inactivePollingAttempts%)
						    %endif% %endif%
					      </td>
						  <!-- last consumer status change -->
                          <td>%value lastTaskStatusChangeDisplay%</td>
						  <!-- received events -->
					      <td>%value consumerSessionEvents%</td>
						  <!-- pre-processing events -->
					      <td>%value consumerPreProcessingEvents%</td>
						  <!-- buffered events -->
						  <td>%value consumerBufferedEvents%</td>
						  <!-- filtered events -->
						  <td>%value consumerFilteredEvents%</td>
						  <!-- error events -->
						  <td>%value consumerErrorEvents%</td>
						  <!-- dropped events (both due to being expired events and duplicate events) -->
						  <td>%value consumerCombinedDroppedEvents%</td>
						  <!-- processing events -->
						  <td>%value consumerProcessingEvents%</td>
						  <!-- processed events -->
						  <td>%value consumerTotalEvents%</td>
						  <!-- last received (or none of no events received) -->
						  <td nowrap>
                            %ifvar lastReceiveDisplay -notempty%
                              %value lastReceiveDisplay encode(html)%
                            %else%
                              none
							%endif%
                          </td>
							
						<!-- Second Time Through Loop (if there is more than one consumer) -->
				        %else%
				        </tr>
				        <tr>  
				          <td></td> 
				          <td></td> 
				          <td></td>
						  <td></td>
					      <td>
							<!-- consumer id and partition status (initializing or passive) -->
						    %ifvar partitionsState equals('active')%
							  %value consumerId encode(html)%
							%else%
							  %value consumerId encode(html)% (%value partitionsState encode(html)%)
						    %endif%
						  </td>
						  <!-- partition -->
					      <td>%value partitionsDisplay%</td>
						  <!-- consumer status + inactive polling time (if not active) -->
					      <td>%value consumerStatus% 
					        %ifvar inactivePollingAttempts equals(0)%
						    %else% %ifvar inactivePollingAttempts equals(1)% %else%
						      (%value inactivePollingAttempts%)
						    %endif% %endif%	
					      </td>
						  <!-- last consumer status change -->
                          <td>%value lastTaskStatusChangeDisplay%</td> 
						  <!-- received events -->
					      <td>%value consumerSessionEvents%</td>
						  <!-- pre-processing events -->
					      <td>%value consumerPreProcessingEvents%</td>
						  <!-- buffered events -->
						  <td>%value consumerBufferedEvents%</td>
						  <!-- filtered events -->
						  <td>%value consumerFilteredEvents%</td>
						  <!-- error events -->
						  <td>%value consumerErrorEvents%</td>
						  <!-- dropped events (both due to being expired events and duplicate events) -->
						  <td>%value consumerCombinedDroppedEvents%</td>
						  <!-- processing events -->
						  <td>%value consumerProcessingEvents%</td>
						  <!-- processed events -->
						  <td>%value consumerTotalEvents%</td>
						  <!-- last received (or none of no events received) -->
						  <td>
                            %ifvar lastReceiveDisplay -notempty%
                              %value lastReceiveDisplay encode(html)%
                            %else%
                              none
						    %endif%
                          </td>
				        %endif%	  
				      %endloop%	 
                    
                    <!-- Else (trigger has no consumers) 
					     This should not happen because we are only displaying enabled and active triggers, 
						 I am keeping this logic just incase something changes in the future. -->					
				    %else%
				      <td></td> 
					  <td></td>
					  <td></td>
					  <td></td>
					  <td></td>
					  <td></td>
					  <td></td>
				    %endif%
				   
				  <!-- Standard Perspective Fields -->
				  %else%
				    <!-- event specification -->
					<td>
				    %loop trigger/source%
					  <script>
	  		            createForm("htmlform_event_source_%value $index%", "streaming-subjects-detail.dsp", "POST", "BODY");
  		      	        setFormProperty("htmlform_event_source_%value $index%", "aliasName", "%value ../trigger/aliasName encode(url)%");
					    setFormProperty("htmlform_event_source_%value $index%", "referenceId", "%value referenceId encode(html)%");
  	      		      </script>  
                        <script>
		                  if(is_csrf_guard_enabled && needToInsertToken) {
		  	                document.write('<a href="javascript:document.htmlform_event_source_%value $index%.submit();">%value referenceId encode(html)%</a>');
		                  } else {
		                    %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		                    var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
						    if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
						      document.write('<a href="streaming-subjects-detail.dsp?aliasName=%value ../trigger/aliasName encode(url)%&referenceId=%value referenceId encode(html)%&webMethods-wM-AdminUI=true">%value referenceId encode(html)%</a>');
						    }else {
						      document.write('<a href="streaming-subjects-detail.dsp?aliasName=%value ../trigger/aliasName encode(url)%&referenceId=%value referenceId encode(html)%">%value referenceId encode(html)%</a>');
						    }
		                  }
                        </script>
				    %endloop%
					</td>
				    <!-- consumer config (min/max) -->
				    <td>%value trigger/minConsumers encode(html)% (%value trigger/maxConsumers encode(html)%)</td>
					<!-- active consumers (with link to runtime perspective)-->
					%ifvar trigger/triggerRuntimeData/consumerCount equals(0)%
					  <td>none</td>
					%else%
					  <td>
                        <script>
	  		              createForm("htmlform_active_consumer_%value $index%", "streaming-trigger-management.dsp", "POST", "BODY");
  		      	          setFormProperty("htmlform_active_consumer_%value $index%", "perspective", "runtime");
  	      		          if(is_csrf_guard_enabled && needToInsertToken) {
		  	                document.write('<a href="javascript:document.htmlform_active_consumer_%value $index%.submit();">%value trigger/triggerRuntimeData/consumerCount encode(url)%</a>');
		                  } else {
		                    %rename ../../webMethods-wM-AdminUI webMethods-wM-AdminUI -copy%
		                    var webMethodswMAdminUI = getUrlParameter('webMethods-wM-AdminUI');
						    if (webMethodswMAdminUI || '%value webMethods-wM-AdminUI encode(javascript)%' || 'webMethods_wM_AdminUI' == 'true') {
						      document.write('<a href="streaming-trigger-management.dsp?perspective=runtime&triggerList=%value node_nsName encode(url)%&webMethods-wM-AdminUI=true">%value trigger/triggerRuntimeData/consumerCount encode(url)%</a>');
						    }else {
						      document.write('<a href="streaming-trigger-management.dsp?perspective=runtime&triggerList=%value node_nsName encode(url)%">%value trigger/triggerRuntimeData/consumerCount encode(url)%</a>');
						    }
		                  }
                        </script>
					  </td>
					%endif%
				  %endif%
                </tr>  
				<!-- last error-->
				%ifvar trigger/triggerRuntimeData/lastError_display%   
                  <tr>
                    <td colspan="9"><font color=red>%value trigger/triggerRuntimeData/lastError_display%</font></td>
                  </tr>
                %endif%  
				
              %endloop%                            
            </table>
          </td>
        </tr>    
      %endinvoke%   
    </table>
  </body>
</html>