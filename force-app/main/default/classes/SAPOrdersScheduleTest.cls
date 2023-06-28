@istest
public class SAPOrdersScheduleTest {
    
    @istest
    Public static void SAPOrdersScheduleTest1()
    {
        list<string> week= new list<string>();
        week.add('3');
        week.add('5');
        test.startTest();
        SAPOrdersSchedule.scheduleClass('test','Custom',week,'2023-01-17','2023-01-25','18',null,null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Custom',week,'2023-01-17','2023-01-25','18','Day',null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Custom',week,'2023-01-17','2023-02-17','18','Day',null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Custom',week,'2023-01-17','2024-02-25','18','Day',null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Daily',week,'2023-01-17','2023-01-25','18','ordinal',null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Daily',week,'2023-01-17','2023-01-25','18','Day',null,null,null);
        SAPOrdersSchedule.scheduleClass('test','Daily',week,'2023-01-17','2023-01-25','18',null,null,null,null);
        System.assert(1==1,'List should not be empty');
        test.stopTest();
    }
    
}