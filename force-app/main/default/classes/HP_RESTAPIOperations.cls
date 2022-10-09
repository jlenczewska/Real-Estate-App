@RestResource(urlMapping='/Doctor/*')
global with sharing class HP_RESTAPIOperations {
    @HttpGet
    global static List<HP_DoctorWrapper> getDoctors() {
        RestRequest request = RestContext.request;
        String first_name = request.params.get('first_name') != null ? String.escapeSingleQuotes(request.params.get('first_name')) + '%' : '%%';
        String last_name = request.params.get('last_name') != null ? String.escapeSingleQuotes(request.params.get('last_name')) + '%' : '%%';
        String email1 = request.params.get('email1') != null ? String.escapeSingleQuotes(request.params.get('email1')) + '%' : '%%';
        String country1 = request.params.get('country1') != null ? String.escapeSingleQuotes(request.params.get('country1')) + '%' : '%%';
        List<HP_DoctorWrapper> result = new List<HP_DoctorWrapper>();

        List<Doctor__c> doctorListWOCountry = new List<Doctor__c>();

        if (country1 == '%%') {
            doctorListWOCountry = [
                    SELECT First_Name__c, Last_Name__c, Email__c, Country__c, License_Number__c, Street__c, Postal_Code__c,
                            Date_of_Birth__c, Start_of_career__c, Speciality__c, City__c, Nationalities__c, Phone__c, Id
                    FROM Doctor__c
                    WHERE First_Name__c LIKE :first_name AND Last_Name__c LIKE :last_name AND Email__c LIKE :email1
            ];
        } else {
            doctorListWOCountry = [
                    SELECT First_Name__c, Last_Name__c, Email__c, Country__c, License_Number__c, Street__c, Postal_Code__c,
                            Date_of_Birth__c, Start_of_career__c, Speciality__c, City__c, Nationalities__c, Phone__c, Id
                    FROM Doctor__c
                    WHERE First_Name__c LIKE :first_name AND Last_Name__c LIKE :last_name AND Email__c LIKE :email1 AND Country__c LIKE :country1
            ];
        }

        for (Doctor__c doctor : doctorListWOCountry) {
            HP_DoctorWrapper wrapper = new HP_DoctorWrapper(doctor);
            result.add(wrapper);
        }

        return result;
    }

    @HttpDelete
    global static void deleteDoctors() {

        String queryDoctorsList = 'SELECT Id, First_Name__c FROM Doctor__c WHERE ';

        for (String fieldName : RestContext.request.params.keySet()) {

            if (fieldName == 'Id' || fieldName == 'Name') {
                queryDoctorsList += fieldName + '=' + '\'' + String.escapeSingleQuotes(RestContext.request.params.get(fieldName)) + '\' AND ';
            } else if (fieldName == 'country1' || fieldName == 'email1') {
                queryDoctorsList += fieldName.replaceAll('1', '') + '__c=' + '\'' + String.escapeSingleQuotes(RestContext.request.params.get(fieldName)) + '\' AND ';
            } else if (fieldName == 'nationality') {
                queryDoctorsList += 'Nationalities__c=' + '\'' + String.escapeSingleQuotes(RestContext.request.params.get(fieldName)) + '\' AND ';
            } else {
                queryDoctorsList += fieldName + '__c=' + '\'' + String.escapeSingleQuotes(RestContext.request.params.get(fieldName)) + '\' AND ';
            }
        }

        queryDoctorsList = queryDoctorsList.removeEnd('AND ');
        delete Database.query(queryDoctorsList);
    }

    @HttpPatch
    global static void updateDoctors() {
        RestResponse res = RestContext.response;

        RestRequest request = RestContext.request;
        String queryDoctorsList = 'SELECT Id, First_Name__c FROM Doctor__c WHERE ';
        Map<String, Object> bodyMap = (Map<String, Object>) JSON.deserializeUntyped(request.requestbody.tostring());

        Map<String, String> paramsList = RestContext.request.params;

        for (String fieldName : paramsList.keySet()) {
            if (fieldName == 'Id' || fieldName == 'Name') {
                queryDoctorsList += fieldName + '=' + '\'' + String.escapeSingleQuotes(paramsList.get(fieldName)) + '\' AND ';
            } else if (fieldName == 'country1' || fieldName == 'email1') {
                queryDoctorsList += fieldName.replaceAll('1', '') + '__c=' + '\'' + String.escapeSingleQuotes(paramsList.get(fieldName)) + '\' AND ';
            } else if (fieldName == 'nationality') {
                queryDoctorsList += 'Nationalities__c=' + '\'' + String.escapeSingleQuotes(paramsList.get(fieldName)) + '\' AND ';
            } else {
                queryDoctorsList += fieldName + '__c=' + '\'' + String.escapeSingleQuotes(paramsList.get(fieldName)) + '\' AND ';
            }
        }

        queryDoctorsList = queryDoctorsList.removeEnd('AND ');
        List<Doctor__c> doctorsList = Database.query(queryDoctorsList);

        for (String fieldName : bodyMap.keySet()) {

            for (Doctor__c doc : doctorsList) {

                Date dt;
                if (fieldName == 'start_of_career' || fieldName == 'date_of_birth') {
                    dt = Date.Parse((String) bodyMap.get(fieldName));
                    doc.put(fieldName + '__c', dt);
                } else if (fieldName == 'country1' || fieldName == 'email1') {
                    doc.put(fieldName.replaceAll('1', '') + '__c', bodyMap.get(fieldName));
                } else if (fieldName == 'nationality') {
                    doc.put('Nationalities__c', bodyMap.get(fieldName));
                } else {
                    doc.put(fieldName + '__c', bodyMap.get(fieldName));
                }

            }
        }

        try {
            update doctorsList;
            res.statusCode = 200;
        }

        catch (Exception ex) {
            res.addHeader('Content-Type', 'text/plain');
            res.responseBody = Blob.valueOf(ex.getMessage());
            res.statusCode = 400;
        }

    }

    @HttpPost
    global static void insertDoctor() {
        RestResponse res = RestContext.response;

        RestRequest request = RestContext.request;
        Doctor__c doctorToInsert = new Doctor__c();
        Map<String, Object> params = (Map<String, Object>) JSON.deserializeUntyped(request.requestbody.tostring());

        for (String fieldName : params.keySet()) {
            Date dt;
            if (fieldName == 'start_of_career' || fieldName == 'date_of_birth') {
                dt = Date.Parse((String) params.get(fieldName));
                doctorToInsert.put(fieldName + '__c', dt);
            } else if (fieldName == 'nationality') {
                doctorToInsert.put('Nationalities__c', dt);
            } else if (fieldName == 'country1' || fieldName == 'email1') {
                doctorToInsert.put(fieldName.replaceAll('1', '') + '__c', params.get(fieldName));
            } else {
                doctorToInsert.put(fieldName + '__c', params.get(fieldName));
            }
        }

        try {
            insert doctorToInsert;
            res.responseBody = Blob.valueOf(doctorToInsert.id);
            res.statusCode = 201;
        }

        catch (Exception ex) {
            res.addHeader('Content-Type', 'text/plain');
            res.responseBody = Blob.valueOf(ex.getMessage());
            res.statusCode = 400;
        }
    }
}