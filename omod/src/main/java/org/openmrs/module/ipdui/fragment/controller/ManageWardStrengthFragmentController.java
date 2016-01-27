package org.openmrs.module.ipdui.fragment.controller;

import org.openmrs.Concept;
import org.openmrs.ConceptAnswer;
import org.openmrs.api.ConceptService;
import org.openmrs.api.context.Context;
import org.openmrs.module.hospitalcore.IpdService;
import org.openmrs.module.hospitalcore.model.WardBedStrength;
import org.openmrs.ui.framework.page.PageModel;


import javax.servlet.http.HttpServletRequest;
import java.util.Collection;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

/**
 * Created by USER on 1/27/2016.
 */
public class ManageWardStrengthFragmentController {
/*
    @RequestMapping(value = "module/ipd/manageWardStrengthController.htm", method = RequestMethod.GET)
*/
    public void get(PageModel model) {

        ConceptService cs = Context.getConceptService();
        IpdService ipdService = (IpdService) Context
                .getService(IpdService.class);
        Map<Integer, Integer> bedStrengthMap = new HashMap<Integer, Integer>();

        Concept concept = cs.getConceptByName("IPD WARD");

        Collection<ConceptAnswer> wards = concept.getAnswers();
        for (ConceptAnswer ward : wards) {
//			System.out.println(ward.getAnswerConcept().getId());

            WardBedStrength wardBedStrength = ipdService
                    .getWardBedStrengthByWardId(ward.getAnswerConcept().getId());

            if (wardBedStrength != null) {
                bedStrengthMap.put(ward.getAnswerConcept().getId(),
                        wardBedStrength.getBedStrength());
            }
        }

        for (Integer key : bedStrengthMap.keySet()) {
//				System.out.println("IPD:bedno=" + key + "bedcount="	+ bedStrengthMap.get(key));
        }

        model.addAttribute("wards", wards);
        model.addAttribute("bedStrengthMap", bedStrengthMap);
        /*return "module/ipd/manageWardStrength";*/
    }
/*
    @RequestMapping(value = "module/ipd/manageWardStrengthController.htm", method = RequestMethod.POST)
*/
    public void post(HttpServletRequest request, PageModel model) {

        ConceptService cs = Context.getConceptService();
        IpdService ipdService = (IpdService) Context
                .getService(IpdService.class);
        Concept concept = cs.getConceptByName("IPD WARD");
        Integer bedStrength = 0;
        Collection<ConceptAnswer> wards = concept.getAnswers();
        WardBedStrength wardBedStrength = null;
        for (ConceptAnswer ward : wards) {
//			System.out.println(ward.getAnswerConcept().getId());
            String bedStrengthRequest = request.getParameter(""
                    + ward.getAnswerConcept().getId());
            if (bedStrengthRequest != null
                    && !bedStrengthRequest.equalsIgnoreCase("")) {
                bedStrength = Integer.parseInt(bedStrengthRequest);

                wardBedStrength = ipdService.getWardBedStrengthByWardId(ward
                        .getAnswerConcept().getId());
                if (wardBedStrength == null) {
                    wardBedStrength = new WardBedStrength();
                }
                wardBedStrength.setWard(ward.getAnswerConcept());
                wardBedStrength.setBedStrength(bedStrength);
                wardBedStrength.setCreatedOn(new Date());
                wardBedStrength.setCreatedBy(Context.getAuthenticatedUser());
                ipdService.saveWardBedStrength(wardBedStrength);

            }

        }

/*
        return "redirect:manageWardStrengthController.htm";
*/
    }


}
