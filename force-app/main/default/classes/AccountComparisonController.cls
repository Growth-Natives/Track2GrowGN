public with sharing class AccountComparisonController 
{
//     @AuraEnabled(cacheable=true)
//     public static List<ReportComparison__mdt> getCustomMetadata() 
//     {
//         List<ReportComparison__mdt> listReportComparison = [SELECT Id,Masterlabel,FieldValue__c,ObjectValue__c from ReportComparison__mdt];
//         return listReportComparison;
//     }
    
//     @AuraEnabled
//     public static list<id> getBatchid(String id,String objectName)
//     {
//         id batchjobid = null;
//         id recordId;
//         id objectIdValue = id;
//         List<String> batchjobids = new List<String>();
//         List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt];
//         List<string> recordtypes = new List<string>();
//         List<string> recordtypesId = new List<string>();
//         List<string> fieldValues = new List<string>();
//         String Businesshour;
//         String FieldName;
//         String HistoryObjectName;
//         String objName;
//         for(Track2Grow__mdt md : listTrack2Grow)
//         {
//             if(md.Masterlabel == 'HistoryObject')
//             {
//                 HistoryObjectName=md.HistoryObject__c;
//             }
//             else if(md.Masterlabel != 'HistoryObject')
//             {
//                 Businesshour=md.Business_Hour__c;
//                 FieldName = md.FieldVal__c;
//                 objName=md.Object_Name__c;
//             }
//         }
        
//         List<Schema.PicklistEntry> ple = new list<Schema.PicklistEntry>(); 
//         if(Schema.getGlobalDescribe().containskey(objName))
//         {
//             SObjectType objecttype = Schema.getGlobalDescribe().get(objName);
//             Map<String,Schema.SObjectField> mfields = objecttype.getDescribe().fields.getMap();
//             if(mfields.containskey(FieldName))
//             {
//                 Schema.DescribeFieldResult fieldm= mfields.get(FieldName).getDescribe();
//                 ple = fieldm.getPicklistValues();
//             }
//         }
        
//         for(Schema.PicklistEntry pickListVal : ple)
//         {
//             fieldValues.add((String)pickListVal.getLabel());
//         }
        
//         SObject recordsList = Schema.getGlobalDescribe().get(objectName).newSObject();
//         String objNameVal;
//         objNameVal = objName + 's';
//         String condition = 'Id =:id';
//         String query;
//         query = 'SELECT Id,(SELECT Id,subject FROM ' + objNameVal + ') FROM ' + objectName + ' WHERE ' + condition + ' LIMIT 1';
//         recordsList = Database.query(query);
        
//         Set<ID> setofIds = new Set<ID>();
//         if(recordsList != null)
//         {
//             for(SObject varObj : recordsList.getSObjects(objNameVal))
//             {    
//                 setofIds.add((id)varObj.get('id'));
//             }
//         }
        
//         List<SObject> objectqueryList = new List<SObject>();
//         String objectquery;
//         String recordtypeIdVal;
//         String recordtypeIdName;
//         objectquery = 'SELECT id, RecordType.Name FROM ' + objName + ' WHERE id IN:setofIds';
//         objectqueryList = Database.query(objectquery);
        
//         if(objectqueryList != null)
//         {
//             for(SObject each:objectqueryList)
//             {
//                 recordtypeIdVal = String.valueOf(each.get('RecordTypeId'));
//                 recordtypeIdName = Schema.getGlobalDescribe().get(objName).getDescribe().getRecordTypeInfosById().get(recordtypeIdVal).getName();
//                 if(!recordtypes.contains(recordtypeIdName))
//                 {
//                     recordtypes.add(recordtypeIdName);
//                 }
//                 if(!recordtypesId.contains(recordtypeIdVal))
//                 {
//                     recordtypesId.add(recordtypeIdVal);
//                 }
//             }
//         }
        
//         System.debug('SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =: '+Businesshour+' and Dates__c = \'Last 3 Months\' AND SobjectFieldType__c =: '+FieldName+ ' AND SobjectFieldValue__c =: '+string.join(fieldValues,', ')+' AND SobjectRecordType__c =: '+string.join(recordtypes,', ')+' AND SobjectType__c =: '+objName);
//         List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour and Dates__c = 'Last 3 Months' AND SobjectFieldType__c =:FieldName AND SobjectFieldValue__c =: string.join(fieldValues,', ') AND SobjectRecordType__c =: string.join(recordtypes,', ') AND SobjectType__c =: objName]);
//         System.debug('Bi :'+bi);
//         if(bi != null && !bi.isEmpty())
//         {
//             for(BatchInfo__c varInfo : bi)
//             {
//                 recordId = varInfo.Id;
//                 if(varInfo.get('LastRefreshedDate__c') == null || varInfo.get('LastRefreshedDate__c') != system.today())
//                 {
//                     system.debug('BATCH EXECUTING');
//                     averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypes,'Last 3 Months',null,null,recordId,True,Businesshour,null,false,true);
//                     batchJobId=database.executeBatch(atbc);
//                     batchjobids.add(batchJobId);
//                 }
//             }	
//         }
//         else
//         {
//             system.debug('BATCH EXECUTED');
//             averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypes,'Last 3 Months',null,null,recordId,True,Businesshour,null,false,true);
//             batchJobId=database.executeBatch(atbc);
//             batchjobids.add(batchJobId);
//         }
//         System.debug('SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,ObjectID__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =: '+Businesshour+' AND SobjectFieldType__c =: '+FieldName+ ' AND SobjectFieldValue__c =: '+string.join(fieldValues,', ')+' AND SobjectType__c =: '+objName +' AND SobjectRecordType__c = null AND ObjectID__c =: '+id);
//         List<BatchInfo__c> bi1 = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,ObjectID__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour AND SobjectFieldType__c =:FieldName AND SobjectFieldValue__c =:string.join(fieldValues,', ') AND SobjectType__c =:objName AND SobjectRecordType__c = null AND ObjectID__c =:id]);
//         System.debug('Bi1 :'+bi1);
//         if(bi1 != null && !bi1.isEmpty())
//         {
//             for(BatchInfo__c varInfo : bi1)
//             {
//                 recordId = varInfo.Id;
//                 if(varInfo.get('LastRefreshedDate__c') == null || varInfo.get('LastRefreshedDate__c') != system.today())
//                 {
//                     system.debug('BATCH EXECUTING');
//                     averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypesId,recordId,objectIdValue,True,Businesshour,null,false,true);
//                     batchJobId=database.executeBatch(atbc);
//                     batchjobids.add(batchJobId);
//                 }
//             }	
//         }
//         else
//         {
//             system.debug('BATCH EXECUTED');
//             averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypesId,recordId,objectIdValue,True,Businesshour,null,false,true);
//             batchJobId=database.executeBatch(atbc);
//             batchjobids.add(batchJobId);
//         }
//         system.debug('batchjobids'+batchjobids);
//         return batchjobids;
//     }
    
//     @AuraEnabled
//     public static Map<String,Map<String,object>> getMetadata(String id,String Apiobject,String objectName,String fieldName)
//     {
//         Map<String,Map<String,object>> chartdata = new Map<String,Map<String,object>>();
//         Map<String,Long> pickValMap = new Map<String,Long>();
        
//         List<String> objectfieldvalue = new List<String>();
//         List<SObject> recordsList = new List<SObject>();
//         List<String> RecordTypeList = new List<String>();
//         List<SObject> objectqueryList = new List<SObject>();
//         List<BatchInfo__c> bi = new List<BatchInfo__c>();
//         List<string> recordtypes = new List<string>();
//         List<string> recordtypesId = new List<string>();
//         Set<ID> setofIds = new Set<ID>();
//         String idName;
//         String recordtypeId;
//         String recordtypeIdName;
//         String objectquery;
//         String recordtypeName;
//         String recordtypeNameValue;
//         String StandardObjectValue;
//         String StandardCreateDateValue;
//         String StandardFieldValue;
//         String StandardNewValue;
//         String StandardOldValue;
//         String query; 
//         String StandardObjectVal;
//         String Businesshour;
//         String dateVal = 'Last 3 Months';
//         String dateVal1;
//         boolean historySwitchValue = true;
//         boolean CustomHistory = false;
//         boolean StandardHistory = false;
//         id businesshourid = [Select Id From BusinessHours WHERE isDefault=true LIMIT 1][0].Id;
        
//         if(objectName <> null)
//         {
//             String[] types = new String[]{objectName};
//             Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
//             for(Schema.DescribeSobjectResult res : results) 
//             {
//                 for(Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
//                 {
//                     if(entry.isActive()) 
//                     {
//                         objectfieldvalue.add(entry.getValue());
//                     }
//                 }
//             }
//         }
        
//         if(objectfieldvalue != null)
//         {
//             for(integer i=0;i<objectfieldvalue.size();i++)
//             {
//                 pickValMap.put(objectfieldvalue[i],0);
//             }
//         }
        
//         List<MappingVal__mdt> lstMappingVal = [SELECT Id,MasterLabel,Custom__c,Standard__c from MappingVal__mdt];
//         if(!lstMappingVal.isEmpty())
//         {
//             if(historySwitchValue)
//             {
//                 for(MappingVal__mdt mdt : lstMappingVal)
//                 {
//                     if(mdt.Masterlabel == 'ObjectValueType')
//                     {
//                         StandardObjectValue = mdt.Custom__c;
//                     }
//                     else if(mdt.Masterlabel == 'CreatedDateValueType')
//                     {
//                         StandardCreateDateValue = mdt.Custom__c;
//                     }
//                     else if(mdt.Masterlabel == 'FieldValueType')
//                     {
//                         StandardFieldValue = mdt.Custom__c;
//                     }
//                     else if(mdt.Masterlabel == 'NewValueType')
//                     {
//                         StandardNewValue = mdt.Custom__c;
//                     }
//                     else if(mdt.Masterlabel == 'OldValueType')
//                     {
//                         StandardOldValue = mdt.Custom__c;
//                     }
//                 }
//                 CustomHistory = true;
//             }
//             else
//             {
//                 for(MappingVal__mdt mdt : lstMappingVal)
//                 {
//                     if(mdt.Masterlabel == 'ObjectValueType')
//                     {
//                         StandardObjectValue = mdt.Standard__c;
//                     }
//                     else if(mdt.Masterlabel == 'CreatedDateValueType')
//                     {
//                         StandardCreateDateValue = mdt.Standard__c;
//                     }
//                     else if(mdt.Masterlabel == 'FieldValueType')
//                     {
//                         StandardFieldValue = mdt.Standard__c;
//                     }
//                     else if(mdt.Masterlabel == 'NewValueType')
//                     {
//                         StandardNewValue = mdt.Standard__c;
//                     }
//                     else if(mdt.Masterlabel == 'OldValueType')
//                     {
//                         StandardOldValue = mdt.Standard__c;
//                     }
//                 }
//                 StandardHistory = true;
//             }
//         }
        
//         if(CustomHistory)
//         {
//             StandardObjectVal = StandardObjectValue.replace('__c','s__r');
//             query = 'SELECT Id,createddate,(SELECT ' + StandardNewValue + ', ' + StandardOldValue + ',' + StandardCreateDateValue + ',' + StandardFieldValue + ' FROM ' + StandardObjectVal + ' order by ' + StandardCreateDateValue + ') FROM '+ objectName + ' WHERE ' + Apiobject + 'Id = :id';
//             recordsList = Database.query(query);
//         }
        
//         if(StandardHistory)
//         {
//             query = 'SELECT Id,createddate,(SELECT ' + objectName + 'Id,NewValue,OldValue,createddate,DataType,field FROM Histories order by CreatedDate) FROM '+ objectName + ' WHERE ' + Apiobject + 'Id = :id';
//             recordsList = Database.query(query);
//         }
        
//         if(recordsList != null)
//         {
//             for(SObject varList : recordsList)
//             {
//                 setofIds.add(varList.Id);
//             }
//         }
        
//         List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt];
//         for(Track2Grow__mdt md : listTrack2Grow)
//         {
//             if(md.Masterlabel != 'HistoryObject')
//             {
//                 Businesshour=md.Business_Hour__c;
//             }
//         }
        
//         objectquery = 'SELECT id, RecordType.Name, RecordTypeId FROM ' + objectName + ' WHERE id IN:setofIds';
//         objectqueryList = Database.query(objectquery);
//         if(objectqueryList != null)
//         {
//             for(SObject each:objectqueryList)
//             {
//                 recordtypeId = String.valueOf(each.get('RecordTypeId'));
//                 recordtypeIdName = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(recordtypeId).getName();
//                 if(!RecordTypeList.contains(recordtypeIdName))
//                 {
//                     RecordTypeList.add(recordtypeIdName);
//                 }
//             }
//         }

//         if(dateVal == 'Last 3 Months')
//         {
//             Map<String,Object> dataValue = new Map<String,Object>();
//             System.debug('SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =: '+Businesshour+' and Dates__c =: '+dateVal+' AND SobjectFieldType__c =: '+FieldName+ ' AND SobjectFieldValue__c =: '+string.join(objectfieldvalue,', ')+' AND SobjectRecordType__c =: '+string.join(RecordTypeList,', ')+' AND SobjectType__c =: '+objectName);
//             bi = [SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour and Dates__c =:dateVal AND SobjectFieldType__c =:FieldName AND SobjectFieldValue__c =:string.join((Iterable<String>)objectfieldvalue,', ') AND SobjectRecordType__c =:string.join((Iterable<String>)RecordTypeList,', ') AND SobjectType__c =: objectName];
//             System.debug('bi values -->'+bi);
//             if(bi != null && !bi.isEmpty())
//             {
//                 for(BatchInfo__c varbInfo : bi)
//                 {
//                     Map<String,Object> data=(Map<String,Object>)json.deserializeUntyped(varbInfo.DataRepresentationPerRecordType__c);
//                     if(varbInfo.DataRepresentationPerRecordType__c != null)  
//                     {
//                         for(String r : data.keyset())
//                         {
//                             idName = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(r).getName();
//                             dataValue.put(idName,data.get(r));
//                             System.debug('dataValue'+dataValue);
//                         }
//                         chartdata.put(dateVal,dataValue);
//                     }
//                 }
//             }
//         }
        
//         if(dateVal1 == null)
//         {
//             Map<String,Object> dataValue = new Map<String,Object>();
//             System.debug('SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,ObjectID__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =: '+Businesshour+' AND SobjectFieldType__c =: '+FieldName+ ' AND SobjectFieldValue__c =: '+string.join((Iterable<String>)objectfieldvalue,', ')+' AND SobjectType__c =: '+objectName +' AND SobjectRecordType__c = null AND ObjectID__c =: '+id);
//             bi = [SELECT Id,dataRepresentation__c,DataRepresentationPerRecordType__c,ObjectID__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour AND SobjectFieldType__c =:FieldName AND SobjectFieldValue__c =: string.join((Iterable<String>)objectfieldvalue,', ') AND SobjectType__c =: objectName AND SobjectRecordType__c = null AND ObjectID__c =:id];
//             System.debug('bi values -->'+bi);
//             if(bi != null && !bi.isEmpty())
//             {
//                 for(BatchInfo__c varbInfo : bi)
//                 {
//                     Map<String,Object> data=(Map<String,Object>)json.deserializeUntyped(varbInfo.DataRepresentationPerRecordType__c);
//                     if(varbInfo.DataRepresentationPerRecordType__c != null)  
//                     {
//                         for(String r : data.keyset())
//                         {
//                             idName = Schema.getGlobalDescribe().get(objectName).getDescribe().getRecordTypeInfosById().get(r).getName();
//                             dataValue.put(idName,data.get(r));
//                             System.debug('dataValue'+dataValue);
//                         }
//                         chartdata.put(dateVal1,dataValue);
//                     }
//                 }
//             }
//         }
//         System.debug('chartdata value '+chartdata);
//         return chartdata;
//     }
}