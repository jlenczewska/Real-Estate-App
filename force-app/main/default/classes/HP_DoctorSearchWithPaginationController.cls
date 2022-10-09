public class HP_DoctorSearchWithPaginationController {
    public Doctor__c doctor { get; set; }
    public List<Doctor__c> doctorList { get; set; }
    public Integer numberOfRecords { get; set; }
    public Integer doctorsPerPageOptionsValue { get; set; }
    public Integer offsetNumber { get; set; }

    List<String> conditions = new List<String>();

    public HP_DoctorSearchWithPaginationController() {
        doctorsPerPageOptionsValue = 10;
        offsetNumber = 0;
        numberOfRecords = 0;
        doctor = new Doctor__c();
        doctorList = new List<Doctor__c>();
    }

    public void searchDoctorsHandler() {
        searchDoctors();
        conditions.clear();
    }

    public void searchDoctors() {
        if (doctorList.size() != 0) {
            doctorList.clear();
        }
        String searchDoctorsQuery = 'SELECT Name, First_Name__c, Last_Name__c, License_Number__c,Postal_Code__c,Street__c,City__c,Country__c,Email__c  From Doctor__c';
        String searchDoctorsQueryNumberOfRecords = 'SELECT COUNT() From Doctor__c';

        if (doctor.First_Name__c != null) {
            conditions.add('First_Name__c = \'' + String.escapeSingleQuotes(doctor.First_Name__c) + '\'');
        }

        if (doctor.Last_Name__c != null) {
            conditions.add('Last_Name__c = \'' + String.escapeSingleQuotes(doctor.Last_Name__c) + '\'');
        }

        if (doctor.Email__c != null) {
            conditions.add('Email__c = \'' + String.escapeSingleQuotes(doctor.Email__c) + '\'');
        }

        if (doctor.Country__c != null) {
            conditions.add('Country__c = \'' + String.escapeSingleQuotes(doctor.Country__c) + '\'');
        }

        if (conditions.size() > 0) {
            searchDoctorsQuery += '  WHERE ' + conditions[0];
            searchDoctorsQueryNumberOfRecords += '  WHERE ' + conditions[0];
            for (Integer i = 1; i < conditions.size(); i++) {
                searchDoctorsQuery += '  AND ' + conditions[i];
                searchDoctorsQueryNumberOfRecords += '  AND ' + conditions[i];
            }
        }

        searchDoctorsQuery += ' LIMIT ' + doctorsPerPageOptionsValue + ' OFFSET ' + offsetNumber;
        doctorList = Database.query(searchDoctorsQuery);
        numberOfRecords = Database.countQuery(searchDoctorsQueryNumberOfRecords);
    }

    public void clearResults(){
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
}