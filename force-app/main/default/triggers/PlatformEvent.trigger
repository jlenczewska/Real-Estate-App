trigger PlatformEvent on Send_Email_With_Quote__e (after insert) {
    RE_getQuoteController.createQuotePDF(Trigger.New[0].quoteId__c, Trigger.New[0].UserId__c);
}