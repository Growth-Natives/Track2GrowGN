public with sharing class CaseComparsionController
{
//     @AuraEnabled(cacheable=true)
//     public static String getStatusValue(String id,String objectName)
//     {
//         String condition = 'Id =:id';
//         String query;
//         query = 'SELECT Status FROM ' + objectName + ' WHERE ' + condition;
//         String statusvalue =  String.valueof(Database.query(query)[0].get('Status'));
//         return statusvalue;
        
//     }
//     @AuraEnabled(cacheable=true)
//     public static id getBatchid(String id,String objectName)
//     {
//         id batchjobid = null;
//         id recordId;
//         List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt];
//         List<string> recordtypes = new List<string>();
//         List<string> fieldValues = new List<string>();
//         string Businesshour;
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
        
//         List<Schema.PicklistEntry> ple = new List<Schema.PicklistEntry>(); 
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
        
//         List<case> caselist = new List<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
//         for(case c : caselist)
//         {
//             recordtypes.add(c.recordtype.name);
//         }
        
//         List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour and Dates__c = 'Last Month' AND SobjectFieldType__c =:FieldName AND SobjectFieldValue__c =: string.join(fieldValues,', ') AND SobjectRecordType__c =: string.join(recordtypes,', ') AND SobjectType__c =: objName LIMIT 1]);
//         if(bi != null && !bi.isEmpty())
//         {
//             recordId = bi[0].Id;
//             if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today())
//             {
//                 averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypes,'Last Month',null,null,recordId,True,Businesshour,null,false,true);
//                 batchJobId=database.executeBatch(atbc);
//             }
//         }
//         else
//         {
//             averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,FieldName,objName,recordtypes,'Last Month',null,null,recordId,True,Businesshour,null,false,true);
//             batchJobId=database.executeBatch(atbc);
//         }
//         return batchjobid;
//     }
    
//     @AuraEnabled
//     public static Map<String,Map<String,decimal>> getCaseStatus(String id,String objectName)
//     {
//         id businesshourid = [Select Id From BusinessHours WHERE isDefault=true LIMIT 1][0].Id;
//         Map<String,Map<String,decimal>> chartdata = new Map<String,Map<String,decimal>>();
//         Map<String,Long> pickValMap = new Map<String,Long>();
//         List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt];
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
//         List<String> newset = new List<String>();
//         if(objName <> null)
//         { 
//             String[] types = new String[]{objName};
//             Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
//             for(Schema.DescribeSobjectResult res : results) 
//             {
//                 for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
//                 {
//                     if (entry.isActive()) 
//                     {
//                         newset.add(entry.getValue());
//                     }
//                 }
//             }
//         }
        
//         for(integer i=0;i<newset.size();i++)
//         {
//             pickValMap.put(newset[i],0);
//         }
        
//         List<Object> recordsList = new List<Object>();
//         String condition = 'Id =:id';
//         String query;
//         if(HistoryObjectName <> null)
//         {
//             if(!test.isRunningTest())
//             {
//                 query = 'SELECT id,createddate__c,(SELECT ' + objName + 'Id__c,NewValue__c,OldValue__c,createddate__c,DataType__c,field__c FROM ' + HistoryObjectName + ' order by CreatedDate__c) FROM ' + objName + ' WHERE ' + condition;
//                 recordsList = Database.query(query);
//             }
//             else
//             {
//                 Profile pf= [Select Id from profile where Name='System Administrator']; 
//                 String orgId=UserInfo.getOrganizationId(); 
//                 String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
//                 Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
//                 String uniqueName=orgId+dateString+RandomId; 
//                 User uu=new User(firstname = 'ABC', 
//                 lastName = 'XYZ', 
//                 email = uniqueName + '@test' + orgId + '.org', 
//                 Username = uniqueName + '@test' + orgId + '.org', 
//                 EmailEncodingKey = 'ISO-8859-1', 
//                 Alias = uniqueName.substring(18, 23), 
//                 TimeZoneSidKey = 'America/Los_Angeles', 
//                 LocaleSidKey = 'en_US', 
//                 LanguageLocaleKey = 'en_US', 
//                 ProfileId = pf.Id); 
//        			insert uu;
                        
//                 Profile pf1= [Select Id from profile where Name='Standard User']; 
//                 String orgId1=UserInfo.getOrganizationId(); 
//                 String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
//                 Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
//                 String uniqueName1=orgId1+dateString1+RandomId1; 
//                 User uu2=new User(firstname = 'ABCD', 
//                 lastName = 'RXYZ', 
//                 email = uniqueName1 + '@test1' + orgId1 + '.org', 
//                 Username = uniqueName1 + '@test1' + orgId1 + '.org', 
//                 EmailEncodingKey = 'ISO-8859-1', 
//                 Alias = uniqueName1.substring(18, 23), 
//                 TimeZoneSidKey = 'America/Los_Angeles', 
//                 LocaleSidKey = 'en_US', 
//                 LanguageLocaleKey = 'en_US', 
//                 ProfileId = pf1.Id); 
//         		insert uu2;
                
//                 Case c1 = new Case();
//                 c1.Origin = 'Email';
//                 c1.Status = 'New';
//                 c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('External').getRecordTypeId();
//                 c1.CreatedDate__c = system.now();
//                 insert c1;
                    
//                 Case c2 = new Case();
//                 c2.Origin = 'Email';
//                 c2.Status = 'New';
//                 c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('External').getRecordTypeId();
//                 c2.CreatedDate__c = system.now();
//                 insert c2;
                    
//                 CustomHistory__c obj = new CustomHistory__c();
//                 obj.CaseId__c =  c1.id;
//                 obj.CreatedDate__c = system.now();
//                 obj.DataType__c = 'EntityId';
//                 obj.Field__c = 'Status';
//                 obj.NewValue__c = uu.Id;
//                 obj.OldValue__c = uu2.Id;
//                 insert obj;
                    
//                 CustomHistory__c obj3 = new CustomHistory__c();
//                 obj3.CaseId__c =  c1.id;
//                 obj3.CreatedDate__c = system.now();
//                 obj3.DataType__c = 'EntityId';
//                 obj3.Field__c = 'Owner';
//                 obj3.NewValue__c = uu.Id;
//                 obj3.OldValue__c = uu2.Id;
//                 insert obj3;
                    
//                 CustomHistory__c obj2 = new CustomHistory__c();
//                 obj2.CaseId__c =  c1.id;
//                 obj2.CreatedDate__c = system.now();
//                 obj2.DataType__c = 'EntityId';
//                 obj2.Field__c = 'Status';
//                 obj2.NewValue__c = uu2.Id;
//                 obj2.OldValue__c = uu.Id;
//                 insert obj2;
                    
//                 CustomHistory__c obj1 = new CustomHistory__c();
//                 obj1.CaseId__c =  c2.id;
//                 obj1.CreatedDate__c = system.now();
//                 obj1.DataType__c = 'EntityId';
//                 obj1.Field__c = 'Owner';
//                 obj1.NewValue__c = uu.Id;
//                 obj1.OldValue__c = uu2.Id;
//                 insert obj1;       
                   
//                 List<Object> caseList = new List<Object>();
//                	objectwrapper newCase = new objectwrapper();
//                 newCase.Id = c1.id;
//                 newCase.OwnerId = '222222222222222222';
//                 newCase.CreatedDate = System.today();   
//                 newCase.histories = new List<Object>{obj,obj1,obj2,obj3};
//                 recordsList.add(c1);
//             }
//         }
//         else if(HistoryObjectName == null)
//         {
//             if(!test.isRunningTest())
//             {
//                 query = 'SELECT id,createddate,(SELECT ' + objName + 'Id,NewValue,OldValue,createddate,DataType,field FROM Histories order by CreatedDate) FROM ' + objName + ' WHERE ' + condition;
//                 recordsList = Database.query(query);
//             }
//             else
//             {
//                 List<Object> caseList = new List<Object>();
//                 objectwrapper newCase = new objectwrapper();
//                 newCase.Id = '111111111111111111';
//                 newCase.OwnerId = '222222222222222222';
//                 newCase.CreatedDate = System.today();
                
//                 ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
//                 ch.Field ='Status';
//                 ch.Newvalue= 'In Progress';
//                 ch.oldvalue = 'New';
//                 ch.DataType = 'DynamicEnum';
//                 ch.CreatedDate = system.now();
                
//                 ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
//                 cHistory.Field ='Owner';
//                 cHistory.NewValue = 'In Progress';
//                 cHistory.OldValue = 'New';
//                 cHistory.DataType = 'EntityId';
//                 cHistory.CreatedDate = system.now();
                
//                 ObjectHistoryMain objNew = new ObjectHistoryMain();
//                 objNew.done =true;
//                 objNew.records = new list<object>{cHistory,ch};
                    
//                 newCase.Histories = objNew;
//                 recordsList.add(newCase);
//             }
//         }
        
//         if(HistoryObjectName <> null)
//         {
//             for(object data : recordsList)
//             {
//                 Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
//                 map<String,object> hisdata;
//                 if(Test.isRunningTest())
//           	  	{ 
//                         Profile pf= [Select Id from profile where Name='System Administrator']; 
        
//                         String orgId=UserInfo.getOrganizationId(); 
//                         String dateString=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
//                         Integer RandomId=Integer.valueOf(Math.rint(Math.random()*1000000)); 
//                         String uniqueName=orgId+dateString+RandomId; 
//                         User uu=new User(firstname = 'ABC', 
//                         lastName = 'XYZ', 
//                         email = uniqueName + '@test' + orgId + '.org', 
//                         Username = uniqueName + '@test' + orgId + '.org', 
//                         EmailEncodingKey = 'ISO-8859-1', 
//                         Alias = uniqueName.substring(18, 23), 
//                         TimeZoneSidKey = 'America/Los_Angeles', 
//                         LocaleSidKey = 'en_US', 
//                         LanguageLocaleKey = 'en_US', 
//                         ProfileId = pf.Id);
//                     	insert uu;
                        
//                         Profile pf1= [Select Id from profile where Name='Standard User']; 
                        
//                         String orgId1=UserInfo.getOrganizationId(); 
//                         String dateString1=String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','') ;
//                         Integer RandomId1=Integer.valueOf(Math.rint(Math.random()*1000000)); 
//                         String uniqueName1=orgId1+dateString1+RandomId1; 
//                         User uu2=new User(firstname = 'ABCD', 
//                         lastName = 'RXYZ', 
//                         email = uniqueName1 + '@test1' + orgId1 + '.org', 
//                         Username = uniqueName1 + '@test1' + orgId1 + '.org', 
//                         EmailEncodingKey = 'ISO-8859-1', 
//                         Alias = uniqueName1.substring(18, 23), 
//                         TimeZoneSidKey = 'America/Los_Angeles', 
//                         LocaleSidKey = 'en_US', 
//                         LanguageLocaleKey = 'en_US', 
//                         ProfileId = pf1.Id); 
//                     	insert uu2;
                    
//                         Case c1 = new Case();
//                         c1.Origin = 'Email';
//                         c1.Status = 'New';
//                         c1.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('External').getRecordTypeId();
//                         c1.CreatedDate__c = system.now();
//                         insert c1;
                        
//                         Case c2 = new Case();
//                         c2.Origin = 'Email';
//                         c2.Status = 'New';
//                         c2.RecordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('External').getRecordTypeId();
//                         c2.CreatedDate__c = system.now();
//                         insert c2;
                        
//                         CustomHistory__c obj = new CustomHistory__c();
//                         obj.CaseId__c =  c1.id;
//                         obj.CreatedDate__c = system.now();
//                         obj.DataType__c = 'EntityId';
//                         obj.Field__c = 'Status';
//                         obj.NewValue__c = 'In Progress';
//                         obj.OldValue__c = 'New';
//                         insert obj;
                        
//                         CustomHistory__c obj3 = new CustomHistory__c();
//                         obj3.CaseId__c =  c1.id;
//                         obj3.CreatedDate__c = system.now();
//                         obj3.DataType__c = 'EntityId';
//                         obj3.Field__c = 'Owner';
//                         obj3.NewValue__c = uu.Id;
//                         obj3.OldValue__c = uu2.Id;
//                         insert obj3;
                        
//                         CustomHistory__c obj2 = new CustomHistory__c();
//                         obj2.CaseId__c =  c1.id;
//                         obj2.CreatedDate__c = system.now();
//                         obj2.DataType__c = 'EntityId';
//                         obj2.Field__c = 'Status';
//                         obj2.NewValue__c = 'In Progress';
//                         obj2.OldValue__c = 'New';
//                         insert obj2;
                        
//                         CustomHistory__c obj1 = new CustomHistory__c();
//                         obj1.CaseId__c =  c2.id;
//                         obj1.CreatedDate__c = system.now();
//                         obj1.DataType__c = 'EntityId';
//                         obj1.Field__c = 'Owner';
//                         obj1.NewValue__c = uu.Id;
//                         obj1.OldValue__c = uu2.Id;
//                         insert obj1;
                        
//                         List<object> hisObject = new List<object>();
//                         object b = JSON.deserializeUntyped(JSON.serialize(obj));
//                         object b1 = JSON.deserializeUntyped(JSON.serialize(obj1));
//                         object b2 = JSON.deserializeUntyped(JSON.serialize(obj2));
//                         object b3 = JSON.deserializeUntyped(JSON.serialize(obj3));
                        
//                         hisObject.add(b);
//                         hisObject.add(b1);
//                         hisObject.add(b2);
//                         hisObject.add(b3);
                        
//                         object vb = JSON.deserializeUntyped(JSON.serialize(hisObject));
//                         hisdata = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(obj));
//                         hisdata.put('records',vb);
// 				}
//                 else
//                 {
//                 	hisdata = (Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get(HistoryObjectName)));
//                 }
//                 boolean firstTime = true;
//                 datetime subtime;
//                 datetime caseTime;
//                 datetime ct;
//                 if(hisdata.get('records') != null)
//                 {
//                     for(object data2 :(list<object>)hisdata.get('records'))
//                     {
//                         Map<String, Object> mapObj2 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data2));
//                         datetime dt;
//                         if(mapObj2.get('Field__c') == FieldName)
//                         {
//                             if(firstTime)
//                             {
//                                 dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
//                                 subtime = dt;
//                                 dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate__c')+'"', DateTime.class);
//                                 Long timee = BusinessHours.diff(businessHourId,dt,subtime);
//                                 timee = ((timee/1000)/60);
//                                 caseTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
//                                 ct = caseTime;
//                                 if (pickValMap.containsKey(String.valueOf(mapObj2.get('OldValue__c'))))
//                                 {
//                                     if(pickValMap.get(String.valueOf(mapObj2.get('OldValue__c'))) == null)
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue__c')),timee);
//                                     }
//                                     else
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(String.valueOf(mapObj2.get('OldValue__c')))+timee);
//                                     }  
//                                 }
                                
//                             }
//                             else
//                             {
//                                 dt =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
//                                 subtime = dt;
//                                 Long timee = BusinessHours.diff(businessHourId,ct,subtime);
//                                 timee = ((timee/1000)/60);
//                                 if (pickValMap.containsKey(String.valueOf(mapObj2.get('OldValue__c'))))
//                                 {
//                                     if(pickValMap.get(String.valueOf(mapObj2.get('OldValue__c'))) != null)
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(String.valueOf(mapObj2.get('OldValue__c')))+timee);
//                                     }
//                                     else
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue__c')),timee);
//                                     }
//                                     caseTime =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
//                                     ct = caseTime; 
//                                 }        
//                             }
//                             firstTime = false;     
//                         }
//                     }
//                 }
//             }
//         }
//         else if(HistoryObjectName == null)
//         {
//             for(object data : recordsList)
//             {
//                 Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
//                 map<String,object> hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get('Histories')));
//                 boolean firstTime = true;
//                 datetime subtime;
//                 datetime caseTime;
//                 datetime ct;
//                 if(hisdata.get('records') != null)
//                 {
//                     for(object data2 :(list<object>)hisdata.get('records'))
//                     {
//                         Map<String, Object> mapObj2 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data2));
//                         datetime dt;
//                         if(mapObj2.get('Field') == FieldName)
//                         {
//                             if(firstTime)
//                             {
//                                 dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
//                                 subtime = dt;
//                                 dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class);
//                                 Long timee = BusinessHours.diff(businessHourId,dt,subtime);
//                                 timee = ((timee/1000)/60);
//                                 caseTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
//                                 ct = caseTime;
//                                 if (pickValMap.containsKey(String.valueOf(mapObj2.get('OldValue'))))
//                                 {
//                                     if(pickValMap.get(String.valueOf(mapObj2.get('OldValue'))) == null)
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue')),timee);
//                                     }
//                                     else
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue')),pickValMap.get(String.valueOf(mapObj2.get('OldValue')))+timee);
//                                     }  
//                                 }
                                
//                             }
//                             else
//                             {
//                                 dt =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
//                                 subtime = dt;
//                                 Long timee = BusinessHours.diff(businessHourId,ct,subtime);
//                                 timee = ((timee/1000)/60);
//                                 if (pickValMap.containsKey(String.valueOf(mapObj2.get('OldValue'))))
//                                 {
//                                     if(pickValMap.get(String.valueOf(mapObj2.get('OldValue'))) != null)
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue')),pickValMap.get(String.valueOf(mapObj2.get('OldValue')))+timee);
                                        
//                                     }
//                                     else
//                                     {
//                                         pickValMap.put(String.valueOf(mapObj2.get('OldValue')),timee);
//                                     }
//                                     caseTime =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
//                                     ct = caseTime; 
//                                 }        
//                             }
//                             firstTime = false;     
//                         }
//                     }
//                 }
//             } 
//         }         
//         chartdata.put('Current',pickValMap);
//         List<case> caselist = new List<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
//         List<BatchInfo__c> bi = new List<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour and Dates__c = 'Last Month' AND SobjectFieldType__c =: FieldName AND SobjectFieldValue__c =: string.join((Iterable<String>)newset,', ') AND SobjectRecordType__c =: caselist[0].recordtype.name  AND SobjectType__c =: objectName LIMIT 1]);
//         if(bi != null && !bi.isEmpty())
//         {
//             Map<String,Object> data=(Map<String,Object>)json.deserializeUntyped(bi[0].dataRepresentation__c);
//             Map<String,decimal> data1=new Map<String,decimal>();
//             if(bi[0].dataRepresentation__c!=null)  
//             {
//                 for(String s :data.keyset())
//                 {
//                     data1.put(s,(decimal)data.get(s));
//                 }
//             }
//             chartdata.put('Average',data1);
//         }
//         return chartdata;
//     }
}