<table style="margin: 10px" cellpadding="5" cellspacing="0" width="100%" id="queueList2">
	<thead>
	<tr align="center">
		<th>${ui.message("ipd.admissionDate")}</th>
		<th>${ui.message("ipd.patient.patientId")}</th>
		<th>${ui.message("ipd.patient.patientName")}</th>
		<th></th>
		<th></th>
	</tr>
	</thead>
	<tbody>
	<% if (listPatientAdmitted != null || listPatientAdmitted != "") { %>
	<% listPatientAdmitted.each { queue -> %>
	<tr align="center">
		<td>${ui.formatDatePretty(queue.admissionDate)}</td>
		<td>${queue.patientIdentifier}</td>
		<td>${queue.patientName}</td>
		<td><a class="button task"
			   href="${ui.pageLink("ipdapp", "patientInfo", [search: queue.patientIdentifier])}" style=""><i
					class="icon-plus-sign"></i> More</a></td>
		<td><a class="button task"
			   href="${ui.pageLink("ipdapp", "dischargePatient", [search: queue.patientIdentifier])}" style=""><i
					class="icon-signin"></i> Discharge</a></td>
	</tr>
	<% } %>
	<% } else { %>
	<tr align="center">
		<td colspan="6">No patient found</td>
	</tr>
	<% } %>
	</tbody>

</table>