public class TrackingToolUtil
{   
    public static List<customHistory__c> testPocInsertRecs = new List<customHistory__c>();
    public static List<String> allObjFields = new List<String>();
    public static List<String> updatedFields = new List<String>();
    public static List<Attachment> insertJson = new List<Attachment>(); 
    public static List<Attachment> tempJson = new List<Attachment>(); 
    public static Set<Id> recIdsIns = new Set<Id>();
    public static Set<Id> recIds = new Set<Id>();
    public static Map<string,Map<String,Object>> finalJson = new Map<string,Map<String,Object>>();
    public static String combinedJson;
    public static String allUpdatedJson;
    public static Map<String,Object> newJson = new Map<String,Object>();
    public static Map<String,Object> oldJson = new Map<String,Object>();
    public static Map<string,Object> dataIdMap = new Map<string,Object>();
    public static String Obj = 'Case';
    public static void onAfterInsert(List<SObject> newlist,Map<Id,SObject> newmap)
    {  
        ////////////////////////////
         system.debug('after update');
        system.debug('newlist newlist'+newlist);
        for(sObject rec : newlist)
          {  
            recIdsIns.add(rec.Id);
          }
        
        String query = 'SELECT Id, LastModifiedBy.Name,CreatedDate,recordType.name,LastModifiedDate FROM '+Obj+ ' WHERE Id IN :recIdsIns';
            
        List<sObject> objList = Database.query(query);
        system.debug('objList..'+objList);
        
        for(sObject rec : objList)
        {      
               customHistory__c insRec = new customHistory__c();
               insRec.Object_Name__c = Obj;
               insRec.recID__c = rec.Id;
               insRec.CreatedDate__c=(datetime)rec.get('CreatedDate');  
               insRec.RecordType__c=string.valueof(rec.getsObject('recordType').get('name'));
               testPocInsertRecs.add(insRec);
               
               dataIdMap.put('Field', 'Created');
               dataIdMap.put('Date/Time', rec.get('LastModifiedDate'));    
               dataIdMap.put('User', rec.getsObject('LastModifiedBy').get('Name'));
               dataIdMap.put('CreatedById', rec.getsObject('LastModifiedBy').get('Id'));
               dataIdMap.put('OldValue', null);
               dataIdMap.put('NewValue', null);
               
               finalJson.put(rec.Id, dataIdMap);
        }
         system.debug('finalJson..'+finalJson);
         insert testPocInsertRecs;
        
         for(customHistory__c rec : testPocInsertRecs)
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
                    jsonfile.Body = Blob.valueOf(JSON.serialize(finalJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable()){
                    insertJson.add(jsonfile);
                }               
           }
        system.debug('insertJson...'+insertJson);
        insert insertJson;
        ////////////////////////////
    }
    public static void onAfterUpdate(List<SObject> newlist,Map<Id,SObject> newmap,List<SObject> oldlist,Map<Id,SObject> oldmap)
    {
        ///////////////////////////////////////
         system.debug('in after update');
       
        allObjFields = customHistoryComponentController.getFields(Obj);
        system.debug('allObjFields..'+allObjFields);
        
        for(sObject rec : newlist)
           {
               recIds.add(rec.Id);
               sObject oldRec = Trigger.oldMap.get(rec.ID);
               
               for(String fieldName : allObjFields)
               {
                   if(fieldName != 'LastModifiedDate' && fieldName != 'SystemModstamp')
                   {  
                   if(rec.get(fieldName) != oldRec.get(fieldName))
                   {
                      updatedFields.add(fieldName);
                   }
                   } 
               }
               system.debug('updatedFields..'+updatedFields);
           }
        
        
        String query = 'SELECT Id,CreatedById, LastModifiedBy.Name,Owner.Name,CreatedDate,LastModifiedDate ';
        
        
        for(String updField : updatedFields)
        {
            query = query + ',' +updField;
        }
        
        query = query + ' FROM '+ Obj + ' WHERE Id IN :recIds';
        
        system.debug('query..'+query);
        
        List<sObject> objList = Database.query(query);
        
        system.debug('objList..'+objList);
        
        
        //List<Case> objList = [SELECT Id, LastModifiedBy.Name,CreatedDate,Owner.Name,LastModifiedDate FROM Case WHERE Id IN :Trigger.new];
        
        for(sObject rec : objList)
        {
            sObject oldRec = Trigger.oldMap.get(rec.ID);
              
            for(String updField : updatedFields)
            {
               if(updField == 'OwnerId')
               {
                   dataIdMap.put('Field', 'Case Owner');
               }
               else
               {    
                   dataIdMap.put('Field', updField);  
               }
               dataIdMap.put('Date/Time', rec.get('LastModifiedDate'));    
               dataIdMap.put('User', rec.getsObject('LastModifiedBy').get('Name'));
               dataIdMap.put('CreatedById', rec.getsObject('LastModifiedBy').get('Id')); 
                if(updField == 'OwnerId')
                {
                    String ownerid = oldRec.get('OwnerId').toString();
                    system.debug('owner name..'+ownerid);
                    List<User> ownerlist = [Select id, Name from User Where id =: ownerid];
                    system.debug('owner name..'+ownerlist[0].Name);
                    dataIdMap.put('OldValue', ownerlist[0].Name);
                    dataIdMap.put('NewValue', rec.getsObject('Owner').get('Name'));
                }
                else
               {     
                   dataIdMap.put('OldValue', oldRec.get(updField));
                   dataIdMap.put('NewValue', rec.get(updField));
               }
               system.debug('dataIdMap..'+dataIdMap);
               if(allUpdatedJson == null)
               {
                   allUpdatedJson = dataIdMap.toString();
               }
                else
               {  
                   allUpdatedJson = dataIdMap.toString() + ',' + allUpdatedJson ;
               }
               newJson.put(rec.Id, allUpdatedJson);
            }
        }
        system.debug('dataIdMap..'+dataIdMap);
        system.debug('newJson..'+newJson);
        
        List<customHistory__c> testPocRecs = [Select id, Name, Object_Name__c,recID__c From customHistory__c Where recID__c in : recIds];
        system.debug('testPocRecs>>'+testPocRecs);
        List<customHistory__c> InsRecsList = new List<customHistory__c>();
        if(testPocRecs == null || testPocRecs.isEmpty())
        {
            for(sObject rec : objList)
            {    
                system.debug('rec not found');
                customHistory__c insRec = new customHistory__c();
                insRec.Object_Name__c = Obj;
                insRec.recID__c = rec.Id;
                InsRecsList.add(insRec);
            }
            
            Insert InsRecsList;
            
            for(customHistory__c rec : InsRecsList)
           {
                Attachment jsonfile = new Attachment();
                if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable())
                {
                    jsonfile.ParentId = rec.Id;
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
                    jsonfile.Body = Blob.valueOf(JSON.serialize(newJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                {
                    tempJson.add(jsonfile);
                }
               Insert jsonfile;
           }
        }
      
        else if(testPocRecs != null && !testPocRecs.isEmpty())
        {   
        for(customHistory__c rec : testPocRecs)            
        {
            Attachment jsonfile = new Attachment();
            for(Attachment a : [SELECT Id,Body, Name FROM Attachment Where ParentId =: rec.Id])
               { 
                   system.debug('Body..'+a.Body.toString());
                   system.debug('Id..'+a.Id);
                   jsonfile.Id = a.ID;
                   oldJson = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
                   system.debug('oldJson..'+oldJson);
                   system.debug('oldJson.. value'+oldJson.get(rec.recID__c));
                   system.debug('newJson.. value'+newJson.get(rec.recID__c));
                   combinedJson =  newJson.get(rec.recID__c).toString() +','+ oldJson.get(rec.recID__c).toString();
                   system.debug('combinedJson...'+combinedJson);
                   newJson.put(rec.recID__c, combinedJson);
               }
                system.debug('newJson..'+newJson);
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
                    jsonfile.Body = Blob.valueOf(JSON.serialize(newJson));
                }
                if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                {
                    insertJson.add(jsonfile);
                }  
        }
        system.debug('insertJson update'+insertJson);
        update insertJson;
    }
    }
        ///////////////////////////////////////
        //
}