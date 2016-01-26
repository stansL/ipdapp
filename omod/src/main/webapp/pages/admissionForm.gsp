<% ui.decorateWith("appui", "standardEmrPage", [title: "admit"]) %>

<body></body>
<header>
</header>
<div class="clear"></div>
<div class="container">
    <div class="example">
        <ul id="breadcrumbs">
            <li>
                <a href="#">
                    <i class="icon-home small"></i></a>
            </li>
            <li>
                <i class="icon-chevron-right link"></i>
                <a href="#">Patient Admission</a>
            </li>
            <li>
            </li>
        </ul>
    </div>
    <div class="patient-header new-patient-header">
        <div class="demographics">
            <h1 class="name">
                <span>${admission.patientName}<em>name</em></span>

            </h1>
            <div class="gender-age">
                <span>${admission.gender}<em>gender</em></span>
                <span>${admission.birthDate}<em>date of birth</em></span>
            </div>
            <br>
        </div>
        <div class="identifiers">
            <em>Patient ID</em>
            <span>${admission.patientIdentifier}</span>
        </div>
        <div class="identifiers">
            <em>Admission Date:</em>
            <span>${admission.admissionDate}</span>
        </div>
    </div>
</div>
<ul style=" margin-top: 10px;" class="grid"></ul>
<div class="patient-header new-patient-header">
    <div>
        <form method="post" action = "admissionForm.page?tab=${tab}&ipdWard=${ipdWard}&ipdWardString=${ipdWardString}">
            <input type="hidden" name="id" value="${admission.id}">
            Admitted Ward:<br/>
            <span class="select-arrow" style="width: 250px;">
                <select required  name="admittedWard" id="admittedWard"  style="width: 250px;">
                    <option value="">Select Ward</option>
                    <% if (listIpd!=null && listIpd!="") { %>
                    <% listIpd.each { ipd -> %>
                    <option title="${ipd.answerConcept.name}"   value="${ipd.answerConcept.id}">
                        ${ipd.answerConcept.name}
                    </option>
                    <%}%>
                    <%}%>
                </select>
            </span>
            <div>
                <ul style=" margin-top: 10px;"></ul>
                Doctor on Call: <br/>
                <span class="select-arrow">
                    <select required name="treatingDoctor" id="treatingDoctor"  style="width: 250px; >
                        <option value="please select ...">Select Doctor On Call</option>
                        <% if (listDoctor!=null && listDoctor!=""){ %>
                        <% listDoctor.each { doct -> %>
                        <option title="${doct.givenName}"   value="${doct.id}">
                            ${doct.givenName}
                        </option>
                        <% } %>
                        <% } %>
                    </select>
                </span>
            </div>

            <ul style=" margin-top: 10px;"></ul>

            <div style="width: 100px; display: inline-block;">
                <label for="FileNo" >File Number:</label>
            </div>

            <input id="FileNo" type="text" name="fileNumber" style="min-width: 200px;" placeholder="Enter File Number">
            <br/>
            <ul style=" margin-top: 10px;"></ul>
            <label for="BedNo" style="width: 400px;">Bed Number:</label>
            <input id="BedNo" type="text" name="bedNumber" style="min-width: 200px;" placeholder="Select Bed number">

            <div><ul style=" margin-top: 10px;"></ul>
                Comments:
                <textarea placeholder="Enter Comments" name="comments" style="min-width: 450px; min-height: 100px;"></textarea>
            </div>
            <ul style=" margin-top: 30px; margin-bottom: 30px;"></ul>
            <div style="width: 100%" align="center">
                <div style="width: 50%">
                    <input type="reset" class="button cancel" style="float: left" value="Reset">
                    <input type="submit" value="submit" class="button confirm" style="float: right">

                </div>
            </div>
        </form>
    </div>


</div>

