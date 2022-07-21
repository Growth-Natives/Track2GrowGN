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
        Boolean historySwitch = false;  
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest2()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        Boolean historySwitch = false;  
        // Date dateNew = System.today() - 5;
        String dates = 'Last Month';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.id;
        Boolean scheduled = False;
        Boolean willRefresh = True;
        String businessHour = 'Default';
        String filterName = '';
        
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
  
        test.startTest();
        //List<CaseHistory> caseHis = [SELECT DataType, OldValue, NewValue, Field, Id, CaseId, CreatedDate, IsDeleted, CreatedById FROM CaseHistory where CaseId =: c.Id];*/    
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest3()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
		Boolean historySwitch = false;        
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
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest4()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 3 Months';
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
        Boolean historySwitch = false;  
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('Internal');
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest5()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
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
        Boolean historySwitch = false;  
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest6()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        Boolean historySwitch = false;  
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
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
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
        Boolean historySwitch = false;  
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
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    @isTest static void averageTimeBatchClassTest8()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Year';
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
        Boolean historySwitch = false;  
        test.startTest();
        
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
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
        String dates = 'This Year';
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
        Boolean historySwitch = false;  
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    
      @isTest static void averageTimeBatchClassTest9New()
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
        Boolean historySwitch = false;  
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    
    @isTest static void testexecute()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Week';
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        insert btchInfo;
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() ;
        Date endDate = System.today()  ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        BusinessHours stdBusinessHours = [select id from BusinessHours where Name = 'India'];
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        Boolean historySwitch = false;  
        
        List<object> caseList = new List<object>();
        
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         Profile pf2= [Select Id from profile where Name='Standard User']; 
        
        String orgId2=UserInfo.getOrganizationId(); 
        String dateString2=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId2=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName2=orgId2+dateString2+RandomId2; 
        User uu3=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName2 + '@test1' + orgId2 + '.org', 
                         Username = uniqueName2 + '@test1' + orgId2 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName2.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf2.Id
                        ); 
        
        
        insert uu3;
     
        
        objectwrapper newCase = new objectwrapper();
        newCase.Id = '111111111111111111';
        newCase.OwnerId = uu.Id;
        newCase.CreatedDate = System.today();
        
        ObjectHistoryWrapper ohw=new ObjectHistoryWrapper();
        ohw.Field ='Created';
        ohw.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
        ch.Field ='Owner';
        ch.Newvalue= uu2.Id;
        ch.oldvalue = uu.Id;
        ch.DataType = 'EntityId';
        ch.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch1 = new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = uu2.Id;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.createddate = system.now();
        
        ObjectHistoryWrapper ch2 = new ObjectHistoryWrapper();
        ch2.Field = 'Status';
        ch2.NewValue = 'In Progress';
        ch2.OldValue = 'New';
        //ch2.DataType = 'DynamicEnum';
        ch2.createddate = system.now();
        
		objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu3.Id;
        newCasen.CreatedDate = System.today();
        
        /*ObjectHistoryWrapper ch3 = new ObjectHistoryWrapper();
        ch3.Field = 'Status';
        ch3.NewValue = 'In Progress';
        ch3.OldValue = 'New';
        //ch3.DataType = 'DynamicEnum';
        ch3.createddate = system.now();*/
        ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{ch,ch1,ch2};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{ch,ch1,ch2};
            
        newCase.Histories= objNew;
        newCasen.Histories = objNew1;    
           
           caseList.add(newCase);
        	caseList.add(newCasen);
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        testObject.execute(null,caseList);
        test.stopTest();
    }
    @isTest static void testexecute2()
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
        Boolean historySwitch = false;  
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
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
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
      
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper ch1 =new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = uu.Id;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Status';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
        
        //cHistoryn.Field = 'Status';
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = 'In Progress';
        cHistory2.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory2.CreatedDate = system.now();
        
        /*ObjectHistoryWrapper cHistory3=new ObjectHistoryWrapper();
        cHistory3.Field ='Status';
        cHistory3.NewValue = 'In Progress';
        cHistory3.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory3.CreatedDate = system.now();*/
        
        
        
        ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{cHistory,cHistoryn};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory2};
        
        newCase1.Histories = objNew;
        newCasen.Histories = objNew1;    
            
        //newCase1.Histories = new List<Object>{cHistory,cHistoryn};
        //newCasen.Histories = new List<Object>{cHistory2};
        //newCasenx.histories = new List<Object>{cHistory3}; 
            
        caseList.add(newCase1);
        caseList.add(newCasen);
        //caseList.add(newCasenx);
   
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    }
    @isTest static void testexecute2Else()
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
        Boolean historySwitch = false;  
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
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
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
      
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper ch1 = new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = null;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.createddate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = null;
        cHistoryn.OldValue = uu.Id;
        //cHistory.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
        
        //cHistoryn.Field = 'Status';
        
        ObjectHistoryWrapper ch2 = new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = null;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.createddate = system.now();
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = null;
        cHistory2.OldValue = uu2.Id;
        //cHistory.DataType = 'EntityId';
        cHistory2.CreatedDate = system.now();
        
        ObjectHistoryWrapper ch3 = new ObjectHistoryWrapper();
        ch1.Field = 'Owner';
        ch1.NewValue = null;
        ch1.OldValue = uu.Id;
        ch1.DataType = 'EntityId';
        ch1.createddate = system.now();
        
        ObjectHistoryWrapper cHistory3=new ObjectHistoryWrapper();
        cHistory3.Field ='Status';
        cHistory3.NewValue = null;
        cHistory3.OldValue = uu2.Id;
      	//cHistory.DataType = 'EntityId';
        cHistory3.CreatedDate = system.now();
        
     
        
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{ch1,cHistoryn};
            
        ObjectHistoryMain objNew2 = new ObjectHistoryMain();
        objNew2.done =true;
        objNew2.records = new list<object>{ch2,cHistory2};    
        
        ObjectHistoryMain objNew3 = new ObjectHistoryMain();
        objNew3.done =true;
        objNew3.records = new list<object>{ch3,cHistory3};      
            
        
        newCase1.Histories = objNew1;
        newCasen.Histories =objNew2;
        newCasenx.Histories = objNew3;
            
        caseList.add(newCase1);
        caseList.add(newCasen);
        caseList.add(newCasenx);
   
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    }
    @isTest static void testexecute2New()
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
        Boolean historySwitch = false;  
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
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
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Owner';
        cHistory.NewValue = null;
        cHistory.OldValue = uu.Id;
        cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        cHistoryn.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
       
		ObjectHistoryWrapper cHistoryny=new ObjectHistoryWrapper();
        cHistoryny.Field ='Owner';
        cHistoryny.NewValue = null;
        cHistoryny.OldValue = uu.Id;
        cHistoryny.DataType = 'EntityId';
        cHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynny=new ObjectHistoryWrapper();
        cHistorynny.Field = 'Status';
        cHistorynny.NewValue = 'In Progress';
        cHistorynny.OldValue = 'New';
        cHistorynny.DataType = 'EntityId';
        cHistorynny.CreatedDate = system.now();
        
        ObjectHistoryWrapper ccHistoryny=new ObjectHistoryWrapper();
        ccHistoryny.Field ='Owner';
        ccHistoryny.NewValue = null;
        ccHistoryny.OldValue = uu2.Id;
        ccHistoryny.DataType = 'EntityId';
        ccHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynnyc=new ObjectHistoryWrapper();
        cHistorynnyc.Field = 'Status';
        cHistorynnyc.NewValue = 'In Progress';
        cHistorynnyc.OldValue = 'New';
        cHistorynnyc.DataType = 'EntityId';
        cHistorynnyc.CreatedDate = system.now();
        
        /*ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{ch,ch1,ch2};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{ch,ch1,ch2};
            
        newCase.Histories= objNew;
        newCasen.Histories = objNew1;  */
        
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory,cHistoryn,cHistoryny,cHistorynny,ccHistoryny,cHistorynnyc};
        
		
        newCase1.Histories = objNew1;
        //newCase1.Histories = new List<Object>{cHistory,cHistoryn,cHistoryny,cHistorynny,ccHistoryny,cHistorynnyc};
                    
        caseList.add(newCase1);
    
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    }
     @isTest static void testexecute2Neww()
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
		Boolean historySwitch = false;          
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() ;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Owner';
        cHistory.NewValue = uu2.Id;
        cHistory.OldValue = uu.Id;
        cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        cHistoryn.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
       
		ObjectHistoryWrapper cHistoryny=new ObjectHistoryWrapper();
        cHistoryny.Field ='Owner';
        cHistoryny.NewValue = uu.Id;
        cHistoryny.OldValue = uu2.Id;
        cHistoryny.DataType = 'EntityId';
        cHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynny=new ObjectHistoryWrapper();
        cHistorynny.Field = 'Status';
        cHistorynny.NewValue = 'In Progress';
        cHistorynny.OldValue = 'New';
        cHistorynny.DataType = 'EntityId';
        cHistorynny.CreatedDate = system.now();
        
        ObjectHistoryWrapper ccHistoryny=new ObjectHistoryWrapper();
        ccHistoryny.Field ='Owner';
        ccHistoryny.NewValue = uu2.Id;
        ccHistoryny.OldValue = uu.Id;
        ccHistoryny.DataType = 'EntityId';
        ccHistoryny.CreatedDate = system.now();
        
        
        
        ObjectHistoryWrapper cHistorynnyc=new ObjectHistoryWrapper();
        cHistorynnyc.Field = 'Status';
        cHistorynnyc.NewValue = 'In Progress';
        cHistorynnyc.OldValue = Null;
        cHistorynnyc.DataType = 'EntityId';
        cHistorynnyc.CreatedDate = system.now();
        
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory,cHistoryn,cHistoryny,cHistorynny,ccHistoryny,cHistorynnyc};
        
        
		
        
        newCase1.Histories = objNew1;
                    
        caseList.add(newCase1);
    
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    } 
    // else part set historyswitch = true.
    @isTest static void averageTimeBatchClassTestElsePart1()
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
        Boolean historySwitch = true;  
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 2 Last Month
    @isTest static void averageTimeBatchClassTestElsePart2()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last Month';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 3 This Month
    @isTest static void averageTimeBatchClassTestElsePart3()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Month';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Month';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 4 Last 3 Months
    @isTest static void averageTimeBatchClassTestElsePart4()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 3 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 3 Months';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 5 Last 6 Months
    @isTest static void averageTimeBatchClassTestElsePart5()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last 6 Months';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 6 Last Year
    @isTest static void averageTimeBatchClassTestElsePart6()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Last Year';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 7 This Week
    @isTest static void averageTimeBatchClassTestElsePart7()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Week';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Week';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    //else part 8 This Year
    @isTest static void averageTimeBatchClassTestElsePart8()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'This Year';
        btchInfo.StartDate__c = System.today() + 5;
        btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
        Boolean historySwitch = true;  
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'This Year';
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
      //  objectwrapper.objectwrapper();
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        //ID batchprocessid = Database.executeBatch(testObject);  
        test.stopTest();
    }
    // for else part 
    @isTest static void averageTimeBatchClassTest9ElsePart()
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
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'India';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('Closed');
        List<String> recordTypes = new List<String>();
        Boolean historySwitch = true;  
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        DataBase.executeBatch(testObject);
        test.stopTest();
    }
    //else part  131
    @isTest static void testexecute2ElsePart()
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
        Boolean historySwitch = true;  
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'Default';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
      
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Status';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
        
        //cHistoryn.Field = 'Status';
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = 'In Progress';
        cHistory2.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory2.CreatedDate = system.now();
        
        /*ObjectHistoryWrapper cHistory3=new ObjectHistoryWrapper();
        cHistory3.Field ='Status';
        cHistory3.NewValue = 'In Progress';
        cHistory3.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory3.CreatedDate = system.now();*/
        
        
        
        ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{cHistory,cHistoryn};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory2};
        
        newCase1.Histories = objNew;
        newCasen.Histories = objNew1;    
            
        //newCase1.Histories = new List<Object>{cHistory,cHistoryn};
        //newCasen.Histories = new List<Object>{cHistory2};
        //newCasenx.histories = new List<Object>{cHistory3}; 
            
        caseList.add(newCase1);
        caseList.add(newCasen);
        //caseList.add(newCasenx);
   
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    }
    // covering { if(dates == 'Custom Date')}
    @isTest static void testexecute2ElsePart1()
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
        Boolean historySwitch = true;  
        btchInfo.WillRefresh__c = True;
        btchInfo.Chart_Name__c = 'Average Field Value Time';
        update btchInfo;
        
        
        String field = 'Status';
        String objectVal = 'Case';
        // Date dateNew = System.today() - 5;
        String dates = 'Custom Date';
        Date startDate = System.today() + 5;
        Date endDate = System.today() + 25 ;
        Id recordId = btchInfo.Id;
        Boolean scheduled = True;
        Boolean willRefresh = False;
        String businessHour = 'Default';
        String filterName = 'test 1';
        List<String> fieldValues = new List<String>();
        fieldValues.add('New');
        List<String> recordTypes = new List<String>();
        //recordTypes.add('External');
        
        List<object> caseList = new List<object>();
        
               
        Profile pf= [Select Id from profile where Name='System Administrator']; 
        
        String orgId=UserInfo.getOrganizationId(); 
        String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName=orgId+dateString+RandomId; 
        User uu=new User(firstname = 'ABC', 
                         lastName = 'XYZ', 
                         email = uniqueName + '@test' + orgId + '.org', 
                         Username = uniqueName + '@test' + orgId + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf.Id
                        ); 
        
        
        insert uu;
        
        Profile pf1= [Select Id from profile where Name='Standard User']; 
        
        String orgId1=UserInfo.getOrganizationId(); 
        String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
        Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
        String uniqueName1=orgId1+dateString1+RandomId1; 
        User uu2=new User(firstname = 'ABCD', 
                         lastName = 'RXYZ', 
                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
                         EmailEncodingKey = 'ISO-8859-1', 
                         Alias = uniqueName1.substring(18, 23), 
                         TimeZoneSidKey = 'America/Los_Angeles', 
                         LocaleSidKey = 'en_US', 
                         LanguageLocaleKey = 'en_US', 
                         ProfileId = pf1.Id
                        ); 
        
        
        insert uu2;
        
         
        objectwrapper newCase1 = new objectwrapper();
        newCase1.Id = '333333333333333333';
        newCase1.OwnerId = uu.Id;
        newCase1.CreatedDate = System.today();
        
      
        
        
        objectwrapper newCasen = new objectwrapper();
        newCasen.Id = '888888888888888888';
        newCasen.OwnerId = uu.Id;
        newCasen.CreatedDate = System.today();
        
        objectwrapper newCasenx = new objectwrapper();
        newCasenx.Id = '555555555555555555';
        newCasenx.OwnerId = uu.Id;
        newCasenx.CreatedDate = System.today();
        
        ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
        cHistory.Field ='Status';
        cHistory.NewValue = 'In Progress';
        cHistory.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory.CreatedDate = system.now();
        
        ObjectHistoryWrapper cHistoryn=new ObjectHistoryWrapper();
        cHistoryn.Field = 'Status';
        cHistoryn.NewValue = 'In Progress';
        cHistoryn.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistoryn.CreatedDate = system.now();
        
        //cHistoryn.Field = 'Status';
        
        ObjectHistoryWrapper cHistory2=new ObjectHistoryWrapper();
        cHistory2.Field ='Status';
        cHistory2.NewValue = 'In Progress';
        cHistory2.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory2.CreatedDate = system.now();
        
        /*ObjectHistoryWrapper cHistory3=new ObjectHistoryWrapper();
        cHistory3.Field ='Status';
        cHistory3.NewValue = 'In Progress';
        cHistory3.OldValue = 'New';
        //cHistory.DataType = 'EntityId';
        cHistory3.CreatedDate = system.now();*/
        
        
        
        ObjectHistoryMain objNew = new ObjectHistoryMain();
        objNew.done =true;
        objNew.records = new list<object>{cHistory,cHistoryn};
            
        ObjectHistoryMain objNew1 = new ObjectHistoryMain();
        objNew1.done =true;
        objNew1.records = new list<object>{cHistory2};
        
        newCase1.Histories = objNew;
        newCasen.Histories = objNew1;    
            
        //newCase1.Histories = new List<Object>{cHistory,cHistoryn};
        //newCasen.Histories = new List<Object>{cHistory2};
        //newCasenx.histories = new List<Object>{cHistory3}; 
            
        caseList.add(newCase1);
        caseList.add(newCasen);
        //caseList.add(newCasenx);
   
        test.startTest();	
        averageTimeBatchClass testObject = new averageTimeBatchClass(fieldValues,field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,scheduled,historySwitch); 
        //DataBase.executeBatch(testObject);
        testObject.execute(null,caseList);
        test.stopTest();
    }
}