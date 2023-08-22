public with sharing class BoxController {
   @AuraEnabled
   public static string getUrl(){
        System.debug('getUrl is calling');
       /* string key = '9nukoymon9vjro9x651mpxvlx8h4b6wj' ;
        string secret = 'AhjwbJOayVXhMKWIaf5kj49G9VFMugQP' ;
        string redirect_uri = 'https://briskminds-b2-dev-ed.develop.my.site.com/s/boxcom' ;*/
        List<User_Credential__mdt> settings = [SELECT 	Key__c, Secret__c, Ridirect_Uri__c FROM User_Credential__mdt LIMIT 1];
        User_Credential__mdt setting = settings[0];
        string key = setting.Key__c;
        string secret = setting.Secret__c;
        string redirect_uri = setting.Ridirect_Uri__c;
        System.debug('Key'+key);
        System.debug('Secret'+secret);
        System.debug('Redirect Uri'+redirect_uri);
        //Authenticating
        PageReference pg = new PageReference(GoogleDriveAuthUri (key , redirect_uri)) ;
        System.debug('The page reference we are returning is'+pg.getUrl());
        return pg.getUrl();
   }
   @auraEnabled public static String GoogleDriveAuthUri(String Clientkey,String redirect_uri)
    {
        String key = EncodingUtil.urlEncode(Clientkey,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String authuri = '';
        authuri = 'https://account.box.com/api/oauth2/authorize'+
        '?client_id='+key+
        '&response_type=code'+
        '&redirect_uri='+uri+
        '&scope=root_readwrite';
        System.debug('The Url which we are passing is'+authuri);
        return authuri;
    }
    @auraEnabled public static Map<STring,Object> getAccess(String addrs){
        system.debug('getAccess method is called');
        system.debug('The value of addrs is '+addrs);

        Map<String, Object> metadata_Map = new Map<String, Object>();
  /*      
        string key = '9nukoymon9vjro9x651mpxvlx8h4b6wj' ;
        string secret = 'AhjwbJOayVXhMKWIaf5kj49G9VFMugQP' ;
        string redirect_uri = 'https://briskminds-b2-dev-ed.develop.my.site.com/s/boxcom' ;*/

        List<User_Credential__mdt> settings = [SELECT 	Key__c, Secret__c, Ridirect_Uri__c FROM User_Credential__mdt LIMIT 1];
        User_Credential__mdt setting = settings[0];
        string key = setting.Key__c;
        string secret = setting.Secret__c;
        string redirect_uri = setting.Ridirect_Uri__c;
       
       HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://api.box.com/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+addrs+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        System.debug(res.getBody());
        metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(resp);
        Datetime expireIn = System.now().addSeconds((Integer)metadata_Map.get('expires_in'));
                String curUserName = UserInfo.getUserName();
                List<BoxUser__c> existingUser = [SELECT Id, User__c FROM BoxUser__c WHERE User__c=:curUserName];
                System.debug('Curret metadata is'+metadata_Map);
                if (existingUser.size()==0) {
                    User usr = [SELECT Id, ContactId FROM User WHERE UserName =:curUserName LIMIT 1];
                    BoxUser__c intAcc = new BoxUser__c( Name=UserInfo.getName(),
                                                            Refresh_Token__c=(String)metadata_Map.get('refresh_token'),
                                                            Access_Token__c=(String)metadata_Map.get('access_token'),
                                                            Expiry_Time__c=expireIn,
                                                            User__c=curUserName
                                                           // Contact__c=usr.ContactId
                                                            );
                    insert intAcc;
                }

        return metadata_Map;
    }
    @auraEnabled
    public static  Object fetchDriveFiles(String accessToken) {
        System.debug('fetchDriveFiles method is called');
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        System.debug('The access token we are getting is '+ existingUser[0].Access_Token__c);
        String apiUrl = 'https://api.box.com/2.0/folders/0/items';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' +existingUser[0].Access_Token__c);
        
        Http dataH = new Http();   
        if(existingUser[0].Expiry_Time__c>System.now()){
            HttpResponse dataResponse = dataH.send(request);
            System.debug('Response from fetch files is '+dataResponse.getBody());
            if(dataResponse.getStatusCode() == 200){
            String dataResStr = dataResponse.getBody();
            //deSerealizeAndStoreInWrapper(dataResStr);
            System.debug('Files response is '+dataResStr);
            Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(dataResStr);
            System.debug('Result we are returning '+fileData.get('entries'));
            return fileData.get('entries');
            }
            else if(dataResponse.getStatusCode() == 401){
                Map<String, Object> accessData=new Map<String,Object>();
                accessData=getAccessTokenFromRefreshToken(existingUser[0].Refresh_Token__c);
                String refreshAccess=(String)accessData.get('access_token');
                String UrlApi = 'https://api.box.com/2.0/folders/0/items';
                
                HttpRequest newRequest = new HttpRequest();
                newRequest.setEndpoint(UrlApi);
                newRequest.setMethod('GET');
                newRequest.setHeader('Authorization', 'Bearer ' +refreshAccess);
                
                HttpResponse newResponse = new Http().send(newRequest);
                if(newResponse.getStatusCode() == 200){
                    Map<String, Object> newTokenResponse = (Map<String, Object>) JSON.deserializeUntyped(newResponse.getBody());
                    Datetime updatedExpireIn = System.now().addSeconds((Integer)accessData.get('expires_in'));
                    existingUser[0].Access_Token__c=(String)accessData.get('access_token');
                    existingUser[0].Expiry_Time__c=updatedExpireIn;
                    update existingUser;
                    return newTokenResponse.get('entries');
                }
                else
                {
                System.debug('Not getting status 200');
                return null;
                }
            }
            return null;
        }            
       else{
        {
            //Checked  this thing is working fine
            System.debug('Entered in else condtion of getting refresh token from google drive');
            Map<String,Object> accessMetadata_Map = getAccessTokenFromRefreshToken(existingUser[0].Refresh_Token__c);
            String refreshAccess=(String)accessMetadata_Map.get('access_token');
            String UrlApi = 'https://api.box.com/2.0/folders/0/items';
             HttpRequest newRequest = new HttpRequest();
             newRequest.setEndpoint(UrlApi);
             newRequest.setMethod('GET');
             newRequest.setHeader('Authorization', 'Bearer ' +refreshAccess);
             HttpResponse newResponse = new Http().send(newRequest);
            if(newResponse.getStatusCode() == 200){
                       Map<String, Object> newTokenResponse = (Map<String, Object>) JSON.deserializeUntyped(newResponse.getBody());
                         Datetime updatedExpireIn = System.now().addSeconds((Integer)accessMetadata_Map.get('expires_in'));
                        existingUser[0].Access_Token__c=(String)accessMetadata_Map.get('access_token');
                        existingUser[0].Expiry_Time__c=updatedExpireIn;
                        update existingUser;
                        System.debug('values of the object is changed successfully');
                        return newTokenResponse.get('entries');
                     }
                     else
                     {
                        System.debug('Not getting status 200');
                        return null;
                     }
            
        }
       
       }
    }
    @auraEnabled
    public static void deleteFileOrFolder(String fileId,String accessToken) {
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        HttpRequest request = new HttpRequest();
        System.debug('Access token of the existing user is '+existingUser[0].Access_Token__c);
        request.setEndpoint('https://api.box.com/2.0/files/' + fileId);
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer ' +existingUser[0].Access_Token__c );
        HttpResponse response = new Http().send(request);
        System.debug(response.getBody());
        if (response.getStatusCode() == 204) {
            System.debug('File or folder deleted successfully');
        } else {
            System.debug('Error deleting file or folder. Status code: ' + response.getStatusCode());
        }
    }
    @AuraEnabled
    public static string createTheFolder(String folderName, String accessToken, String parentFolder){
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        System.debug('Folder name is '+folderName);
        System.debug('Access Token in create folder is '+existingUser[0].Access_Token__c);
        String apiUrl = 'https://api.box.com/2.0/folders';

        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
        request.setHeader('Content-Type', 'application/json');
    
        String requestBody = JSON.serialize(
            new Map<String, Object>{
                'name' => folderName,
                'parent' => new Map<String, Object>{
                    'id' => parentFolder
                }
            }
        );
        request.setBody(requestBody);
    
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('REsponse of foder create is '+response.getBody());
        return 'Successfull';
    }
    @AuraEnabled(cacheable=true)
    public static String checkUser(){
        System.debug('Method is calling check user');
         String curUserName = UserInfo.getUserName();
         List<BoxUser__c> userlist=[SELECT Id,User__c FROM BoxUser__c WHERE User__c=:curUserName];
        if(userlist.size()==0){
            return 'False';
        }
        else{
            return 'True';
        }
    }
    @AuraEnabled
    public static Map<String,Object> getAccessTokenFromRefreshToken(String refreshToken) {
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        System.debug('Refresh token method is called');
        String apiUrl = 'https://api.box.com/oauth2/token';
        String clientId='9nukoymon9vjro9x651mpxvlx8h4b6wj';
        String clientSecret='AhjwbJOayVXhMKWIaf5kj49G9VFMugQP';
        //String refreshToken='72ylOkHXiqsVoWsPnx6E55s5pNNdxHlVDzSH0TIHAlWI3YAL7EK2Vow0aPoyBgS0';
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        
        String requestBody = 'grant_type=refresh_token';
        requestBody += '&refresh_token=' + EncodingUtil.urlEncode(existingUser[0].Refresh_Token__c, 'UTF-8');
        requestBody += '&client_id=' + EncodingUtil.urlEncode(clientId, 'UTF-8');
        requestBody += '&client_secret=' + EncodingUtil.urlEncode(clientSecret, 'UTF-8');
        
        request.setBody(requestBody);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('result which we are ending is '+response.getBody());
       
            Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            System.debug('result which we are ending is '+response.getBody());
            System.debug('Access token from refresh token is '+responseMap.get('access_token'));
            return  responseMap;
    }
    
    @auraEnabled public static void uploadFileToBox(String fileName, String fileCon, String parentID, String accessToken) {
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        System.debug('Upload the file is calling');
        System.debug('File content is ' + fileCon);
        
        String boundary = '----WebKitFormBoundary' + System.currentTimeMillis();
        String newLine = '\r\n';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://upload.box.com/api/2.0/files/content');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
        request.setHeader('Content-Type', 'multipart/form-data; boundary=' + boundary);
        
        String body = '--' + boundary + newLine;
        body += 'Content-Disposition: form-data; name="file"; filename="' + fileName + '"' + newLine;
        body += 'Content-Type: application/octet-stream' + newLine + newLine;
        body += fileCon + newLine;
        body += '--' + boundary + newLine;
        body += 'Content-Disposition: form-data; name="parent_id"' + newLine + newLine;
        body += parentID + newLine;
        body += '--' + boundary + '--';
        
        request.setBody(body);
        
        HttpResponse response = new Http().send(request);
        if (response.getStatusCode() == 201) {
            System.debug('File uploaded successfully');
        } else {
            System.debug('Error uploading file. Status code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());
        }
    }
    @AuraEnabled
    public static String downloadTheFile(String fileId, String accessToken) {
        
            String curUserName = UserInfo.getUserName();
            List<Integration_User__c> existingUser = [SELECT Id, User__c, Access_Token__c, Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c = :curUserName];
            String endpoint = 'https://www.googleapis.com/drive/v3/files/' + fileId + '/export?mimeType=application%2Fpdf'; // Specify the desired MIME type for the exported file
            
            HttpRequest request = new HttpRequest();
            request.setEndpoint(endpoint);
            request.setMethod('GET');
            request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
            
            Http http = new Http();
            HttpResponse response = http.send(request);
            
            if (response.getStatusCode() == 200) {
                String fileLocation = response.getHeader('location');
                return fileLocation;
            }
            
            return null;
        }
        
    @AuraEnabled
    public static Object getSubFolders( String folder){
        System.debug('I am entered in Sub folders');
        String curUserName = UserInfo.getUserName();
        System.debug('Folder id is '+folder);
        List<BoxUser__c> existingUser = [SELECT Access_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        System.debug('getSubfoldersAndFiles method is calling');
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://api.box.com/2.0/folders/' + folder + '/items');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' +  existingUser[0].Access_Token__c);
        request.setTimeout(60000);
        HttpResponse response = new Http().send(request);
      //  String jsonResponse = response.getBody();
        System.debug('Subfolder and files are>>>>'+response.getBody());
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return jsonResponse.get('entries');
    }
    @AuraEnabled
    public static string deleteFolder(String folderId, String accessToken ){
        System.debug('Delete folder method is running');
        System.debug('folderId is '+folderId);
        String curUserName = UserInfo.getUserName();
        List<BoxUser__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM BoxUser__c WHERE User__c=:curUserName];
        HttpRequest request = new HttpRequest();
        System.debug('Access token of the existing user is '+existingUser[0].Access_Token__c);
        request.setEndpoint('https://api.box.com/2.0/folders/' + folderId);
        request.setMethod('DELETE');
        request.setHeader('Authorization', 'Bearer ' +existingUser[0].Access_Token__c );
        HttpResponse response = new Http().send(request);
        System.debug(response.getBody());
        if (response.getStatusCode() == 204) {
            System.debug('File or folder deleted successfully');
        } else {
            System.debug('Error deleting file or folder. Status code: ' + response.getStatusCode());
        }
        return 'Success';
    }
}