public with sharing class MM_Movie_Maniac_ComponentController {

    @AuraEnabled
    public static Map<String, Object> getMovieGenres() {

        Map<String, Object> resultMap = new Map<String, Object>();
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/genre/movie/list?api_key=' + custom_settings.api_key__c + '&language=en-US');
        req.setMethod('GET');
        HttpResponse res = h.send(req);

        String responseBody = res.getBody().removeStart('{"genres":').removeEnd('}');

        for (Object obj : (List<Object>) System.JSON.deserializeUntyped(responseBody)) {

            String currStr = obj.toString().removeEnd('}').removeStart('{');
            String currKey = (currStr.split(',')[0]).removeStart('id=');
            String currValue = (currStr.split(',')[1]).removeStart(' name=');

            resultMap.put(currKey, currValue);
        }

        return resultMap;
    }
}