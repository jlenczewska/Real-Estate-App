global with sharing class RE_ScheduledBatchableCheckPriceBooks implements Schedulable {
    global void execute(SchedulableContext sc) {
        Re_BatchCheckPricebooks batchClass = new Re_BatchCheckPricebooks(); 
        database.executebatch(batchClass);
     }
  }
