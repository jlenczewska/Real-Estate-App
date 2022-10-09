public with sharing class MM_MovieDetailsActorsController {

    @AuraEnabled
    public static MM_MovieDetailsActorsWrappr.cls_cast[] fetchMovieActors(Integer idMovieToFetch) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/movie/' + idMovieToFetch + '/credits?api_key=' + custom_settings.api_key__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        responseBody = responseBody.replaceAll('\"cast\"', '\"cast1\"');
        MM_MovieDetailsActorsWrappr actorList = (MM_MovieDetailsActorsWrappr) System.JSON.deserialize(responseBody, MM_MovieDetailsActorsWrappr.class);
        return actorList.cast1;
    }
}