<% ui.decorateWith("appui", "standardEmrPage") %>
<script>
    var jq = jQuery;
    jq(function() {
        jq( "#tabs" ).tabs();
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
            <h2>Admission Date:</h2>
            <h3>...</h3>
        </div>
        <div class="persondatalabel">
            <h2>Patient ID:</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Name:</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Bed Number:</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Age:</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Gender:</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission Ward :</h2>
            <h3> ....</h3>
        </div>
        <div class="persondatalabel">
            <h2>Admission By:</h2>
            <h3> ....</h3>
        </div>
        <div class="clearboth"></div>

        <div style="margin-top: 30px;">
            <a class="button confirm morebuttons">Discharge</a>
            <a class="button confirm morebuttons">Request for Discharge</a>
            <a class="button confirm morebuttons">Abscord</a>
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

    </div>
    <div id="tabs-4">
        <section>
            <form>
                <div class="simple-form-ui">
                    <div class="persondatalabel">
                        <h2>Select Ward</h2>
                        <select>
                            <option>Item 1</option>
                            <option>Item 2</option>
                            <option>Item 3</option>
                        </select>
                    </div>
                    <div class="persondatalabel">
                        <h2>Select Doctor</h2>
                        <select>
                            <option>Item 1</option>
                            <option>Item 2</option>
                            <option>Item 3</option>
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
