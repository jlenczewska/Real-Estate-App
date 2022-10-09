global with sharing class MM_PopularActorsWrapper {
    @AuraEnabled public Integer page;	//1
    @AuraEnabled public cls_results[] results;
    @AuraEnabled public Integer total_pages;	//500
    @AuraEnabled public Integer total_results;	//10000

    public class cls_results {
        @AuraEnabled public boolean adult;
        @AuraEnabled public Integer id;	//238
        @AuraEnabled public String known_for_department;	//en
        @AuraEnabled public String name;	//The Godfather
        @AuraEnabled public String popularity;	//Spanning the years 1945 to 1955, a chronicle of the fictional Italian-American Corleone crime family. When organized crime family patriarch, Vito Corleone barely survives an attempt on his life, his youngest son, Michael steps in to take care of the would-be killers, launching a campaign of bloody revenge.
        @AuraEnabled public String profile_path;	///3bhkrj58Vtu7enYsRolD1fZdja1.jpg
    }
}