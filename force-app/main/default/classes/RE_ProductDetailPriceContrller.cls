public with sharing class RE_ProductDetailPriceContrller {
    @auraenabled(cacheable=true)
    public static Decimal getProductPrice(String recordId) {
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();

        Set<Id> pricebooksIds = new Set<Id>();
        List<Decimal> prices = new List<Decimal>();

        try {
            List<Pricebook2> pricebooksId = [SELECT Id FROM pricebook2 WHERE isactive = TRUE];

            for (Pricebook2 pb : pricebooksId) {
                pricebooksIds.add(pb.Id);
            }

            pricebookEntryList = [
                SELECT Product2ID, Pricebook2ID, UnitPrice
                FROM PricebookEntry
                WHERE Product2ID = :recordId AND Pricebook2ID IN :pricebooksIds
            ];

            for (PricebookEntry entry : pricebookEntryList) {
                prices.add(entry.UnitPrice);
            }

            prices.sort();
            Decimal minValue = prices[0];

            return minValue;
        } catch (Exception e) {
            throw newMessageException(e.getMessage());
        }
    }
    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }
}
