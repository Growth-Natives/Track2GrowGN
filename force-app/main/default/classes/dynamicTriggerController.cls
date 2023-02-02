public class dynamicTriggerController {
    private static String endPoint = URL.getSalesforceBaseUrl().toExternalForm()  + '/services/data/v41.0/sobjects';
    public static String createApexTrigger(TriggerInfoWrapper objTriggerInfo){
        system.debug('value of objTriggerInfo'+objTriggerInfo);
        system.debug('endPoint======>'+endPoint);
        HttpRequest req = createHttpRequest(endPoint+'/ApexTrigger','POST');
        system.debug('req'+req);
        req.setBody(JSON.serialize(objTriggerInfo));
        String response = fetchResponse(req);
        system.debug('response'+response);
        return response;
    }
    /* This method returns only triggerable object infos via callout to sobjects REST Resource */
    public static Map<String, String> fetchTriggerableObjInfo(String objName)
    {
        Map<String, String> mapObjectMapping = new Map<String, String>();
        HttpRequest req = createHttpRequest(endPoint, 'GET');
        String response = fetchResponse(req);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> objs = (List<Object>) body.get('sobjects');
        for (Object obj : objs){
            Map<String, Object> objDesc = (Map<String, Object>)(obj);
            String name = (String) objDesc.get('name');
            if(objName == name){
                Boolean isTriggerable = (Boolean) objDesc.get('triggerable');
                if(isTriggerable){
                    mapObjectMapping.put(name, (String) objDesc.get('label'));
                }
                System.debug(System.LoggingLevel.ERROR, name + ': ' + isTriggerable);
            }
        }
        return mapObjectMapping;
    }
    /* This method returns only triggerable object infos via callout to sobjects REST Resource */
    public static Map<String, String> fetchTriggerableObjInfo(){
        Map<String, String> mapObjectMapping = new Map<String, String>();
        HttpRequest req = createHttpRequest(endPoint, 'GET');
        String response = fetchResponse(req);
        Map<String, Object> body = (Map<String, Object>)JSON.deserializeUntyped(response);
        List<Object> objs = (List<Object>) body.get('sobjects');
        for (Object obj : objs)
        {
            Map<String, Object> objDesc = (Map<String, Object>)(obj);
            String name = (String) objDesc.get('name');
            Boolean isTriggerable = (Boolean) objDesc.get('triggerable');
            if(isTriggerable)
            {
                mapObjectMapping.put(name, (String) objDesc.get('label'));
            }
            System.debug(System.LoggingLevel.ERROR, name + ': ' + isTriggerable);
        }
        return mapObjectMapping;
    }
    /* This method returns response of an http request */
    private static String fetchResponse(HttpRequest req){
        Http objHttp = new Http();
        HttpResponse res = objHttp.send(req);
        return res.getBody();
    }
    // getRequestToken  a access token
    public class responseWrapper
    {
        public string id;
        public string access_token;
        public string instance_url;
    }
    public string getRequestToken()
    {
        string cKey = '3MVG9qZBLe2KqPrgTiCExKbq0llZuEjNVRBctKMhnqfUL.Pd9.b8EEIjKQfN.O1J6whhoU5kVrv_LrubPk6Rq';
        string cSecret = '779AAA1EDAF5BF5F25E572BAA18F7CEFCC0229D0779861701D6A2104D43CB9B0';
        string uName = 'gaurav+admin@growthnatives.com.track2grow';
        string passwd = 'Track2Grow@123';
        // string reqBody = 'test';
        string reqBody = 'grant_type=password&client_id=' + cKey + '&client_secret=' + cSecret + '&username=' + uName + '&password=' + passwd;
        // string reqBody = 'grant_type=password&client_id=' +dynamicTrigger__mdt.getInstance('dynamicTriggerMdt_Details').Access_Key__c + '&client_secret=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdt_Details').cSecret__c + '&username=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdt_Details').uName__c + '&password=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdt_Details').passwd__c;
        system.debug('reqBody  >> '+reqBody);
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setBody(reqBody);
        req.setMethod('POST');
        req.setEndpoint('https://login.salesforce.com/services/oauth2/token?username=gaurav+admin@growthnatives.com.track2grow&password=Track2Grow@123XRmeoGcHSud3gONlnZuVmqi8Y&grant_type=password&client_id=3MVG9qZBLe2KqPrgTiCExKbq0llZuEjNVRBctKMhnqfUL.Pd9.b8EEIjKQfN.O1J6whhoU5kVrv_LrubPk6Rq&client_secret=779AAA1EDAF5BF5F25E572BAA18F7CEFCC0229D0779861701D6A2104D43CB9B0');
        system.debug('req  >> '+req);
        HttpResponse hresp = h.send(req);
        system.debug('hresp  >> '+hresp);
        responseWrapper wResp = (responseWrapper) JSON.deserialize(hresp.getBody(), responseWrapper.class);
        system.debug('Instance url' + wResp.instance_url);
        system.debug('session id' + wResp.access_token);
        system.debug('wResp genrate access token'+wResp.access_token);
        return wResp.access_token;
    }
    /* This method creates a http request with required endpoint and request method */
    private static HttpRequest createHttpRequest(String endpoint, String method)
    {
        String accToken;
        string responseBody;
        dynamicTriggerController obj = new dynamicTriggerController();
        accToken = obj.getRequestToken();
        system.debug('acc token :'+accToken);
        Http h1 = new Http();
        HttpRequest req1 = new HttpRequest();
        req1.setHeader('Authorization', 'Bearer ' + accToken);
        req1.setHeader('Content-Type', 'application/json');
        req1.setMethod('POST');
        req1.setEndpoint(endPoint);
        req1.setMethod(method);
        return req1;
    }
    /* Wraper class to hold trigger information which needs to be set as body while creating trigger */
    public class TriggerInfoWrapper{
        public String Name;
        public String TableEnumOrId;
        public String Body;
        public TriggerInfoWrapper(String objName, String triggerName, String triggerBody)
        {
            System.debug('here>>'+objName+triggerName+triggerBody);
            this.Name = triggerName;
            this.TableEnumOrId = objName;
            this.Body = triggerBody;
        }
    }
}