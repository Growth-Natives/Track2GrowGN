@istest
public class caseComarisionTest
{
    @testsetup
    Public static void averagetimechartcontrollertest1()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        insert btchInfo;
        
        Attachment att = new Attachment();
        att.ParentId = btchInfo.Id;
        att.Body = Blob.valueof('{"a0EBh0000003YjqMAE:Assess:1":8393.32,"a0EBh0000003YjqMAE:New:1":6.92}');
        att.Name = 'test';
        system.debug('att>>>'+att);
        insert att;
        
        Attachment at = new Attachment();
        at.ParentId = btchInfo.Id;
        at.Body = Blob.valueof('{"a0EBh0000003YjqMAE:Assess:1":8393.32,"a0EBh0000003YjqMAE:New:1":6.92}');
        at.Name = 'test';
        system.debug('at>>>'+at);
        insert at;
        System.assert(1==1,'List should not be empty');
    }
    
    @istest
    Public static void caseComarisionTest1()
    {
            BatchInfo__c btchInfo = new BatchInfo__c();
            btchInfo.Businesshour__c = 'India';
            btchInfo.Dates__c = 'this week';
            btchInfo.SobjectFieldType__c = 'Status';
            btchInfo.WillRefresh__c = True;
            btchInfo.LastRefreshedDate__c = system.today();
            btchInfo.SobjectFieldValue__c = 'New';
            btchInfo.SobjectRecordType__c = 'Internal';
            btchInfo.SobjectType__c='Case';
            btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            
            insert btchInfo;
            system.debug('btchInfo'+btchInfo);
            
            BatchInfo__c bchInfo = new BatchInfo__c();
            bchInfo.Businesshour__c = 'India';
            bchInfo.Dates__c = 'this week';
            bchInfo.SobjectFieldType__c = 'Status';
            bchInfo.WillRefresh__c = True;
            bchInfo.SobjectFieldValue__c = 'New';
            bchInfo.SobjectRecordType__c = 'Internal';
            bchInfo.SobjectType__c='Case';
            bchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            bchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
            bchInfo.Filter_Name__c='test';
            insert bchInfo;
          Profile pf= [Select Id from profile where Name='System Administrator']; 
        
       /* String orgId=UserInfo.getOrganizationId(); 
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
        
        
             insert uu;*/
        
             string username=UserInfo.getName();
            CaseComparison.getAllCasesForUser(username, bchInfo.Filter_Name__c, 'New,Research,Solution');
        
        
        list<case> cd= new list<case>();
        for(integer i=0;i<50;i++)
        {
            case cs= new case();
            cs.status='New';
            cs.Priority='Email';
            cs.ownerid='0052w000003dXf7AAE';
            cd.add(cs);
        }
        for(integer i=0;i<50;i++)
        {
            case cs= new case();
            cs.status='New';
            cs.Priority='Email';
            cs.ownerid='0052w000003cdO7AAI';
            cd.add(cs);
        }
        insert cd;
        CaseComparison.getAllUser();
    }
    
}