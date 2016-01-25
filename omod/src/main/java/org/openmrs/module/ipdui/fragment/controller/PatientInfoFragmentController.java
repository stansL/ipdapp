package org.openmrs.module.ipdui.fragment.controller;

import org.apache.commons.collections.CollectionUtils;
import org.apache.commons.lang.ArrayUtils;
import org.openmrs.*;
import org.openmrs.api.AdministrationService;
import org.openmrs.api.ConceptService;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.*;
import org.openmrs.module.hospitalcore.model.*;
import org.openmrs.module.hospitalcore.util.ConceptComparator;
import org.openmrs.module.hospitalcore.util.PatientDashboardConstants;
import org.openmrs.module.ipdui.model.Procedure;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.*;

/**
 * Created by Francis on 1/12/2016.
 */
public class PatientInfoFragmentController {
    //get the list of procedures starting with a certain string
    public List<SimpleObject> getProcedures(@RequestParam(value = "q") String name, UiUtils ui) {
        List<Concept> procedures = Context.getService(PatientDashboardService.class).searchProcedure(name);
        List<Procedure> proceduresPriority = new ArrayList<Procedure>();
        for (Concept myConcept : procedures) {
            proceduresPriority.add(new Procedure(myConcept));
        }

        List<SimpleObject> proceduresList = SimpleObject.fromCollection(proceduresPriority, ui, "id", "label", "schedulable");
        return proceduresList;
    }
    public List<SimpleObject> getInvestigations(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> investigations = Context.getService(PatientDashboardService.class).searchInvestigation(name);
        List<SimpleObject> investigationsList = SimpleObject.fromCollection(investigations, ui, "id", "name");
        return investigationsList;
    }
    public List<SimpleObject> getDrugs(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<InventoryDrug> drugs = Context.getService(PatientDashboardService.class).findDrug(name);
        List<SimpleObject> drugList = SimpleObject.fromCollection(drugs, ui, "id", "name");
        return drugList;
    }
    public List<SimpleObject> getFormulationByDrugName(@RequestParam(value="drugName") String drugName,UiUtils ui)
    {

        InventoryCommonService inventoryCommonService = (InventoryCommonService) Context.getService(InventoryCommonService.class);
        InventoryDrug drug = inventoryCommonService.getDrugByName(drugName);

        List<SimpleObject> formulationsList = null;

        if(drug != null){
            List<InventoryDrugFormulation> formulations = new ArrayList<InventoryDrugFormulation>(drug.getFormulations());
            formulationsList = SimpleObject.fromCollection(formulations, ui, "id", "name");
        }

        return formulationsList;
    }

    public List<SimpleObject> getDiagnosis(@RequestParam(value="q") String name,UiUtils ui)
    {
        List<Concept> diagnosis = Context.getService(PatientDashboardService.class).searchDiagnosis(name);

        List<SimpleObject> diagnosisList = SimpleObject.fromCollection(diagnosis, ui, "id", "name");
        return diagnosisList;
    }
    
    public void requestForDischarge(@RequestParam(value = "id", required = false) Integer admittedId,
                                    @RequestParam(value = "ipdWard", required = false) String ipdWard,
                                    @RequestParam(value = "obStatus", required = false) Integer obStatus) {

        int requestForDischargeStatus = 1;
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        IpdPatientAdmitted admitted = ipdService.getIpdPatientAdmitted(admittedId);

        IpdPatientAdmissionLog ipal = admitted.getPatientAdmissionLog();
        ipal.setAbsconded(obStatus);

        admitted.setRequestForDischargeStatus(requestForDischargeStatus);
        admitted.setAbsconded(obStatus);

        if(obStatus==1){
            Date date = new Date();
            admitted.setAbscondedDate(date);
        }

        admitted=ipdService.saveIpdPatientAdmitted(admitted);
        IpdPatientAdmissionLog ipdPatientAdmissionLog=admitted.getPatientAdmissionLog();
        ipdPatientAdmissionLog.setRequestForDischargeStatus(requestForDischargeStatus);
        ipdService.saveIpdPatientAdmissionLog(ipdPatientAdmissionLog);
    }

    public void transferPatient(@RequestParam("admittedId") Integer id,
                                @RequestParam("toWard") Integer toWardId,
                                @RequestParam("doctor") Integer doctorId,
                                @RequestParam(value = "bedNumber", required = false) String bed,
                                @RequestParam(value = "comments", required = false) String comments,
                                PageModel model){
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        ipdService.transfer(id, toWardId, doctorId, bed,comments);

    }
    public void saveVitalStatistics(@RequestParam("admittedId") Integer admittedId,
                                    @RequestParam("patientId") Integer patientId,
                                    @RequestParam(value = "bloodPressure", required = false) String bloodPressure,
                                    @RequestParam(value = "pulseRate", required = false) String pulseRate,
                                    @RequestParam(value = "temperature", required = false) String temperature,
                                    @RequestParam(value = "dietAdvised", required = false) String dietAdvised,
                                    @RequestParam(value = "notes", required = false) String notes,
                                    @RequestParam(value = "ipdWard", required = false) String ipdWard,PageModel model)
    {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getPatientService();
        Patient patient = patientService.getPatient(patientId);
        IpdPatientAdmitted admitted = ipdService.getIpdPatientAdmitted(admittedId);
        IpdPatientVitalStatistics ipdPatientVitalStatistics=new IpdPatientVitalStatistics();
        ipdPatientVitalStatistics.setPatient(patient);
        ipdPatientVitalStatistics.setIpdPatientAdmissionLog(admitted.getPatientAdmissionLog());
        ipdPatientVitalStatistics.setBloodPressure(bloodPressure);
        ipdPatientVitalStatistics.setPulseRate(pulseRate);
        ipdPatientVitalStatistics.setTemperature(temperature);
        ipdPatientVitalStatistics.setDietAdvised(dietAdvised);
        ipdPatientVitalStatistics.setNote(notes);
        ipdPatientVitalStatistics.setCreator(Context.getAuthenticatedUser().getUserId());
        ipdPatientVitalStatistics.setCreatedOn(new Date());
        ipdService.saveIpdPatientVitalStatistics(ipdPatientVitalStatistics);
    }
    public void dischargePatient( @RequestParam(value ="dischargeAdmittedID", required = false) Integer dischargeAdmittedID,
                                  @RequestParam(value ="patientId", required = false) Integer patientId,
                                  @RequestParam(value ="selectedDiagnosisList[]", required = false) Integer[] selectedDiagnosisList,
                                  @RequestParam(value ="selectedDischargeProcedureList[]", required = false) Integer[] selectedDischargeProcedureList,
                                  @RequestParam(value ="dischargeOutcomes", required = false) Integer dischargeOutcomes,
                                  @RequestParam(value ="otherDischargeInstructions", required = false) String otherDischargeInstructions
    ){

        HospitalCoreService hospitalCoreService = (HospitalCoreService) Context.getService(HospitalCoreService.class);
        PatientQueueService queueService = Context.getService(PatientQueueService.class);
        PatientSearch patientSearch = hospitalCoreService.getPatient(patientId);

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);

        if (Context.getConceptService().getConcept(dischargeOutcomes).getName().getName().equalsIgnoreCase("DEATH")) {

            ConceptService conceptService = Context.getConceptService();
            Concept causeOfDeath = conceptService.getConceptByName("NONE");
            hospitalCoreService.savePatientSearch(patientSearch);
            PatientService ps=Context.getPatientService();
            Patient patient = ps.getPatient(patientId);
            patient.setDead(true);
            patient.setDeathDate(new Date());
            patient.setCauseOfDeath(causeOfDeath);
            ps.savePatient(patient);
            patientSearch.setDead(true);
            patientSearch.setAdmitted(false);
            hospitalCoreService.savePatientSearch(patientSearch);
        }
        else{
            patientSearch.setAdmitted(false);
            hospitalCoreService.savePatientSearch(patientSearch);
        }

        AdministrationService administrationService = Context.getAdministrationService();
        GlobalProperty gpDiagnosis = administrationService
                .getGlobalPropertyObject(PatientDashboardConstants.PROPERTY_PROVISIONAL_DIAGNOSIS);
        GlobalProperty procedure = administrationService
                .getGlobalPropertyObject(PatientDashboardConstants.PROPERTY_POST_FOR_PROCEDURE);
        ConceptService conceptService = Context.getConceptService();
        Concept cDiagnosis = conceptService.getConceptByName(gpDiagnosis.getPropertyValue());
        Concept cProcedure = conceptService.getConceptByName(procedure.getPropertyValue());
        IpdPatientAdmitted admitted = ipdService.getIpdPatientAdmitted(dischargeAdmittedID);
        Encounter ipdEncounter = admitted.getPatientAdmissionLog().getIpdEncounter();
        List<Obs> listObsOfIpdEncounter = new ArrayList<Obs>(ipdEncounter.getAllObs());
        Location location = new Location(1);

        User user = Context.getAuthenticatedUser();
        Date date = new Date();
        //diagnosis

        Set<Obs> obses = new HashSet(ipdEncounter.getAllObs());

        ipdEncounter.setObs(null);

        List<Concept> listConceptDianosisOfIpdEncounter = new ArrayList<Concept>();
        List<Concept> listConceptProcedureOfIpdEncounter = new ArrayList<Concept>();
        if (CollectionUtils.isNotEmpty(listObsOfIpdEncounter)) {
            for (Obs obx : obses) {
                if (obx.getConcept().getConceptId().equals(cDiagnosis.getConceptId())) {
                    listConceptDianosisOfIpdEncounter.add(obx.getValueCoded());
                }

                if (obx.getConcept().getConceptId().equals( cProcedure.getConceptId())) {
                    listConceptProcedureOfIpdEncounter.add(obx.getValueCoded());
                }
            }
        }

        List<Concept> listConceptDiagnosis = new ArrayList<Concept>();

        if(selectedDiagnosisList!=null){
            for (Integer cId : selectedDiagnosisList) {
                Concept cons = conceptService.getConcept(cId);
                listConceptDiagnosis.add(cons);
                //if (!listConceptDianosisOfIpdEncounter.contains(cons)) {
                Obs obsDiagnosis = new Obs();
                //obsDiagnosis.setObsGroup(obsGroup);
                obsDiagnosis.setConcept(cDiagnosis);
                obsDiagnosis.setValueCoded(cons);
                obsDiagnosis.setCreator(user);
                obsDiagnosis.setObsDatetime(date);
                obsDiagnosis.setLocation(location);
                obsDiagnosis.setDateCreated(date);
                obsDiagnosis.setPatient(ipdEncounter.getPatient());
                obsDiagnosis.setEncounter(ipdEncounter);
                obsDiagnosis = Context.getObsService().saveObs(obsDiagnosis, "update obs diagnosis if need");
                obses.add(obsDiagnosis);
                //}
            }
        }
        List<Concept> listConceptProcedure = new ArrayList<Concept>();
        if (!ArrayUtils.isEmpty(selectedDischargeProcedureList)) {

            if (cProcedure == null) {
                try {
                    throw new Exception("Post for procedure concept null");
                }
                catch (Exception e) {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
            for (Integer pId : selectedDischargeProcedureList) {
                Concept cons = conceptService.getConcept(pId);
                listConceptProcedure.add(cons);
                //if (!listConceptProcedureOfIpdEncounter.contains(cons)) {
                Obs obsProcedure = new Obs();
                //obsDiagnosis.setObsGroup(obsGroup);
                obsProcedure.setConcept(cProcedure);
                obsProcedure.setValueCoded(conceptService.getConcept(pId));
                obsProcedure.setCreator(user);
                obsProcedure.setObsDatetime(date);
                obsProcedure.setLocation(location);
                obsProcedure.setPatient(ipdEncounter.getPatient());
                obsProcedure.setDateCreated(date);
                obsProcedure.setEncounter(ipdEncounter);
                obsProcedure = Context.getObsService().saveObs(obsProcedure, "update obs diagnosis if need");
                //ipdEncounter.addObs(obsProcedure);
                obses.add(obsProcedure);
                //}
            }

        }
        ipdEncounter.setObs(obses);

        Context.getEncounterService().saveEncounter(ipdEncounter);


        IpdPatientAdmittedLog ipdPatientAdmittedLog=ipdService.discharge(dischargeAdmittedID, dischargeOutcomes, otherDischargeInstructions );
        OpdPatientQueueLog opdPatientQueueLog=ipdPatientAdmittedLog.getPatientAdmissionLog().getOpdLog();
        opdPatientQueueLog.setVisitOutCome("DISCHARGE ON REQUEST");
        queueService.saveOpdPatientQueueLog(opdPatientQueueLog);
        Encounter encounter=ipdPatientAdmittedLog.getPatientAdmissionLog().getIpdEncounter();
        BillingService billingService = (BillingService) Context.getService(BillingService.class);
        PatientServiceBill patientServiceBill=billingService.getPatientServiceBillByEncounter(encounter);
        patientServiceBill.setDischargeStatus(1);
        billingService.savePatientServiceBill(patientServiceBill);

    }
}
