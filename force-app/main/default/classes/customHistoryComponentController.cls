public class customHistoryComponentController {
    
    @AuraEnabled
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
    public static List<wrapper> getHistoryData(id recid)
    {
        System.debug('recid>>>'+recid);
        List<customHistory__c> recData = [Select id, Name, Object_Name__c,recID__c From customHistory__c Where recID__c =: recid];
        system.debug('recData..'+recData);
        Map<String,Object> hismap = new Map<String,Object>();
        List<Object> hislist = new List<Object>();
        List<String> templist = new List<String>();
        List<String> templist2 = new List<String>();
        List<wrapper> hisdata = new List<wrapper>();
        String listRec;
        String tempRecAfter;
        String tempRecBefore;
        
        for(customHistory__c rec : recData)
        {
            for(Attachment a : [SELECT ParentId, Id, Body FROM Attachment where ParentId =: rec.Id])
            {
                hismap = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
            }
        }
        system.debug('hismap...'+hismap);
        String allRecs;
        for(String key : hismap.keySet())
        {
           System.debug(hismap.get(key)); 
           allRecs = hismap.get(key).toString();
        }
        system.debug('allRecs..'+allRecs);
        hislist = allRecs.split('},');
        system.debug('hislist..'+hislist);
        for(object rec : hislist)
        {
            listRec = rec.toString();
            templist.add(listRec);
        }

        system.debug('templist..'+templist);

        for(String rec : templist)
        {
            templist2 = rec.split(',');
            wrapper wrp = new wrapper();
            for(String s : templist2)
            {
                tempRecBefore = s.substringBefore('=');
                tempRecAfter = s.substringAfter('=');
                system.debug('tempRecAfter..'+tempRecAfter);
                system.debug('tempRecBefore..'+tempRecBefore);

                
                if(tempRecBefore.contains('Date/Time'))
                {
                    wrp.timestamp = tempRecAfter;
                }
                if(tempRecBefore.contains('Field'))
                {
                    wrp.field = tempRecAfter;
                }
                if(tempRecBefore.contains('NewValue'))
                {
                    wrp.newVal = tempRecAfter;
                }
                if(tempRecBefore.contains('OldValue'))
                {
                    wrp.oldVal = tempRecAfter;
                }
                if(tempRecBefore.contains('User'))
                {
                     tempRecAfter = tempRecAfter.replace('}','');
                    wrp.user = tempRecAfter;
                }
                if(tempRecBefore.contains('CreatedById'))
                {
                    wrp.createdById = tempRecAfter;
                }
            }
            hisdata.add(wrp);
        }

        System.debug('hisdata>>>'+hisdata);

        
        return hisdata;
    }


    @AuraEnabled
    public static List<wrapper> getSearchHistoryData(id recid, String searchVal, List<wrapper> data)
    {
        List<wrapper> hisdata = new List<wrapper>();
        List<wrapper> tempdata = new List<wrapper>();
        List<wrapper> finaldata = new List<wrapper>();
        String temp;
        Integer count=0;
        String searchKey;
        List<Object> result = (List<Object>)JSON.deserializeUntyped(searchVal); 
        System.debug('result>>>'+result);
        List<Map<String, Object>> searchMapList = new List<Map<String, Object>>();
        for(Object obj : result)
        {  
            searchMapList.add((Map<String, Object>) obj);
        }
        // System.debug('searchMapList>>>'+searchMapList);
        // System.debug('data>>>'+data);
        // System.debug('recid>>>'+recid);
        for(Map<String, Object> val : searchMapList)
        {
            count++;
            // system.debug('values>>'+val.keySet());
            // system.debug('values>>'+val.values());
            searchKey = val.values().toString();
            searchKey = searchKey.replace('(','');
            searchKey = searchKey.replace(')','');
            System.debug('searchKey...'+searchKey);
            if(searchKey != null)
            { system.debug('not null');
            if(count == 1)
            {
                tempdata = data;
                system.debug('tempdata..'+tempdata);
            }
            else if(count >= 2)
            {
                tempdata = finaldata;
                system.debug('tempdata..'+tempdata);
                //finaldata.clear();
                finaldata = new List<wrapper>();
                system.debug('finaldata..'+finaldata);
            }
            system.debug('tempdata..'+tempdata);
            for(wrapper wrp : tempdata)
        { 
            System.debug('in for>>>');
            if(val.keySet().contains('user'))
            {
                System.debug('in user>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.user;
                System.debug('temp>>>'+temp);
                if(temp.containsIgnoreCase(searchKey))
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
            }
            }
            else if(val.keySet().contains('createdById'))
            {
                System.debug('in createdById>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.createdById;
                System.debug('temp>>>'+temp);
                if(temp.containsIgnoreCase(searchKey))
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
            }
            }
            else if(val.keySet().contains('oldVal'))
            {
                System.debug('in oldVal>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.oldVal;
                System.debug('temp>>>'+temp);
                if(temp.containsIgnoreCase(searchKey))
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
            }
            }
            else if(val.keySet().contains('newVal'))
            {
                System.debug('in newVal>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.newVal;
                System.debug('temp>>>'+temp);
                if(temp.containsIgnoreCase(searchKey))
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
            }
            }
            else if(val.keySet().contains('field'))
            {
                System.debug('in field>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.field;
                System.debug('temp>>>'+temp);
                if(temp.containsIgnoreCase(searchKey))
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
            }
            }
            // else if(val.keySet().contains('timestamp'))
            // {
            //     System.debug('in timestamp>>>');
            //     temp= wrp.timestamp;
            //     System.debug('temp>>>'+temp);
            //     if(temp.containsIgnoreCase(searchKey))
            //     {
            //         System.debug('contains');
            //         finaldata.add(wrp);
            //     }
                
            // }

            else if(val.keySet().contains('startdate'))
            {
                System.debug('in startdate>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.timestamp;
                Date tempDate = Date.valueOf(temp);
                System.debug('temp>>>'+temp);
                system.debug('searchKey>>'+searchKey);
                Date searchDate = Date.valueOf(searchKey);
                system.debug('searchDate>>'+searchDate);
                if(tempDate >= searchDate)
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
                }
            }

            else if(val.keySet().contains('enddate'))
            {
                System.debug('in enddate>>>');
                if(searchKey == '')
                {
                    finaldata.add(wrp);
                }
                else 
                {
                temp= wrp.timestamp;
                Date tempDate = Date.valueOf(temp);
                System.debug('temp>>>'+temp);
                system.debug('searchKey>>'+searchKey);
                Date searchDate = Date.valueOf(searchKey);
                system.debug('searchDate>>'+searchDate);
                if(tempDate <= searchDate)
                {
                    System.debug('contains');
                    finaldata.add(wrp);
                }
                }
            }
            //system.debug('finaldata..'+finaldata);
        }
      }
        system.debug('finaldata..'+finaldata);
    }
        hisdata = finaldata;
        system.debug('hisdata..'+hisdata);
        return hisdata;
}



@AuraEnabled
    public static Boolean isHistoryOn(String obj, Id recId)
    {
        System.debug('objectName...'+obj);
        System.debug('recId...'+recId);
        List<sObject> dataList = new List<sObject>();
        // List<sObject> hisList = new List<sObject>();
        Map<String,object> hisdata = new Map<String,object>();
        Boolean val;
        String query = 'Select id,(Select id,field from Histories) From '+ obj + ' Where id =: recId';
        dataList = Database.query(query);
        for(sObject data :dataList){
            Map<String, Object> mapObj =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
            hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj.get('Histories'))); 
        }
        system.debug('query>>'+query);
        system.debug('dataList>>'+dataList);
        system.debug('hisdata>>'+hisdata);
        if(hisdata.size() == 0)
        val = false;
        else
        val = true;

        return val;
    }

     @AuraEnabled
    public static list<String> fetchLookupData(string searchKey , List<String> allFields) { 
        system.debug('searchKey>>'+searchKey);
        system.debug('allFields>>'+allFields);  
        List < String > returnList = new List < String > ();
        for (string f: allFields) {
            if(f.containsIgnoreCase(searchKey))
            {
            returnList.add(f);
            }
        }
        system.debug('returnList>>'+returnList);
        return returnList;
    }

    public class wrapper{
    @AuraEnabled
    public String timestamp{get;set;}
    @AuraEnabled
    public String field{get;set;}
    @AuraEnabled
    public String newVal{get;set;}
    @AuraEnabled
    public String oldVal{get;set;}
    @AuraEnabled
    public String user{get;set;}
    @AuraEnabled
    public String createdById{get;set;}
    }

}