public class customHistoryBatchClass implements Database.Batchable<sObject>, Database.Stateful{

public String query;
public String obj;
public List<sObject> dataList = new List<sObject>();
    public customHistoryBatchClass(String obj){
        this.query = 'Select id,(Select '+obj + 'Id,NewValue,OldValue,CreatedBy.name,createddate,field from Histories order by CreatedDate) From '+ obj+ ' LIMIT 2';
        System.debug('query..'+this.query);
        this.obj = obj.capitalize();
    }


    public Database.QueryLocator start(Database.BatchableContext bc){
         System.debug('query..'+query);
        return Database.getQueryLocator(this.query);      
    }

    public void execute(Database.BatchableContext bc, List<object> records){
         Map<string,Object> dataIdMap = new Map<string,Object>();
         Map<String,Object> newJson = new Map<String,Object>();
         Map<string,Object> tempMap = new Map<string,Object>();
         Map<string,Map<String,Object>> finalJson = new Map<string,Map<String,Object>>();
         List<Object> dataList = new List <Object>();
         List<testPOC__c> testPocInsertRecs = new List<testPOC__c>();
         List<Attachment> insertJson = new List<Attachment>();
         Set<Id> recsPresent = new Set<Id>();
         String recid;
         List<testPOC__c> allRecs = [Select Id,recID__c from testPOC__c];
         
         for(Object data :(list<Object>)records){
             Map<String, Object> mapObj =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
             for(testPOC__c rec : allRecs){
                 if(mapObj.get('Id') == rec.recID__c)
                 {
                     recsPresent.add(rec.recID__c);
                 }
             }
         }
         System.debug('recsPresent>>'+recsPresent);

        for(Object data :(list<Object>)records){
            system.debug('data>>'+data);
            Map<String, Object> mapObj =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
            map<String,Object> recdata = (map<string,Object>)JSON.deserializeUntyped(JSON.serialize(mapObj.get('Histories')));
            dataList = new List <Object>();
            if(recdata == null || recdata.isEmpty())
            {
                system.debug('no history found');
            }
            else
            {system.debug('history found');
                List<object> hisdata = (List<object>)JSON.deserializeUntyped(JSON.serialize(recdata.get('records')));
            
                for(Object his : hisdata)
                {   
                    String objId = this.obj + 'Id';
                    map<string,object> hisObj =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(his));
                    // system.debug('objId>>'+objId);
                    // system.debug('hisObj.(objId)>>'+hisObj.get(objId));
                    String idRec = hisObj.get(objId).toString();
                    // system.debug('idRec>>'+idRec);
                    // system.debug('contains>>'+recsPresent.contains(idRec));
                    if(!recsPresent.contains(idRec))
                        {
                        dataList.add(his);
                        }
                }
                System.debug('datalist>>'+dataList);
                if(dataList != null && !dataList.isEmpty())
                {
                String allJson;
            for(Object his : dataList)
            {
                map<string,object> hisObj =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(his));
                map<String,Object> username = (map<string,Object>)JSON.deserializeUntyped(JSON.serialize(hisObj.get('CreatedBy')));
                dataIdMap.put('Field', hisObj.get('Field'));            
                dataIdMap.put('Date/Time', hisObj.get('CreatedDate'));    
                dataIdMap.put('User', username.get('Name'));
                dataIdMap.put('OldValue', hisObj.get('OldValue'));
                dataIdMap.put('NewValue', hisObj.get('NewValue'));
            
               if(allJson == null)
               {
                   allJson = dataIdMap.toString();
               }
                else
               {   
                   allJson = dataIdMap.toString() + ',' + allJson;
               }
               recid =  (String)hisObj.get('CaseId');
               newJson.put(recid, allJson);
            }
            system.debug('newJson...'+newJson);

            testPOC__c insRec = new testPOC__c();
            insRec.Object_Name__c = this.obj;
            insRec.recID__c = recid;
            testPocInsertRecs.add(insRec);
            }
        }
        }
        system.debug('testPocInsertRecs>>>'+testPocInsertRecs);
        if(testPocInsertRecs != null && !testPocInsertRecs.isEmpty())
        {
            System.debug('in insert if');
            // system.debug('testPocInsertRecs>>>'+testPocInsertRecs);
            Insert testPocInsertRecs;

        for(testPOC__c rec : testPocInsertRecs)
           {
            //    system.debug('newJson.get(rec.recID__c)>>>'+newJson.get(rec.recID__c));
               Attachment jsonfile = new Attachment();
                if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable())
                {
                    jsonfile.ParentId = rec.ID;
                }
                if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
                {
                    jsonfile.Name = 'testAttachment';
                }
               if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable())
                {
                    jsonfile.ContentType = 'text/plain';
                }
                if (Schema.sObjectType.Attachment.fields.Body.isCreateable())
                {
                    jsonfile.Body = Blob.valueOf('{"' + rec.recID__c + '" : ' + JSON.serialize(newJson.get(rec.recID__c))+ '}');
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable()){
                    insertJson.add(jsonfile);
                }               
           }
        system.debug('insertJson...'+insertJson);
        Insert insertJson;
  }
}
        

        public void finish(Database.BatchableContext bc){
            
        }
       
}