@isTest
public class CaseComparsionControllertest
{
    @istest
    public static void CaseComparsionControllertest1()
    {
        List<object> caseList = new List<object>();
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        //btchInfo.LastReferencedDate = '2022-07-08';
        //btchInfo.StartDate__c = System.today() + 5;
        //btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.DataRepresentation__c = '{"Closed":null,"On Hold":null,"Escalated":null,"InProgress":1.18,"New":null}';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'New, InProgress, Escalated, On Hold, Closed';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.SobjectType__c = 'Case';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        System.debug('btchInfo>>>'+btchInfo);
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 6 Months';
        //Date startDate = System.today() + 5;
        //Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        //Boolean willRefresh = True;
        String businessHour = 'India';
        //String filterName = 'test';
        List<String> fieldValues = new List<String>();
        //fieldValues.add('New');
        //fieldValues.add('InProgress');
        fieldValues.add('InProgress');
        //fieldValues.add('Escalated');
        //fieldValues.add('On Hold');
        //fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('Internal');
        /*Account a=new Account();
        a.Name='Test Account';
        insert a;*/

		Case c = new Case();
        c.Status = 'New';
        c.Origin = 'Email';
        insert c;
        
        
        
        objectwrapper newCase = new objectwrapper();
        newCase.Id = '111111111111111111';
        newCase.OwnerId = '222222222222222222';
        //newCase.recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('External').getRecordTypeId();
        newCase.CreatedDate = System.today();
        
        ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
        ch.Field ='Status';
        ch.Newvalue= 'In Progress';
        ch.oldvalue = 'New';
        ch.DataType = 'DynamicEnum';
        ch.CreatedDate = system.now();

        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Owner';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        newCase.histories = new List<Object>{cHistory,ch};
		caseList.add(newCase);

        String NewId ;
        for(object data :(list<object>)caseList){
            System.debug('pass>>'+data);
            
            Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
            System.debug('mapObj1>>'+mapObj1);
            //map<String,object> hisdata = (map<string,object>)mapObj1.get('Id');
            NewId = String.valueof(mapObj1.get('Id'));
            System.debug('hisdata>>'+NewId);
        }
        Test.startTest();          
        CaseComparsionController.getBatchid(c.id,'Case');
        CaseComparsionController.getCaseStatus(c.id,'Case');
        //CaseComparsionController_Mohit.getBatchid(a.id,'Account');
        Test.stopTest();
    }
     
}