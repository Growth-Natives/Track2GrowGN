@isTest
public class SAPOrdersScheduleTest1{

    static testMethod void testScheduleClass1(){
        // Create test data
        List<String> testWeekdays = new List<String>{'MON', 'WED', 'FRI'};
        String testStartDate = '2022-01-01';
        String testEndDate = '2022-02-01';
        String testPreferredTime = '12:00';
        String testMonthlyPriority = 'ordinal';
        String testMonthlyDay = '10';
        String testMonthlyOrdinal = '1';
        String testMonthlyWeek = 'MON';
        String testFrequency = 'Weekly';
        Boolean testIsCustom = true;

        // Run the schedule class
        Test.startTest();
        SAPOrdersSchedule.scheduleClass('testJob', testFrequency, testIsCustom, testWeekdays, testStartDate, testEndDate, testPreferredTime, testMonthlyPriority, testMonthlyDay, testMonthlyOrdinal, testMonthlyWeek);
        Test.stopTest();

        // Verify that the batch class is scheduled
      //  CronTrigger ct = [SELECT Id, CronExpression FROM CronTrigger WHERE JobName = 'testJob'];
      //  System.assertNotEquals(null, ct, 'Batch class was not scheduled');
        // Verify the cron expression that was used to schedule the batch class 
        // you can use an online cron expression validator to check the generated expression
    }
}