public with sharing class MM_MovieDetailsActorsWrappr {
    @AuraEnabled public Integer id;    //550
    @AuraEnabled public cls_cast[] cast1;
    @AuraEnabled public cls_crew[] crew;
    public class cls_cast {
        @AuraEnabled public boolean adult;
        @AuraEnabled public Integer gender;    //2
        @AuraEnabled public Integer id;    //819
        @AuraEnabled public String known_for_department;    //Acting
        @AuraEnabled public String name;    //Edward Norton
        @AuraEnabled public String original_name;    //Edward Norton
        @AuraEnabled public Double popularity;    //23.367
        @AuraEnabled public String profile_path;    ///5XBzD5WuTyVQZeS4VI25z2moMeY.jpg
        @AuraEnabled public Integer cast_id;    //4
        @AuraEnabled public String character;    //The Narrator
        @AuraEnabled public String credit_id;    //52fe4250c3a36847f80149f3
        @AuraEnabled public Integer order;    //0
    }
    public class cls_crew {
        @AuraEnabled public boolean adult;
        @AuraEnabled public Integer gender;    //2
        @AuraEnabled public Integer id;    //376
        @AuraEnabled public String known_for_department;    //Production
        @AuraEnabled public String name;    //Arnon Milchan
        @AuraEnabled public String original_name;    //Arnon Milchan
        @AuraEnabled public Double popularity;    //3.474
        @AuraEnabled public String profile_path;    ///b2hBExX4NnczNAnLuTBF4kmNhZm.jpg
        @AuraEnabled public String credit_id;    //55731b8192514111610027d7
        @AuraEnabled public String department;    //Production
        @AuraEnabled public String job;    //Executive Producer
    }
}