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

        //autocomplete for the discharge tab
        jq("#dischargeProcedures").autocomplete({
            source: function( request, response ) {
                jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "getProcedures") }',
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
                jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "getDiagnosis") }',
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






        //dicharge patient send post information
        jq("#dischargeSubmit").click(function(event){
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
                    jq.getJSON('${ ui.actionLink("ipdapp", "PatientInfo", "dischargePatient") }',dischargeFormData)
                            .success(function(data) {
                                jq().toastmessage('showNoticeToast', "Patient has been discharged");
                            })
                            .error(function(xhr, status, err) {
                                jq().toastmessage('showErrorToast', "Error:" + err);
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


        <div id="content" class="container">

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
