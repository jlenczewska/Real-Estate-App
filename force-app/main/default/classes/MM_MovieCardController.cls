public with sharing class MM_MovieCardController {

    @AuraEnabled
    public static MM_MovieWrapper fetchMovieDetails(Integer idMovieToFetch) {

        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/movie/' + idMovieToFetch + '?api_key=' + custom_settings.api_key__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_MovieWrapper movieDetails = (MM_MovieWrapper) System.JSON.deserialize(res.getBody(), MM_MovieWrapper.class);
        return movieDetails;
    }
}