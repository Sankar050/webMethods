<html>
	<head>
		<title>'%value alias%' listener runtime status</title>
		<script type="text/javascript" src="js/jquery-min.js"></script>
		<LINK REL="stylesheet" TYPE="text/css" HREF="/WmRoot/webMethods.css">
		</LINK>
		<link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>
		<SCRIPT SRC="../WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/messages.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/oauth-util-functions.js" type="text/javascript"></SCRIPT>
		<script type="text/javascript">
			var reasonRows = "";
			function formTableRows(value) {
				reasonRows += "<tr><td>" + value['dateTime'] + " " + value['stateMsg'] + "</td></tr>";
			}
			
			/**
            * Close and refresh the Listener list page.
            */
            function closeAndRefresh() {
                // close modal
                parent.document.getElementById("closeIFrameWindow").click();
                // refresh listener list page
                parent.$("#showallListener a").click();
            }

			/**
			* toggle rows - show more or show less
			*/
			function toggleTableRows(element) {

				$('#reasonsTable').find('tr:gt(2)').toggle();

				$(".showLess").toggle();
				$(".showMore").toggle();

				return false;
			}

			/**
			* Disable the listener and close the modal window.
			*/
			function disableSuspendedListener() {
				var listenerAlias = "%value alias%";
				$.ajax({
					type: 'GET',
					url: '/invoke/pub.cloudstreams.admin.listener:disable?listenerAlias=' + listenerAlias,
					dataType: 'json',
					contentType: 'application/json',
					async: false,
					success: function(data) {
						var closeOnSuccess = false;
						var statusMessage = "";
						$.each(data, function(key, value) {
							if (key == 'status' && value == 'true') {
								closeOnSuccess = true;
							}
							if (key == 'statusMessage') {
								statusMessage = value;
							}
						});

						if(closeOnSuccess) {
							closeAndRefresh();

						} else {
							var err = statusMessage;
							errorMessageToggle(err, "show");
							$("html, body").animate({scrollTop : 0}, 200, 'swing');
						}
					},
					error: function(xhr, status) {
						$("#err_message_span").html("Error: " + xhr.responseText);
						$("html, body").animate({scrollTop : 0 }, 200, 'swing');						}
				});
			}

			$(document).ready(function () {

				$.ajax({
					type: 'GET',
					url: '/invoke/wm.cloudstreams.listener:listRuntimeDetails?listenerAlias=' + "%value alias%",
					dataType: 'json',
					contentType: 'application/json',
					async: false,
					success: function(data) {
						var closeOnSuccess = false;
						$.each(data, function(key, value) {
							if (key == 'status' && value == 200) {
								closeOnSuccess = true;
							}
							if (key == 'stateDetails') {
								value.forEach(formTableRows);
								$("#reasonsTable tbody").append(reasonRows);
							}
						});
					},
					error: function(xhr, status) {
						$("#err_message_span").html("Error: " + xhr.responseText);
						$("html, body").animate({scrollTop : 0 }, 200, 'swing');
					}
				});

				// hide reasons table rows excluding first 2 rows.
				$('#reasonsTable').each(function () {
					if($(this).find('tr:gt(2)').length > 0) {
						$(this).find('tr:gt(2)').hide();
						$(".showLess").toggle();
					} else {
						$(".toggleView").hide();
					}
				});

			});
		</script>
	</head>
	<body style="border-spacing: 0; border-width:0">
		<form action="#">
			<table id="mainTable" class="tableView" width="100%" />
				<!-- all rows dynamically updated -->
				<table id="reasonsTable" class='tableView' summary="Table to input CloudStreams Keystore runtime config information">
					<tbody>
					<tr>
						<td class="heading" colspan=2>Reason(s)</td>
					</tr>
					<tr id='status'><td colspan=8 name='err_message_span' class='error' style='text-align: left; padding-left: 35pt; display: none;' id='err_message_span'></td></tr>

					</tbody>
				</table>
				<div class="toggleView">
					<a href="javascript:void(0);">
					<!-- view more -->
					<span class="showMore" onclick="javascript:toggleTableRows(this);">View more</span>
					<img class="showMore" id="toggleIcon" border="0" src="images/arrow_down.gif" align="baseline" width="18" height="18" onclick="javascript:toggleTableRows(this);" />
					<!-- view less -->
					<span class="showLess" onclick="javascript:toggleTableRows(this);">View less</span>
					<img class="showLess" id="toggleIcon" border="0" src="images/arrow_up.gif" align="baseline" width="18" height="18" onclick="javascript:toggleTableRows(this);" />
					</a>
				</div>
				<table style="margin-top: 10px" width=100%>
					<tr>
						<td class="action" colspan="3" style="text-align: left">
							<input type="button" id="disableListener" onclick="javascript:disableSuspendedListener();" value="Disable Listener" width="100%" />
							<input type="button" id="close" value="Close" onclick="javascript:closeAndRefresh();" style="padding: 0px 15px;" width="100%" />
						</td>
					</tr>
				</table>
			</table>
		</form>
	</body>
</html>