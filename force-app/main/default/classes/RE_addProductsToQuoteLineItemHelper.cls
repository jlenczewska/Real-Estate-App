public with sharing class RE_addProductsToQuoteLineItemHelper {
  public RE_addProductsToQuoteLineItemHelper() {
  }

  public void handleAfterInsert(List<Quote> newList) {
      String quoteId = newList[0].get('Id').toString();
      String opportunityId = newList[0].get('OpportunityId').toString();
      String pricebookId = newList[0].get('pricebook2Id').toString();

      List<OpportunityLineItem> listOfOpportunityLineItem = [
          SELECT Id, Product2Id, UnitPrice, PriceBookentryid
          FROM OpportunityLineItem
          WHERE OpportunityId = :opportunityId
      ];
      Set<id> opportunityLineItemIds = new Set<id>();
      List<QuoteLineItem> quoteLineItems = new List<QuoteLineItem>();

      for (OpportunityLineItem item : listOfOpportunityLineItem) {
          quoteLineItems.add(
              new QuoteLineItem(
                  Quantity = 1,
                  Product2Id = item.Product2Id,
                  QuoteId = quoteId,
                  PriceBookentryid = item.PriceBookentryid,
                  UnitPrice = item.UnitPrice
              )
          );
      }
      insert quoteLineItems;
  }
}
