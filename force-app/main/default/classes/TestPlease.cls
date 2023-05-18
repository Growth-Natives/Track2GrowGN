public class TestPlease {
     @AuraEnabled
     public static list<String> getUserList(){
         
     list<String> userr= new list<String>();
    List<user> acc=[Select name from User];
       system.debug('acc==>'+acc);
       for(user us:acc)
       {
           userr.add(string.valueof(us.name));
       }
    return userr;
}
}