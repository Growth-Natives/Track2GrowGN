public class averageTimeBatchClass implements Database.Batchable<sObject>, Database.Stateful
{
    public map<string,decimal> pickValMap = new map<string,decimal>();
    public map<string,decimal> ownerTimeMap = new map<string,decimal>();
    public map<string,integer> recordcountperowner = new map<string,integer>();
    public Set<string> recordPerIdSet = new Set<string>();
    public integer recordsProcessed = 0;
    public string query;
    public String field;
    public String fieldValues;
    public list<String> fieldValue;
    public list<String> recordType;
    public string recordTypes;
    public string recordTypeids;
    public String objectVal;
    public string dates;
    public date startDate;
    public date endDate;
    public Id recordId;
    public Id objectIdValue;
    public boolean scheduled;
    public boolean willRefresh=false;
    public string businessHour;
    public id businessHourId;
    public string filterName;
    public string historyObject;
    
    public averageTimeBatchClass(list<String> fieldValues, String field, String objectVal, list<String> recordTypes, string dates, date startDate, date endDate, Id recordId, boolean willRefresh, string businessHour, String filterName, boolean scheduled) 
    {
        this.field = field;
        this.objectVal = objectVal;
        this.dates = dates;
        this.startDate = startDate;
        this.endDate = endDate;
        this.recordId = recordId;
        this.scheduled = scheduled;
        this.willRefresh = willRefresh;
        this.filterName = filterName;
        this.fieldValues = string.join(fieldValues,', '); 
        if(recordTypes == null||recordTypes.isEmpty()){
             this.recordTypes=null;
	    }
        else{
           this.recordTypes = String.join(recordTypes,', ');
        }
        string query;
        String gsRecordTypeID;
        list<BusinessHours> bhlist = new list<BusinessHours>([Select Id From BusinessHours WHERE Name =: businessHour LIMIT 1]);
        if(bhlist!=null && !bhlist.isEmpty() && businessHour != null){
            this.businessHourId = bhlist[0].id;
            this.businessHour = businessHour;
        }
        else
        {
            bhlist = [Select Id From BusinessHours WHERE Name = 'Default' LIMIT 1];
            this.businessHourId = bhlist[0].id;
            this.businessHour = 'Default';
        }
        for(String s : fieldValues)
        {
            pickValMap.put(s,0.0);
        }
       if(objectVal != null && field != null)
            {
                if(recordTypes.isEmpty()||recordTypes==null){
                    query = 'select id,createddate,OwnerId,' + field + ',(select ' + objectVal +'id,NewValue,OldValue,createddate,DataType,field from Histories order by CreatedDate) from ' + objectVal;
                }
                else{
                    query = 'select id,createddate,RecordTypeId,OwnerId,' + field + ',(select ' + objectVal +'id,NewValue,OldValue,createddate,DataType,field from Histories order by CreatedDate) from ' + objectVal;
                }
            }
            if(recordTypes != null && !recordTypes.isEmpty())
            {
                string recordtypenames = '(\'' + string.join(recordTypes, '\',\'') + '\')';
                query = query + ' WHERE recordType.name in ' + recordtypenames;
            }
            if(dates != null && dates != 'Custom Date')
            {
                if(recordTypes == null || recordTypes.isEmpty())
                {
                    query = query + ' WHERE ';
                }
                else if(recordTypes != null && !recordTypes.isEmpty())
                {
                    query = query + ' AND ';
                }
                if(dates == 'Last Week')
                    query = query + ' CreatedDate = LAST_WEEK';
                else if(dates == 'Last Month')
                    query = query + ' CreatedDate = LAST_MONTH';
                else if(dates == 'This Month')
                    query = query + ' CreatedDate = THIS_MONTH';
                else if(dates == 'Last 3 Months')
                    query = query + ' CreatedDate = LAST_N_MONTHS:3';
                else if(dates == 'Last 6 Months')
                    query = query + ' CreatedDate = LAST_N_MONTHS:6';
                else if(dates == 'Last Year')
                    query = query + ' CreatedDate = LAST_YEAR';
                else if(dates == 'This Week')
                    query = query + ' CreatedDate = THIS_WEEK';
                else if(dates == 'This Year')
                    query = query + ' CreatedDate = THIS_YEAR';
            }
            if(dates == 'Custom Date')
            {
                if(recordTypes == null || recordTypes.isEmpty())
                {
                    query = query + ' WHERE ';
                }
                else if(recordTypes != null && !recordTypes.isEmpty())
                {
                    query = query + ' AND ';
                }
                if(startDate != null & endDate != null)
                {
                    string startDateTime = string.valueof(startDate);
                    startDateTime = startDateTime + 'T00:00:00Z';
                    string endDateTime = string.valueof(endDate);
                    endDateTime = endDateTime + 'T23:59:59Z';
                    query = query + ' CreatedDate <= ' + endDateTime + ' AND CreatedDate >= ' + startDateTime;
                }
                query = query + ' LIMIT 1000';
            }
      
        this.query = query;
    }
    public Database.QueryLocator start(Database.BatchableContext bc) 
    {
        return Database.getQueryLocator(query);      
    }
    public void execute(Database.BatchableContext bc, List<object> records)
    {
        for(object data :(list<object>)records)
            {
                Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
                map<String,object> hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get('Histories')));                
                boolean firstTime = true;
                boolean ownerfirstTime = true;
                dateTime subtime;
                datetime recentRecTime;
                id newValue;
                id oldValue;
                map<id,decimal> ownerChangeMap = new map<id,decimal>();
                set<string> ownerset = new set<string>();
                if((list<object>)hisdata.get('records')!=null)
                {
                    for(object data2 : (list<object>)hisdata.get('records'))
                    {
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2));
                        if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId')
                        {
                            oldValue = (ID)string.valueOf(mapObj2.get('OldValue'));
                            break;
                        }
                    }
                    for(object data2 : (list<object>)hisdata.get('records'))
                    {decimal ownersubtime;
                        dateTime dt;
                        id oldVal;
                     
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2));
                        if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId')
                        {
                            if(ownerfirstTime)
                            {
                                ownersubtime = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class),(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class));                        
                                ownersubtime = (ownersubtime/1000)/60;  
                                if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue'))))
                                {
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownersubtime);
                                }
                                else
                                {
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue')))+ownersubtime);    
                                }
                            }
                            else
                            {
                                system.debug('value 0f recentRecTime'+recentRecTime);
                                ownersubtime = BusinessHours.diff(businessHourId,(dateTime)recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class));                        
                                ownersubtime = (ownersubtime/1000)/60;  
                                  if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue'))))
                                {
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownersubtime);
                                }
                                else
                                {
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue')))+ownersubtime);    
                                }
                            }
                            newValue = (ID)string.valueOf(mapObj2.get('NewValue'));
                            
                        }    
                        if(mapObj2.get('Field') == field)
                        {
                            if(firstTime)
                            {
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
                                subtime = dt;
                                dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class);
                                decimal timee = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class),(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class));
                                timee = (timee/1000)/60;
                                  
                                if(ownerChangeMap != null && !ownerChangeMap.isEmpty())
                                {
                                    for(string s : ownerChangeMap.keyset())
                                    {
                                        ownerset.add(s+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerChangeMap.get(s));
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue'))+ownerChangeMap.get(s));
                                        }
                                    }
                                    ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                    if(!ownerTimeMap.containsKey(newValue+':'+(string)mapObj2.get('OldValue')))
                                    {
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                                    }
                                    else
                                    {
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                                    }
                                }
                                else
                                {
                                    if(OldValue != null && newValue == null){
                                        ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                    }
                                    if(newValue!=null)
                                    {
                                        ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                    }
                                    if(oldValue == null && newValue == null)
                                    {
                                        ownerset.add((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                        
                                    }
                                }
                                if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue'))))
                                {
                                    if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) == null)
                                    {
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
                                    }
                                    else
                                    {
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
                                    }
                                }
                            }
                            else
                            {
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
                                decimal timee = BusinessHours.diff(businessHourId ,subtime,dt);
                                subtime = dt;
                                timee = (timee/1000)/60;
                                     
                                if(ownerChangeMap != null && !ownerChangeMap.isEmpty())
                                {
                                    for(string s : ownerChangeMap.keyset())
                                    {
                                        ownerset.add(s+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerChangeMap.get(s));
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue'))+ownerChangeMap.get(s));
                                        }
                                    }
                                    ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                    if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue')))
                                    {
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                                    }
                                    else
                                    {
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                                    }
                                }
                                else
                                {
                                    if(oldValue != null && newValue == null)
                                    {
                                        ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                    }
                                    else if(newValue!=null)
                                    {
                                        ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                    }
                                    else if(oldValue == null && newValue == null)
                                    {
                                        ownerset.add((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue')))
                                        {
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else
                                        {
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))+timee);
                                        }
                                    }
                                }
                                if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue'))))
                                {
                                    if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) != null)
                                    {
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
                                    }
                                    else
                                    {
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
                                    }
                                }
                            }
                            firstTime = false;
                            ownerChangeMap.clear();
                        }
                        ownerfirstTime = false;
                        if(mapObj2.get('Field') == 'Created' ||mapObj2.get('Field') == field || (mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId'))
                        {
                            recentRecTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
                        } 
                    }
                    for(string os : ownerset)
                    {
                        if(!recordcountperowner.containsKey(os))
                        {
                            recordcountperowner.put(os,1);
                        }
                        else
                        {
                            recordcountperowner.put(os,recordcountperowner.get(os)+1);
                        }
                    }
                }
            }
        system.debug('pickValMapex===>'+pickValMap);
        recordsProcessed=recordsProcessed+records.size();
    }
    public void finish(Database.BatchableContext bc)
    {   system.debug('recordsProcessed===>'+recordsProcessed);
       
        system.debug('pickValMapfn===>'+pickValMap);
      system.debug('value of mapfn>>'+ownerTimeMap);
        for(string s : pickValMap.keyset())
        {
            Decimal avg;
            if(pickValMap.get(s) != null && pickValMap.get(s)!=0)
            {
                avg = pickValMap.get(s)/recordsProcessed;
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
            {
                pickValMap.put(s,0.00);
            }
            else
            {
                pickValMap.put(s,avg);
            }
            
        }
        system.debug('value of '+pickValMap);
        for(string s : ownerTimeMap.keySet())
        {
            Decimal avg;
            if(ownerTimeMap.get(s)!=null && ownerTimeMap.get(s)!=0)
            {
                 system.debug('recordsProcessed<><><><>'+  recordcountperowner.get(s));
     
                avg = ownerTimeMap.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
            {
                ownerTimeMap.put(s,null);
            }
            else
            {
                ownerTimeMap.put(s,avg);
            }
        }
         system.debug('value of '+ownerTimeMap);
        if(this.scheduled == false)
        {
            if(this.recordId == null)
            {
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) 
                {
                    bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
                }
				if (Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isAccessible()) 
				{
					bInfo.ObjectID__c = this.objectIdValue;
				}
                if (Schema.sObjectType.BatchInfo__c.fields.Dates__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isAccessible()) 
                {
                    bInfo.Dates__c = this.dates;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isAccessible()) 
                {
                    bInfo.StartDate__c = this.startDate;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isAccessible()) 
                {
                    bInfo.EndDate__c = this.endDate;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isAccessible()) 
                {
                    bInfo.SobjectFieldType__c = this.field;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isAccessible()) 
                {
                    bInfo.SobjectFieldValue__c = this.fieldValues;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isAccessible()) 
                {
                    bInfo.SobjectRecordType__c = this.recordTypes;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isAccessible()) 
                {
                    bInfo.SobjectType__c = this.objectVal;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isAccessible()) 
                {
                    bInfo.WillRefresh__c = this.willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isAccessible()) 
                {
                    bInfo.Businesshour__c = this.businessHour;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()) 
                {
                    bInfo.Filter_Name__c = this.filterName;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
                {
                    bInfo.LastRefreshedDate__c = system.today();
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                    database.insert(bInfo); 
                }
                IF(this.filterName!=NULL)
                {
                    Attachment jsonfile = new Attachment();
                    if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable()) 
                    {
                    jsonfile.ParentId = bInfo.ID;
                    }
                    if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) 
                    {
                    jsonfile.Name = this.filterName;
                    }
                    if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable()) 
                    {
                    jsonfile.ContentType = 'text/plain';
                    }
                    if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) 
                    {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(ownerTimeMap));
                    }
                    if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                    {
                    insert jsonfile;
                    }
                }
                else if(this.filterName==NULL)
                {
                    Attachment jsonfile = new Attachment();
                    if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable()) 
                    {
                    jsonfile.ParentId = bInfo.ID;
                    }
                    if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) 
                    {
                    jsonfile.Name = 'TestRECORD';
                    }
                    if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable()) 
                    {
                    jsonfile.ContentType = 'text/plain';
                    }
                    if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) 
                    {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(ownerTimeMap));
                    }
                    if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                    {
                    insert jsonfile;
                    }
                    
                }
            }
            else
            {
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible() && Schema.sObjectType.BatchInfo__c.fields.Id.isUpdateable()) 
                {
                    bInfo.Id = this.recordId;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) 
                {
                    bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
                }
				if (Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isAccessible()) 
				{
					bInfo.ObjectID__c = this.objectIdValue;
				}
                if (Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isAccessible()) 
                {
                    bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMap);
                }
                if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
                {
                    bInfo.LastRefreshedDate__c = system.today();
                }
                if (Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isAccessible()) 
                {
                    bInfo.SobjectRecordType__c = this.recordTypeids;
                }
                if(this.willRefresh)
                {
                    if (Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isAccessible()) 
                    {
                        bInfo.WillRefresh__c = this.willRefresh;
                    }
                    if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()) 
                    { 
                        bInfo.Filter_Name__c = this.filterName;
                    }
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isUpdateable())
                {
                    if (Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()){
                    bInfo.Id = this.recordId;
                    }
                    database.update(bInfo);
                }
                list<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:this.recordId];
                if (BatchInfo__c.sObjectType.getDescribe().isDeletable())
                {
                    delete doc;
                }
                Attachment jsonfile = new Attachment();
                if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable()) 
                    {
                    jsonfile.ParentId = bInfo.ID;
                    }
                    if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) 
                    {
                    jsonfile.Name = 'TestRECORD';
                    }
                    if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable()) 
                    {
                    jsonfile.ContentType = 'text/plain';
                    }
                    if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) 
                    {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(ownerTimeMap));
                    }
                    if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                    {
                    insert jsonfile;
                    }
            }
        }
        else
        {
            list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT DataRepresentation__c,  Dates__c, StartDate__c, EndDate__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, LastRefreshedDate__c,Businesshour__c FROM BatchInfo__c WHERE WillRefresh__c = TRUE ORDER BY LastRefreshedDate__c LIMIT 1]);
            if(bi != null && !bi.isEmpty())
            {
                if(bi[0].LastRefreshedDate__c != system.today())
                {  
                    averageTimeBatchClass atbc = new averageTimeBatchClass(bi[0].SobjectFieldValue__c.Split(','),bi[0].SobjectFieldType__c,bi[0].SobjectType__c,bi[0].SobjectRecordType__c.Split(','),bi[0].Dates__c,bi[0].StartDate__c,bi[0].EndDate__c,bi[0].Id,bi[0].WillRefresh__c,bi[0].Businesshour__c,null,true);
                    database.executeBatch(atbc);
                }
            }
            BatchInfo__c bInfo = new BatchInfo__c();
            if (Schema.sObjectType.BatchInfo__c.fields.Id.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()) 
            {
                bInfo.Id = this.recordId;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) 
            {
                bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
            }
			if (Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.ObjectID__c.isAccessible()) 
            {
                bInfo.ObjectID__c = this.objectIdValue;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isAccessible()) 
            {
                bInfo.SobjectRecordType__c = this.recordTypeids;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
            {
                bInfo.LastRefreshedDate__c = system.today();
            }
            if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isUpdateable())
            {
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()) {
                bInfo.Id = this.recordId;
                }
                database.update(bInfo);
            }
            list<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:this.recordId];
            if (BatchInfo__c.sObjectType.getDescribe().isDeletable())
            {
            delete doc;
            }
            Attachment jsonfile = new Attachment();
            if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable()) 
                    {
                    jsonfile.ParentId = bInfo.ID;
                    }
                    if (Schema.sObjectType.Attachment.fields.Name.isCreateable()) 
                    {
                    jsonfile.Name = 'ELSERECORD';
                    }
                    if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable()) 
                    {
                    jsonfile.ContentType = 'text/plain';
                    }
                    if (Schema.sObjectType.Attachment.fields.Body.isCreateable()) 
                    {
                    jsonfile.Body = Blob.valueOf(JSON.serialize(ownerTimeMap));
                    }
                    if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable())
                    {
                    insert jsonfile;
                    }
        }
    }
     
    }