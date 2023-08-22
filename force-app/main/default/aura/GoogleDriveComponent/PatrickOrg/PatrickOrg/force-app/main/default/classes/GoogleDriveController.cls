public class GoogleDriveController
{
    public String nextPageToken;	
	public String kind;	
	public boolean incompleteSearch;
    

    
    @auraEnabled
    public static string checkUserExist(){
        System.debug('Method is calling check user');
         String curUserName = UserInfo.getUserName();
         List<Integration_User__c> userlist=[SELECT Id,User__c FROM Integration_User__c WHERE User__c=:curUserName];
        if(userlist.size()==0){
            System.debug('Method is returning coorect information');
            return 'False';
        }
        else{
            
            return 'True';
        }
    }
   @auraEnabled
    public static String printaddress(String link){
        System.debug('method is calling');
        System.debug('link is>>>>>>>>>>>>>>>>>>>>>>>>>>>'+link);
        return link;
    }  
     @auraEnabled
    public static void test(){							
        System.debug('test method is running');
    }  
    
    @AuraEnabled
    public static String DriveAuth()
    {
        System.debug('Drive auth is calling');
        string key = '763108278293-7m5o3i8lnvvnqq3v3p8e6vuecrorn6cc.apps.googleusercontent.com' ;
        string secret = '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' ;
        string redirect_uri = 'https://briskminds-b2-dev-ed.develop.my.site.com/s/google-drive-page' ;

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
        authuri = 'https://accounts.google.com/o/oauth2/v2/auth?'+
        'client_id='+key+
        '&response_type=code'+
        '&scope=https://www.googleapis.com/auth/drive'+
        '&redirect_uri='+uri+
        '&state=security_token%3D138r5719ru3e1%26url%3Dhttps://oa2cb.example.com/myHome&'+
        '&login_hint=jsmith@example.com&'+
        'access_type=offline';
        
        return authuri;
    }
    @auraEnabled public static String getAccessToken(String addrs){
        string key = '763108278293-7m5o3i8lnvvnqq3v3p8e6vuecrorn6cc.apps.googleusercontent.com' ;
        string secret = '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' ;
        string redirect_uri = 'https://briskminds-b2-dev-ed.develop.my.site.com/s/google-drive-page' ;
       
       HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        req.setEndpoint('https://accounts.google.com/o/oauth2/token');
        req.setHeader('content-type', 'application/x-www-form-urlencoded');
        String messageBody = 'code='+addrs+'&client_id='+key+'&client_secret='+secret+'&redirect_uri='+redirect_uri+'&grant_type=authorization_code';
        req.setHeader('Content-length', String.valueOf(messageBody.length()));
        req.setBody(messageBody);
        req.setTimeout(60*1000);

        Http h = new Http();
        String resp;
        HttpResponse res = h.send(req);
        resp = res.getBody();
        
        System.debug(' You can parse the response to get the access token ::: ' + resp);
        
        Map<String, Object> metadata_Map = new Map<String, Object>();
        metadata_Map = (Map<String, Object>) JSON.deserializeUntyped(resp);
        Datetime expireIn = System.now().addSeconds((Integer)metadata_Map.get('expires_in'));
                       String curUserName = UserInfo.getUserName();
                List<Integration_User__c> existingUser = [SELECT Id, User__c FROM Integration_User__c WHERE User__c=:curUserName];
                System.debug('Curret metadata is'+metadata_Map);
                if (existingUser.size()==0) {
                    User usr = [SELECT Id, ContactId FROM User WHERE UserName =:curUserName LIMIT 1];
                    Integration_User__c intAcc = new Integration_User__c( Name=UserInfo.getName(),
                                                            Refresh_Token__c=(String)metadata_Map.get('refresh_token'),
                                                            Access_Token__c=(String)metadata_Map.get('access_token'),
                                                            Expiry_Time__c=expireIn,
                                                            User__c=curUserName
                                                           // Contact__c=usr.ContactId
                                                            );
                    insert intAcc;
                }
        return resp;
    }
	
    @auraEnabled
    public static  Object fetchDriveFiles(String accessToken) {
        
        //This thing is working fine from here to
       System.debug('Fetch drive files is  running');
        String curUserName = UserInfo.getUserName();
        List<Integration_User__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c=:curUserName];
        
        String apiUrl = 'https://www.googleapis.com/drive/v3/files?q=\'root\'+in+parents&trashed=false&fields=*';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' +existingUser[0].Access_Token__c);
        
        Http dataH = new Http();
        if(existingUser[0].Expiry_Time__c>System.now()){                 //update the sign positively
                HttpResponse dataResponse = dataH.send(request);
                if(dataResponse.getStatusCode() == 200){
                    String dataResStr = dataResponse.getBody();
                    //deSerealizeAndStoreInWrapper(dataResStr);
                    Map<String, Object> fileData = (Map<String, Object>) JSON.deserializeUntyped(dataResStr);
                   System.debug('Files are '+fileData);
                    return fileData.get('files');
                    
        		}
            //here 
                 else if(dataResponse.getStatusCode() == 401){
                     Map<String, Object> accessData=new Map<String,Object>();
                     accessData=getFromRefreshToken(existingUser[0].Refresh_Token__c);
                       String refreshAccess=(String)accessData.get('access_token');
                       String UrlApi = 'https://www.googleapis.com/drive/v3/files';
                        
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
                        System.debug('Files are '+newTokenResponse);
                         return newTokenResponse.get('files');
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
            //Checked  this thing is working fine
            
            Map<String,Object> accessMetadata_Map = getFromRefreshToken(existingUser[0].Refresh_Token__c);
            String refreshAccess=(String)accessMetadata_Map.get('access_token');
            String UrlApi = 'https://www.googleapis.com/drive/v3/files';
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
                        System.debug('Files are '+newTokenResponse);
                         return newTokenResponse.get('files');
                     }
                     else
                     {
                        System.debug('Not getting status 200');
                        return null;
                     }
            
        }
       
    }
    @auraEnabled
    public static  Map<String, Object> getFromRefreshToken(String refresh){
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://accounts.google.com/o/oauth2/token');
        request.setMethod('POST');
		//refresh token-'1//0g4WFeElvfbOfCgYIARAAGBASNwF-L9IrmW9f_igNi0jL8qzgdeup3xF-EoIi86_-REWjX004uw0FuN8V7663YjKAPRCs93aqSXs'
        
        String requestBody = 'grant_type=refresh_token' +
                             '&client_id=' + EncodingUtil.urlEncode('763108278293-7m5o3i8lnvvnqq3v3p8e6vuecrorn6cc.apps.googleusercontent.com', 'UTF-8') +
                             '&client_secret=' + EncodingUtil.urlEncode('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', 'UTF-8') +
                             '&refresh_token=' + EncodingUtil.urlEncode(refresh, 'UTF-8');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setBody(requestBody);

       
        HttpResponse response = new Http().send(request);
        
        
        if (response.getStatusCode() == 200) {
           	   Map<String, Object> tokenResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
              
               
              return  tokenResponse;
        }
        else {
            System.debug('Error refreshing access token: ' + response.getBody());
            return null;
    }
}
    
    @auraEnabled 
    public static void createFolder(String accessToken,String filename, String parent){
    
    System.debug('Parent folder is '+parent);
    String curUserName = UserInfo.getUserName();
    List<Integration_User__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c=:curUserName];    
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://www.googleapis.com/drive/v3/files');
    request.setMethod('POST');
    request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
    request.setHeader('Content-Type', 'application/json');
    
    //String body = '{"name": "' + filename + '", "mimeType": "application/vnd.google-apps.folder"';
    
    //body += '}';
    
    String requestBody = JSON.serialize(
    new Map<String, Object>{
        'name' => filename,
        'mimeType' => 'application/vnd.google-apps.folder',
        'parents' => new List<String>{ parent }
    }
);


    request.setBody(requestBody);
    
    HttpResponse response = new Http().send(request);
    
    if (response.getStatusCode() == 200) {
        System.debug('Folder created successfully.');
    } else {
        System.debug('Failed to create folder. Error: ' + response.getBody());
    }
        
}
    @auraEnabled
    public static void deleteFileOrFolder(String fileId) {
    String curUserName = UserInfo.getUserName();
    List<Integration_User__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c=:curUserName];
    HttpRequest request = new HttpRequest();
    request.setEndpoint('https://www.googleapis.com/drive/v3/files/' + fileId);
    request.setMethod('DELETE');
    request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
    HttpResponse response = new Http().send(request);
        System.debug(response.getBody());
    if (response.getStatusCode() == 204) {
        System.debug('File or folder deleted successfully');
    } else {
        System.debug('Error deleting file or folder. Status code: ' + response.getStatusCode());
    }
}

    @auraEnabled
    public static Object getSubfoldersAndFiles(String parentfolderid, String accessToken) {
        System.debug('I am entered in Sub folders');
        String curUserName = UserInfo.getUserName();
    	List<Integration_User__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c=:curUserName];

        System.debug('getSubfoldersAndFiles method is calling');
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/drive/v3/files?q="' + parentFolderId + '"+in+parents');
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' +  existingUser[0].Access_Token__c);
    
        HttpResponse response = new Http().send(request);
      //  String jsonResponse = response.getBody();
        System.debug('Subfolder and files are>>>>'+response.getBody());
        Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
        return jsonResponse.get('files');
}

    @AuraEnabled
    
        public static string getFileUrl(String fileId, String accessToken) {
        String endpoint = 'https://www.googleapis.com/drive/v3/files/' + fileId + '?fields=webContentLink';
        String curUserName = UserInfo.getUserName();
    	List<Integration_User__c> existingUser = [SELECT Id, User__c,Access_Token__c,Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c=:curUserName];

            
        HttpRequest request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
        
        Http http = new Http();
        HttpResponse response = http.send(request);
        
        if (response.getStatusCode() == 200) {
            Map<String, Object> jsonResponse = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            String webContentLink = (String) jsonResponse.get('webContentLink');
            system.debug('Link is'+webContentLink);
            return webContentLink;
        }
        
        return null;            
        }

    @auraEnabled 
    public static void uploadTheFile(String filename,String parentid,String filecon,String cd,String accessToken){
        String curUserName = UserInfo.getUserName();
        List<Integration_User__c> existingUser = [SELECT Id, User__c, Access_Token__c, Expiry_Time__c, Refresh_Token__c FROM Integration_User__c WHERE User__c = :curUserName];
        System.debug('Upload the file is calling');
        System.debug('File content is ' + fileCon);
        
        String boundary = '----WebKitFormBoundary' + System.currentTimeMillis();
        String newLine = '\r\n';
        
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart');
        request.setMethod('POST');
        request.setHeader('Authorization', 'Bearer ' + existingUser[0].Access_Token__c);
        request.setHeader('Content-Type', 'multipart/related; boundary=' + boundary);
        
        String body = '--' + boundary + newLine;
        body += 'Content-Type: application/json' + newLine + newLine;
        body += '{"name": "' + filename + '", "parents": ["' + parentid + '"]}' + newLine + newLine;
        body += '--' + boundary + newLine;
        body += 'Content-Type: application/octet-stream' + newLine;
        body += 'Content-Disposition: form-data; name="file"; filename="' + fileName + '"' + newLine + newLine;
        body += fileCon + newLine;
        body += '--' + boundary + '--';
        
        request.setBody(body);
        
        HttpResponse response = new Http().send(request);
        system.debug('response is '+response.getBody());
        if (response.getStatusCode() == 200) {
            System.debug('File uploaded successfully');
        } else {
            System.debug('Error uploading file. Status code: ' + response.getStatusCode());
            System.debug('Response Body: ' + response.getBody());
        }
        
    }
	
	
    
}