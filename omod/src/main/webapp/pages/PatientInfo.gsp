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
                var selectedProcedure = document.createElement('option');
                selectedProcedure.value = ui.item.value;
                selectedProcedure.text = ui.item.label;
                selectedProcedure.id = ui.item.value;
                var selectedProcedureList = document.getElementById("selectedProcedureList");


                //adds the selected procedures to the div
                var selectedProcedureP = document.createElement("P");
                selectedProcedureP.className = "selectp";

                var selectedProcedureT = document.createTextNode(ui.item.label);
                selectedProcedureP.id = ui.item.value;
                selectedProcedureP.appendChild(selectedProcedureT);



                var btnselectedRemoveIcon = document.createElement("p");
                btnselectedRemoveIcon.className = "icon-remove selecticon";
                btnselectedRemoveIcon.id = "procedureRemoveIcon";



                /*
                 var btnselectedAnchor = document.createElement("a");
                 btnselectedAnchor.id = ui.item.value;

                 var btnselectedProcedure = document.createElement("input");
                 btnselectedProcedure.id = "remove";
                 btnselectedProcedure.type = "button";
                 btnselectedProcedure.appendChild(btnselectedRemoveIcon);
                 */
                selectedProcedureP.appendChild(btnselectedRemoveIcon);

                var selectedProcedureDiv = document.getElementById("selected-procedures");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedProcedureList.length; i++) {
                    if(selectedProcedureList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedProcedureList.appendChild(selectedProcedure);
                    selectedProcedureDiv.appendChild(selectedProcedureP);
                }

            },
            open: function() {
                jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
            },
            close: function() {
                jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
            }
        });
        jq("#selected-procedures").on("click", "#procedureRemoveIcon",function(){
            var procedureId = jq(this).parent("p").attr("id");
            var procedureP = jq(this).parent("p");

            var divProcedure = procedureP.parent("div");
            var selectInputPosition = divProcedure.siblings("p");
            var selectedProcedure = selectInputPosition.find("select");
            var removeProcedure = selectedProcedure.find("#" + procedureId);

            procedureP.remove();
            removeProcedure.remove();

        });

        //investigations autocomplete functionality
        jq("#investigation").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "getInvestigations") }',
                        {
                            q: request.term
                        }
                ).success(function(data) {
                            var results = [];
                            for (var i in data) {
                                var result = { label: data[i].name, value: data[i].id};
                                results.push(result);
                            }
                            response(results);
                        });
            },
            minLength: 3,
            select: function( event, ui ) {
                var selectedInvestigation = document.createElement('option');
                selectedInvestigation.value = ui.item.value;
                selectedInvestigation.text = ui.item.label;
                selectedInvestigation.id = ui.item.value;
                var selectedInvestigationList = document.getElementById("selectedInvestigationList");


                //adds the selected procedures to the div
                var selectedInvestigationP = document.createElement("P");
                selectedInvestigationP.className = "selectp";

                var selectedInvestigationT = document.createTextNode(ui.item.label);
                selectedInvestigationP.id = ui.item.value;
                selectedInvestigationP.appendChild(selectedInvestigationT);



                var btnselectedRemoveIcon = document.createElement("p");
                btnselectedRemoveIcon.className = "icon-remove selecticon";
                btnselectedRemoveIcon.id = "investigationRemoveIcon";




                selectedInvestigationP.appendChild(btnselectedRemoveIcon);

                var selectedInvestigationDiv = document.getElementById("selected-investigations");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedInvestigationList.length; i++) {
                    if(selectedInvestigationList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedInvestigationList.appendChild(selectedInvestigation);
                    selectedInvestigationDiv.appendChild(selectedInvestigationP);
                }

            },
            open: function() {
                jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
            },
            close: function() {
                jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
            }
        });

        jq("#selected-investigations").on("click", "#procedureRemoveIcon",function(){
            var investigationId = jq(this).parent("p").attr("id");
            var investigationP = jq(this).parent("p");

            var divProcedure = investigationP.parent("div");
            var selectInputPosition = divProcedure.siblings("p");
            var selectedProcedure = selectInputPosition.find("select");
            var removeProcedure = selectedProcedure.find("#" + investigationId);

            investigationP.remove();
            removeProcedure.remove();

        });



        //autocomplete for the discharge tab
        jq("#dischargeProcedures").autocomplete({
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
                var selectedProcedure = document.createElement('option');
                selectedProcedure.value = ui.item.value;
                selectedProcedure.text = ui.item.label;
                selectedProcedure.id = ui.item.value;
                var selectedProcedureList = document.getElementById("selectedDischargeProcedureList");


                //adds the selected procedures to the div
                var selectedProcedureP = document.createElement("P");
                selectedProcedureP.className = "selectp";

                var selectedProcedureT = document.createTextNode(ui.item.label);
                selectedProcedureP.id = ui.item.value;
                selectedProcedureP.appendChild(selectedProcedureT);



                var btnselectedRemoveIcon = document.createElement("p");
                btnselectedRemoveIcon.className = "icon-remove selecticon";
                btnselectedRemoveIcon.id = "procedureRemoveIcon";



                /*
                 var btnselectedAnchor = document.createElement("a");
                 btnselectedAnchor.id = ui.item.value;

                 var btnselectedProcedure = document.createElement("input");
                 btnselectedProcedure.id = "remove";
                 btnselectedProcedure.type = "button";
                 btnselectedProcedure.appendChild(btnselectedRemoveIcon);
                 */
                selectedProcedureP.appendChild(btnselectedRemoveIcon);

                var selectedProcedureDiv = document.getElementById("selected-procedures2");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedProcedureList.length; i++) {
                    if(selectedProcedureList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedProcedureList.appendChild(selectedProcedure);
                    selectedProcedureDiv.appendChild(selectedProcedureP);
                }

            },
            open: function() {
                jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
            },
            close: function() {
                jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
            }
        });
        jq("#selected-procedures2").on("click", "#procedureRemoveIcon",function(){
            var procedureId = jq(this).parent("p").attr("id");
            var procedureP = jq(this).parent("p");

            var divProcedure = procedureP.parent("div");
            var selectInputPosition = divProcedure.siblings("p");
            var selectedProcedure = selectInputPosition.find("select");
            var removeProcedure = selectedProcedure.find("#" + procedureId);

            procedureP.remove();
            removeProcedure.remove();

        });


        //diagnoses autocomplete functionality
        jq("#diagnosis").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "getDiagnosis") }',
                        {
                            q: request.term
                        }
                ).success(function(data) {
                            var results = [];
                            for (var i in data) {
                                var result = { label: data[i].name, value: data[i].id};
                                results.push(result);
                            }
                            response(results);
                        });
            },
            minLength: 3,
            select: function( event, ui ) {
                var selectedInvestigation = document.createElement('option');
                selectedInvestigation.value = ui.item.value;
                selectedInvestigation.text = ui.item.label;
                selectedInvestigation.id = ui.item.value;
                var selectedInvestigationList = document.getElementById("selectedDiagnosisList");


                //adds the selected procedures to the div
                var selectedInvestigationP = document.createElement("P");
                selectedInvestigationP.className = "selectp";

                var selectedInvestigationT = document.createTextNode(ui.item.label);
                selectedInvestigationP.id = ui.item.value;
                selectedInvestigationP.appendChild(selectedInvestigationT);



                var btnselectedRemoveIcon = document.createElement("p");
                btnselectedRemoveIcon.className = "icon-remove selecticon";
                btnselectedRemoveIcon.id = "investigationRemoveIcon";




                selectedInvestigationP.appendChild(btnselectedRemoveIcon);

                var selectedInvestigationDiv = document.getElementById("selected-diagnoses");

                //check if the item already exist before appending
                var exists = false;
                for (var i = 0; i < selectedInvestigationList.length; i++) {
                    if(selectedInvestigationList.options[i].value==ui.item.value)
                    {
                        exists = true;
                    }
                }

                if(exists == false)
                {
                    selectedInvestigationList.appendChild(selectedInvestigation);
                    selectedInvestigationDiv.appendChild(selectedInvestigationP);
                }

            },
            open: function() {
                jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
            },
            close: function() {
                jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
            }
        });

        jq("#selected-diagnoses").on("click", "#procedureRemoveIcon",function(){
            var investigationId = jq(this).parent("p").attr("id");
            var investigationP = jq(this).parent("p");

            var divProcedure = investigationP.parent("div");
            var selectInputPosition = divProcedure.siblings("p");
            var selectedProcedure = selectInputPosition.find("select");
            var removeProcedure = selectedProcedure.find("#" + investigationId);

            investigationP.remove();
            removeProcedure.remove();

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
                'admittedId': jq('#vitalStatisticsAdmittedID').val(),
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


        //dicharge patient send post information
        jq("#dischargeSubmit").click(function(event){

            alert("The discharge submit button has bee clicked");
            var dischargeForm = jq("#dischargeForm");

            //fetch the selected discharge diagnoses and store in an array
            var selectedDiag = new Array;

            jq("#selectedDiagnosisList option").each  ( function() {
                selectedDiag.push ( jq(this).val() );
            });

            //get the list of selected procedures and store them in an array
            var selectedDischargeProcedureList = new Array;

            jq("#selectedDischargeProcedureList option").each  ( function() {
                selectedDischargeProcedureList.push ( jq(this).val() );
            });



            var dischargeFormData = {
                'dischargeAdmittedID': jq('#dischargeAdmittedID').val(),
                'patientId': jq('#dischargePatientID').val(),
                'selectedDiagnosisList': selectedDiag,
                'selectedDischargeProcedureList': selectedDischargeProcedureList,
                'dischargeOutcomes': jq('#dischargeOutcomes').val(),
                'otherDischargeInstructions': jq('#otherDischargeInstructions').val(),
            };

            dischargeForm.submit(
                    jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "dischargePatient") }',dischargeFormData)
                            .success(function(data) {
                                alert('ok');
                            })
                            .error(function(xhr, status, err) {
                                alert('AJAX error ' + err);
                            })
            );

        });


        //treatment: send post information
        jq("#treatmentSubmit").click(function(event){

            var treatmentForm = jq("#treatmentForm");

            //get the list of selected procedures and store them in an array
            var selectedProc = new Array;

            jq("#selectedProcedureList option").each  ( function() {
                selectedProc.push ( jq(this).val() );
            });

            //fetch the selected discharge diagnoses and store in an array
            var selectedInv = new Array;

            jq("#selectedInvestigationList option").each  ( function() {
                selectedInv.push ( jq(this).val() );
            });



            var treatmentFormData = {
                'patientId': jq('#treatmentPatientID').val(),
                'selectedInvestigationList': selectedInv,
                'selectedProcedureList': selectedProc,
                'ipdWard': jq('#treatmentIPDWard').val(),
                'otherTreatmentInstructions': jq('#otherTreatmentInstructions').val(),
            };

            dischargeForm.submit(
                    jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "treatment") }',treatmentFormData)
                            .success(function(data) {
                                alert('ok');
                            })
                            .error(function(xhr, status, err) {
                                alert('AJAX error ' + err);
                            })
            );

        });


        var adddrugdialog = emr.setupConfirmationDialog({
            selector: '#addDrugDialog',
            actions: {
                confirm: function() {
                    adddrugdialog.close();
                },
                cancel: function() {
                    adddrugdialog.close();
                }
            }
        });
        jq("#addDrugsButton").on("click", function(e){
            adddrugdialog.show();
        });


        //add drug autocomplete
        jq(".drug-name").on("focus.autocomplete", function () {
            var selectedInput = this;
            jq(this).autocomplete({
                source: function( request, response ) {
                    jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "getDrugs") }',
                            {
                                q: request.term
                            }
                    ).success(function(data) {
                                var results = [];
                                for (var i in data) {
                                    var result = { label: data[i].name, value: data[i].id};
                                    results.push(result);
                                }
                                response(results);
                            });
                },
                minLength: 3,
                select: function( event, ui ) {
                    event.preventDefault();
                    jq(selectedInput).val(ui.item.label);
                },
                change: function (event, ui) {
                    event.preventDefault();
                    jq(selectedInput).val(ui.item.label);

                    jq.getJSON('${ ui.actionLink("ipdui", "PatientInfo", "getFormulationByDrugName") }',
                            {
                                "drugName": ui.item.label
                            }
                    ).success(function(data) {
                                var formulations = jq.map(data, function (formulation) {
                                  jq('#formulationsSelect').append(jq('<option>').text(formulation.name).attr('value', formulation.id));
                                });
                            });
                },
                open: function() {
                    jq( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
                },
                close: function() {
                    jq( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
                }
            });
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
.selecticon{
    float: right;
    vertical-align: middle;
    font-size: x-large;
}
.selectp{
    min-width: 450px;
    border-bottom: solid;
    border-bottom-width: 1px;
    padding-left: 5px;
    margin-top:20px;
}
.selectdiv{
    width: 450px;
    margin-top:10px;
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
        <li><a href="#tabs-5">Discharge</a></li>
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
            <% if (patientInformation.requestForDischargeStatus != 1 && patientInformation.absconded != 1) { %>
            <a class="button confirm morebuttons" href="${ui.actionLink("ipdui", "PatientInfo", "requestForDischarge", [id: patientInformation.id, ipdWard:patientInformation.admittedWard,obStatus:0])}">Request for Discharge</a>
            <% } %>
            <% if (patientInformation.absconded != 1 && patientInformation.requestForDischargeStatus != 1) { %>
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
                        <input id="vitalStatisticsTemperature" name="vitalStatisticsTemperature" placeholder="Temperature(C)"  type="number"> </input>
                    </div>
                    <div class="vitalstatisticselements" >
                        <select required name="vitalStatisticsDietAdvised" id="vitalStatisticsDietAdvised" >
                            <option value="">Select Diet Advised</option>
                            <% if (dietList!=null && dietList!=""){ %>
                            <% dietList.each { dl -> %>
                            <option  value="${dl.name}">
                                ${dl.name}
                            </option>
                            <% } %>
                            <% } %>
                        </select>
                    </div>

                    <div class="vitalstatisticselements">
                        <textarea name="vitalStatisticsComment" id="vitalStatisticsComment" placeholder="Notes if any"></textarea>
                    </div>
                    <div class="vitalstatisticselements">
                        <input required name="vitalStatisticsAdmittedID" id="vitalStatisticsAdmittedID" value="${patientInformation.id}" type="hidden">
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
                    <% if (ipdPatientVitalStatistics!=null && ipdPatientVitalStatistics!=""){ %>
                    <% ipdPatientVitalStatistics.eachWithIndex { ipvs , idx-> %>
                    <tr>
                        <td>${idx+1}</td>
                        <td>${ipvs.createdOn}</td>
                        <td>${ipvs.bloodPressure}</td>
                        <td>${ipvs.pulseRate}</td>
                        <td>${ipvs.temperature}</td>
                        <td>${ipvs.dietAdvised}</td>
                        <td>${ipvs.note}</td>
                    </tr>
                    <% } %>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </section>
    </div>
    <div id="tabs-3">
        <div id="content" class="container">

            <h1>Treatment</h1>

            <form class="simple-form-ui" id="treatmentForm" method="post">

                <section id="charges-info">


                    <fieldset style="min-width: 500px; width: auto">

                        <legend>Procedure</legend>
                        <p>
                            <input type="text" style="width: 450px" id="procedure" name="procedure" placeholder="Enter Procedure" />
                            <select style="display: none" id="selectedProcedureList"></select>
                            <div class="selectdiv"  id="selected-procedures"></div>
                        </p>
                    </fieldset>
                    <fieldset>
                        <legend>Investigation</legend>
                        <p>
                            <input type="text" style="width: 450px" id="investigation" name="investigation" placeholder="Enter Investigations" />
                            <select style="display: none" id="selectedInvestigationList"></select>
                            <div class="selectdiv"  id="selected-investigations"></div>
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

                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            <td>
                            </td>
                            </tbody>
                        </table>
                        <input type="button" value="Add" class="button confirm" name="addDrugsButton" id="addDrugsButton">
                    </fieldset>
                    <fieldset>

                        <legend>Other Instructions</legend>

                        <p>
                            <textarea placeholder="Enter Other Instructions" style="width:400px"></textarea>
                            <input value="${patientInformation.admittedWard.id}" name="treatmentIPDWard" id="treatmentIPDWard" type="hidden">
                            <input name="treatmentPatientID" id="treatmentPatientID" value="${patientID}" type="hidden">
                            <a style="margin-top:12px" id="treatmentSubmit" class="button confirm">Submit</a>
                        </p>

                    </fieldset>
                </section>

            </form>

        </div>
        <div id="addDrugDialog" class="dialog">
            <div class="dialog-header">
                <i class="icon-folder-open"></i>
                <h3>Prescription</h3>
            </div>
            <div class="dialog-content">
                <ul>
                    <li>
                        <span>Drug</span>
                        <input class="drug-name" type="text" >
                    </li>
                    <li>
                        <span>Formulation</span>
                        <select id="formulationsSelect" >
                            <option>Select Formulation</option>
                        </select>
                    </li>
                    <li>
                        <span>Frequency</span>
                        <select id="drugFrequency">
                            <option>Select Frequency</option>
                            <% if (drugFrequencyList!=null &&drugFrequencyList!=""){ %>
                            <% drugFrequencyList.each { dfl -> %>
                            <option  value="${dfl.name}.${dfl.conceptId}">
                              ${dfl.name}
                            </option>
                            <% } %>
                            <% } %>
                        </select>
                    </li>
                    <li>
                        <span>Number of Days</span>
                        <input type="text"  >
                    </li>
                    <li>
                        <span>Comment</span>
                        <textarea ></textarea>
                    </li>
                </ul>

                <span class="button confirm right"> Confirm </span>
                <span class="button cancel"> Cancel </span>
            </div>
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
    <div id="tabs-5">
        <div id="content2" class="container">

            <h1>Discharge Patient</h1>

            <form class="simple-form-ui" id="dischargeForm" method="post">
                <section id="charges-info2">
                    <fieldset>

                        <legend>Diagnosis</legend>

                        <p>
                            <input type="text" style="width: 450px" id="diagnosis" name="diagnosis" placeholder="Enter Diagnosis" />
                            <select multiple style="display: none" id="selectedDiagnosisList"></select>
                        <div class="selectdiv"  id="selected-diagnoses"></div>
                    </p>

                    </fieldset>

                    <fieldset style="min-width: 500px; width: auto">

                        <legend>Procedure</legend>

                        <p>

                            <input type="text" style="width: 450px" id="dischargeProcedures" placeholder="Enter Procedure" />
                            <select multiple style="display: none" id="selectedDischargeProcedureList"></select>
                        <div class="selectdiv"  id="selected-procedures2"></div>
                    </p>

                    </fieldset>

                    <fieldset>

                        <legend>Outcome*</legend>

                        <p>
                            <select class="selectdiv" id="dischargeOutcomes">
                                <option>Select Outcome</option>
                                <% if (listOutCome!=null && listOutCome!=""){ %>
                                <% listOutCome.each { outCome -> %>
                                <option  value="${outCome.id}">
                                    ${outCome.answerConcept.name}
                                </option>
                                <% } %>
                                <% } %>
                            </select>
                        </p>

                    </fieldset>

                    <fieldset>

                        <legend>Other Instructions</legend>

                        <p>
                            <textarea id="otherDischargeInstructions" placeholder="Enter Other Instructions" style="width:400px"></textarea>
                            <input required name="dischargeAdmittedID" id="dischargeAdmittedID" value="${patientInformation.id}" type="hidden">
                            <input name="dischargePatientID" id="dischargePatientID" value="${patientID}" type="hidden">
                            <a style="margin-top:12px" id="dischargeSubmit" class="button confirm">Submit</a>
                        </p>

                    </fieldset>
                </section>

            </form>

        </div>

    </div>
</div>
