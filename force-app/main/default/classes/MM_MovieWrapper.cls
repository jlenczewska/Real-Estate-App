global with sharing class MM_MovieWrapper {

    @AuraEnabled public boolean adult;
    @AuraEnabled public String backdrop_path;    ///1fJSyFhvxBjyLZsBnYs4641YXu1.jpg
    @AuraEnabled public cls_belongs_to_collection belongs_to_collection;
    @AuraEnabled public Integer budget;    //2962051
    @AuraEnabled public cls_genres[] genres;
    @AuraEnabled public String homepage;    //
    @AuraEnabled public Integer id;    //549
    @AuraEnabled public String imdb_id;    //tt0115632
    @AuraEnabled public String original_language;    //en
    @AuraEnabled public String original_title;    //Basquiat
    @AuraEnabled public String overview;    //The brief life of Jean Michel Basquiat, a world renowned New York street artist struggling with fame, drugs and his identity.
    @AuraEnabled public Double popularity;    //10.15
    @AuraEnabled public String poster_path;    ///qS3zqMxjcXcHUUExvt2uhRvqi8Y.jpg
    @AuraEnabled public cls_production_companies[] production_companies;
    @AuraEnabled public cls_production_countries[] production_countries;
    @AuraEnabled public String release_date;    //1996-08-09
    @AuraEnabled public Integer revenue;    //3011195
    @AuraEnabled public Integer runtime;    //108
    @AuraEnabled public cls_spoken_languages[] spoken_languages;
    @AuraEnabled public String status;    //Released
    @AuraEnabled public String tagline;    //In 1981, A Nineteen-Year-Old Unknown Graffiti Writer Took The New York Art World By Storm. The Rest Is Art History.
    @AuraEnabled public String title;    //Basquiat
    @AuraEnabled public boolean video;
    @AuraEnabled public Double vote_average;    //6.7
    @AuraEnabled public Integer vote_count;    //236
    class cls_belongs_to_collection {
    }
    class cls_genres {
        @AuraEnabled public Integer id;    //18
        @AuraEnabled public String name;    //Drama
    }
    class cls_production_companies {
        @AuraEnabled public Integer id;    //14
        @AuraEnabled public String logo_path;    ///m6AHu84oZQxvq7n1rsvMNJIAsMu.png
        @AuraEnabled public String name;    //Miramax
        @AuraEnabled public String origin_country;    //US
    }
    class cls_production_countries {
        @AuraEnabled public String iso_3166_1;    //US
        @AuraEnabled public String name;    //United States of America
    }
    class cls_spoken_languages {
        @AuraEnabled public String english_name;    //English
        @AuraEnabled public String iso_639_1;    //en
        @AuraEnabled public String name;    //English
    }
}