public with sharing class MM_MovieCardsController {

    @AuraEnabled
    public static MM_TopMovieWrapper.cls_results[] fetchMovies(Integer currentPage) {

        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/movie/top_rated?api_key=' + custom_settings.api_key__c + '&page=' + currentPage + '&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_TopMovieWrapper movieList = (MM_TopMovieWrapper) System.JSON.deserialize(res.getBody(), MM_TopMovieWrapper.class);
        return movieList.results;
    }

    @AuraEnabled
    public static MM_TopMovieWrapper.cls_results[] fetchMovieByPhrase(String searchPhrase, Integer currentPage) {

        String searchPhraseTransformed = searchPhrase.replaceAll('\\s+', ' ').removeEnd(' ').removeStart(' ').replaceAll(' ', '+');
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();

        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/search/movie?api_key=' + custom_settings.api_key__c + '&query=' + searchPhraseTransformed + '&page=' + currentPage + '&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_TopMovieWrapper movieList = (MM_TopMovieWrapper) System.JSON.deserialize(res.getBody(), MM_TopMovieWrapper.class);
        return movieList.results;

    }

    @AuraEnabled
    public static MM_TopMovieWrapper.cls_results[] fetchMovieByPhraseActor(String searchPhrase, Integer currentPage) {

        String searchPhraseTransformed = searchPhrase.replaceAll('\\s+', ' ').removeEnd(' ').removeStart(' ').replaceAll(' ', '+');
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/search/person?api_key=' + custom_settings.api_key__c + '&query=' + searchPhraseTransformed + '&page=' + currentPage + '&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_TopMovieWrapper actorId = (MM_TopMovieWrapper) System.JSON.deserialize(res.getBody(), MM_TopMovieWrapper.class);

        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('https://api.themoviedb.org/3/discover/movie?api_key=' + custom_settings.api_key__c + '&with_cast=' + actorId.results[0].id + '&page=' + currentPage + '&include_adult=false');
        req1.setMethod('GET');
        HttpResponse res1 = h1.send(req1);
        MM_TopMovieWrapper movieList = (MM_TopMovieWrapper) System.JSON.deserialize(res1.getBody(), MM_TopMovieWrapper.class);
        return movieList.results;

    }

    @AuraEnabled
    public static MM_TopMovieWrapper.cls_results[] fetchMovieByPhraseGenre(String searchPhrase, Integer currentPage, Map<String, Object> movieGenres) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        String genreId;
        for (String key : movieGenres.keySet()) {
            if (movieGenres.get(key) == searchPhrase) {
                genreId = key;
                break;
            }
        }

        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setEndpoint('https://api.themoviedb.org/3/discover/movie?api_key=' + custom_settings.api_key__c + '&sort_by=popularity.desc&page=' + currentPage + '&include_adult=false&with_genres=' + genreId);
        req1.setMethod('GET');
        HttpResponse res1 = h1.send(req1);
        MM_TopMovieWrapper movieList = (MM_TopMovieWrapper) System.JSON.deserialize(res1.getBody(), MM_TopMovieWrapper.class);
        System.debug(movieList);
        return movieList.results;

    }

    @AuraEnabled
    public static MM_PopularActorsWrapper.cls_results[] fetchActors(Integer currentPage) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/person/popular?api_key=' + custom_settings.api_key__c + '&language=en-US&page=1&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_PopularActorsWrapper movieList = (MM_PopularActorsWrapper) System.JSON.deserialize(res.getBody(), MM_PopularActorsWrapper.class);

        return movieList.results;
    }

    @AuraEnabled
    public static MM_PopularActorsWrapper.cls_results[] fetchActorsByPhrase(String searchPhrase, Integer currentPage) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        String searchPhraseTransformed = searchPhrase.replaceAll('\\s+', ' ').removeEnd(' ').removeStart(' ').replaceAll(' ', '+');
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/search/person?api_key=' + custom_settings.api_key__c + '&query=' + searchPhraseTransformed + '&include_adult=false');
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_PopularActorsWrapper movieList = (MM_PopularActorsWrapper) System.JSON.deserialize(res.getBody(), MM_PopularActorsWrapper.class);
        System.debug(movieList);
        System.debug(movieList.results);
        return movieList.results;

    }

}