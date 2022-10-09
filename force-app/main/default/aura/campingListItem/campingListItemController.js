({
	 packItem: function(component, event, helper) {
        var cItem = component.get("v.item",true);
        cItem.Packed__c = true;
        component.set("v.item",cItem);
       
        event.getSource().set("v.disabled","true");
    }
})