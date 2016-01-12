package org.openmrs.module.ipdui.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.openmrs.*;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.ipdui.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

/**
 * Created by ngarivictor on 1/12/2016.
 */
public class ChooseIpdWardPageController {
    public void get(
            @RequestParam(value = "ipdWard", required = false) String[] ipdWard,
            @RequestParam(value = "tab", required = false) Integer tab,
            PageModel model) {
        creatConceptQuestionAndAnswer(Context.getConceptService(), Context.getAuthenticatedUser(), HospitalCoreConstants.CONCEPT_ADMISSION_OUTCOME, new String[]{"Improve", "Cured", "Discharge on request", "LAMA", "Absconding", "Death"});
        Concept ipdConcept = Context.getConceptService().getConceptByName(Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        List<ConceptAnswer> list = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(list)) {
            Collections.sort(list, new ConceptAnswerComparator());
        }
        model.addAttribute("listIpd", list);
        String doctorRoleProps = Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_NAME_DOCTOR_ROLE);
        Role doctorRole = Context.getUserService().getRole(doctorRoleProps);
        if (doctorRole != null) {
            List<User> listDoctor = Context.getUserService().getUsersByRole(doctorRole);
            model.addAttribute("listDoctor", listDoctor);
        }
        tab = 0;
        model.addAttribute("ipdWard", ipdWard);
        model.addAttribute("tab", tab.intValue());

    }
    public void creatConceptQuestionAndAnswer(ConceptService conceptService,  User user ,String conceptParent, String...conceptChild) {
        // System.out.println("========= insertExternalHospitalConcepts =========");
        Concept concept = conceptService.getConcept(conceptParent);
        if(concept == null){
            insertConcept(conceptService, "Coded", "Question" , conceptParent);
        }
        if (concept != null) {

            for (String hn : conceptChild) {
                insertHospital(conceptService, hn);
            }
            addConceptAnswers(concept, conceptChild, user);
        }
    }
}
