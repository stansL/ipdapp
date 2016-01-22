<% ui.decorateWith("appui", "standardEmrPage") %>


<ul class="select">
    <% listIpd.each { it -> %>
    <li><a href="${ui.pageLink("ipdui", "patientsAdmission", [tab: 0, ipdWard: it.answerConcept.id ])}"> ${it.answerConcept.name} </a> </li>
    <% } %>
</ul>






