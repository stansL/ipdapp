<head>

</head>
<% ui.decorateWith("appui", "standardEmrPage") %>

<script>
    var jq = jQuery;
    jq(function() {
        jq( "#tabs" ).tabs();
        jq("#procedure").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "getProcedures") }',
                        {
                            q: request.term
                        }
                ).success(function(data) {
                            procedureMatches = [];
                            for (var i in data) {
                                var result = { label: data[i].label, value: data[i].id, schedulable: data[i].schedulable };
                                procedureMatches.push(result);
                            }
                            response(procedureMatches);
                        });
            },
            minLength: 3,
            select: function( event, ui ) {

            },
            open: function() {
                jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
            },
            close: function() {
                jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
            }
        });
    });
</script>
<style>
    .persondatalabel{
        width:50%;
        border: 1px;
        float: left;
        margin-bottom: 15px;
    }
    .clearboth{
        clear: both;
    }
    .persondatalabel h3{
        display: inline;
        width: 50%;
    }
    .persondatalabel h2{
        display: inline;
        width: 50%;
    }
    .morebuttons{
        display: inline;
        float: left;
        margin-left: 20px;
    }
    .tableelement{
        width: auto;
        min-width: 10px;
    }
</style>
</head>
<body>

<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Patient Details</a></li>
        <li><a href="#tabs-2">Daily Vitals</a></li>
        <li><a href="#tabs-3">Treatment</a></li>
        <li><a href="#tabs-4">Transfer</a></li>
    </ul>
    <div id="tabs-1">
        <div class="persondatalabel">
            <h2>Admission Date: </h2>
            <h3> ${ui.formatDatePretty(patientInformation.admissionDate)}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Patient ID: </h2>
            <h3> ${patientInformation.patientIdentifier}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Name: </h2>
            <h3> ${patientInformation.patientName}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Bed Number: </h2>
            <h3> ${patientInformation.bed}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Age: </h2>
            <h3> ${patientInformation.age}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Gender: </h2>
            <h3> ${patientInformation.gender}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission By: </h2>
            <h3> ${patientInformation.ipdAdmittedUser.givenName}</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission Ward :</h2>
            <h3> ${patientInformation.admittedWard.name}</h3>
        </div>

        <div class="clearboth"></div>

        <div style="margin-top: 30px;">
            <a class="button confirm morebuttons" href="${ui.actionLink("ipdui", "PatientInfo", "dischargePatient")}">Discharge</a>
            <% if (patientInformation.requestForDischargeStatus == 0) { %>
                <a class="button confirm morebuttons" href="${ui.actionLink("ipdui", "PatientInfo", "requestForDischarge", [id: patientInformation.id, ipdWard:patientInformation.admittedWard,obStatus:0])}">Request for Discharge</a>
            <% } %>
            <% if (patientInformation.absconded == 0) { %>
                 <a class="button confirm morebuttons"  href="${ui.actionLink("ipdui", "PatientInfo", "requestForDischarge", [id: patientInformation.id, ipdWard:patientInformation.admittedWard,obStatus:1])}">Abscord</a>
            <% } %>
            <a class="button confirm morebuttons">Print</a>
            <div class="clearboth"></div>
        </div>
    </div>
    <div id="tabs-2">
        <section>
            <form>
            <div class="simple-form-ui">
                <div class="persondatalabel">
                    <h2>S.No:</h2>
                    <h3>...</h3>
                </div>
                <div class="persondatalabel">
                    <h2>Date/Time:</h2>
                    <h3> ....</h3>
                </div>
                <div class="persondatalabel">
                    <h2>Blood Pressure</h2>
                    <input type="number">
                </div>
                <div class="persondatalabel">
                    <h2>Pulse Rate(/min)</h2>
                    <input type="number">
                </div>
                <div class="persondatalabel">
                    <h2>Diet Advised</h2>
                    <select>
                        <option>Item 1</option>
                        <option>Item 2</option>
                        <option>Item 3</option>
                    </select>
                </div>
                <div class="persondatalabel">
                    <h2>Temperature(C)</h2>
                    <p>
                     <input placeholder="Temperature"  type="number"> </input>
                    </p>
                </div>
                <div class="clearboth"></div>
                <div class="">
                    <h2>Notes if any</h2>
                    <textarea></textarea>
                </div>
                <div class="" style="margin-top:15px" >
                    <a class="button confirm">Submit</a>
                </div>

            </div>
            </form>
        </section>
    </div>
    <div id="tabs-3">
        <form method="post">
            <div class="persondatalabel">
                <h2>Post for Procedure:</h2>
                <input type="text" id="procedure" name="procedure" />
                <div data-bind="foreach: procedures">
                    <p data-bind="text: label"></p>
                    <span data-bind="if: schedulable">Schedule:<input type="date"></span>
                    <button data-bind="click: \$root.removeProcedure">Remove</button>
                </div>
            </div>
            <div class="persondatalabel">
                <h2>Investigation:</h2>
                <input type="text" id="investigation" name="investigation" />
                <div data-bind="foreach: investigations">
                    <p data-bind="text: label"></p>
                    <button data-bind="click: \$root.removeInvestigation">Remove</button>
                </div>
            </div>


            <div class="persondatalabel">
                <h2>Prescription:</h2>
                <table>
                    <thead>
                        <th>Drug Name</th>
                        <th>Formulation</th>
                        <th>Frequency</th>
                        <th>Number of Days</th>
                        <th>Comment</th>
                        <th> </th>
                    </thead>
                    <tbody data-bind="foreach: drugs">
                        <td>
                            <input class="drug-name tableelement" type="text" data-bind="value: name, valueUpdate: 'blur'" >
                        </td>
                        <td>
                            <select class="tableelement" data-bind="options: formulationOpts, value: formulation, optionsText: 'label'"></select>
                        </td>
                        <td>
                            <select class="tableelement" data-bind="options: \$root.frequencyOpts, value: frequency, optionsText: 'label'"></select>
                        </td>
                        <td><input class="tableelement" type="text" data-bind="value: numberOfDays" >
                        </td>
                        <td>
                            <textarea class="tableelement" data-bind="value: comment"></textarea>
                        </td>
                        <td>
                            <button class="tableelement" data-bind="click: \$root.removeDrug">Remove</button>
                        </td>
                    </tbody>
                </table>
            <button data-bind="click: addDrug">Add</button>
        </div>
        <div style="clear:both;"></div>

        <div style="clear:both;"></div>
        <div class="persondatalabel">
            <h2>Other Instructions:</h2>
            <input  data-bind="value: \$root.otherInstructions" type="text" id="note" name="note" />
        </div>
        <div style="clear:both;"></div>
        <div class="" style="margin-top:15px" >
            <a class="button confirm">Submit</a>
        </div>
    </form>
    </div>
    <div id="tabs-4">
        <section>
            <form>
                <div class="simple-form-ui">
                    <div class="persondatalabel">
                        <h2>Select Ward: </h2>
                        <select id="ipdWard"  name="ipdWard"  style="width: 150px;">
                            <option value="">Select Ward</option>
                            <% if (listIpd!=null && listIpd!="") { %>
                            <% listIpd.each { ipd -> %>
                            <option title="${ipd.answerConcept.name}"   value="${ipd.answerConcept.id}">
                                ${ipd.answerConcept.name}
                            </option>
                            <%}%>
                            <%}%>
                        </select>
                    </div>
                    <div class="persondatalabel">
                        <h2>Select Doctor: </h2>
                        <select id="doctor"  name="doctor"  >
                            <option value="">Select Doctor On Call</option>
                            <% if (listDoctor!=null && listDoctor!=""){ %>
                            <% listDoctor.each { doct -> %>
                            <option title="${doct.givenName}"   value="${doct.id}">
                                ${doct.givenName}
                            </option>
                            <% } %>
                            <% } %>
                        </select>
                    </div>
                    <div class="persondatalabel">
                        <h2>Bed Number</h2>
                        <input type="number">
                    </div>

                    <div class="persondatalabel" >
                        <h2>Comments</h2>
                        <textarea></textarea>
                    </div>
                    <div class="persondatalabel" >
                        <a class="button confirm">Submit</a>
                    </div>
                </div>
            </form>
        </section>
    </div>
</div>
