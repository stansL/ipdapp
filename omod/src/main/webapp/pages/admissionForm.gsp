
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
                <span>First,<em>First</em></span>
                <span>Surname<em>surname</em></span>
            </h1>
            <div class="gender-age">
                <span>Male</span>
                <span>25 year(s)</span>
            </div>
            <br>
        </div>
        <div class="identifiers">
            <em>Patient ID</em>
            <span>MKL51611902054650-7</span>
        </div>
        <div class="identifiers">
            <em>Admission Date:</em>
            <span>25-01-2016 10:56:41</span>
        </div>
    </div>
</div>
<ul style=" margin-top: 10px;" class="grid"></ul>
<div class="patient-header new-patient-header">
    <div>
        <form>
            Admitted Ward:<br/>
            <span class="select-arrow" style="width: 250px;">
                <select style="width: 250px;">
                    <option>Ward 4 - Male Medical</option>
                    <option>Ward 4 - Male Medical</option>
                </select>
            </span>
            <div>
                <ul style=" margin-top: 10px;"></ul>
                Doctor on Call: <br/>
                <span class="select-arrow">
                    <select>
                        <option>Dr. Kiruis</option>
                        <option>Dr. Kiruis</option>
                    </select>
                </span></div>
        </form>
        <ul style=" margin-top: 10px;"></ul>

        <div style="width: 100px; display: inline-block;">
            <label for="FileNo" >File Number:</label>
        </div>

        <input id="FileNo" type="text" name="file number" style="min-width: 200px;" placeholder="Enter File Number">
        <br/>
        <ul style=" margin-top: 10px;"></ul>
        <label for="BedNo" style="width: 400px;">Bed Number:</label>
        <input id="BedNo" type="text" name="bed number" style="min-width: 200px;" placeholder="Select Bed number">
        <form>
            <div><ul style=" margin-top: 10px;"></ul>
                Comments:
                <textarea placeholder="Enter Comments"style="min-width: 450px; min-height: 100px;"></textarea></div>

        </form>
    </div>
    <ul style=" margin-top: 30px; margin-bottom: 30px;"></ul>
    <div style="width: 100%" align="center">
        <div style="width: 50%">
            <span class="button confirm" style="float: left"> Submit </span>
            <span class="button cancel" style="float: right"> Cancel </span>
        </div>
    </div>

</div>
