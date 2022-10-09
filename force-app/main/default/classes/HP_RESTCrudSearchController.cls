public with sharing class HP_RESTCrudSearchController {

    public HP_DoctorWrapperWerka doctor { get; set; }
    public HP_DoctorWrapperWerka doctorToAdd { get; set; }
    public HP_DoctorWrapperWerka doctorToUpdate { get; set; }
    public HP_DoctorWrapperWerka doctorToDelete { get; set; }
    public List<HP_DoctorWrapperWerka> doctorList { get; set; }
    public Integer numberOfRecords { get; set; }
    public Integer doctorsPerPageOptionsValue { get; set; }
    public Integer offsetNumber { get; set; }
    public String deleteDoctorId { get; set; }
    public String updateDoctorId { get; set; }

    private String basicUrl = 'callout:Werka_Org/services/apexrest/Hs_Crud?';

    public HP_RESTCrudSearchController() {
        doctorsPerPageOptionsValue = 10;
        offsetNumber = 0;
        numberOfRecords = 0;
        doctor = new HP_DoctorWrapperWerka();
        doctorToAdd = new HP_DoctorWrapperWerka();
        doctorToUpdate = new HP_DoctorWrapperWerka();
        doctorList = new List<HP_DoctorWrapperWerka>();
    }

    public void clearResults() {
        doctorList.clear();
        offsetNumber = 0;
        numberOfRecords = 0;
    }

    public void changeRecordPerPageTo10() {
        doctorsPerPageOptionsValue = 10;
        offsetNumber = 0;
        searchDoctors();
    }
    public void changeRecordPerPageTo20() {
        doctorsPerPageOptionsValue = 20;
        offsetNumber = 0;
        searchDoctors();
    }
    public void changeRecordPerPageTo50() {
        doctorsPerPageOptionsValue = 50;
        offsetNumber = 0;
        searchDoctors();
    }

    public void firstPage() {
        offsetNumber = 0;
        searchDoctors();
    }
    public void previousPage() {
        offsetNumber = offsetNumber - doctorsPerPageOptionsValue;
        searchDoctors();
    }
    public void nextPage() {
        offsetNumber = offsetNumber + doctorsPerPageOptionsValue;
        searchDoctors();
    }
    public void lastPage() {
        offsetNumber = numberOfRecords - Math.Mod(numberOfRecords, doctorsPerPageOptionsValue);
        searchDoctors();
    }

    public void updateDoctor() {

        String endpoint = basicUrl.removeEnd('?') + '/' + HP_REST_CRUD_Helper.getDoctorToUpdateId(doctorList, doctorToUpdate);

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);

        request.setMethod('PATCH');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        request.setBody(HP_REST_CRUD_Helper.serializedDoctorToUpdate(doctorToUpdate));

        System.debug(HP_REST_CRUD_Helper.serializedDoctorToUpdate(doctorToUpdate));

        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            String errMessage = HP_REST_CRUD_Helper.setMessageError(response.getBody());
            if (ApexPages.getMessages().size() == 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errMessage));
            }

        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.HP_Successfully_updated + ': ' + doctorToUpdate.first_name + ' ' + doctorToUpdate.last_name));
        }
        searchDoctors();
    }

    public void searchDoctors() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(basicUrl + HP_REST_CRUD_Helper.setConditionsToGetDoctors(doctorList, doctor));
        request.setMethod('GET');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');

        try {
            HttpResponse response = http.send(request);
            doctorList = (List<HP_DoctorWrapperWerka>) JSON.deserialize(response.getBody(), List<HP_DoctorWrapperWerka>.class);

        } catch (Exception ex) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.HP_Incorrect_data_entered));
        }

        numberOfRecords = doctorList.size();
    }

    public void deleteDoctor() {
        Http http = new Http();
        HttpRequest request = new HttpRequest();

        doctorToDelete = HP_REST_CRUD_Helper.getDoctorToDeleteId(doctorList, deleteDoctorId);
        request.setMethod('DELETE');

        if(doctorToDelete.email1 != null && doctorToDelete.email1.length() > 0){
            request.setEndpoint(basicUrl + 'param=' + doctorToDelete.email1);
        }
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, System.Label.HP_Delete_record_failed));

        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.HP_Successfully_removed + ': ' + doctorToDelete.first_name + ' ' + doctorToDelete.last_name));
        }

        searchDoctors();
    }

    public void addNewDoctor() {

        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(basicUrl);

        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setBody(HP_REST_CRUD_Helper.serializedDoctorToAdd(doctorToAdd));

        HttpResponse response = http.send(request);

        if (response.getStatusCode() != 200) {

            String errMessage = HP_REST_CRUD_Helper.setMessageError(response.getBody());
            if (ApexPages.getMessages().size() == 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, errMessage));
            }

        } else {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, System.Label.HP_Successfully_added_to_the_database));
            doctorToAdd = new HP_DoctorWrapperWerka();
        }
        searchDoctors();

    }

    public void loadDoctorToUpdate() {

        for (HP_DoctorWrapperWerka doc : doctorList) {
            if (doc.Id == updateDoctorId) {
                doctorToUpdate = doc;
                break;
            }
        }
    }

}