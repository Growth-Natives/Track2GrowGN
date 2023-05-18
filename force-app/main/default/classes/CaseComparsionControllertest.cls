@isTest
public class CaseComparsionControllertest
{
    @istest
    public static void CaseComparsionControllertest1()
    {
        List<object> caseList = new List<object>();
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'Default';
        btchInfo.Dates__c = 'This Month';
        //btchInfo.LastReferencedDate = '2022-07-08';
        //btchInfo.StartDate__c = System.today() + 5;
        //btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.DataRepresentation__c = '{"Closed":null,"On Hold":null,"Escalated":null,"InProgress":1.18,"New":null}';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'New, Research, Solution, Assess, Scheduled, Booked, Cancelled, Delivered, Closed';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.SobjectRecordType__c = 'External';
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
        String businessHour = 'Default';
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
        cHistory.NewValue = '222222222222222288';
        cHistory.OldValue = '222222222222222222';
        cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch1=new ObjectHistoryWrapper();
        ch1.Field ='Status';
        ch1.Newvalue= 'In Progress';
        ch1.oldvalue = 'New';
        ch1.DataType = 'DynamicEnum';
        ch1.CreatedDate = system.now();

        ObjectHistoryWrapper cHistory1=new ObjectHistoryWrapper();
        cHistory1.Field ='Owner';
        cHistory1.NewValue = '222222222222222289';
        cHistory1.OldValue = '222222222222222222';
        cHistory1.DataType = 'EntityId';
        cHistory1.CreatedDate = system.now();
        
        newCase.histories = new List<Object>{cHistory,ch,ch1,cHistory1};
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
        //list<BatchInfo__c> bi = new list<BatchInfo__c>( [SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c ='Default' and Dates__c = 'This Month' AND SobjectFieldType__c ='Status' And SobjectType__c ='Case' LIMIT 1]);
        //system.debug('bi>>>>>'+bi);
        Test.startTest();    
        CaseComparsionController.getStatusValue(c.id,'Case');
        CaseComparsionController.getBatchid(c.id,'Case');
        CaseComparsionController.getCaseStatus(c.id,'Case');
        //CaseComparsionController_Mohit.getBatchid(a.id,'Account');
        Test.stopTest();
    }
    
    
    @istest
    public static void CaseComparsionControllertest2()
    {
        List<object> caseList = new List<object>();
        
        BatchInfo__c btchInfo1 = new BatchInfo__c();
        btchInfo1.Businesshour__c = 'Default';
        btchInfo1.Dates__c = 'This Month';
        //btchInfo.LastReferencedDate = '2022-07-08';
        //btchInfo.StartDate__c = System.today() + 5;
        //btchInfo.EndDate__c = System.today() +30;
        btchInfo1.Filter_Name__c = 'test';
        btchInfo1.DataRepresentation__c = '{"Closed":null,"On Hold":null,"Escalated":null,"InProgress":1.18,"New":null}';
        btchInfo1.WillRefresh__c = True;
        btchInfo1.SobjectFieldValue__c = 'New, Research, Solution, Assess, Scheduled, Booked, Cancelled, Delivered';
        btchInfo1.SobjectFieldType__c = 'Status';
        btchInfo1.SobjectRecordType__c = 'External';
        btchInfo1.SobjectType__c = 'Case';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo1;
        
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 6 Months';
        //Date startDate = System.today() + 5;
        //Date endDate = System.today() + 25 ;
        Id recordId = btchInfo1.Id;
        Boolean scheduled = False;
        //Boolean willRefresh = True;
        String businessHour = 'Default';
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
        cHistory.NewValue = '222222222222222288';
        cHistory.OldValue = '222222222222222222';
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
        //list<BatchInfo__c> bi = new list<BatchInfo__c>( [SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c ='Default' and Dates__c = 'This Month' AND SobjectFieldType__c ='Status' And SobjectType__c ='Case' LIMIT 1]);
        //system.debug('bi>>>>>'+bi);
        Test.startTest();    
        CaseComparsionController.getStatusValue(c.id,'Case');
        CaseComparsionController.getBatchid(c.id,'Case');
        CaseComparsionController.getCaseStatus(c.id,'Case');
        //CaseComparsionController_Mohit.getBatchid(a.id,'Account');
        Test.stopTest();
    }
    
     
}