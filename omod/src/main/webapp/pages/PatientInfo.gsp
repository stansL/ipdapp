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
</style>
</head>
<body>

<div id="tabs">
    <ul>
        <li><a href="#tabs-1">Patient Details</a></li>
        <li><a href="#tabs-2">Enter Vitals</a></li>
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
    </div>
    <div id="tabs-2">
        <p>Enter Vitals</p>
    </div>
    <div id="tabs-3">
        <p>Treatment</p>
    </div>
    <div id="tabs-4">
        <p>Transfer</p>
    </div>
</div>
