@isTest
private class TestWrapperController {
    public static testMethod void myUnitTest()
    {
        objectwrapper wrapper= new objectwrapper();
        string Id=wrapper.Id;
        DateTime CreatedDate= wrapper.CreatedDate;
        String OwnerId =wrapper.OwnerId;
        String recordTypeId =wrapper.recordTypeId;
        object Histories =wrapper.Histories;
    } 
    public static testMethod void myUnitTest1()
    {
        
        ObjectHistoryWrapper wrapper1= new ObjectHistoryWrapper();
        string Field=wrapper1.Field;
        object OldValue=wrapper1.OldValue;
        object NewValue=wrapper1.NewValue;
        datetime CreatedDate=wrapper1.CreatedDate;
        string DataType=wrapper1.DataType;
        
        ObjectHistoryMain wrapper3= new ObjectHistoryMain();
        
         Boolean done=wrapper3.done;
         List<Object> records=wrapper3.records;
    }
}