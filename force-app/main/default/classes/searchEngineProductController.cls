public with sharing class searchEngineProductController {
  public static final String ROLE_SALES_REPRESENTANTS_B2B = 'B2B Sales Representants';
  public static final String ROLE_SALES_REPRESENTANTS_B2C = 'B2C Sales Representants';
  public static final String PROFILE_SYSTEM_ADMIN = 'System Administrator';

  private static AuraHandledException newMessageException(String message) {
    AuraHandledException e = new AuraHandledException(message);
    e.setMessage(message);
    return e;
  }

  @AuraEnabled
  public static String checkUserPremissions() {
    String typeOfUser;

    Id userRoleId = UserInfo.getUserRoleId();
    Id profileId = UserInfo.getProfileId();

    if (userRoleId != null) {
      String roleName = [SELECT Id, Name FROM Profile WHERE Id = :userRoleId]
      .Name;
      if (roleName == ROLE_SALES_REPRESENTANTS_B2B) {
        typeOfUser = 'Business premise';
      } else if (roleName == ROLE_SALES_REPRESENTANTS_B2B) {
        typeOfUser = 'Apartment';
      }
    }

    if (profileId != null) {
      String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId]
      .Name;
      typeOfUser = profileName == PROFILE_SYSTEM_ADMIN
        ? 'Business premise'
        : '';
    }

    return typeOfUser;
  }

  public static String generateQuery(FilterParametersWrapper filtersMap, String queryPhrase){

    String query = 'SELECT Id,Name,Area__c,Balcony__c,City__c,Country__c,Picture__c,Elevator__c,Year_of_construction__c, Facilities_for_the_disabled__c,Kitchen__c,Parking_space__c,Number_of_rooms__c,Shower_Access__c,Street__c, Swimming_Pool__c,cityCountry__c FROM Product2 ';
    List<String> conditions = new List<String>();

    if (
      String.isNotBlank(filtersMap.Filters_Area_From) &&
      filtersMap.Filters_Area_From != 'null'
    ) {
      conditions.add(
        '	Area__c >= ' +
        Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Area_From))
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Area_To) &&
      filtersMap.Filters_Area_To != 'null'
    ) {
      conditions.add(
        '	Area__c <= ' +
        Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Area_To))
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Rooms_From) &&
      filtersMap.Filters_Rooms_From != 'null'
    ) {
      conditions.add(
        '	Number_of_rooms__c >= ' +
        Integer.valueof(
          String.escapeSingleQuotes(filtersMap.Filters_Rooms_From)
        )
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Rooms_To) &&
      filtersMap.Filters_Rooms_To != 'null'
    ) {
      conditions.add(
        '	Number_of_rooms__c <= ' +
        Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Rooms_To))
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Year_From) &&
      filtersMap.Filters_Year_From != 'null'
    ) {
      conditions.add(
        '	Year_of_construction__c >= ' +
        Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Year_From))
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Year_To) &&
      filtersMap.Filters_Year_To != 'null'
    ) {
      conditions.add(
        '	Year_of_construction__c <= ' +
        Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Year_To))
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Parking_From) &&
      filtersMap.Filters_Parking_From != 'null'
    ) {
      conditions.add(
        '	Parking_space__c >= ' +
        Integer.valueof(
          String.escapeSingleQuotes(filtersMap.Filters_Parking_From)
        )
      );
    }
    if (
      String.isNotBlank(filtersMap.Filters_Parking_To) &&
      filtersMap.Filters_Parking_To != 'null'
    ) {
      conditions.add(
        '	Parking_space__c <= ' +
        Integer.valueof(
          String.escapeSingleQuotes(filtersMap.Filters_Parking_To)
        )
      );
    }

    query += ' WHERE ';
    if (conditions.size() > 0) {
      query += conditions[0] + ' AND ';

      for (Integer i = 1; i < conditions.size(); i++) {
        query += conditions[i] + ' AND ';
      }
    }

    if (filtersMap.Filters_Checkbox_Group != null) {
      if (filtersMap.Filters_Checkbox_Group.contains('Swimming Pool')) {
        query += ' Swimming_Pool__c  = true AND ';
      }
      if (filtersMap.Filters_Checkbox_Group.contains('Elevator')) {
        query += ' Elevator__c  = true AND ';
      }
      if (filtersMap.Filters_Checkbox_Group.contains('Balcony')) {
        query += ' Balcony__c  = true AND ';
      }
      if (filtersMap.Filters_Checkbox_Group.contains('Shower')) {
        query += ' Shower_Access__c  = true AND ';
      }
      if (filtersMap.Filters_Checkbox_Group.contains('Kitchen')) {
        query += ' Kitchen__c  = true AND ';
      }
      if (
        filtersMap.Filters_Checkbox_Group.contains(
          'Facilities for the disabled'
        )
      ) {
        query += ' Facilities_for_the_disabled__c  = true AND ';
      }
    }
    query +=
      'RecordTypeId = \'' +
      Schema.SObjectType.Product2.getRecordTypeInfosByName()
        .get(checkUserPremissions())
        .getRecordTypeId() +
      '\' AND cityCountry__c LIKE \'' +
      queryPhrase +
      '\'';

    query = query.removeEnd('AND');
    return query;

  }

  @AuraEnabled
  public static List<Product2> searchProductByFilters(
    String searchPhrase,
    String filtersInfo
  ) {
    List<Product2> productsList;

    String queryPhrase =
      '%' +
      String.escapeSingleQuotes(searchPhrase.trim()) +
      '%';

    Set<Id> pricebooksIds = new Set<Id>();

    List<Pricebook2> pricebooksIdsList = [
      SELECT Id
      FROM pricebook2
      WHERE isactive = TRUE
    ];

    for (Pricebook2 pb : pricebooksIdsList) {
      pricebooksIds.add(pb.id);
    }

    FilterParametersWrapper filtersMap;

    if (filtersInfo != null && filtersInfo != 'null' && filtersInfo != '') {
      filtersMap = (FilterParametersWrapper) JSON.deserialize(
        filtersInfo,
        FilterParametersWrapper.class
      );
    } else {
      productsList = [
        SELECT
          Id,
          Name,
          Area__c,
          Balcony__c,
          City__c,
          Country__c,
          Picture__c,
          Elevator__c,
          Year_of_construction__c,
          Facilities_for_the_disabled__c,
          Kitchen__c,
          Parking_space__c,
          Number_of_rooms__c,
          Shower_Access__c,
          Street__c,
          Swimming_Pool__c,
          cityCountry__c
        FROM Product2
        WHERE
          cityCountry__c LIKE :queryPhrase
          AND RecordTypeId = :Schema.SObjectType.Product2.getRecordTypeInfosByName()
            .get(checkUserPremissions())
            .getRecordTypeId()
      ];
      return productsList;
    }
   
    String query = generateQuery(filtersMap, queryPhrase);

    try{
      return Database.query(query);
    }
    catch(Exception e){
      throw newMessageException(e.getMessage());
    }
  }

  @AuraEnabled
  public static List<AggregateResult> getProductsPrice() {
    List<Product2> productsList;
    Set<Id> pricebooksIds = new Set<Id>();
    
    try{
    List<Pricebook2> pricebooksIdsList = [
      SELECT Id
      FROM pricebook2
      WHERE isactive = TRUE
    ];

    for (Pricebook2 pb : pricebooksIdsList) {
      pricebooksIds.add(pb.id);
    }

    List<PricebookEntry> pricebookEntryList = [
      SELECT Id, Product2ID, Pricebook2Id
      FROM PricebookEntry
      WHERE Pricebook2Id IN :pricebooksIds
    ];

    List<AggregateResult> pricebookMinPrices = [
      SELECT MIN(UnitPrice), Product2ID
      FROM PricebookEntry
      GROUP BY Product2ID
    ];
    
    return pricebookMinPrices;

    }
    catch(Exception e){
      throw newMessageException(e.getMessage());
    }
  }

  public class FilterParametersWrapper {
    public String Filters_Area_From;
    public String Filters_Area_To;
    public String[] Filters_Checkbox_Group;
    public String Filters_Rooms_From;
    public String Filters_Rooms_To;
    public String Filters_Year_From;
    public String Filters_Year_To;
    public String Filters_Parking_From;
    public String Filters_Parking_To;
  }
}
