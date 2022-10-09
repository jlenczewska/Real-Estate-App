trigger SendEmailOnNewContactTrigger on Contact (after insert) {

    	 Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
         mail.setTemplateID('00X7Q000002K6fsUAC');
       	 mail.setSaveAsActivity(false);
    
      for (Contact c : Trigger.New){
          mail.setTargetObjectId(c.id);
          mail.setWhatId(c.id);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});    
      }
      
    
}