<head>

</head>
<%
    ui.decorateWith("appui", "standardEmrPage")
    ui.includeJavascript("uicommons", "datetimepicker/bootstrap-datetimepicker.min.js")
    ui.includeJavascript("uicommons", "handlebars/handlebars.min.js", Integer.MAX_VALUE - 1)
    ui.includeJavascript("uicommons", "navigator/validators.js", Integer.MAX_VALUE - 19)
    ui.includeJavascript("uicommons", "navigator/navigator.js", Integer.MAX_VALUE - 20)
    ui.includeJavascript("uicommons", "navigator/navigatorHandlers.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorModels.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/navigatorTemplates.js", Integer.MAX_VALUE - 21)
    ui.includeJavascript("uicommons", "navigator/exitHandlers.js", Integer.MAX_VALUE - 22)
%>

<script>
    var jq = jQuery;

    var NavigatorController
    jq(function(){
        NavigatorController = new KeyboardController();
    });

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
        jq("#printButton").click(function(){
            var printDiv = jq("#printArea").html();
            var printWindow = window.open('', '', 'height=400,width=800');
            printWindow.document.write('<html><head><title>Patient Information</title>');
            printWindow.document.write(printDiv);
            printWindow.document.write('</body></html>');
            printWindow.document.close();
            printWindow.print();
        });
/*        //transfer patient
               jq("#transferButton").click(function(){
                                var transferForm = jq("#transferForm");
                                transferForm.submit(
                                        function (ev) {
                                            jq.ajax({
                                                type: transferForm.attr('method'),
                                                url: '${ ui.actionLink("ipdui", "PatientInfo", "transferPatient") }',
                                                data: transferForm.serialize(),
                                                success: function (data) {
                                                    alert('ok');
                        }
                    });
                });
        });*/

        jq("#transferButton").click(function(event){
            var transferForm = jq("#transferForm");
            var transferFormData = {
                'admittedId': jq('#transferAdmittedID').val(),
                'toWard': jq('#transferIpdWard').val(),
                'doctor': jq('#transferDoctor').val(),
                'bedNumber': jq('#transferBedNumber').val(),
                'comments': jq('#transferComment').val(),
            };



            transferForm.submit(
                jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "transferPatient") }',transferFormData)
                        .success(function(data) {
                            alert('ok');
                        })
                        .error(function(xhr, status, err) {
                            alert('AJAX error ' + err);
                        })
            );

        });

        jq("#vitalStatisticsButton").click(function(event){
            var vitalStatisticsForm = jq("#vitalStatisticsForm");
            var vitalStatisticsFormData = {
                'admittedId': jq('#vitalStatisticsrAdmittedID').val(),
                'patientId': jq('#vitalStatisticsPatientID').val(),
                'bloodPressure': jq('#vitalStatisticsBloodPressure').val(),
                'pulseRate': jq('#vitalStatisticsPulseRate').val(),
                'temperature': jq('#vitalStatisticsTemperature').val(),
                'dietAdvised': jq('#vitalStatisticsDietAdvised').val(),
                'notes': jq('#vitalStatisticsComment').val(),
                'ipdWard': jq('#vitalStatisticsIPDWard').val(),
            };
            console.log(vitalStatisticsFormData);


            vitalStatisticsForm.submit(
                    jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "saveVitalStatistics") }',vitalStatisticsFormData)
                            .success(function(data) {
                                alert('ok');
                            })
                            .error(function(xhr, status, err) {
                                alert('AJAX error ' + err);
                            })
            );

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
    .vitalstatisticselements{
        float:left;
        margin-left:10px;
        margin-bottom: 10px;
    }
    .vitalstatisticselements textarea{
        height: 23px;
        width: 183px;
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
        <div id="printArea">
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
            <a class="button confirm morebuttons" id="printButton">Print</a>
            <div class="clearboth"></div>
        </div>
    </div>
    <div id="tabs-2">
        <section>
            <form method="post" id="vitalStatisticsForm">
                <div class="simple-form-ui">

                    <div class="vitalstatisticselements">
                        <input id="vitalStatisticsBloodPressure" name="vitalStatisticsBloodPressure" placeholder="Blood Pressure" type="number">
                    </div>
                    <div class="vitalstatisticselements">
                        <input id="vitalStatisticsPulseRate" name="vitalStatisticsPulseRate" placeholder="Pulse Rate(/min)" type="number">
                    </div>
                    <div class="vitalstatisticselements" >
                        <input id="vitalStatisticsDietTemperature" name="vitalStatisticsTemperature" placeholder="Temperature(C)"  type="number"> </input>
                    </div>
                    <div class="vitalstatisticselements" >
                        <select name="vitalStatisticsDietAdvised" id="vitalStatisticsDietAdvised">
                            <option>Select Diet Advised</option>
                            <option>Item 2</option>
                            <option>Item 3</option>
                        </select>
                    </div>

                    <div class="vitalstatisticselements">
                        <textarea name="vitalStatisticsComment" id="vitalStatisticsComment" placeholder="Notes if any"></textarea>
                    </div>
                    <div class="vitalstatisticselements"> <input required name="vitalStatisticsrAdmittedID" id="vitalStatisticsAdmittedID" value="${patientInformation.id}" type="hidden">
                        <input value="${patientInformation.admittedWard.id}" name="vitalStatisticsIPDWard" id="vitalStatisticsIPDWard" type="hidden">
                        <input name="vitalStatisticsrPatientID" id="vitalStatisticsPatientID" value="${patientID}" type="hidden">
                        <a id="vitalStatisticsButton" name="vitalStatisticsButton" class="button confirm">Submit</a>
                    </div>
                </div>
            </form>
                <div>
                    <table id="vitalSummary">
                        <thead>
                            <tr >
                                <th>S.No</th>
                                <th>Date/Time</th>
                                <th>Blood Pressure</th>
                                <th>Pulse Rate</th>
                                <th>Temperature</th>
                                <th>Diet Advised</th>
                                <th>Notes</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>1</td>
                                <td>2016-01-19 09:59:57.0</td>
                                <td>54</td>
                                <td>66</td>
                                <td>74</td>
                                <td>Solid</td>
                                <td>test note</td>
                            </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        <tr>
                            <td>1</td>
                            <td>2016-01-19 09:59:57.0</td>
                            <td>54</td>
                            <td>66</td>
                            <td>74</td>
                            <td>Solid</td>
                            <td>test note</td>
                        </tr>
                        </tbody>
                    </table>
                </div>
        </section>
    </div>
    <div id="tabs-3">
        <div id="content" class="container">

            <h1>Treatment</h1>

            <form class="simple-form-ui" id="charges" method="post">

                <section id="charges-info">


                    <fieldset>

                        <legend>Procedure</legend>

                        <p>

                            <input type="text" id="procedure" name="procedure" placeholder="Enter Procedure" />

                        </p>

                    </fieldset>

                    <fieldset>

                        <legend>Investigation</legend>

                        <p>
                            <input type="text" id="investigation" name="investigation" placeholder="Enter Investigation" />
                        </p>

                    </fieldset>
                    <fieldset>

                        <legend>Prescription</legend>

                        <table>
                            <thead>
                            <th>Drug Name</th>
                            <th>Formulation</th>
                            <th>Frequency</th>
                            <th>Number of Days</th>
                            <th>Comment</th>
                            </thead>
                            <tbody data-bind="foreach: drugs">
                            <td>
                                #
                            </td>
                            <td>
                                #
                            </td>
                            <td>
                                #
                            </td>
                            <td>
                                #
                            </td>
                            <td>
                                #
                            </td>
                            </tbody>
                        </table>

                    </fieldset>
                    <fieldset>

                        <legend>Other Instructions</legend>

                        <p>
                            <textarea placeholder="Enter Other Instructions" style="width:400px"></textarea>
                            <a style="margin-top:12px" class="button confirm">Submit</a>
                        </p>

                    </fieldset>
                </section>

            </form>
        </div>
    </div>
    <div id="tabs-4">
        <section>
            <form method="post" id="transferForm">
                <div class="simple-form-ui">
                    <div class="persondatalabel">
                        <h2>Select Ward: </h2>
                        <select required  name="transferIpdWard" id="transferIpdWard"  name="ipdWard"  style="width: 150px;">
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
                        <select required name="transferDoctor" id="transferDoctor"  name="doctor"  >
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
                        <input required name="transferBedNumber" id="transferBedNumber" type="number">
                </div>

                    <div class="persondatalabel" >
                        <h2>Comments</h2>
                        <textarea name="transferComment" id="transferComment"></textarea>
                    </div>
                    <div class="persondatalabel" >
                        <input required name="transferAdmittedID" id="transferAdmittedID" value="${patientInformation.id}" type="hidden">
                        <a type="submit" class="button confirm" id="transferButton">Submit</a>
                    </div>
                </div>
            </form>
        </section>
    </div>
</div>
