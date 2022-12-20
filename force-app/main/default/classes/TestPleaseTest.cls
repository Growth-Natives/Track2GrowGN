@isTest
public class TestPleaseTest {
@isTest
    public static void TestPleaseTestmethod1(){
        Account acc= new Account();
        acc.Name = 'test';
        insert acc;
        
        Contact con = new Contact();
        con.LastName = 'test';
        con.AccountId = acc.Id;
        insert con;
        
        List<Account> acc1=[Select id, name,(select id, lastname from contacts) from account];
        system.debug('acc==>'+acc1);
        test.startTest();
        TestPlease.testPleaseMethod();
        test.stopTest();
    }
}