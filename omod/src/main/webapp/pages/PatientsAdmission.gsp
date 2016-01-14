<%
    ui.decorateWith("appui", "standardEmrPage")
%>

<head>
    <link rel="stylesheet" type="text/css" href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">
</head>
<div  style="margin-bottom: 15px">
    <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
        <thead>
            <tr align="center">
                <th>${ui.message("ipd.patient.admissionAdvisedOn")}</th>
                <th>${ui.message("ipd.patient.patientId")}</th>
                <th>${ui.message("ipd.patient.patientName")}</th>
                <th></th>
            </tr>
        </thead>
        <tbody>
            <% if (listPatientAdmission!=null || listPatientAdmission!="") { %>
                <% listPatientAdmission.each { pAdmission -> %>
                    <tr  align="center">
                        <td>${ui.formatDatePretty(pAdmission.admissionDate)}</td>
                        <td>${pAdmission.patientIdentifier}</td>
                        <td>${pAdmission.patientName}</td>
                        <td>
                            <div style="position: static" class="dropdown">
                                <span class="dropdown-name">
                                    <i class="icon-cog"></i>
                                        Actions
                                    <i class="icon-sort-down"></i>
                                </span>
                                <ul>
                                    <li>
                                        <a href="#">
                                            <i class="icon-signin"></i>
                                            Admit
                                        </a>
                                    </li>

                                    <li>
                                        <a href="#">
                                            <i class="icon-remove"></i>
                                           Remove
                                        </a>
                                    </li>
                                    <li>
                                        <a href="#">
                                            <i class="icon-thumbs-down "></i>
                                            No bed
                                        </a>
                                    </li>
                                </ul>
                            </div>

                        </td>
                    </tr>
                <% } %>
            <% } else { %>
                <tr align="center" >
                    <td colspan="6">No patient found</td>
                </tr>
            <% } %>
        </tbody>
    </table>
</div>
<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.8.2.min.js"></script>
<script type="text/javascript" charset="utf8" src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
<script>
    var jq = jQuery;
    jq(function () {
        jq("#queueList").dataTable();
    });
</script>
</div>
