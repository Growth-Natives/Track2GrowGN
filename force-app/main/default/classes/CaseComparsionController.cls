public with sharing class CaseComparsionController 
{
    @AuraEnabled(cacheable=true)
    public static id getBatchid(String id,String objectName)
    {
        system.debug('getBatchid');
        id batchjobid = null;
        id recordId;
        List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c from Track2Grow__mdt WHERE Object_Name__c =: objectName];
        list<string> recordtypes = new list<string>();
        list<string> fieldValues = new list<string>();
        string fieldName = listTrack2Grow[0].FieldVal__c;
        List<Schema.PicklistEntry> ple = new list<Schema.PicklistEntry>();
        if(Schema.getGlobalDescribe().containskey(objectName))
        {
            SObjectType objecttype = Schema.getGlobalDescribe().get(objectName);
            Map<String,Schema.SObjectField> mfields = objecttype.getDescribe().fields.getMap();
            if(mfields.containskey(fieldName))
            {
                Schema.DescribeFieldResult fieldm= mfields.get(fieldName).getDescribe();
                ple = fieldm.getPicklistValues();
            }
        }
        for(Schema.PicklistEntry pickListVal : ple){
            fieldValues.add((String)pickListVal.getLabel());
        } 
        list<case> caselist = new list<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
        for(case c : caselist)
        {
            recordtypes.add(c.recordtype.name);
        }
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:listTrack2Grow[0].Business_Hour__c and Dates__c = 'Last 6 Months' AND SobjectFieldType__c =: listTrack2Grow[0].FieldVal__c AND SobjectFieldValue__c =: string.join(fieldValues,', ') AND SobjectRecordType__c =: string.join(recordtypes,', ') AND SobjectType__c =: objectName LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;
            if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today())
            {
                averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,listTrack2Grow[0].FieldVal__c,objectName,recordtypes,'Last 6 Months',null,null,recordId,True,listTrack2Grow[0].Business_Hour__c,null,false);
                batchJobId=database.executeBatch(atbc);
            }
        }
        else
        {
            system.debug('BATCH EXECUTED');
            averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,listTrack2Grow[0].FieldVal__c,objectName,recordtypes,'Last 6 Months',null,null,recordId,True,listTrack2Grow[0].Business_Hour__c,null,false);
            batchJobId=database.executeBatch(atbc);
        }
        
        return batchjobid;
    }
    
    @AuraEnabled(cacheable=true)
    public static MAP<string,Map<String,decimal>> getCaseStatus(String id,String objectName)
    {
        system.debug('inside getCaseStatus');
        Map<string,Map<String,decimal>> chartdata = new Map<String,Map<String,decimal>>();
        Map<String,Long> pickValMap = new Map<String,Long>();
        List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c from Track2Grow__mdt WHERE Object_Name__c =: objectName];
        String FieldName;
        for(Track2Grow__mdt md : listTrack2Grow)
        {
            FieldName = md.FieldVal__c;
        }
        Track2Grow__mdt mdt = Track2Grow__mdt.getall().values();
        List<String> newset = new List<String>();
        if(objectName <> null)
        {
            List<TrackingAnalytics__c> listTrack = [SELECT Id, Selected_Values__c FROM TrackingAnalytics__c WHERE Name=:objectName+'-'+fieldName];   
            String[] types = new String[]{objectName};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
            for(Schema.DescribeSobjectResult res : results) 
            {
                for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
                {
                    if (entry.isActive()) 
                    {
                        newset.add(entry.getValue());
                    }
                }
            }
            System.debug(newset);
        }
        for(integer i=0;i<newset.size();i++)
        {
            pickValMap.put(newset[i],0);
        }
        List<SObject> recordsList;
        String condition = 'Id =:id';
        String query = 'SELECT id,createddate,(SELECT CaseId,NewValue,OldValue,createddate,DataType,field FROM Histories order by CreatedDate) FROM ' + objectName + ' WHERE ' + condition;
        recordsList = Database.query(query);
        for(sobject data : recordsList)
        {
            boolean firstTime = true;
            Long subtime;
            datetime caseTime;
            Long ct;
            for(sobject data2 : (list<sobject>)data.getsObjects('histories'))
            {
                datetime dt;
                if(data2.get('Field') == FieldName)
                {
                    if(firstTime)
                    {
                        dt = (dateTime)data2.get('CreatedDate');
                        subtime = dt.gettime();
                        dt = (dateTime)data.get('CreatedDate');
                        Long timee = subtime - dt.gettime();
                        timee = ((timee/1000)/60);
                        caseTime = (dateTime)data2.get('CreatedDate');
                        ct = caseTime.getTime();
                        if (pickValMap.containsKey(string.valueOf(data2.get('OldValue'))))
                        {
                            if(pickValMap.get(string.valueOf(data2.get('OldValue'))) == null)
                            {
                                pickValMap.put(string.valueOf(data2.get('OldValue')),timee);
                            }
                            else
                            {
                                pickValMap.put(string.valueOf(data2.get('OldValue')),pickValMap.get(string.valueOf(data2.get('OldValue')))+timee);
                            }  
                        }
                        
                    }
                    else
                    {
                        dt = (dateTime)data2.get('CreatedDate');
                        subtime = dt.getTime();
                        Long timee = subtime - ct;
                        timee = ((timee/1000)/60);
                        if (pickValMap.containsKey(string.valueOf(data2.get('OldValue'))))
                        {
                            if(pickValMap.get(string.valueOf(data2.get('OldValue'))) != null)
                            {
                                pickValMap.put(string.valueOf(data2.get('OldValue')),pickValMap.get(string.valueOf(data2.get('OldValue')))+timee);
                            }
                            else
                            {
                                pickValMap.put(string.valueOf(data2.get('OldValue')),timee);
                            }
                            caseTime = (dateTime)data2.get('CreatedDate');
                            ct = caseTime.getTime(); 
                        }        
                    }
                    firstTime = false;     
                }
            }
        }
        chartdata.put('Current',pickValMap);
        list<case> caselist = new list<case>([select id, recordtype.name from case where id =: id LIMIT 1]);
        system.debug('1--'+listTrack2Grow[0].Business_Hour__c);
        system.debug('2---'+listTrack2Grow[0].FieldVal__c);
        system.debug('3--'+string.join((Iterable<String>)newset,', '));
        system.debug('4--'+caselist[0].recordtype.name);
        system.debug('5---'+objectName);
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:listTrack2Grow[0].Business_Hour__c and Dates__c = 'Last 6 Months' AND SobjectFieldType__c =: listTrack2Grow[0].FieldVal__c AND SobjectFieldValue__c =: string.join((Iterable<String>)newset,', ') AND SobjectRecordType__c =: caselist[0].recordtype.name  AND SobjectType__c =: objectName LIMIT 1]);
        system.debug('bi value-->'+bi);
        if(bi != null && !bi.isEmpty())
        {
            system.debug('bi[0].dataRepresentation__c value-->'+bi[0].dataRepresentation__c);
            map<string,object> data=(map<string,object>)json.deserializeUntyped(bi[0].dataRepresentation__c);
            map<string,decimal> data1=new map<string,decimal>();
            if(bi[0].dataRepresentation__c!=null)
            {
                for(string s :data.keyset())
                {
                    data1.put(s,(decimal)data.get(s));
                }
            }
            chartdata.put('Average',data1);
        }
        system.debug('chartdata '+chartdata);
        return chartdata;
    }
}