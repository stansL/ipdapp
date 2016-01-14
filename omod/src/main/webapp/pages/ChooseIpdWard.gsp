<% ui.decorateWith("appui", "standardEmrPage") %>


<ul class="select">
    <% listIpd.each { it -> %>
    <li> ${it.answerConcept.name} </li>
    <% } %>
</ul>






