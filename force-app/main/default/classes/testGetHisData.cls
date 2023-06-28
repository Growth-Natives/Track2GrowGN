public class testGetHisData {
    
    //  public static void getHistoryData()
    // {
    //     id recid = '500Bh0000026RvjIAE';
    //     List<testPOC__c> recData = [Select id, Name, Object_Name__c,recID__c From testPOC__c Where recID__c =: recid];
    //     system.debug('recData..'+recData);
    //     Map<String,Object> hismap = new Map<String,Object>();
    //     List<Object> hisdata = new List<Object>();
        
    //     for(testPOC__c rec : recData)
    //     {
    //         for(Attachment a : [SELECT ParentId, Id, Body FROM Attachment])
    //         {
    //             hismap = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
    //         }
    //     }
    //     system.debug('hismap...'+hismap);
    //     String allRecs;
    //     for(String key : hismap.keySet())
    //     {
    //        System.debug(hismap.get(key)); 
    //        allRecs = hismap.get(key).toString();
    //     }
    //     system.debug('allRecs..'+allRecs);
    //     hisdata = allRecs.split('},');
        
    //     system.debug('hisdata..'+hisdata);
    //     //return hisdata;
    // }





    ///////
    public static List<String> getFields(String Obj)
    {
        List<String> allFields = new List<String>();
        Map <String,Schema.SObjectType> gd = Schema.getGlobalDescribe();
        Schema.SObjectType sobjType = gd.get(Obj);
        Schema.DescribeSObjectResult r = sobjType.getDescribe();
        Map<String, Schema.SObjectField> MapofField = r.fields.getMap();
        
        for(String fieldName : MapofField.keySet()) 
        {
            Schema.SObjectField field = MapofField.get(fieldName);
            //System.debug('field-->'+field);
            allFields.add(string.valueof(field));
        }
        system.debug('allFields...'+allFields);
        return allFields;
    }
    
    @AuraEnabled
    public static List<Case> getHistoryData(id recid)
    {
        // //id recid = '500Bh0000026RvjIAE';
        // List<testPOC__c> recData = [Select id, Name, Object_Name__c,recID__c From testPOC__c Where recID__c =: recid];
        // system.debug('recData..'+recData);
        // Map<String,Object> hismap = new Map<String,Object>();
        // List<Object> hislist = new List<Object>();
        // List<wrapper> hisdata = new List<wrapper>();
        
        // for(testPOC__c rec : recData)
        // {
        //     for(Attachment a : [SELECT ParentId, Id, Body FROM Attachment])
        //     {
        //         hismap = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
        //     }
        // }
        // system.debug('hismap...'+hismap);
        // String allRecs;
        // for(String key : hismap.keySet())
        // {
        //    System.debug(hismap.get(key)); 
        //    allRecs = hismap.get(key).toString();
        // }
        // system.debug('allRecs..'+allRecs);
        // hislist = allRecs.split('},');

        // for(object rec : hislist)
        // {
        //     wrapper wrp = new wrapper();
        // }
        
        // system.debug('hislist..'+hislist);
        // //return hisdata;


        List<Case> hisdata = [SELECT ID, OwnerId, (SELECT Id, Field, OldValue, NewValue, CreatedDate, CreatedBy.Name FROM Histories order BY CreatedDate) FROM Case WHERE ID =: recid]; 
        return hisdata;
    }


    public class wrapper{
    @AuraEnabled
    public Datetime timestamp{get;set;}
    @AuraEnabled
    public String field{get;set;}
    @AuraEnabled
    public String newVal{get;set;}
    @AuraEnabled
    public String oldVal{get;set;}
    @AuraEnabled
    public String user{get;set;}
    }

    @AuraEnabled
    public static List<Case> getSearchHistoryData(id recid, String searchVal, String field)
    {
        String j= searchVal;
        System.debug('J=='+j);
        List<Case> hisdata = [SELECT ID, OwnerId, (SELECT Id, Field, OldValue, NewValue, CreatedDate, CreatedBy.Name FROM Histories WHERE Field=:j) FROM Case WHERE ID =: recid];
        //system.debug('ghdghfgdh'+hisdata.casehistory);
        for(case cs:hisdata)
        {
            for(casehistory bdd:cs.Histories){system.debug('value of his'+bdd); }
        }
        return hisdata;
    }
}