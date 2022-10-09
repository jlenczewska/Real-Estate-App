public with sharing class HP_ImportDoctorsController {

    public Blob csvFile { get; set; }
    public String uploadedCsvFile { get; set; }
    public String[] csvFileLines { get; set; }
    public List<Doctor__c> doctorList { get; set; }
    public List<List<String>> doctorStatuses { get; set; }
    public List<List<String>> doctorLinks { get; set; }
    public String licenseNamesToImport { get; set; }

    public HP_ImportDoctorsController() {
        csvFileLines = new String[]{
        };
        doctorList = new List<Doctor__c>();
        doctorStatuses = new List<List<String>> ();
        doctorLinks = new List<List<String>> ();
    }

    public void importCSVFile() {
        uploadedCsvFile = csvFile.toString();
        csvFileLines = uploadedCsvFile.split('\n');
        doctorStatuses.clear();
        doctorList.clear();

        for (Integer i = 1; i < csvFileLines.size(); i++) {
            Doctor__c doctorRecord = new Doctor__c() ;
            String[] doctorRecordData = csvFileLines[i].replaceAll('\"', '').split(',');
            doctorRecord.First_Name__c = doctorRecordData[9];
            doctorRecord.Last_Name__c = doctorRecordData[10];
            doctorRecord.Country__c = doctorRecordData[21];
            doctorRecord.Street__c = doctorRecordData[18];
            doctorRecord.Postal_Code__c = doctorRecordData[19];
            doctorRecord.License_Number__c = doctorRecordData[13];

            doctorList.add(doctorRecord);
        }
        setDoctorViewsEmpty();
        setDoctorStatusesEmpty();
    }

    public void importDoctorToDatabase() {

        List<String> doctorsToInsert = licenseNamesToImport.split(',');
        Integer indexOfDoctors = 0;

        for (Doctor__c doc : doctorList) {
            if (doctorsToInsert.contains(doc.License_Number__c)) {
                Doctor__c doctorToInsert = new Doctor__c(First_Name__c = doc.First_Name__c, Last_Name__c = doc.Last_Name__c, Country__c = doc.Country__c, Street__c = doc.Street__c,
                        Postal_Code__c = doc.Postal_Code__c, License_Number__c = doc.License_Number__c);
                try {
                    insert doctorToInsert;
                    setDoctorsLink(indexOfDoctors, doctorToInsert.License_Number__c);
                    setDoctorMessage(indexOfDoctors, System.Label.HP_Successfully_added_to_the_database);
                }

                catch (Exception e) {

                    if (e.getMessage().contains('DUPLICATE_VALUE')) {
                        setDoctorMessage(indexOfDoctors, System.Label.HP_Duplicated);
                    } else {
                        setDoctorMessage(indexOfDoctors, System.Label.HP_Invalid_record);
                    }

                }

            }
            indexOfDoctors++;
        }
    }

    private void setDoctorsLink(Integer doctorsIndex, String doctorsLicenseNumber){
        Doctor__c insertedDoctor = [SELECT Id, First_Name__c, License_Number__c from Doctor__c where License_Number__c = :doctorsLicenseNumber];
        doctorLinks.get(doctorsIndex)[1] = '/' + insertedDoctor.Id;
    }

    private void setDoctorMessage(Integer doctorsIndex, String message) {
        doctorStatuses.get(doctorsIndex)[1] = message;
    }

    private void setDoctorStatusesEmpty() {
        for (Integer i = 0; i < doctorList.size(); i++) {
            doctorStatuses.add(new String[]{
                    'Doctor' + i, ''
            });
        }
    }

    private void setDoctorViewsEmpty() {
        for (Integer i = 1; i < doctorList.size(); i++) {
            doctorLinks.add(new String[]{
                    'Doctor' + i, 'null'
            });
        }
    }
}