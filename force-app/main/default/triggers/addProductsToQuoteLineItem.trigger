trigger addProductsToQuoteLineItem on Quote (after insert) {

    addProductsToQuoteLineItemHelper helper = new addProductsToQuoteLineItemHelper();
    helper.handleAfterInsert(Trigger.new);
}