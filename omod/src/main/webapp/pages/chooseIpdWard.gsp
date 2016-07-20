<% ui.decorateWith("appui", "standardEmrPage") %>
<style>
ul.select li.selected{background-color: #007FFF; color: #FFF;border-color: transparent}
</style>

<ul class="select">
    <% listIpd.each { it -> %>
    <li><a href="${ui.pageLink("ipdapp", "patientsAdmission", [tab: 0, ipdWard: it.answerConcept.id,ipdWardString:it.answerConcept.id ])}"> ${it.answerConcept.name} </a> </li>
    <% } %>
</ul>






