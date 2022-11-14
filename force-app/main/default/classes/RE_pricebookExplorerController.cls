public with sharing class RE_pricebookExplorerController {
    public static final String ROLE_SALES_COORINATOR = 'Sales Coordinators';
    public static final String ROLE_SALES_MANAGEMENT = 'Sales Management';
    public static final String ROLE_SALES_REPRESENTANTS = 'Sales Representants';
    public static final String ROLE_HEAD_OF_SALES = 'Head Of Sales';
    public static final String PROFILE_SYSTEM_ADMIN = 'System Administrator';
  
    private static AuraHandledException newMessageException(String message) {
      AuraHandledException e = new AuraHandledException(message);
      e.setMessage(message);
      return e;
    }
  
    @AuraEnabled
    public static Boolean editShouldBeAvailable() {
      List < String > listOfUserEditPermissions = new List < String > {
        ROLE_SALES_COORINATOR,
        ROLE_SALES_MANAGEMENT,
        ROLE_SALES_REPRESENTANTS,
        ROLE_HEAD_OF_SALES
      };
  
      Id userRoleId = UserInfo.getUserRoleId();
      Id profileId = UserInfo.getProfileId();
  
      if (userRoleId != null) {
        String roleName = [SELECT Id, Name FROM Profile WHERE Id = :userRoleId].Name;
        return listOfUserEditPermissions.contains(roleName) ? true: false;
      }
  
      if (profileId != null) {
        String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;
        return profileName == PROFILE_SYSTEM_ADMIN ? true: false;
      }
  
      return false;
    }
  
    @AuraEnabled
    public static List < Pricebook2 > getPricebooks(String searchPhrase) {
      List < Pricebook2 > pricebooksList = new List < Pricebook2 > ();
      String queryPhrase = '%' + String.escapeSingleQuotes(searchPhrase) + '%';
  
      pricebooksList = [
      SELECT Id, Name
      FROM Pricebook2
      WHERE Name LIKE: queryPhrase];
  
      return pricebooksList;
    }
  
    @AuraEnabled
    public static List < PriceBookEntry > getPricebookEntryInfo(String pricebookId) {
      try {
        return [
        SELECT
        Id, Name, Product2Id, Product2.Name, PriceBook2Id, PriceBook2.Name, UnitPrice
        FROM PriceBookEntry
        WHERE PriceBook2Id = :pricebookId];
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static PriceBook2 getPricebookInfo(String pricebookId) {
      PriceBook2 pricebookInfo = new PriceBook2();
  
      try {
        pricebookInfo = [
        SELECT Id, ValidFrom__c, ValidTo__c, IsActive
        FROM PriceBook2
        WHERE id = :pricebookId];
        return pricebookInfo;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static Boolean updatePricebook(
    String pricebookId, String pricebookEntries) {
      List < PricebookEntryWrapper > entryList = (List < PricebookEntryWrapper > ) JSON.deserialize(
      pricebookEntries, List < PricebookEntryWrapper > .class);
      List < PriceBookEntry > pricebookInfo = [
      SELECT Product2Id, UnitPrice
      FROM PriceBookEntry
      WHERE PriceBook2Id = :pricebookId];
  
      Map < Id,
      Decimal > pricebookEntities = new Map < Id,
      Decimal > ();
      Set < Id > idsToChange = new Set < Id > ();
  
      for (PricebookEntryWrapper entry: entryList) {
        pricebookEntities.put(entry.Id, entry.UnitPrice);
        idsToChange.add(entry.Id);
      }
  
      for (PriceBookEntry entry: pricebookInfo) {
        if (idsToChange.contains(entry.Product2Id)) {
          entry.unitPrice = pricebookEntities.get(entry.Product2Id);
        }
      }
  
      try {
        Database.update(pricebookInfo, true);
        return true;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static Boolean updatePricebookDateActive(String pricebookId, Date startDay, Date endDate) {
      Pricebook2 pricebookInfo = [SELECT Name, IsActive, ValidFrom__c, ValidTo__c FROM Pricebook2 WHERE Id = :pricebookId LIMIT 1];
      PricebookEntry pricebookEntries = [SELECT Pricebook2Id, Product2Id, IsActive FROM PricebookEntry WHERE Pricebook2Id = :pricebookId LIMIT 1];
      List < Product2 > product = [SELECT Id, Name, RecordTypeId FROM Product2 WHERE Id = :pricebookEntries.Product2Id];
      List < Pricebook2 > activePricebooks = [SELECT Id, Name, IsActive, ValidFrom__c, ValidTo__c FROM Pricebook2 WHERE isStandard = false];
  
      List < Product2 > productsOfRecordType = [SELECT Id, Name, RecordTypeId FROM Product2 WHERE recordTypeId = :product[0].RecordTypeId];
      Set < Id > productsIds = new Set < Id > ();
      for (Product2 p: productsOfRecordType) {
        productsIds.add(p.Id);
      }
  
      List < PricebookEntry > pricebookEntriesOfRecordType = [SELECT Pricebook2Id, Product2Id, IsActive FROM PricebookEntry WHERE Product2Id IN: productsIds];
      Set < Id > pricebookEntriesPricebookIds = new Set < Id > ();
      for (PricebookEntry entry: pricebookEntriesOfRecordType) {
        pricebookEntriesPricebookIds.add(entry.Pricebook2Id);
      }
  
      List < Pricebook2 > pricebooksOfSelectedIds = [SELECT Id, Name, ValidFrom__c, ValidTo__c FROM Pricebook2 WHERE Id IN: pricebookEntriesPricebookIds];
      List < Date > startDates = new List < Date > ();
      List < Date > endDates = new List < Date > ();
  
      Date overlappingStart;
      Date overlappingEnd;
      String overlappingName;
  
      try {
        for (Pricebook2 pb: pricebooksOfSelectedIds) {
          if (pb.ValidFrom__c != null && pb.ValidTo__c != null && pb.Id != pricebookId) {
            startDates.add(pb.ValidFrom__c);
            endDates.add(pb.ValidTo__c);
            if ((startDay <= pb.ValidTo__c) && (endDate >= pb.ValidFrom__c)) {
              overlappingStart = pb.ValidFrom__c;
              overlappingEnd = pb.ValidTo__c;
              overlappingName = pb.Name;
              throw newMessageException(String.format(System.Label.RE_Dates_Overlap, new String[] {
                overlappingName,
                string.valueOfGmt(overlappingStart),
                string.valueOfGmt(overlappingEnd)
              }));
            }
          }
        }
        pricebookInfo.ValidFrom__c = startDay;
        pricebookInfo.ValidTo__c = endDate;
  
        Database.update(pricebookInfo, true);
        return true;
      }
      catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static String getMissingRecords(
    String currentRecords, String pricebookId) {
      List < PricebookEntry > productListResults = new List < PricebookEntry > ();
      List < Product2 > missingProducts = new List < Product2 > ();
      Set < Id > idsOfExistingProducts = new Set < Id > ();
  
      try {
        List < PricebookEntryWrapper > existingEntryList = (List < PricebookEntryWrapper > ) JSON.deserialize(
        currentRecords, List < PricebookEntryWrapper > .class);
        String productID = existingEntryList[0].Id;
  
        List < Product2 > priceBookRecordType = [
        SELECT id, RecordTypeId
        FROM Product2
        WHERE Id = :productID
        LIMIT 1];
        RecordType recordTypeInfo = [
        SELECT Name, Id
        FROM RecordType
        WHERE Id = :priceBookRecordType[0].RecordTypeId];
  
        for (PricebookEntryWrapper entry: existingEntryList) {
          idsOfExistingProducts.add(entry.id);
        }
  
        Pricebook2 standardPriceBook = [
        SELECT id, name
        FROM Pricebook2
        WHERE isStandard = TRUE];
        List < PricebookEntry > listOfPriceBookEntries = [
        SELECT Id, Product2Id, Name, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2Id = :standardPriceBook.id];
        List < Product2 > listOfIdsMissingProducts1 = [
        SELECT Id, Name
        FROM Product2
        WHERE
        id NOT IN: idsOfExistingProducts
        AND RecordTypeId = :recordTypeInfo.Id];
  
        if (listOfIdsMissingProducts1.size() < 1) {
          return null;
        }
  
        Set < Id > idsOfMissingProducts = new Set < Id > ();
  
        for (Product2 entry: listOfIdsMissingProducts1) {
          idsOfMissingProducts.add(entry.id);
        }
  
        for (PricebookEntry entry: listOfPriceBookEntries) {
          if (idsOfMissingProducts.contains(entry.Product2Id)) {
            productListResults.add(entry);
          }
        }
        return JSON.serialize(productListResults);
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static Boolean addRecordsToPricebook(
    String pricebookId, String pricebookEntries) {
      List < PricebookEntryWrapper > entryList = (List < PricebookEntryWrapper > ) JSON.deserialize(
      pricebookEntries, List < PricebookEntryWrapper > .class);
      Set < Id > entriesIds = new Set < Id > ();
  
      for (PricebookEntryWrapper entry: entryList) {
        entriesIds.add(entry.id);
      }
  
      List < PriceBookEntry > pbEntriesToAdd = [
      SELECT Product2Id, Pricebook2Id, UnitPrice, Name
      FROM PriceBookEntry
      WHERE Id IN: entriesIds];
  
      Map < Id,
      Decimal > entriesIdPrice = new Map < Id,
      Decimal > ();
  
      for (PricebookEntryWrapper entry: entryList) {
        entriesIdPrice.put(entry.Id, entry.UnitPrice);
      }
  
      List < PriceBookEntry > pbEntriesToAdd2 = new List < PriceBookEntry > ();
  
      for (PriceBookEntry entry: pbEntriesToAdd) {
        pbEntriesToAdd2.add(
        new PricebookEntry(
        Pricebook2Id = pricebookId, Product2Id = entry.Product2Id, UnitPrice = entriesIdPrice.get(entry.Id), IsActive = true));
      }
  
      try {
        Database.insert(pbEntriesToAdd2, true);
        return true;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled(cacheable = true)
    public static List < PricebookEntry > getRecordsByRecordType(
    String premiseName) {
      List < Object > result = new List < Object > ();
      List < String > productsOfRecordType = new List < String > ();
      List < PricebookEntry > productListResults = new List < PricebookEntry > ();
  
      if (premiseName.length() == 0) {
        return productListResults;
      }
  
      try {
        RecordType recordTypeInfo = [
        SELECT Name, Id
        FROM RecordType
        WHERE Name = :premiseName];
        List < Product2 > productList = [
        SELECT Id, RecordTypeId, Name
        FROM Product2
        WHERE RecordTypeId = :recordTypeInfo.Id];
  
        for (Product2 product: productList) {
          productsOfRecordType.add(product.Id);
        }
  
        Pricebook2 priceBook = [
        SELECT id, name
        FROM Pricebook2
        WHERE isStandard = TRUE];
        List < PricebookEntry > listOfPriceBookEntries = [
        SELECT Id, Product2Id, Name, UnitPrice
        FROM PricebookEntry
        WHERE Pricebook2Id = :priceBook.Id];
  
        for (PricebookEntry product: listOfPriceBookEntries) {
          if (productsOfRecordType.contains(product.Product2Id)) {
            productListResults.add(product);
          }
        }
        return productListResults;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    public static Pricebook2 createPricebook(
    String pbName, String pbDesc, Date pbStartDay, Date pbEndDay) {
      try {
        Pricebook2 newPricebook = new Pricebook2();
        newPricebook.Name = pbName;
        newPricebook.Description = pbDesc;
        newPricebook.ValidFrom__c = pbStartDay;
        newPricebook.ValidTo__c = pbEndDay;
        newPricebook.IsActive = true;
        Database.insert(newPricebook, false);
  
        return newPricebook;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    @AuraEnabled
    public static Boolean addPricebookToDatabase(
    String pbName, String pbDesc, Date pbStartDay, Date pbEndDay, String pricebookEntries) {
      Pricebook2 pricebook = createPricebook(
      pbName, pbDesc, pbStartDay, pbEndDay);
      List < PricebookEntryWrapper > entryList = (List < PricebookEntryWrapper > ) JSON.deserialize(
      pricebookEntries, List < PricebookEntryWrapper > .class);
      List < PricebookEntry > pricebookEntryList = new List < PricebookEntry > ();
  
      Map < Id,
      PricebookEntry > productMap = new Map < Id,
      PricebookEntry > ([SELECT Id, Product2Id FROM PricebookEntry]);
  
      for (PricebookEntryWrapper entry: entryList) {
        String productID = productMap.get(entry.Id).Product2Id;
        pricebookEntryList.add(
        new PricebookEntry(
        UnitPrice = entry.UnitPrice, Pricebook2Id = pricebook.id, product2Id = productID, isActive = true));
      }
  
      try {
        Database.insert(pricebookEntryList, true);
        return true;
      } catch(Exception e) {
        throw newMessageException(e.getMessage());
      }
    }
  
    class PricebookEntryWrapper {
      Decimal UnitPrice;
      String Id;
    }
  
    class PricebookWrapper {
      String Id;
      Boolean IsActive;
      Date ValidFrom;
      Date ValidTo;
    }
  }