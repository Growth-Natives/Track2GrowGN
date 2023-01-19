public class TestUtility
    {
        Integer s_num = 1;
        
        public  String getFakeId(Schema.SObjectType sot)
        {
            String result = String.valueOf(s_num++);
            return sot.getDescribe().getKeyPrefix() + 
                '0'.repeat(12-result.length()) + result;
        }
    }