package org.openmrs.module.ipdui.page.controller;

import org.openmrs.PersonAddress;
import org.openmrs.PersonAttribute;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmission;
import org.openmrs.module.hospitalcore.model.IpdPatientAdmitted;
import org.openmrs.module.ipdui.utils.IpdUtils;
import org.openmrs.ui.framework.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Created by ngarivictor,francisgithae on 1/6/2016.
 */
public class PatientsAdmissionPageController {

    //@RequestMapping(value = "/module/ipd/patientsForAdmission.htm", method = RequestMethod.GET)
    public void get(@RequestParam(value = "searchPatient", required = false) String searchPatient,//patient name or patient identifier
                    @RequestParam(value = "fromDate", required = false) String fromDate,
                    @RequestParam(value = "toDate", required = false) String toDate,
                    @RequestParam(value = "ipdWard", required = false) String ipdWard,
                    @RequestParam(value = "ipdWardString", required = false) String ipdWardString, //ipdWard multiselect
                    @RequestParam(value = "tab", required = false) Integer tab, //If that tab is active we will set that tab active when page load.
                    @RequestParam(value = "doctorString", required = false) String doctorString, Model model) {

        IpdService ipdService = (IpdService) Context.getService(IpdService.class);

        List<IpdPatientAdmission> listPatientAdmission = ipdService.searchIpdPatientAdmission(searchPatient,
                IpdUtils.convertStringToList(doctorString), fromDate, toDate, ipdWard, "");

        model.addAttribute("listPatientAdmission", listPatientAdmission);

        List<IpdPatientAdmitted> listPatientAdmitted = ipdService.searchIpdPatientAdmitted(searchPatient,
                IpdUtils.convertStringToList(doctorString), fromDate, toDate, ipdWardString, "");

        /*Sagar Bele 08-08-2012 Support #327 [IPD] (DDU(SDMX)instance) snapshot- age column in IPD admitted patient index */
        model.addAttribute("listPatientAdmitted", listPatientAdmitted);

        Map<Integer, String> mapRelationName = new HashMap<Integer, String>();
        Map<Integer, String> mapRelationType = new HashMap<Integer, String>();
        for (IpdPatientAdmitted admit : listPatientAdmitted) {
            PersonAttribute relationNameattr = admit.getPatient().getAttribute("Father/Husband Name");
            //ghanshyam 10/07/2012 New Requirement #312 [IPD] Add fields in the Discharge screen and print out
            PersonAddress add =admit.getPatient().getPersonAddress();
            String address1 = add.getAddress1();
            if(address1!=null){
                String address = " " + add.getAddress1() +" " + add.getCountyDistrict() + " " + add.getCityVillage();
                model.addAttribute("address", address);
            }
            else{
                String address = " " + add.getCountyDistrict() + " " + add.getCityVillage();
                model.addAttribute("address", address);
            }
            PersonAttribute relationTypeattr = admit.getPatient().getAttribute("Relative Name Type");
            //ghanshyam 30/07/2012 this code modified under feedback of 'New Requirement #313'
            if(relationTypeattr!=null){
                mapRelationType.put(admit.getId(), relationTypeattr.getValue());
            }
            else{
                mapRelationType.put(admit.getId(), "Relative Name");
            }
            mapRelationName.put(admit.getId(), relationNameattr.getValue());
        }
        model.addAttribute("mapRelationName", mapRelationName);
        model.addAttribute("mapRelationType", mapRelationType);
        model.addAttribute("dateTime", new Date().toString());



    }
}
