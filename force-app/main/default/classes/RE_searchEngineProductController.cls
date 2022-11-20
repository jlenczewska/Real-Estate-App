public without sharing class RE_searchEngineProductController {
    public static final String ROLE_SALES_REPRESENTANTS_B2B = 'B2B Sales Representants';
    public static final String ROLE_SALES_REPRESENTANTS_B2C = 'B2C Sales Representants';
    public static final String PROFILE_SYSTEM_ADMIN = 'System Administrator';
    public static final String PREMISE_TYPE_BUSINESS = 'Business premise';
    public static final String PREMISE_TYPE_APARTMENT = 'Apartment';
    public static final String OBJECT_PRODUCT2 = 'Product2';
    public static final String FIELD_SET_PRODUCT2_FILTERS = 'searchBarFilters';

    @AuraEnabled
    public static String checkUserPremissions() {
        String typeOfUser;

        Id userRoleId = UserInfo.getUserRoleId();
        Id profileId = UserInfo.getProfileId();
      
        if (Site.getName() != null) {
            typeOfUser = PREMISE_TYPE_APARTMENT;
        } else {
            if (userRoleId != null) {
                String roleName = [SELECT Id, UserRole.Name FROM User WHERE UserRoleId = :userRoleId][0].UserRole.Name;
                if (roleName == ROLE_SALES_REPRESENTANTS_B2B) {
                    typeOfUser = PREMISE_TYPE_BUSINESS;
                } else if (roleName == ROLE_SALES_REPRESENTANTS_B2B) {
                    typeOfUser = PREMISE_TYPE_APARTMENT;
                }
            }

            if (profileId != null) {
                String profileName = [SELECT Id, Name FROM Profile WHERE Id = :profileId].Name;
                typeOfUser = profileName == PROFILE_SYSTEM_ADMIN ? PREMISE_TYPE_APARTMENT : PREMISE_TYPE_APARTMENT;
            }
        }
        return PREMISE_TYPE_APARTMENT;
    }

    @AuraEnabled
    public static List<Product2> searchProductByFilters(String searchPhrase, String filtersInfo) {
        List<Product2> productsList;

        String queryPhrase = '%' + String.escapeSingleQuotes(searchPhrase.trim()) + '%';

        Set<Id> pricebooksIds = new Set<Id>();

        List<Pricebook2> pricebooksIdsList = [SELECT Id FROM pricebook2 WHERE isactive = TRUE];

        for (Pricebook2 pb : pricebooksIdsList) {
            pricebooksIds.add(pb.id);
        }

        FilterParametersWrapper filtersMap;

        if (filtersInfo != null && filtersInfo != 'null' && filtersInfo != '') {
            filtersMap = (FilterParametersWrapper) JSON.deserialize(filtersInfo, FilterParametersWrapper.class);
        } else {
            productsList = [
                SELECT
                    Id,
                    Name,
                    Area__c,
                    Balcony__c,
                    City__c,
                    Country__c,
                    DisplayUrl,
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
                    AND RecordTypeId = :Schema.SObjectType.Product2.getRecordTypeInfosByName().get(checkUserPremissions()).getRecordTypeId()
            ];

            return productsList;
        }

        String query = generateQuery(filtersMap, queryPhrase);

        try {
            return Database.query(query);
        } catch (Exception e) {
            throw newMessageException(e.getMessage());
        }
    }

    @AuraEnabled
    public static List<PricebookEntry> getProductsPrice() {
        List<Product2> productsList;
        List<PricebookEntry> pricebookEntryList = new List<PricebookEntry>();
        List<PricebookEntry> pricebookEntryStandardList = new List<PricebookEntry>();
        Set<Id> pricebooksIds = new Set<Id>();
        Set<Id> entriesWithNonStandardPriceIds = new Set<Id>();
        List<Product2> allProducts = new List<Product2>();

        try {
            allProducts = [SELECT Id FROM Product2];
            List<Pricebook2> pricebooksId = [SELECT Id FROM pricebook2 WHERE isactive = TRUE AND isStandard = FALSE];

            for (Pricebook2 pb : pricebooksId) {
                pricebooksIds.add(pb.Id);
            }

            if (pricebooksId.size() > 0) {
                pricebookEntryList = [SELECT Product2ID, UnitPrice FROM PricebookEntry WHERE Pricebook2Id IN :pricebooksIds];
            }

            for (PricebookEntry pbentry : pricebookEntryList) {
                entriesWithNonStandardPriceIds.add(pbentry.Product2ID);
            }

            for (Product2 product : allProducts) {
                if (!entriesWithNonStandardPriceIds.contains(product.Id)) {
                    entriesWithNonStandardPriceIds.add(product.Id);
                }
            }

            pricebookEntryStandardList = [SELECT Product2ID, UnitPrice FROM PricebookEntry WHERE Product2ID IN :entriesWithNonStandardPriceIds];

            List<PricebookEntry> result = new List<PricebookEntry>();
            result.addAll(pricebookEntryList);
            result.addAll(pricebookEntryStandardList);

            return result;
        } catch (Exception e) {
            throw newMessageException(e.getMessage());
        }
    }

    private static AuraHandledException newMessageException(String message) {
        AuraHandledException e = new AuraHandledException(message);
        e.setMessage(message);
        return e;
    }

    private static String addCondition(FilterParametersWrapper filtersMap) {
        String generatedString = '';
        Map<String, String> checkboxesMap = new Map<String, String>();

        Map<String, Schema.SObjectType> GlobalDescribeMap = Schema.getGlobalDescribe();
        Schema.SObjectType SObjectTypeObj = GlobalDescribeMap.get(OBJECT_PRODUCT2);
        Schema.DescribeSObjectResult DescribeSObjectResultObj = SObjectTypeObj.getDescribe();
        Schema.FieldSet fieldSetObj = DescribeSObjectResultObj.FieldSets.getMap().get(FIELD_SET_PRODUCT2_FILTERS);
        List<Schema.FieldSetMember> fieldSetMemberList = fieldSetObj.getFields();

        for (Schema.FieldSetMember fieldSetMemberObj : fieldSetMemberList) {
            checkboxesMap.put(fieldSetMemberObj.getLabel(), fieldSetMemberObj.getFieldPath());
        }

        for (String key : checkboxesMap.keySet()) {
            if (filtersMap.Filters_Checkbox_Group.contains(key)) {
                generatedString += ' ' + checkboxesMap.get(key) + '  = true AND ';
            }
        }
        return generatedString;
    }

    private static String generateQuery(FilterParametersWrapper filtersMap, String queryPhrase) {
        String query = 'SELECT Id,Name,Area__c,Balcony__c,City__c,Country__c,DisplayUrl,Elevator__c,Year_of_construction__c, Facilities_for_the_disabled__c,Kitchen__c,Parking_space__c,Number_of_rooms__c,Shower_Access__c,Street__c, Swimming_Pool__c,cityCountry__c FROM Product2 ';
        List<String> conditions = new List<String>();

        if (String.isNotBlank(filtersMap.Filters_Area_From) && filtersMap.Filters_Area_From != 'null') {
            conditions.add('	Area__c >= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Area_From)));
        }
        if (String.isNotBlank(filtersMap.Filters_Area_To) && filtersMap.Filters_Area_To != 'null') {
            conditions.add('	Area__c <= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Area_To)));
        }
        if (String.isNotBlank(filtersMap.Filters_Rooms_From) && filtersMap.Filters_Rooms_From != 'null') {
            conditions.add('	Number_of_rooms__c >= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Rooms_From)));
        }
        if (String.isNotBlank(filtersMap.Filters_Rooms_To) && filtersMap.Filters_Rooms_To != 'null') {
            conditions.add('	Number_of_rooms__c <= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Rooms_To)));
        }
        if (String.isNotBlank(filtersMap.Filters_Year_From) && filtersMap.Filters_Year_From != 'null') {
            conditions.add('	Year_of_construction__c >= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Year_From)));
        }
        if (String.isNotBlank(filtersMap.Filters_Year_To) && filtersMap.Filters_Year_To != 'null') {
            conditions.add('	Year_of_construction__c <= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Year_To)));
        }
        if (String.isNotBlank(filtersMap.Filters_Parking_From) && filtersMap.Filters_Parking_From != 'null') {
            conditions.add('	Parking_space__c >= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Parking_From)));
        }
        if (String.isNotBlank(filtersMap.Filters_Parking_To) && filtersMap.Filters_Parking_To != 'null') {
            conditions.add('	Parking_space__c <= ' + Integer.valueof(String.escapeSingleQuotes(filtersMap.Filters_Parking_To)));
        }

        query += ' WHERE ';
        if (conditions.size() > 0) {
            query += conditions[0] + ' AND ';

            for (Integer i = 1; i < conditions.size(); i++) {
                query += conditions[i] + ' AND ';
            }
        }
        if (filtersMap.Filters_Checkbox_Group != null) {
            query += addCondition(filtersMap);
        }

        query +=
            'RecordTypeId = \'' +
            Schema.SObjectType.Product2.getRecordTypeInfosByName().get(checkUserPremissions()).getRecordTypeId() +
            '\' AND cityCountry__c LIKE \'' +
            queryPhrase +
            '\'';
        query = query.removeEnd('AND');
        return query;
    }

    private class FilterParametersWrapper {
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