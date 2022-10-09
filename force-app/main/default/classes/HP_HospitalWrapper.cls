global with sharing class HP_HospitalWrapper {
    public String name {get;set;}
    public String city {get;set;}
    public String country {get;set;}
    public String Id {get;set;}
    public Decimal fax_number {get;set;}
    public Boolean helicopter_access {get;set;}
    public Decimal no_ambulances {get;set;}
    public String phone {get;set;}
    public String postal_code {get;set;}
    public String street {get;set;}

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