public with sharing class MM_AddReview {

    @AuraEnabled
    public static void addReviewApex(Integer numberOfStars, String comment, Integer movieID) {

        User usr = [SELECT ID, Name FROM User WHERE ID = :UserInfo.getUserId()];

        Comment__c comm = new Comment__c();
        comm.DateOfReview__c = Date.today();
        comm.MovieID__c = movieID;
        comm.CommenterID__c = UserInfo.getUserId();
        comm.NumberOfStars_c__c = numberOfStars;
        comm.DisplayedName__c = usr.Name;

        if(comment != null && comment.length()>0){
            comm.CommentText__c = comment;
        }
        else{
            comm.CommentText__c = '-';
        }

        try {
            insert comm;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

    }

    @AuraEnabled
    public static Comment__c checkForCommentsApex(Integer movieID) {
        Comment__c comm = new Comment__c();

        try {
            comm = [SELECT MovieID__c, CommenterID__c, CommentText__c, DisplayedName__c,DateOfReview__c,NumberOfStars_c__c FROM Comment__c WHERE MovieID__c = :movieID AND CommenterID__c = :UserInfo.getUserId() LIMIT 1];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return comm;
    }

    @AuraEnabled
    public static List<Comment__c> getAllCommentsApex(Integer movieID) {
        List<Comment__c> comm = new List<Comment__c>();

        try {
            comm = [SELECT MovieID__c, CommenterID__c, CommentText__c, DisplayedName__c,DateOfReview__c,NumberOfStars_c__c FROM Comment__c WHERE MovieID__c = :movieID];
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        return comm;
    }

    @AuraEnabled
    public static String checkUserLicense() {
        Profile p = [Select Name from Profile where Id = :userinfo.getProfileid()];
        return p.Name;
    }

    @AuraEnabled
    public static void deleteComment(String personID, Decimal movieID) {
        Comment__c comm = new Comment__c();

        try {
            comm = [SELECT MovieID__c, CommenterID__c, CommentText__c,NumberOfStars_c__c FROM Comment__c WHERE MovieID__c = :movieID AND CommenterID__c = :personID LIMIT 1];
            delete comm;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }

    }
}