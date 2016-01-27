<%
    ui.decorateWith("appui", "standardEmrPage")
%>
<head>
    <link rel="stylesheet" type="text/css"
          href="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/css/jquery.dataTables.css">
    <script type="text/javascript" charset="utf8"
            src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
    <script>
        var jq = jQuery;
        jq(function () {
            jq("#tabs").tabs();
        });
        jq(function () {
            jq("#queueList").dataTable();
            jq("#queueList2").dataTable();
        });
    </script>
    <style>
    .paginate_disabled_previous, .paginate_enabled_previous, .paginate_disabled_next, .paginate_enabled_next{
        width:auto;
    }
    .button.task, button.task, input[type="submit"].task, input[type="button"].task, input[type="submit"].task, a.button.task{
        min-width: auto;
    }
    .dataTables_length{text-align: left}
    </style>
</head>

<div id="tabs">

    <ul>
        <li><a href="#tabs-1">Admmision Patients</a></li>
        <li><a href="#tabs-2">Admmited Patients</a></li>

    </ul>

    <div id="tabs-1">

        <div style="margin-bottom: 25px">
            <table cellpadding="5" cellspacing="0" width="100%" id="queueList">
                <thead>
                <tr align="center">
                    <th>Admission Advised On</th>
                    <th>Patients ID</th>
                    <th>Patients Name</th>
                    <th></th>
                </tr>
                </thead>
                <tbody>
                <% if (listPatientAdmission != null || listPatientAdmission != "") { %>
                <% listPatientAdmission.each { pAdmission -> %>
                <tr align="center">
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

                                    <a href="http://localhost:9001/openmrs/ipdui/admissionForm.page?admissionId=${pAdmission.id}&tab=${tab}&ipdWard=${ipdWard}&ipdWardString=${ipdWardString}"><i class="icon-signin"></i>
                                        Admit</a>
                                </li>

                                <li>
                                    <a href="${ui.actionLink("ipdui", "patientsAdmission", "removeOrNoBed", [admissionId: pAdmission.id, action: 1])}
                                    ">
                                        <i class="icon-remove"></i>
                                        Remove
                                    </a>
                                </li>
                                <li>
                                    <a href="${ui.actionLink("ipdui", "patientsAdmission", "removeOrNoBed", [admissionId: pAdmission.id, action: 2])}
                                    ">
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
                <tr align="center">
                    <td colspan="6">No patient found</td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

    </div>


    <div id="tabs-2">
        <div style="margin-bottom: 25px">
            <table style="margin: 10px" cellpadding="5" cellspacing="0" width="100%" id="queueList2">
                <thead>
                <tr align="center">
                    <th>${ui.message("ipd.admissionDate")}</th>
                    <th>${ui.message("ipd.patient.patientId")}</th>
                    <th>${ui.message("ipd.patient.patientName")}</th>
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
                           href="${ui.pageLink("ipdui", "patientInfo", [search: queue.patientIdentifier])}" style=""><i
                                class="icon-plus-sign"></i>  View More</a></td>
                </tr>
                <% } %>
                <% } else { %>
                <tr align="center">
                    <td colspan="6">No patient found</td>
                </tr>
                <% } %>
                </tbody>

            </table>

            <script type="text/javascript" charset="utf8"
                    src="http://ajax.aspnetcdn.com/ajax/jquery.dataTables/1.9.4/jquery.dataTables.min.js"></script>
            <script>
                var jq = jQuery;
                jq(function () {
                    jq("#queueList").dataTable();
                });
            </script>
        </div>

    </div>

</div>




