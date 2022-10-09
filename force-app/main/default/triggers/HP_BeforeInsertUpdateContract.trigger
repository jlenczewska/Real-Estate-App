trigger HP_BeforeInsertUpdateContract on Contract__c (before insert, before update) {

    HP_TriggerHandlerContract ContractTriggerHandler = new HP_TriggerHandlerContract();

    if ((Trigger.isInsert && Trigger.isBefore) || (Trigger.isUpdate && Trigger.isBefore)) {
        ContractTriggerHandler.validateContract(Trigger.new);
    }
}