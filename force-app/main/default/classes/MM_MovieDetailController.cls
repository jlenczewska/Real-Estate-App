public with sharing class MM_MovieDetailController {

    @AuraEnabled
    public static MM_MovieWrapper fetchMovieDetails(Integer idMovieToFetch) {
        api_key_themoviedb__c custom_settings = api_key_themoviedb__c.getInstance();
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.themoviedb.org/3/movie/' + idMovieToFetch + '?api_key=' + custom_settings.api_key__c);
        req.setMethod('GET');
        HttpResponse res = h.send(req);
        MM_MovieWrapper movieDetails = (MM_MovieWrapper) System.JSON.deserialize(res.getBody(), MM_MovieWrapper.class);
        System.debug(movieDetails);
        return movieDetails;
    }

    @AuraEnabled
    public static List<Decimal> getMovieRating(Integer idMovieToFetch) {

        Decimal reviewCount = 0;
        List<Decimal> returnValues = new List<Decimal>();

        List<Comment__c> reviews = new List<Comment__c>();

        reviews = [SELECT NumberOfStars_c__c FROM Comment__c WHERE MovieID__c = :idMovieToFetch];

        for (Comment__c rev : reviews) {
            reviewCount += rev.NumberOfStars_c__c;
        }

        if(reviews.size() != 0){
            returnValues.add(reviewCount / reviews.size());
            returnValues.add(reviews.size());
        }
        else{
            returnValues.add(0);
            returnValues.add(0);
        }

        return returnValues;
    }
}