@isTest
public class ConfigPageTest
{
    @isTest
    public static void testmethod1()
    {
        list<ConfigPage.visitorList> wrp = new list<ConfigPage.visitorList>(); 
        ConfigPage.visitorList newwrapper = new ConfigPage.visitorList();
        newwrapper.name = 'abc';
        newwrapper.company = 'xyz';
        newwrapper.email = 'abc@test.com';
        wrp.add(newwrapper);
        test.startTest();    
        ConfigPage.metadatasaved('CustomHistorys__r', wrp);
        test.startTest();
    }
}