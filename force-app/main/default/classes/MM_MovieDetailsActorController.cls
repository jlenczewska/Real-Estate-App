public with sharing class MM_MovieDetailsActorController {
    @AuraEnabled
    public static MM_MovieActorWrapper.cls_cast[] fetchActorMovies(Integer idActorToFetch) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/person/' + idActorToFetch + '/movie_credits?api_key=' + custom_settings.api_key__c+'&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        responseBody = responseBody.replaceAll('\"cast\"', '\"cast1\"');
        MM_MovieActorWrapper movieList = (MM_MovieActorWrapper) System.JSON.deserialize(responseBody, MM_MovieActorWrapper.class);
        return movieList.cast1;
    }

    @AuraEnabled
    public static MM_ActorWrapper fetchActorInfo(Integer idActorToFetch) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/person/'+idActorToFetch+'?api_key=' + custom_settings.api_key__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        String responseBody = res.getBody();
        MM_ActorWrapper actorInfo = (MM_ActorWrapper) System.JSON.deserialize(responseBody, MM_ActorWrapper.class);
        return actorInfo;
    }
}