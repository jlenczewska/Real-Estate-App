public with sharing class RE_CaseFormController {
    public static final String QUEUE_PAYMENTS = 'Payments Case Queue';
    public static final String QUEUE_RESERVATION = 'Renovation Case Queue';
    public static final String CASE_TYPE_PAYMENTS = 'Payments';
    public static final String CASE_TYPE_RENOVATIONS = 'Renovations';
    public static final String GROUP_TYPE_QUEUE = 'Queue';

    @AuraEnabled
    public static void changeCaseOwner(String recordId) {
        try {
            Case createdCase = [SELECT Id, OwnerId, Type FROM Case WHERE Id = :recordId];
            ID queueIdPayments = [SELECT Id, Name FROM Group WHERE Type = :GROUP_TYPE_QUEUE AND Name = :QUEUE_PAYMENTS].Id;
            ID queueIdRenovations = [SELECT Id, Name FROM Group WHERE Type = :GROUP_TYPE_QUEUE AND Name = :QUEUE_RESERVATION].Id;

            if (createdCase.Type == CASE_TYPE_PAYMENTS) {
                createdCase.OwnerId = queueIdPayments;
                update createdCase;
            } else if (createdCase.Type == CASE_TYPE_RENOVATIONS) {
                createdCase.OwnerId = queueIdRenovations;
                update createdCase;
            }
        } catch (Exception exc) {
            throw newMessageException(exc.getMessage());
        }
    }
    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
}
