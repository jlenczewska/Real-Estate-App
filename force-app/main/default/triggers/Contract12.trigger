trigger Contract12 on Contract__c (before update) {

     for( Contract__c c: trigger.new ){
      System.debug(Trigger.new);
     }
    
}