public with sharing class ShareWithSharing {
    public static Integer account_Count(){
        Integer total=[SELECT Id FROM ACCount].size();
        return total;
    }
}