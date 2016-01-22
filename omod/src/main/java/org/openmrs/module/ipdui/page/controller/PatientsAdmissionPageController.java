package org.openmrs.module.ipdui.page.controller;

import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.ipdui.utils.IpdUtils;
import org.openmrs.ui.framework.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

/**
 * Created by ngarivictor on 1/6/2016.
 */
public class PatientsAdmissionPageController {

    //@RequestMapping(value = "/module/ipd/patientsForAdmission.htm", method = RequestMethod.GET)
    public void get(@RequestParam(value = "searchPatient", required = false) String searchPatient,//patient name or patient identifier
                    @RequestParam(value = "fromDate", required = false) String fromDate,
                    @RequestParam(value = "toDate", required = false) String toDate,
                    @RequestParam(value = "ipdWard", required = false) String ipdWard,
                    //    @RequestParam(value = "ipdWardString", required = false) String ipdWardString, //ipdWard multiselect
                    @RequestParam(value = "tab", required = false) Integer tab, //If that tab is active we will set that tab active when page load.
                    @RequestParam(value = "doctorString", required = false) String doctorString, Model model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);

        List<IpdPatientAdmission> listPatientAdmission = ipdService.searchIpdPatientAdmission(searchPatient,
                IpdUtils.convertStringToList(doctorString), fromDate, toDate, ipdWard, "");

        model.addAttribute("listPatientAdmission", listPatientAdmission);

    }
}
