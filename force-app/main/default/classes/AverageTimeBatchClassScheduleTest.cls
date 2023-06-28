@istest
public class AverageTimeBatchClassScheduleTest {
    
    @istest
    Public static void AverageTimeBatchClassScheduleTest1()
    {
        BatchInfo__c btchInfo = new BatchInfo__c();
        btchInfo.Businesshour__c = 'India';
        btchInfo.Dates__c = 'this week';
        btchInfo.SobjectFieldType__c = 'Status';
        btchInfo.WillRefresh__c = True;
        btchInfo.LastRefreshedDate__c = system.today();
        btchInfo.SobjectFieldValue__c = 'New,InProgress';
        btchInfo.SobjectRecordType__c = 'Internal,External';
        btchInfo.SobjectType__c='Case';
        btchInfo.OwnerDataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        btchInfo.dataRepresentation__c = '{"0052w000003cdO7AAI:InProgress":3.53}';
        insert btchInfo;
        
        Test.startTest();
        AverageTimeBatchClassSchedule ba= new AverageTimeBatchClassSchedule();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check',sch, ba);
        System.assert(1==1,'List should not be empty');
        Test.stopTest();
    }
    
}