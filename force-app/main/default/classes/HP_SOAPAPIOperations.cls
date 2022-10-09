global with sharing class HP_SOAPAPIOperations {

    global with sharing class HP_HospitalWrapper {
        webService String name { get; set; }
        webService String city { get; set; }
        webService String country { get; set; }
        webService String Id { get; set; }
        webService Decimal fax_number { get; set; }
        webService Boolean helicopter_access { get; set; }
        webService Decimal no_ambulances { get; set; }
        webService String phone { get; set; }
        webService String postal_code { get; set; }
        webService String street { get; set; }

        global HP_HospitalWrapper() {
        }

        global HP_HospitalWrapper(String name, String city, String country, String Id, Decimal fax_number,
                Boolean helicopter_access, Decimal no_ambulances, String phone, String postal_code, String street) {
            this.name = name;
            this.city = city;
            this.country = country;
            this.Id = Id;
            this.fax_number = fax_number;
            this.helicopter_access = helicopter_access;
            this.no_ambulances = no_ambulances;
            this.phone = phone;
            this.postal_code = postal_code;
            this.street = street;
        }

        global HP_HospitalWrapper(Hospital__c hospital) {
            this.name = hospital.Name;
            this.city = hospital.City__c;
            this.country = hospital.Country__c;
            this.Id = hospital.Id;
            this.fax_number = hospital.Fax_Number__c;
            this.helicopter_access = hospital.Helicopter_Access__c;
            this.no_ambulances = hospital.No_Ambulances__c;
            this.phone = hospital.Phone_Number__c;
            this.postal_code = hospital.Postal_Code__c;
            this.street = hospital.Street__c;
        }
        public Hospital__c convertToHospital() {
            Hospital__c hp = new Hospital__c();
            hp.Name = this.name;
            hp.City__c = this.city;
            hp.Country__c = this.country;
            hp.Id = this.Id;
            hp.Fax_Number__c = this.fax_number;
            hp.Helicopter_Access__c = this.helicopter_access;
            hp.No_Ambulances__c = this.no_ambulances;
            hp.Phone_Number__c = this.phone;
            hp.Postal_Code__c = this.postal_code;
            hp.Street__c = this.street;
            return hp;
        }
    }

    webService static List<HP_HospitalWrapper> getHospitalMethod(String hospitalName, String hospitalCity, String hospitalCountry) {
        String nameToSearch = hospitalName.length() != 0 ? hospitalName + '%' : '%%';
        String cityToSearch = hospitalCity.length() != 0 ? hospitalCity + '%' : '%%';
        String countryToSearch = hospitalCountry.length() != 0 ? hospitalCountry + '%' : '%%';
        List<String> conditions = new List<String>();
        List<Hospital__c> hospitalList;
        List<HP_HospitalWrapper> hospitalListWrapper = new List<HP_HospitalWrapper>();

        String queryDoctorsList = 'SELECT Name, City__c, Country__c, Fax_Number__c, Helicopter_Access__c, No_Ambulances__c, Phone_Number__c, Postal_Code__c,\n' +
                ' Street__c, Id FROM Hospital__c ';

        if (hospitalCountry.length() == 0) {
            addCondition(conditions, getConditionInsert(nameToSearch, Hospital__c.Name.getDescribe().name));
            addCondition(conditions, getConditionInsert(cityToSearch, Hospital__c.City__c.getDescribe().name));

        } else {
            addCondition(conditions, getConditionInsert(nameToSearch, Hospital__c.Name.getDescribe().name));
            addCondition(conditions, getConditionInsert(cityToSearch, Hospital__c.City__c.getDescribe().name));
            addCondition(conditions, getConditionInsert(countryToSearch, Hospital__c.Country__c.getDescribe().name));
        }
        String queryConditions = 'WHERE ' + String.join(conditions, ' AND ');
        queryDoctorsList += queryConditions;

        hospitalList = Database.query(queryDoctorsList);

        for (Hospital__c hp : hospitalList) {
            hospitalListWrapper.add(new HP_HospitalWrapper(hp));
        }
        return hospitalListWrapper;
    }

    webService static void deleteHospitalMethod(String hospitalId) {

        String queryDoctorsList = 'SELECT Id, Name FROM Hospital__c ';

        List<String> conditions = new List<String>();
        addCondition(conditions, getCondition(hospitalId, Hospital__c.Id.getDescribe().name));

        String queryConditions = 'WHERE ' + String.join(conditions, ' AND ');
        queryDoctorsList += queryConditions;

        try{
            delete Database.query(queryDoctorsList);
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    webService static void updateHospitalMethod(HP_HospitalWrapper params, String hospitalId) {
        String queryDoctorsList = 'SELECT Name, City__c, Country__c, Fax_Number__c, Helicopter_Access__c, No_Ambulances__c, Phone_Number__c, Postal_Code__c, Street__c, Id FROM Hospital__c ';

        List<String> conditions = new List<String>();
        addCondition(conditions, getCondition(hospitalId, Hospital__c.Id.getDescribe().name));

        String queryConditions = ' WHERE ' + conditions;
        queryDoctorsList += queryConditions;

        Hospital__c hospitalToUpdate = Database.query(queryDoctorsList);

        hospitalToUpdate.Name = String.isNotBlank(params.name) ? params.name : hospitalToUpdate.Name;
        hospitalToUpdate.City__c = String.isNotBlank(params.city) ? params.city : hospitalToUpdate.City__c;
        hospitalToUpdate.Country__c = String.isNotBlank(params.country) ? params.country : hospitalToUpdate.Country__c;
        hospitalToUpdate.Fax_Number__c = params.fax_number != null ? params.fax_number : hospitalToUpdate.Fax_Number__c;
        hospitalToUpdate.Helicopter_Access__c = params.helicopter_access!= null ? params.helicopter_access : hospitalToUpdate.Helicopter_Access__c;
        hospitalToUpdate.No_Ambulances__c = params.no_ambulances!= null ? params.no_ambulances : hospitalToUpdate.No_Ambulances__c;
        hospitalToUpdate.Phone_Number__c = String.isNotBlank(params.phone) ? params.phone : hospitalToUpdate.Phone_Number__c;
        hospitalToUpdate.Postal_Code__c = String.isNotBlank(params.postal_code) ? params.postal_code : hospitalToUpdate.Postal_Code__c;
        hospitalToUpdate.Street__c = String.isNotBlank(params.street) ? params.street : hospitalToUpdate.Street__c;

        try{
            update hospitalToUpdate;
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    webService static void insertHospitalMethod(HP_HospitalWrapper objectToInsert) {
    
        Hospital__c newHospital = objectToInsert.convertToHospital();

        try{
        insert newHospital;
        
        }
        catch(Exception e){
            System.debug(e.getMessage());
        }
    }

    private static String getCondition(Object value, String fieldName) {
        if (value != null) {
            return fieldName + ' = \'' + String.valueOf(value) + '\'';
        }
        return null;
    }

    private static String getConditionInsert(Object value, String fieldName) {
        if (value != null) {
            return fieldName + ' LIKE \'' + String.valueOf(value) + '\'';
        }
        return null;
    }

    private static void addCondition(List<String> conditions, String condition) {
        if (String.isNotBlank(condition)) {
            conditions.add(condition);
        }
    }
}