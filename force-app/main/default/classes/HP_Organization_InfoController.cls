public with sharing class HP_Organization_InfoController {

    public List<UserLicense> licencesList { get; set; }
    public Decimal nOApexClasses { get; set; }
    public Decimal nOVFPages { get; set; }
    public List<User> userList { get; set; }
    public List<AggregateResult> deviceList { get; set; }
    public Map<id, String> deviceMap { get; set; }
    public String deleteUserId { get; set; }
    public String saveStatus { get; set; }

    public HP_Organization_InfoController() {
        deviceMap = new Map<id, String>();
        getnOLicences();
        getnOApexClasses();
        getnOVFPages();
        getuserList();
    }

    public void getnOLicences() {
        licencesList = [select TotalLicenses, UsedLicenses, name from userlicense];
    }

    public void getnOApexClasses() {
        nOApexClasses = [SELECT COUNT() FROM ApexClass];
    }

    public void getnOVFPages() {
        nOVFPages = [SELECT COUNT() FROM VisualforceAccessMetrics];
    }

    public void getuserList() {
        userList = [SELECT Username, Email, IsActive, LastLoginDate, id FROM User];
        deviceList = [SELECT UserId, max(LoginTime), min(Application) from LoginHistory group by userid];

        if (deviceList.size() > 0) {
            for (AggregateResult device : deviceList) {
                deviceMap.put((String) device.get('UserId'), (String) device.get('expr1'));
            }
        }
    }

    public PageReference  deleteUser() {

        if(deleteUserId != null){
            system.debug('jup   ' + deleteUserId);
        }
        system.debug(deleteUserId);
        system.debug(saveStatus);
//        User user = [SELECT Username, Email, IsActive, LastLoginDate FROM User WHERE Id = :deleteUserId];
//        system.debug('jup   ' + deleteUserId);
//
//        if (user != null) {
//            system.debug('jup');
//            user.IsActive = false;
//            update user;
//        }
        return null;
    }
}