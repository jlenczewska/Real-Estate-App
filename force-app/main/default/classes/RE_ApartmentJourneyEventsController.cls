public without sharing class RE_ApartmentJourneyEventsController {
    
    @AuraEnabled
    public static User getAgentInfo(String recordId) {
        Product2 selectedProduct = [SELECT Id, Agent__c FROM Product2 WHERE Id = :recordId];
        User apartmentAgent = [SELECT Id, FirstName, LastName FROM User WHERE id = :selectedProduct.Agent__c];
        return apartmentAgent;
    }

    @AuraEnabled
    public static List<Event> getExistingEvents(String recordId) {
        User apartmentAgent = getAgentInfo(recordId);
        return [SELECT Id, Subject, StartDateTime, IsAllDayEvent, EndDateTime, WhoId, WhatId, OwnerId FROM Event WHERE OwnerId = :apartmentAgent.Id];
    }

    @AuraEnabled
    public static Boolean addNewEvent(String addEventArguments) {
        EventArgumentsWrapper addEventArgumentsDeserialized = (EventArgumentsWrapper) JSON.deserialize(addEventArguments, EventArgumentsWrapper.class);
        String apartmentId = addEventArgumentsDeserialized.apartmentId;
        String meetingDate = addEventArgumentsDeserialized.meetingDate;
        String meetingTime = addEventArgumentsDeserialized.meetingTime;
        String description = addEventArgumentsDeserialized.description;
        
        try {
            User apartmentAgent = getAgentInfo(apartmentId);
            User currUser = [SELECT firstname, lastname, id, ContactId FROM User WHERE Id = :UserInfo.getUserId()];
            Event E = new Event();

            String[] dateInfo = meetingDate.split('-');
            String timeInfoStart = meetingTime.split('-')[0];
            String timeInfoEnd = meetingTime.split('-')[1];

            Integer year = integer.valueOf(dateInfo[0]);
            Integer month = integer.valueOf(dateInfo[1]);
            Integer day = integer.valueOf(dateInfo[2]);
            Integer hourStart = integer.valueOf(timeInfoStart.split(':')[0]);
            Integer minutesStart = integer.valueOf(timeInfoStart.split(':')[1]);
            Integer hourEnd = integer.valueOf(timeInfoEnd.split(':')[0]);
            Integer minutesEnd = integer.valueOf(timeInfoEnd.split(':')[1]);

            E.Description = Description;
            E.OwnerId = apartmentAgent.id;
            E.StartDateTime = DateTime.newInstanceGmt(year, month, day, hourStart, minutesStart, 0);
            E.EndDateTime = DateTime.newInstanceGmt(year, month, day, hourEnd, minutesEnd, 0);
            E.Subject = Label.RE_meeting_with_client;
            E.WhatId = apartmentId;
            E.WhoId = currUser.ContactId;

            Database.insert(E, true);
            return true;
        } catch (Exception exc) {
            throw newMessageException(exc.getMessage());
        }
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }

    private class EventArgumentsWrapper {
        public String apartmentId;
        public String meetingDate;
        public String meetingTime;
        public String description;
    }
}
