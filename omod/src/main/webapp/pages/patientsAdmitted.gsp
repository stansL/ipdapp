<%
    ui.decorateWith("appui", "standardEmrPage")
%>
<table cellpadding="5" cellspacing="0" width="100%" id="queueList">
    <tr align="center" >
        <th>${ui.message("ipd.admissionDate")}</th>
        <th>${ui.message("ipd.patient.patientName")}</th>
        <th>${ui.message("ipd.patient.age")}</th>
        <th>${ui.message("ipd.patient.gender")}</th>
        <th>${ui.message("ipd.patient.admissionWard")}</th>
        <th>${ui.message("ipd.patient.bedNumber")}</th>

    </tr>
    <% if(listPatientAdmitted!=null || listPatientAdmitted!=""){ %>
        <% listPatientAdmitted.each { queue -> %>
            <tr align="center" >
                <td>${queue.patientIdentifier}</td>
                <td>${queue.patientName}</td>
                <td>${queue.age}</td>
                <td>${queue.gender}</td>
                <td>${queue.admittedWard.name}</td>
                <td>${queue.bed}</td>
            </tr>
        <% } %>
    <% } else { %>
        <tr align="center" >
            <td colspan="6">No patient found</td>
        </tr>
    <% } %>

</table>
