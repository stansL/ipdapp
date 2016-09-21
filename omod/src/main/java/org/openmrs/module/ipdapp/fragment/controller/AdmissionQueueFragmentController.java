package org.openmrs.module.ipdapp.fragment.controller;

import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.ipdapp.utils.IpdUtils;
import org.openmrs.ui.framework.SimpleObject;
import org.openmrs.ui.framework.UiUtils;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.List;

/**
 * Created by daugm on 9/21/2016.
 */

public class AdmissionQueueFragmentController {
    public void controller() {
    }

    public List<SimpleObject> listAdmissionQueuePatients(@RequestParam("ipdWard") String ipdWard,
                                                         @RequestParam(value = "searchPatient", required = false) String searchPatient,
                                                         @RequestParam(value = "fromDate", required = false) String fromDate,
                                                         @RequestParam(value = "toDate", required = false) String toDate,
                                                         @RequestParam(value = "doctorString", required = false) String doctorString,
                                                         UiUtils uiUtils) {
        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        List<IpdPatientAdmission> admissionQueue = ipdService.searchIpdPatientAdmission(searchPatient,
                IpdUtils.convertStringToList(doctorString), fromDate, toDate, ipdWard, "");

        return SimpleObject.fromCollection(admissionQueue, uiUtils, "id", "admissionDate", "patient", "patientName", "patientIdentifier", "birthDate", "gender", "admissionWard", "status", "opdAmittedUser", "opdLog", "acceptStatus", "ipdEncounter");
    }
}
