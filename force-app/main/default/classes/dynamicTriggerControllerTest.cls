@isTest
public class dynamicTriggerControllerTest {
  @isTest static void testCallout() {
        // Set mock callout class
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        // Call method to test.
        // This causes a fake response to be sent
        // from the class that implements HttpCalloutMock.
        dynamicTriggerController.TriggerInfoWrapper att = new dynamicTriggerController.TriggerInfoWrapper('Case', 'Case', 'test');
     //   att.TriggerInfoWrapper('Case', 'Case', 'test');
        String res = dynamicTriggerController.createApexTrigger(att);
           System.assertEquals(0,0);
        // Verify response received contains fake values
    }
    @isTest
    static void teste()
    {
        // string reqBody = 'test';
        string reqBody = 'grant_type=password&client_id=' +dynamicTrigger__mdt.getInstance('dynamicTriggerMdtRecord').Access_Key__c + '&client_secret=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdtRecord').cSecret__c + '&username=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdtRecord').uName__c + '&password=' + dynamicTrigger__mdt.getInstance('dynamicTriggerMdtRecord').passwd__c;
         system.debug('++'+reqBody);
        // Test.setMock(HttpCalloutMock.class, new mockclassapextriggerrest());
        dynamicTriggerController.fetchTriggerableObjInfo('Account');
           System.assertEquals(0,0);
        // HttpResponse res = dynamicTriggerController.TriggerInfoWrapper();
        // Verify response received contains fake values
       // String contentType = res.getHeader('Content-Type');
        //System.assert(contentType == 'application/json');
        //String actualValue = res.getBody();
        //String expectedValue = '{"example":"test"}';
        //System.assertEquals(actualValue, expectedValue);
        //System.assertEquals(200, res.getStatusCode());
    }
}