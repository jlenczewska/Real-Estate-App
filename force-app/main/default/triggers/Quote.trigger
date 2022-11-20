trigger Quote on Quote (after insert) {

    RE_addProductsToQuoteLineItemHelper helper = new RE_addProductsToQuoteLineItemHelper();
    helper.handleAfterInsert(Trigger.new);
}