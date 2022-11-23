@isTest
public with sharing class RE_ApartmentJourneyEventsControllerTest {
    
    public static final String PREMISE_NAME = 'Apartment';
    public static final String SAMPLE_TEXT = 'text';

    @isTest
    static void shouldGetExistingEvents() {

        List<Event> events;
        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);

        insert u;

        Product2 product = new Product2();
        product.Name = SAMPLE_TEXT;
        product.Agent__c = u.id;
        product.RecordTypeId = recordType;
        product.City__c = SAMPLE_TEXT;
        product.Country__c = SAMPLE_TEXT;
        product.Street__c = SAMPLE_TEXT;
        product.Number_of_rooms__c = 3;
        product.Area__c = 100;
        insert product;

        Event event = new Event();
        event.OwnerId=u.Id;
        event.StartDateTime=datetime.now();
        event.EndDateTime=datetime.now();
        insert event;

        Test.startTest();
        events = RE_ApartmentJourneyEventsController.getExistingEvents(product.id);
        Test.stopTest();

        System.assertEquals(events.size(), 1);
    }

    @isTest
    static void shouldAddNewEvent() {

        Boolean result;
        Id recordType = Schema.SObjectType.Product2.getRecordTypeInfosByName().get(PREMISE_NAME).getRecordTypeId();

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);

        insert u;

        Product2 product = new Product2();
        product.Name = SAMPLE_TEXT;
        product.Agent__c = u.id;
        product.RecordTypeId = recordType;
        product.City__c = SAMPLE_TEXT;
        product.Country__c = SAMPLE_TEXT;
        product.Street__c = SAMPLE_TEXT;
        product.Number_of_rooms__c = 3;
        product.Area__c = 100;
        insert product;

        EventArgumentsWrapper eventWrapper = new EventArgumentsWrapper();
        eventWrapper.apartmentId = product.id;
        eventWrapper.meetingTime = '9:30-10:00';
        eventWrapper.meetingDate = '2022-11-24';
        eventWrapper.description = SAMPLE_TEXT;
        // Event event = new Event();
        // event.OwnerId=u.Id;
        // event.StartDateTime=datetime.now();
        // event.EndDateTime=datetime.now();
        // insert event;

        Test.startTest();
        result = RE_ApartmentJourneyEventsController.addNewEvent(JSON.serialize(eventWrapper));
        Test.stopTest();

        System.assertEquals(result, true);
    }

    private class EventArgumentsWrapper {
        public String apartmentId;
        public String meetingDate;
        public String meetingTime;
        public String description;
    }
}
