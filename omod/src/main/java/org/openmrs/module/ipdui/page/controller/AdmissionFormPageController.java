package org.openmrs.module.ipdui.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.ipdui.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Collections;

import java.util.List;

/**
 * Created by USER on 1/25/2016.
 */
public class AdmissionFormPageController {
    /*@RequestMapping(value = "/module/ipd/admission.htm", method = RequestMethod.GET)*/
    public void get(@RequestParam(value = "admissionId", required = false) Integer admissionId, //If that tab is active we will set that tab active when page load.
                         PageModel model) {
        IpdService ipdService = Context.getService(IpdService.class);
        Concept ipdConcept = Context.getConceptService().getConceptByName(
                Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        List<ConceptAnswer> list = (ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        if (CollectionUtils.isNotEmpty(list)) {
            Collections.sort(list, new ConceptAnswerComparator());
        }
        model.addAttribute("listIpd", list);
        IpdPatientAdmission admission = ipdService.getIpdPatientAdmission(admissionId);
        if (admission != null) {
            PersonAddress add = admission.getPatient().getPersonAddress();
            String address = add.getAddress1();
            //ghansham 25-june-2013 issue no # 1924 Change in the address format
            String district = add.getCountyDistrict();
            String upazila = add.getCityVillage();

            String doctorRoleProps = Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_NAME_DOCTOR_ROLE);
            Role doctorRole = Context.getUserService().getRole(doctorRoleProps);
            if (doctorRole != null) {
                List<User> listDoctor = Context.getUserService().getUsersByRole(doctorRole);
                model.addAttribute("listDoctor", listDoctor);
            }

            PersonAttribute relationNameattr = admission.getPatient().getAttribute("Father/Husband Name");

            PersonAttribute relationTypeattr = admission.getPatient().getAttribute("Relative Name Type");

            PersonAttribute maritalStatus  = admission.getPatient().getAttribute("Marital Status");

            PersonAttribute contactNumber = admission.getPatient().getAttribute("Phone Number");

            PersonAttribute emailAddress = admission.getPatient().getAttribute("Patient E-mail Address");

            PersonAttribute nationalID  = admission.getPatient().getAttribute("National ID");

            PersonAttribute patientCategory  = admission.getPatient().getAttribute("Payment Category");

            PersonAttribute fileNumber = admission.getPatient().getAttribute("File Number");

            model.addAttribute("address", StringUtils.isNotBlank(address) ? address : "");
            //  issue no # 1924 Change in the address format
            model.addAttribute("district", district);
            model.addAttribute("upazila", upazila);
            model.addAttribute("relationName", relationNameattr.getValue());
            if(fileNumber!=null){
                model.addAttribute("fileNumber", fileNumber.getValue());
            }


			/* this code modified under feedback of #290 for new patient it is working fine but for old patient it is giving null pointer
			                       exception.*/

           /* return "module/ipd/admissionForm";*/
        }

        /*return "redirect:/module/ipd/main.htm";*/
    }

}
