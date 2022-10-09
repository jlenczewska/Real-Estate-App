global with sharing class HP_DoctorWrapperWerka
{
    public String first_name {get;set;}
    public String last_name {get;set;}
    public String Id {get;set;}
    public Date date_of_birth {get;set;}
    public String nationality {get;set;}
    public String license_number {get;set;}
    public String speciality {get;set;}
    public Date start_of_career {get;set;}
    public String phone {get;set;}
    public String email1 {get;set;}
    public String street {get;set;}
    public String postal_code {get;set;}
    public String city {get;set;}
    public String country1 {get;set;}

    public HP_DoctorWrapperWerka() {
    }

    public HP_DoctorWrapperWerka(String fist_name, String last_name, String Id, Date date_of_birth, String nationality,
            String license_number, String speciality, Date start_of_career, String phone, String email1, String street,
            String postal_code, String city, String country1) {
        this.first_name = fist_name;
        this.last_name = last_name;
        this.Id = Id;
        this.date_of_birth = date_of_birth;
        this.nationality = nationality;
        this.license_number = license_number;
        this.speciality = speciality;
        this.start_of_career = start_of_career;
        this.phone = phone;
        this.email1 = email1;
        this.street = street;
        this.postal_code = postal_code;
        this.city = city;
        this.country1 = country1;
    }

    public HP_DoctorWrapperWerka(Doctor__c doctor) {
        this.first_name = doctor.First_Name__c;
        this.last_name = doctor.Last_Name__c;
        this.Id = doctor.Id;
        this.date_of_birth = doctor.Date_of_Birth__c;
        this.nationality = doctor.Nationalities__c;
        this.license_number = doctor.License_Number__c;
        this.speciality = doctor.Speciality__c;
        this.start_of_career = doctor.Start_of_career__c;
        this.phone = doctor.Phone__c;
        this.email1 = doctor.Email__c;
        this.street = doctor.Street__c;
        this.postal_code = doctor.Postal_Code__c;
        this.city = doctor.City__c;
        this.country1 = doctor.Country__c;
    }
}