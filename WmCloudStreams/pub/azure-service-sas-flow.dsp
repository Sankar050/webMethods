<html>
	<head>
		<title>Azure Service SAS Flow</title>
		<script type="text/javascript" src="js/jquery-min.js"></script>
		<LINK REL="stylesheet" TYPE="text/css" HREF="/WmRoot/sag-delite.css">
		<LINK REL="stylesheet" TYPE="text/css" HREF="css/webMethods-modified.css">
		<link rel="stylesheet" href="css/messages.css" type="text/css"/>
		<link rel="stylesheet" href="css/cloudstreams.css" type="text/css"/>
		<link rel="stylesheet" href="css/jquery.multiselect.css" type="text/css"/>
		
		<SCRIPT SRC="../WmRoot/webMethods.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/messages.js" type="text/javascript"></SCRIPT>
		<SCRIPT src="js/csConnection.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/oauth-util-functions.js" type="text/javascript"></SCRIPT>
		<SCRIPT SRC="js/azure-service-sas-flow.js" type="text/javascript"></SCRIPT>
		<script src="js/jquery.multiselect.js"></script>

		<style type="text/css">
			td:first-child { text-align: right }
			
			.ms-options-wrap > .ms-options > ul input[type="checkbox"] {
				top: 4px;
			}
		</style>
		<script type="text/javascript">
			
			$(function() {
			
				$('select[multiple]').multiselect({
					columns: 4,
					placeholder: 'Select options'
				});
				
				$(document).ready(function() {
					// restore multi select values
						var selectFieldMap = {};
						$('form select[multiple]', window.parent.document).each(function () {  
							var hiddenInputName = this.name.substring(0, this.name.lastIndexOf("$"));
							var splitArray = $("input[name='"+ hiddenInputName + "']").val().split(',');
							selectFieldMap[this.name] = splitArray;
						});

						$('form select[multiple]', document).each(function () {
							$(this).val(selectFieldMap[this.name]);
							$(this).multiselect('reload');
						});
					
				});
			});
		</script>
	</head>
	<body style="border-spacing: 0; border-width:0">
		<form action="#">
		
			<input type="hidden" name="passwordChange" value="false">
			<table id="EndPointTable" class="tableView" width="100%" />
			<table id="mainTable" class="tableView" width="100%" />
				<!-- all rows dynamically updated -->
				<table style="margin-top: 10px" width=100%>
					<tr>
						<td class="action" colspan="3" style="text-align: left">
							<input type="button" id="getToken" value="Get Token" width="100%"/>
							<!--input type="button" id="next" value="Next" style="padding: 0px 15px;" width="100%" /-->
						</td>
					</tr>
				</table>
			</table>
		</form>
	</body>
</html>
