package org.openmrs.module.ipdui.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.ui.framework.Model;
import org.springframework.web.bind.annotation.RequestParam;

/**
 * Created by Francis on 1/7/2016.
 */
public class PatientInfoPageController {
    public void get(@RequestParam(required = false) int searchPatientID, Model model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);

        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(searchPatientID);
        model.addAttribute("patientInformation", patientInformation);

    }
}
