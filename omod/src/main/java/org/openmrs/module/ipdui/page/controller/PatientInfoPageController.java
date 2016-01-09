package org.openmrs.module.ipdui.page.controller;

import org.openmrs.Patient;
import org.openmrs.api.PatientService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.ui.framework.page.PageModel;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by Francis on 1/7/2016.
 */
public class PatientInfoPageController {
    public void get(@RequestParam(value = "search",required = true) String search, PageModel model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);
        PatientService patientService = Context.getService(PatientService.class);

        List<Patient> patientList = patientService.getPatients(null,search, null, true,null,null);
        IpdPatientAdmitted patientInformation = ipdService.getAdmittedByPatientId(patientList.get(0).getPatientId());
        model.addAttribute("patientInformation",patientInformation );

    }

}
