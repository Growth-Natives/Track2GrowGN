@istest
public class averagetimechartcontrollertest 
{
   @testsetup
    Public static void averagetimechartcontrollertest1()
    {
       BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'Last 6 Months';
        //btchInfo.StartDate__c = System.today() + 5;
        //btchInfo.EndDate__c = System.today() +30;
        btchInfo.Filter_Name__c = 'test';
        btchInfo.WillRefresh__c = True;
        btchInfo.SobjectFieldValue__c = 'InProgress';
        btchInfo.SobjectRecordType__c = 'Internal';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        //btchInfo.Chart_Name__c = 'Average Field Value Time';
        insert btchInfo;
    }
    @istest
    Public static void averagetimechartcontrollertest2()
    {
     list<Schema.PicklistEntry> Statuspicklist = Case.Status.getDescribe().getPicklistValues();
     list<Schema.PicklistEntry> Recordtypepicklist = Case.RecordTypeId.getDescribe().getPicklistValues();
     list<String> str1=new List<String>();
     integer i=0;
     for(Schema.PicklistEntry s:Statuspicklist)
     {
         if(i==1)
         {
             break;
         }
         i++;
         str1.add(String.valueOf(s));
     }
     list<String> str2=new List<String>();
        i=0;
     for(Schema.PicklistEntry s:Recordtypepicklist)
     {
         if(i==1)
         {
             break;
         }
         i++;
         str2.add(String.valueOf(s));
     }
     id str=averagetimechartcontroller.retriveAccs('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null,true );
     string abc=averagetimechartcontroller.retriveFilter('Case', 'Status',str1,str2 , 'India', 'this week',null ,null,true,null );
     AsyncApexJob jobInfo = [SELECT Status FROM AsyncApexJob];
     averagetimechartcontroller.getBatchJobStatus(jobInfo.id);
     averagetimechartcontroller.getcaseowner('Case', 'Status',str2 , 'India', 'this week',null ,null,true,null);
     averagetimechartcontroller.mapvalue('Case','Status',str1 ,str2, 'India', 'this week',null ,null,true,null);
       
        averagetimechartcontroller.getLeadByStatus('InProgress','Case','Status',str2,'India', 'this week',null ,null,true,null);
        Case c=new case();
        averagetimechartcontroller.pickListValueDynamically(c,'status');
    }
}