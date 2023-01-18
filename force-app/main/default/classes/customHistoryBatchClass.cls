public class customHistoryBatchClass implements Database.Batchable<sObject>, Database.Stateful{

public String query;
public String obj;
public List<sObject> dataList = new List<sObject>();
    public customHistoryBatchClass(String obj){
        this.query = 'Select id,(Select '+obj + 'Id,NewValue,OldValue,CreatedBy.name,createddate,field from Histories order by CreatedDate) From '+ obj+ ' LIMIT 10';
        System.debug('query..'+this.query);

        this.obj = obj;
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
         String recid;
        for(Object data :(list<Object>)records){
            system.debug('data>>'+data);
            Map<String, Object> mapObj =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
            map<String,Object> recdata = (map<string,Object>)JSON.deserializeUntyped(JSON.serialize(mapObj.get('Histories')));
            List<object> hisdata = (List<object>)JSON.deserializeUntyped(JSON.serialize(recdata.get('records')));
            dataList = new List <Object>();
                for(Object his : hisdata)
                {
                        dataList.add(his);
                }
                String allJson;
                // newJson = new Map<String,Object>(); 
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

        // Insert testPocInsertRecs;

        for(testPOC__c rec : testPocInsertRecs)
           {
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
                    jsonfile.Body = Blob.valueOf(JSON.serialize(newJson.get(rec.recID__c)));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable()){
                    insertJson.add(jsonfile);
                }               
           }
        system.debug('insertJson...'+insertJson);
        //insert insertJson;
        }

        public void finish(Database.BatchableContext bc){
            
        }
       
}