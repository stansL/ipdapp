package org.openmrs.module.ipdui.page.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.commons.lang.math.NumberUtils;
import org.openmrs.*;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.BillingService;
import org.openmrs.module.hospitalcore.HospitalCoreService;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.PatientDashboardService;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ConceptAnswerComparator;
import org.openmrs.module.hospitalcore.util.HospitalCoreConstants;
import org.openmrs.module.hospitalcore.util.Money;
import org.openmrs.module.hospitalcore.util.PatientUtils;
import org.openmrs.module.ipdui.utils.IpdConstants;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestParam;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Array;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;

import java.util.Date;
import java.util.List;

/**
 * Created by ngarivictor on 1/25/2016.
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
            String pname = add.getPerson().getGivenName();

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

            model.addAttribute("admission",admission);
            model.addAttribute("address", StringUtils.isNotBlank(address) ? address : "");
            //  issue no # 1924 Change in the address format
            model.addAttribute("district", district);
            model.addAttribute("upazila", upazila);
            model.addAttribute("name", pname);
            model.addAttribute("relationName", relationNameattr.getValue());
            if(fileNumber!=null){
                model.addAttribute("fileNumber", fileNumber.getValue());
            }

        }

    }

    public void post(HttpServletRequest request, PageModel model) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        int id = NumberUtils.toInt(request.getParameter("id"));
        IpdPatientAdmission admission = ipdService.getIpdPatientAdmission(id);

        String caste = request.getParameter("caste");
        String basicPay = request.getParameter("basicPay");
        int admittedWard = NumberUtils.toInt(request.getParameter("admittedWard"), 0);
        String bedNumber = request.getParameter("bedNumber");
        String fileNumber = request.getParameter("fileNumber");
        String comments = request.getParameter("comments");
        String chief = request.getParameter("chief");
        String subChief = request.getParameter("subChief");
        String religion = request.getParameter("religion");

        int treatingDoctor = NumberUtils.toInt(request.getParameter("treatingDoctor"), 0);

        //PersonAttribute relationNameattr = null;
        String fathername = "";
        String relationshipType = "";

        User treatingD = null;
        try {

            Date date = new Date();

            //copy admission to log
            IpdPatientAdmissionLog patientAdmissionLog = new IpdPatientAdmissionLog();
            patientAdmissionLog.setAdmissionDate(date);
            patientAdmissionLog.setAdmissionWard(Context.getConceptService().getConcept(admittedWard));
            patientAdmissionLog.setBirthDate(admission.getPatient().getBirthdate());
            patientAdmissionLog.setGender(admission.getPatient().getGender());
            patientAdmissionLog.setOpdAmittedUser(Context.getAuthenticatedUser());
            patientAdmissionLog.setOpdLog(admission.getOpdLog());
            patientAdmissionLog.setPatient(admission.getPatient());
            patientAdmissionLog.setPatientIdentifier(admission.getPatientIdentifier());
            patientAdmissionLog.setPatientName(admission.getPatientName());
            patientAdmissionLog.setStatus(IpdConstants.STATUS[0]);
            patientAdmissionLog.setIndoorStatus(1);

            //save ipd encounter
            User user = Context.getAuthenticatedUser();
            EncounterType encounterType = Context.getService(HospitalCoreService.class).insertEncounterTypeByKey(
                    HospitalCoreConstants.PROPERTY_IPDENCOUNTER);

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

                BillingService billingService = Context.getService(BillingService.class);
                Patient patient=admission.getPatient();
                IndoorPatientServiceBill bill = new IndoorPatientServiceBill();

                bill.setCreatedDate(new Date());
                bill.setPatient(patient);
                bill.setCreator(Context.getAuthenticatedUser());

                IndoorPatientServiceBillItem item;
                int quantity = 1;
                Money itemAmount;
                Money mUnitPrice;
                Money totalAmount = new Money(BigDecimal.ZERO);
                BigDecimal totalActualAmount = new BigDecimal(0);
                BillableService service;

                ArrayList<Concept> al=new ArrayList<Concept>();
                Concept concept1=Context.getConceptService().getConcept("ADMISSION FEE");
                Concept concept2=Context.getConceptService().getConcept("CATERING FEE");
                al.add(concept1);
                al.add(concept2);
                for(Concept c:al){
                    service = billingService.getServiceByConceptId(c.getConceptId());

                    mUnitPrice = new Money(service.getPrice());
                    itemAmount = mUnitPrice.times(quantity);
                    totalAmount = totalAmount.plus(itemAmount);

                    item = new IndoorPatientServiceBillItem();
                    item.setCreatedDate(new Date());
                    item.setName(service.getName());
                    item.setIndoorPatientServiceBill(bill);
                    item.setQuantity(quantity);
                    item.setService(service);
                    item.setUnitPrice(service.getPrice());
                    item.setAmount(itemAmount.getAmount());
                    item.setActualAmount(itemAmount.getAmount());
                    totalActualAmount = totalActualAmount.add(item.getActualAmount());

                    bill.addBillItem(item);
                }
                bill.setAmount(totalAmount.getAmount());
                bill.setActualAmount(totalActualAmount);
                bill.setEncounter(admission.getIpdEncounter());
                bill = billingService.saveIndoorPatientServiceBill(bill);

                ipdService.removeIpdPatientAdmission(admission);
            }

            PersonAddress add = admission.getPatient().getPersonAddress();

            String address = add.getAddress1();
            // ghansham 25-june-2013 issue no # 1924 Change in the address format
            String district = add.getCountyDistrict();
            String upazila = add.getCityVillage();
            model.addAttribute("address", StringUtils.isNotBlank(address) ? address : "");
            model.addAttribute("district", district);
            model.addAttribute("upazila", upazila);

            PersonAttribute relationNameattr = admission.getPatient().getAttribute("Father/Husband Name");
            PersonAttribute relationTypeattr = admission.getPatient().getAttribute("Relative Name Type");

            model.addAttribute("relationName", relationNameattr.getValue());
            if(relationTypeattr!=null){
                model.addAttribute("relationType", relationTypeattr.getValue());
            }
            else{
                model.addAttribute("relationType", "Relative Name");
            }



            PersonAttribute fileNumber_old = admission.getPatient().getAttribute("File Number");
            if(fileNumber_old!=null){
                model.addAttribute("fileNumber", fileNumber_old.getValue());
            }
            else{
                PersonAttributeType type = Context.getPersonService().getPersonAttributeTypeByName("File Number");
                PersonAttribute attribute = new PersonAttribute();
                attribute.setAttributeType(type);
                attribute.setValue(fileNumber);
                Patient patient=admission.getPatient();
                patient.addAttribute(attribute);
                model.addAttribute("fileNumber", fileNumber);
            }


            model.addAttribute("dateAdmission", date);

            //save in admitted
            IpdPatientAdmitted admitted = new IpdPatientAdmitted();
            admitted.setAdmissionDate(date);
            admitted.setAdmittedWard(Context.getConceptService().getConcept(admittedWard));
            admitted.setBasicPay(basicPay);
            admitted.setBed(bedNumber);
            admitted.setComments(comments);
            admitted.setBirthDate(admission.getPatient().getBirthdate());
            admitted.setCaste(caste);
            if (relationNameattr != null) {
                fathername = relationNameattr.getValue();
            }
            admitted.setFatherName(fathername);
            if (relationTypeattr != null) {
                relationshipType = relationTypeattr.getValue();
            }
            else{
                relationshipType = "Relative Name";
            }

            admitted.setRelationshipType(relationshipType);
            admitted.setGender(admission.getPatient().getGender());

            treatingD = Context.getUserService().getUser(treatingDoctor);

            admitted.setIpdAdmittedUser(treatingD);
            if(patientAdmissionLog!=null){
                admitted.setPatient(patientAdmissionLog.getPatient());
            }
            admitted.setPatientAddress(StringUtils.isNotBlank(address) ? address : "");
            admitted.setPatientAdmissionLog(patientAdmissionLog);
            admitted.setPatientIdentifier(admission.getPatientIdentifier());
            admitted.setPatientName(admission.getPatientName());
            admitted.setStatus(IpdConstants.STATUS[0]);
            admitted.setUser(Context.getAuthenticatedUser());
            admitted.setChief(chief);
            admitted.setSubChief(subChief);
            admitted.setReligion(religion);
            admitted = ipdService.saveIpdPatientAdmitted(admitted);
            HospitalCoreService hospitalCoreService = (HospitalCoreService) Context.getService(HospitalCoreService.class);
            PatientSearch patientSearch = hospitalCoreService.getPatient(patientAdmissionLog.getPatient().getPatientId());
            patientSearch.setAdmitted(true);
            hospitalCoreService.savePatientSearch(patientSearch);
            model.addAttribute("admitted", admitted);

            //delete admission
        }
        catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("message", e.getMessage());
           /* return "module/ipd/admissionForm";*/
        }
        model.addAttribute("treatingDoctor", treatingD);
        model.addAttribute("relationName", fathername);
        model.addAttribute("relationType", relationshipType);
        model.addAttribute("message", "Succesfully");
        model.addAttribute("urlS", "main.htm");

        // patient category
        model.addAttribute("patCategory", PatientUtils.getPatientCategory(admission.getPatient()));

        PersonAttribute contactNumber = admission.getPatient().getAttribute("Phone Number");

        PersonAttribute emailAddress = admission.getPatient().getAttribute("Patient E-mail Address");

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

        /*patient is accepted into the ward*/
        int acceptStatus = 1;
        PatientDashboardService patientDashboardService = Context.getService(PatientDashboardService.class);

        if (admission != null) {
            admission.setAcceptStatus(acceptStatus);
            EncounterType encounterType = Context.getService(HospitalCoreService.class).insertEncounterTypeByKey(
                    HospitalCoreConstants.PROPERTY_IPDENCOUNTER);

            Encounter encounter = new Encounter();
            Date date = new Date();
            User user = Context.getAuthenticatedUser();
            Location location = new Location(1);
            encounter.setPatient(admission.getPatient());
            encounter.setCreator(user);
            encounter.setProvider(user);
            encounter.setEncounterDatetime(date);
            encounter.setEncounterType(encounterType);
            encounter.setLocation(location);
            encounter = Context.getEncounterService().saveEncounter(encounter);
            admission.setIpdEncounter(encounter);
            ipdService.saveIpdPatientAdmission(admission);
        }

    }

}
