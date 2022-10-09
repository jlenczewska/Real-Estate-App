public with sharing class HP_HospitalSearchController {

    public HP_HospitalWrapper hospital { get; set; }
    public HP_HospitalWrapper hospitalToAdd { get; set; }
    public HP_HospitalWrapper hospitalToUpdate { get; set; }
    public List<HP_HospitalWrapper> hospitalList { get; set; }
    public String deleteHospitalId { get; set; }
    public String updateHospitalIdLoadData { get; set; }
    public Integer numberOfRecords { get; set; }
    public soapSforceComSchemasClassHsSoapcru.HS_soapCrudOperations soapAPI;

    public HP_HospitalSearchController() {
        hospital = new HP_HospitalWrapper();
        hospitalList = new List<HP_HospitalWrapper>();
        hospitalToAdd = new HP_HospitalWrapper();
        hospitalToUpdate = new HP_HospitalWrapper();
        numberOfRecords = 0;
        soapAPI = new soapSforceComSchemasClassHsSoapcru.HS_soapCrudOperations();
        if (!Test.isRunningTest()) {
            connect();
        }
    }

    public void clearResults() {
        hospitalList.clear();
        numberOfRecords = 0;
    }

    public void searchHospitals() {
        if (hospitalList.size() != 0) {
            hospitalList.clear();
        }

        List<soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO> results = soapAPI.getHospitalList(hospital.name.trim().replaceAll('\\s+', ' '), hospital.city.trim().replaceAll('\\s+', ' '), hospital.country.trim().replaceAll('\\s+', ' '));

        if (results != null) {
            for (soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO hospital : results) {
                hospitalList.add(transformToHP_HospitalWrapper(hospital));
            }
            numberOfRecords = hospitalList.size();
        } else {
            numberOfRecords = 0;
        }
    }

    public void updateHospital() {
        String hospitalToUpdateParam = ApexPages.CurrentPage().getParameters().get('hospitalToUpdateParam');

        if (hospitalToUpdateParam.length() > 0) {
            chceckIfRequiredFieldsArePresent();
        }

        if (ApexPages.getMessages().size() == 0) {
            try {
                soapAPI.updateHospital(transformTosoapSforceComSchemasClass(hospitalToUpdate), hospitalToUpdateParam);
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, String.format(System.Label.HP_Successfully_updated_parameters, new String[]{
                        hospitalToUpdate.Name, ''
                })));

            } catch (Exception e) {
                if (ApexPages.getMessages().size() == 0) {
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.HP_An_error_occurred_Please_refresh_the_page_and_try_again));
                }
            }
            if (!Test.isRunningTest()) {
                searchHospitals();
            }
        }

    }

    public void deleteHospital() {
        HP_HospitalWrapper oldHospital = new HP_HospitalWrapper();
        oldHospital.id = deleteHospitalId;
        String hospitalNameToError;

        for (HP_HospitalWrapper hp : hospitalList) {
            if (hp.id == deleteHospitalId) {
                hospitalNameToError = hp.Name;
            }
        }

        try {
            soapAPI.deleteHospital(oldHospital.id);
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, String.format(System.Label.HP_Successfully_deleted_parameters, new String[]{
                    hospitalNameToError, ''
            })));
        } catch (Exception e) {
            if (ApexPages.getMessages().size() == 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.HP_An_error_occurred_Please_refresh_the_page_and_try_again));
            }
        }
        if (!Test.isRunningTest()) {
            searchHospitals();
        }
    }

    public void addNewHospital() {
        try {
            soapAPI.insertHospital(transformTosoapSforceComSchemasClass(hospitalToAdd));
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO, String.format(System.Label.HP_Successfully_added_to_the_database_parameters, new String[]{
                    hospitalToAdd.Name, ''
            })));
            hospitalToAdd = new HP_HospitalWrapper();

        } catch (Exception e) {
            if (ApexPages.getMessages().size() == 0) {
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, Label.HP_An_error_occurred_Please_refresh_the_page_and_try_again));
            }
        }
        if (!Test.isRunningTest()) {
            searchHospitals();
        }
    }

    public void loadHospitalToUpdate() {
        for (HP_HospitalWrapper hp : hospitalList) {
            if (hp.Id == updateHospitalIdLoadData) {
                hospitalToUpdate = hp;
                break;
            }
        }
    }

    private HP_HospitalWrapper transformToHP_HospitalWrapper(soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO hospital) {
        HP_HospitalWrapper newHospital = new HP_HospitalWrapper();
        newHospital.name = hospital.name;
        newHospital.city = hospital.city;
        newHospital.country = hospital.country;
        newHospital.Id = hospital.Id;
        newHospital.fax_number = hospital.fax_number;
        newHospital.helicopter_access = hospital.helicopter_access;
        newHospital.no_ambulances = hospital.no_ambulances;
        newHospital.phone = hospital.phone_number;
        newHospital.postal_code = hospital.postal_code;
        newHospital.street = hospital.street;
        return newHospital;
    }

    private soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO transformTosoapSforceComSchemasClass(HP_HospitalWrapper hospital) {
        soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO newHospital = new soapSforceComSchemasClassHsSoapcru.HS_HospitalsDTO();
        newHospital.name = hospital.name;
        newHospital.city = hospital.city;
        newHospital.country = hospital.country;
        newHospital.Id = hospital.Id;
        newHospital.fax_number = hospital.fax_number;
        newHospital.helicopter_access = hospital.helicopter_access;
        newHospital.no_ambulances = hospital.no_ambulances;
        newHospital.phone_number = hospital.phone;
        newHospital.postal_code = hospital.postal_code;
        newHospital.street = hospital.street;
        return newHospital;
    }

    private void connect() {
        soap_login__c custom_settings = soap_login__c.getInstance();
        partnerSoapSforceCom.Soap myPartnerSoap = new partnerSoapSforceCom.Soap();
        partnerSoapSforceCom.LoginResult partnerLoginResult = myPartnerSoap.login(custom_settings.julia_email__c, custom_settings.julia_password__c);
        soapSforceComSchemasClassHsSoapcru.SessionHeader_element webserviceSessionHeader = new soapSforceComSchemasClassHsSoapcru.SessionHeader_element();
        webserviceSessionHeader.sessionId = partnerLoginResult.sessionId;
        soapAPI.SessionHeader = webserviceSessionHeader;
    }

    @TestVisible
    private void chceckIfRequiredFieldsArePresent() {

        if (hospitalToUpdate.name.replaceAll('\\s+', '').length() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, String.format(System.Label.HP_cannot_be_empty, new String[]{
                    Label.HP_Name
            })));
        } else if (hospitalToUpdate.phone.replaceAll('\\s+', '').length() == 0) {
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING, String.format(System.Label.HP_cannot_be_empty, new String[]{
                    Label.HP_Phone
            })));
        }
    }
}