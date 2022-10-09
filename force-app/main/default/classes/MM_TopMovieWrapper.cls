public class MM_TopMovieWrapper {
    @AuraEnabled public Integer page;    //1
    @AuraEnabled public cls_results[] results;
    @AuraEnabled public Integer total_pages;    //515
    @AuraEnabled public Integer total_results;    //10296
    public class cls_results {
        @AuraEnabled public boolean adult;
        @AuraEnabled public String backdrop_path;    ///tmU7GeKVybMWFButWEGl2M4GeiP.jpg
        @AuraEnabled public Integer[] genre_ids;
        @AuraEnabled public Integer id;    //238
        @AuraEnabled public String original_language;    //en
        @AuraEnabled public String original_title;    //The Godfather
        @AuraEnabled public String overview;    //Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.
        @AuraEnabled public Double popularity;    //88.309
        @AuraEnabled public String poster_path;    ///3bhkrj58Vtu7enYsRolD1fZdja1.jpg
        @AuraEnabled public String release_date;    //1972-03-14
        @AuraEnabled public String title;    //The Godfather
        @AuraEnabled public boolean video;
        @AuraEnabled public Double vote_average;    //8.7
        @AuraEnabled public Integer vote_count;    //16563
    }
}