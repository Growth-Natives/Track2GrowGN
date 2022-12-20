public with sharing class CaseComparsionControllerDuplicate
{
    // @AuraEnabled(cacheable=true)
    // public static id getBatchid(String id,String objectName)
    // {
    //     system.debug('getBatchid');
    //     id batchjobid = null;
    //     id recordId;
    //     List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c from Track2Grow__mdt WHERE Object_Name__c =: objectName];
    //     System.debug('Track2GrowList:'+listTrack2Grow);
    //     list<string> recordtypes = new list<string>();
    //     list<string> fieldValues = new list<string>();
    //     string fieldName = listTrack2Grow[0].FieldVal__c;
    //     List<Schema.PicklistEntry> ple = new list<Schema.PicklistEntry>();
        
    //     if(Schema.getGlobalDescribe().containskey(objectName))
    //     {
    //         SObjectType objecttype = Schema.getGlobalDescribe().get(objectName);
    //         Map<String,Schema.SObjectField> mfields = objecttype.getDescribe().fields.getMap();
    //         if(mfields.containskey(fieldName))
    //         {
    //             Schema.DescribeFieldResult fieldm= mfields.get(fieldName).getDescribe();
    //             ple = fieldm.getPicklistValues();
    //         }
    //         System.debug('ple value-->'+ple);
    //     }
        
    //     for(Schema.PicklistEntry pickListVal : ple)
    //     {
    //         fieldValues.add((String)pickListVal.getLabel());
    //     } 
    //     system.debug('id-->'+id);
    //     System.debug('ple value-->'+ple);
        
    //     list<case> caselist = new list<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
    //     System.debug('Case List :'+caselist);
        
    //     for(case c : caselist)
    //     {
    //         system.debug(c.recordtype.name);
    //         recordtypes.add(c.recordtype.name);
    //     }
        
    //     System.debug('Businesshour__c'+listTrack2Grow[0].Business_Hour__c);
    //     System.debug('SobjectFieldType__c'+listTrack2Grow[0].FieldVal__c);
    //     System.debug('SobjectFieldValue__c'+string.join(fieldValues,', '));
    //     System.debug('SobjectRecordType__c'+string.join(recordtypes,', '));
    //     System.debug('SobjectType__c'+objectName);
    //     //system.debug('SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =: '+listTrack2Grow[0].Business_Hour__c+ ' and Dates__c = \'This Week\' AND SobjectFieldType__c =: '+ listTrack2Grow[0].FieldVal__c  + ' AND SobjectFieldValue__c =: '+string.join(fieldValues,', ')+' AND SobjectRecordType__c =: '+string.join(recordtypes,', ')+' AND SobjectType__c =: '+objectName +' LIMIT 1');
    //     list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:listTrack2Grow[0].Business_Hour__c and Dates__c = 'Last 6 Months' AND SobjectFieldType__c =: listTrack2Grow[0].FieldVal__c AND SobjectFieldValue__c =: string.join(fieldValues,', ') AND SobjectRecordType__c =: string.join(recordtypes,', ') AND SobjectType__c =: objectName LIMIT 1]);
    //     System.debug('Bi :'+bi);
    //     if(bi != null && !bi.isEmpty())
    //     {
    //         recordId = bi[0].Id;
    //         if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today())
    //         {
    //             duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,listTrack2Grow[0].FieldVal__c,objectName,recordtypes,'Last 6 Months',null,null,recordId,True,listTrack2Grow[0].Business_Hour__c,null,false,true);
    //             batchJobId=database.executeBatch(atbc);
    //         }
    //     }
    //     else
    //     {
    //         system.debug('BATCH EXECUTED');
    //         duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,listTrack2Grow[0].FieldVal__c,objectName,recordtypes,'Last 6 Months',null,null,recordId,True,listTrack2Grow[0].Business_Hour__c,null,false,true);
    //         batchJobId=database.executeBatch(atbc);
    //     }
        
    //     return batchjobid;
    // }
    
    // @AuraEnabled
    // public static MAP<string,Map<String,decimal>> getCaseStatus(String id,String objectName)
    // {
    //     id businesshourid = [Select Id From BusinessHours WHERE isDefault=true LIMIT 1][0].Id;
    //     Map<string,Map<String,decimal>> chartdata = new Map<String,Map<String,decimal>>();
    //     Map<String,Long> pickValMap = new Map<String,Long>();
    //     List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt limit 50000];
    //     string Businesshour;
    //     System.debug('listTrack2Grow value'+listTrack2Grow);
    //     String FieldName;
    //     String HistoryObjectName;
    //     String objName;
    //     for(Track2Grow__mdt md : listTrack2Grow)
    //     {
    //         if(md.Masterlabel == 'HistoryObject')
    //         {
    //             HistoryObjectName=md.HistoryObject__c;
    //             System.debug('HistoryObjectName value -->'+HistoryObjectName);
    //         }
    //         else if(md.Masterlabel != 'HistoryObject')
    //         {
    //             Businesshour=md.Business_Hour__c;
    //             FieldName = md.FieldVal__c;
    //             objName=md.Object_Name__c;
    //             System.debug('objName value -->'+objName);
    //         }
    //     }
    //     //Track2Grow__mdt mdt = Track2Grow__mdt.getall().values();
    //     List<String> newset = new List<String>();
    //     if(objName <> null)
    //     {
    //         //List<TrackingAnalytics__c> listTrack = [SELECT Id, Selected_Values__c FROM TrackingAnalytics__c WHERE Name=:objectName+'-'+fieldName];   
    //         String[] types = new String[]{objName};
    //         Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
    //         for(Schema.DescribeSobjectResult res : results) 
    //         {
    //             for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
    //             {
    //                 if (entry.isActive()) 
    //                 {
    //                     newset.add(entry.getValue());
    //                 }
    //             }
    //         }
    //         System.debug('newset value-->'+newset);
    //     }
        
    //     for(integer i=0;i<newset.size();i++)
    //     {
    //         pickValMap.put(newset[i],0);
    //     }
        
    //     List<Object> recordsList = new List<Object>();
    //     String condition = 'Id =:id';
    //     String query;
    //     if(HistoryObjectName <> null)
    //     {
    //         system.debug('HistoryObjectName value-->'+HistoryObjectName);
    //         if(!test.isRunningTest())
    //         {
    //             query = 'SELECT id,createddate__c,(SELECT ' + objName + 'Id__c,NewValue__c,OldValue__c,createddate__c,DataType__c,field__c FROM ' + HistoryObjectName + ' order by CreatedDate__c) FROM ' + objName + ' WHERE ' + condition;
    //             system.debug('query value-->'+query);
    //             recordsList = Database.query(query);
    //             system.debug('recordsList value-->'+recordsList);
                
    //         }
    //         else
    //         {
    //             List<Object> caseList = new List<Object>();
    //             objectwrapper newCase = new objectwrapper();
    //             newCase.Id = '111111111111111111';
    //             newCase.OwnerId = '222222222222222222';
    //             newCase.CreatedDate = System.today();
                
    //             ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
    //             ch.Field ='Status';
    //             ch.Newvalue= 'In Progress';
    //             ch.oldvalue = 'New';
    //             ch.DataType = 'DynamicEnum';
    //             ch.CreatedDate = system.now();
                
    //             ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
    //             cHistory.Field ='Owner';
    //             cHistory.NewValue = 'In Progress';
    //             cHistory.OldValue = 'New';
    //             cHistory.DataType = 'EntityId';
    //             cHistory.CreatedDate = system.now();
                
    //             ObjectHistoryMain objNew = new ObjectHistoryMain();
    //             objNew.done =true;
    //             objNew.records = new list<object>{cHistory,ch};
                    
    //             newCase.Histories =objNew;
    //             recordsList.add(newCase);
    //         }
            
    //         System.debug('RecordList :'+recordsList);
            
    //     }
    //     else if(HistoryObjectName == null)
    //     {
    //         system.debug('HistoryObjectName value-->'+HistoryObjectName);
    //         if(!test.isRunningTest())
    //         {
    //             query = 'SELECT id,createddate,(SELECT ' + objName + 'Id,NewValue,OldValue,createddate,DataType,field FROM Histories order by CreatedDate) FROM ' + objName + ' WHERE ' + condition;
    //             recordsList = Database.query(query);
    //             system.debug('recordsList value-->'+recordsList);	
    //         }
    //         else
    //         {
    //             List<Object> caseList = new List<Object>();
    //             objectwrapper newCase = new objectwrapper();
    //             newCase.Id = '111111111111111111';
    //             newCase.OwnerId = '222222222222222222';
    //             newCase.CreatedDate = System.today();
                
    //             ObjectHistoryWrapper ch=new ObjectHistoryWrapper();
    //             ch.Field ='Status';
    //             ch.Newvalue= 'In Progress';
    //             ch.oldvalue = 'New';
    //             ch.DataType = 'DynamicEnum';
    //             ch.CreatedDate = system.now();
                
    //             ObjectHistoryWrapper cHistory=new ObjectHistoryWrapper();
    //             cHistory.Field ='Owner';
    //             cHistory.NewValue = 'In Progress';
    //             cHistory.OldValue = 'New';
    //             cHistory.DataType = 'EntityId';
    //             cHistory.CreatedDate = system.now();
                
    //             ObjectHistoryMain objNew = new ObjectHistoryMain();
    //             objNew.done =true;
    //             objNew.records = new list<object>{cHistory,ch};
                    
    //                 newCase.Histories =objNew;
    //             recordsList.add(newCase);
    //         }
            
    //         System.debug('RecordList :'+recordsList);
    //     }
        
    //     if(HistoryObjectName <> null)
    //     {
    //         system.debug('HistoryObjectName value-->'+HistoryObjectName);
    //         for(object data : recordsList)
    //         {
    //             Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
    //             map<String,object> hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get(HistoryObjectName)));
    //             system.debug('hisdata value--->'+hisdata);
    //             boolean firstTime = true;
    //             datetime subtime;
    //             datetime caseTime;
    //             datetime ct;
    //             for(object data2 :(list<object>)hisdata.get('records'))
    //             {
    //                 Map<String, Object> mapObj2 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data2));
    //                 datetime dt;
    //                 if(mapObj2.get('Field__c') == FieldName)
    //                 {
    //                     if(firstTime)
    //                     {
    //                         dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
    //                         subtime = dt;
    //                         dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate__c')+'"', DateTime.class);
    //                         Long timee = BusinessHours.diff(businessHourId,dt,subtime);
    //                         timee = ((timee/1000)/60);
    //                         caseTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
    //                         ct = caseTime;
    //                         if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue__c'))))
    //                         {
    //                             if(pickValMap.get(string.valueOf(mapObj2.get('OldValue__c'))) == null)
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),timee);
    //                             }
    //                             else
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(string.valueOf(mapObj2.get('OldValue__c')))+timee);
    //                             }  
    //                         }
                            
    //                     }
    //                     else
    //                     {
    //                         dt =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
    //                         subtime = dt;
    //                         Long timee = BusinessHours.diff(businessHourId,ct,subtime);
    //                         timee = ((timee/1000)/60);
    //                         if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue__c'))))
    //                         {
    //                             if(pickValMap.get(string.valueOf(mapObj2.get('OldValue__c'))) != null)
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(string.valueOf(mapObj2.get('OldValue__c')))+timee);
    //                             }
    //                             else
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),timee);
    //                             }
    //                             caseTime =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
    //                             ct = caseTime; 
    //                         }        
    //                     }
    //                     firstTime = false;     
    //                 }
    //             }
    //         }
    //     }
    //     else if(HistoryObjectName == null)
    //     {
    //         system.debug('HistoryObjectName value-->'+HistoryObjectName);
    //         for(object data : recordsList)
    //         {
    //             Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
    //             map<String,object> hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get('Histories')));
    //             boolean firstTime = true;
    //             datetime subtime;
    //             datetime caseTime;
    //             datetime ct;
    //             for(object data2 :(list<object>)hisdata.get('records'))
    //             {
    //                 Map<String, Object> mapObj2 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data2));
    //                 datetime dt;
    //                 if(mapObj2.get('Field') == FieldName)
    //                 {
    //                     if(firstTime)
    //                     {
    //                         dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
    //                         subtime = dt;
    //                         dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class);
    //                         Long timee = BusinessHours.diff(businessHourId,dt,subtime);
    //                         timee = ((timee/1000)/60);
    //                         caseTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
    //                         ct = caseTime;
    //                         if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue'))))
    //                         {
    //                             if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) == null)
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
    //                             }
    //                             else
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
    //                             }  
    //                         }
                            
    //                     }
    //                     else
    //                     {
    //                         dt =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
    //                         subtime = dt;
    //                         Long timee = BusinessHours.diff(businessHourId,ct,subtime);
    //                         timee = ((timee/1000)/60);
    //                         if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue'))))
    //                         {
    //                             if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) != null)
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
                               		
    //                             }
    //                             else
    //                             {
    //                                 pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
    //                             }
    //                             caseTime =  (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
    //                             ct = caseTime; 
    //                         }        
    //                     }
    //                     firstTime = false;     
    //                 }
    //             }
    //         } 
    //     }         
    //     chartdata.put('Current',pickValMap);
    //     list<case> caselist = new list<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
    //     System.debug('Businesshour__c value '+Businesshour);
    //     System.debug('SobjectFieldType__c value '+FieldName);
    //     System.debug('SobjectFieldValue__c value '+string.join((Iterable<String>)newset,', '));
    //     System.debug('SobjectRecordType__c value'+caselist[0].recordtype.name);
    //     System.debug('SobjectType__c value'+objectName);
    //     list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:Businesshour and Dates__c = 'Last 6 Months' AND SobjectFieldType__c =: FieldName AND SobjectFieldValue__c =: string.join((Iterable<String>)newset,', ') AND SobjectRecordType__c =: caselist[0].recordtype.name  AND SobjectType__c =: objectName LIMIT 1]);
    //     system.debug('bi value-->'+bi);
    //     if(bi != null && !bi.isEmpty())
    //     {
    //         map<string,object> data=(map<string,object>)json.deserializeUntyped(bi[0].dataRepresentation__c);
    //         map<string,decimal> data1=new map<string,decimal>();
    //         if(bi[0].dataRepresentation__c!=null)  
    //         {
    //             for(string s :data.keyset())
    //             {
    //                 data1.put(s,(decimal)data.get(s));
    //             }
    //         }
    //         chartdata.put('Average',data1);
    //         System.debug('chartdata value -->'+chartdata);
    //     }
    //     system.debug('chartdata '+chartdata);
    //     return chartdata;
    // }
}