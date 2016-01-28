package org.openmrs.module.ipdui.model;

import java.util.List;

/**
 * Created by Francis on 1/28/2016.
 */
public class PrescriptionList {
    public List<Prescription> getPrescriptionList() {
        return prescriptionList;
    }

    public void setPrescriptionList(List<Prescription> prescriptionList) {
        this.prescriptionList = prescriptionList;
    }

    private List<Prescription> prescriptionList;

}
