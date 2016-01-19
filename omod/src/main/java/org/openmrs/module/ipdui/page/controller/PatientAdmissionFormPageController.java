package org.openmrs.module.ipdui.page.controller;

import org.apache.commons.lang.StringUtils;
import org.openmrs.*;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.ipdui.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by ngarivictor on 1/18/2016.
 */
public class PatientAdmissionFormPageController {
    public void get(@RequestParam(value = "admissionId", required = false) String patientId, //If that tab is active we will set that tab active when page load.
                    PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getService(PatientService.class);

        List<Patient> patientList = patientService.getPatients(null,patientId, null, true,null,null);
        Concept ipdConcept = Context.getConceptService().getConceptByName(
                Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        model.addAttribute("listIpd", ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);

        Patient mypatienttest = patientList.get(0);

        IpdPatientAdmission admission = ipdService.getIpdPatientAdmissionByPatientId(patientList.get(0));

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

            model.addAttribute("district", district);
            model.addAttribute("upazila", upazila);
            model.addAttribute("relationName", relationNameattr.getValue());
            if(fileNumber!=null){
                model.addAttribute("fileNumber", fileNumber.getValue());
            }
            if(relationTypeattr!=null){
                model.addAttribute("relationType", relationTypeattr.getValue());
            }
            else{
                model.addAttribute("relationType", "Relative Name");
            }

            model.addAttribute("admission", admission);

            model.addAttribute("dateAdmission", new Date());

            // patient category
            model.addAttribute("patCategory", PatientUtils.getPatientCategory(admission.getPatient()));

            model.addAttribute("maritalStatus", maritalStatus.getValue());

            if(contactNumber!=null){
                model.addAttribute("contactNumber", contactNumber.getValue());
            }
            else{
                model.addAttribute("contactNumber", "");
            }

            if(emailAddress!=null){
                model.addAttribute("emailAddress", emailAddress.getValue());
            }
            else{
                model.addAttribute("emailAddress", "");
            }

            if(nationalID!=null){
                model.addAttribute("nationalID", nationalID.getValue());
            }
            else{
                model.addAttribute("nationalID", "");
            }

            model.addAttribute("patientCategory", patientCategory.getValue());

        }

    }
}

