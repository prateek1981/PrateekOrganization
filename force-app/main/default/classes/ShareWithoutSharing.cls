public without sharing class ShareWithoutSharing {
    public static Integer account_Count(){
        return [SELECT ID FROM Account].size();
        
    }
}