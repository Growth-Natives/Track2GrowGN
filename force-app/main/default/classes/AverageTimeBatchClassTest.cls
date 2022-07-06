@isTest
public class AverageTimeBatchClassTest 
{ 
    @isTest static void averageTimeBatchClassTest()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
        recordTypes.add('Internal');
        
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest2()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = Null;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'India';
        String filterName = '';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        /*List<Case> caseList = new List<Case>();
        Case newCase = new Case();
        newCase.Origin = 'Email';
        newCase.Status = 'New';
        insert newCase;
        caseList.add(newCase);*/
        recordTypes.add('External');
        /*Case c = new Case();
        c.Origin = 'Email';
        c.Status = 'New';
        insert c;
        c.Status = 'Escalated';
        update c;*/
        test.startTest();
        //List<CaseHistory> caseHis = [SELECT DataType, OldValue, NewValue, Field, Id, CaseId, CreatedDate, IsDeleted, CreatedById FROM CaseHistory where CaseId =: c.Id];*/    
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        /*Database.QueryLocator ql = testObject.start(null);
        testObject.execute(null,caseList);
        testObject.Finish(null);*/
       
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest3()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('Internal,');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest4()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 3 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'tanish';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('Internal');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest5()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 6 Months';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1234';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Escalated');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest6()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('InProgress');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest7()
    {
		BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Week';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('On Hold');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest8()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Year';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = False;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Escalated');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest9()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    
    @isTest static void testexecute()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        objectwrapper newCase = new objectwrapper();
        newCase.Id = '111111111111111111';
        
        
        casehistorywrapper ch=new casehistorywrapper();
        ch.Field ='status';
        ch.Newvalue='test';
        ch.oldvalue ='new';
        
        newCase.histories=new list<object>{ch};
        
        /*ch= (casehistory)setReadOnlyField(ch, new Map<String, Object>{ 'oldvalue' => null });
        ch= (casehistory)setReadOnlyField(ch, new Map<String, Object>{ 'CreatedDate' => system.now()}); 
        ch= (casehistory)setReadOnlyField(ch, new Map<String, Object>{ 'Id' => 'uuuuuuuuuuuuuuuuuu'});

        newCase= (case)setReadOnlyField(newCase, new Map<String, Object>{ 'histories' => new list<sobject>{ch}});*/
		caseList.add(newCase);
        test.startTest();	
        averageTimeBatchClas_Mohit testObject = new averageTimeBatchClas_Mohit(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled); 
        testObject.execute(null,caseList);
        test.stopTest();
    }
    private static SObject setReadOnlyField(SObject sobj, Map<String, Object> changesToFields) {
      String serializedRecord = JSON.serialize(sobj);
      Map<String, Object> deserializedRecordMap = (Map<String, Object>) JSON.deserializeUntyped(serializedRecord);
    
      // Loop through the deserialized record map and put the field & value
      // Since it's a map, if the field already exists on the SObject, it's updated (or added if it wasn't there already)
      for(String sobjectField : changesToFields.keySet()) {
        deserializedRecordMap.put(sobjectField, changesToFields.get(sobjectField));
      }
    
      serializedRecord = JSON.serialize(deserializedRecordMap);
      return (SObject) JSON.deserialize(serializedRecord, SObject.class);
    }
}