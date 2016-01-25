package org.openmrs.module.ipdui.fragment.controller;


import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientQueueService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.Money;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.ipdui.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;

import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by ngarivictor on 1/19/2016.
 */
public class PatientAdmissionFragmentController {

    public void removeOrNoBed(@RequestParam(value = "admissionId", required = false) Integer admissionId, //If that tab is active we will set that tab active when page load.
                                @RequestParam(value = "action", required = false) Integer action, PageModel model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientQueueService queueService = Context.getService(PatientQueueService.class);
        IpdPatientAdmission admission = ipdService.getIpdPatientAdmission(admissionId);
        IpdPatientAdmissionLog patientAdmissionLog = new IpdPatientAdmissionLog();
        User user = Context.getAuthenticatedUser();
        EncounterType encounterType = Context.getService(HospitalCoreService.class).insertEncounterTypeByKey(
                HospitalCoreConstants.PROPERTY_IPDENCOUNTER);

        if (admission != null && (action == 1 || action == 2)) {

            //remove
            Date date = new Date();
            //copy admission to log

            patientAdmissionLog.setAdmissionDate(date);
            patientAdmissionLog.setAdmissionWard(admission.getAdmissionWard());
            patientAdmissionLog.setBirthDate(admission.getBirthDate());
            patientAdmissionLog.setGender(admission.getGender());
            patientAdmissionLog.setOpdAmittedUser(user);
            patientAdmissionLog.setOpdLog(admission.getOpdLog());
            patientAdmissionLog.setPatient(admission.getPatient());
            patientAdmissionLog.setPatientIdentifier(admission.getPatientIdentifier());
            patientAdmissionLog.setPatientName(admission.getPatientName());
            patientAdmissionLog.setStatus(IpdConstants.STATUS[action]);
            patientAdmissionLog.setIndoorStatus(1);


            //save ipd encounter

            Encounter encounter = new Encounter();
            Location location = new Location(1);
            encounter.setPatient(admission.getPatient());
            encounter.setCreator(user);
            encounter.setProvider(user);
            encounter.setEncounterDatetime(date);
            encounter.setEncounterType(encounterType);
            encounter.setLocation(location);
            encounter = Context.getEncounterService().saveEncounter(encounter);
            //done save ipd encounter
            patientAdmissionLog.setIpdEncounter(encounter);
            //Get Opd Obs Group
            Obs obsGroup = Context.getService(HospitalCoreService.class).getObsGroup(admission.getPatient());
            patientAdmissionLog.setOpdObsGroup(obsGroup);

            patientAdmissionLog = ipdService.saveIpdPatientAdmissionLog(patientAdmissionLog);

            if (patientAdmissionLog != null && patientAdmissionLog.getId() != null) {
                ipdService.removeIpdPatientAdmission(admission);
            }

            OpdPatientQueueLog opdPatientQueueLog=patientAdmissionLog.getOpdLog();
            opdPatientQueueLog.setVisitOutCome("no bed");
            queueService.saveOpdPatientQueueLog(opdPatientQueueLog);
        }

    }
    /*@RequestMapping(value = "/module/ipd/admission.htm", method = RequestMethod.GET)*/
    public void admission(@RequestParam(value = "admissionId", required = false) Integer admissionId, //If that tab is active we will set that tab active when page load.
                            PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        Concept ipdConcept = Context.getConceptService().getConceptByName(
                Context.getAdministrationService().getGlobalProperty(IpdConstants.PROPERTY_IPDWARD));
        model.addAttribute("listIpd", ipdConcept != null ? new ArrayList<ConceptAnswer>(ipdConcept.getAnswers()) : null);
        IpdPatientAdmission admission = ipdService.getIpdPatientAdmission(admissionId);
        if (admission != null) {
            PersonAddress add = admission.getPatient().getPersonAddress();
            String address = add.getAddress1();
            //ghansham 25-june-2013 issue no # 1924 Change in the address format
            String district = add.getCountyDistrict();
            String upazila = add.getCityVillage();

            String doctorRoleProps = Context.getAdministrationService().getGlobalProperty(
                    IpdConstants.PROPERTY_NAME_DOCTOR_ROLE);
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
