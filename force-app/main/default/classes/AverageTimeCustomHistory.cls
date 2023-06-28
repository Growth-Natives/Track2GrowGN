public class AverageTimeCustomHistory implements Database.Batchable<sObject>, Database.Stateful{
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
    public boolean scheduled;
    public boolean willRefresh=false;
    public string businessHour;
    public id businessHourId;
    public string filterName;
    public string historyObject;
    public static Map<String,Object> oldJson = new Map<String,Object>();
    
    public AverageTimeCustomHistory(list<String> fieldValues, String field, String objectVal, list<String> recordTypes, string dates, date startDate, date endDate, Id recordId, boolean willRefresh, string businessHour, String filterName, boolean scheduled) {
        String query;
        String gsRecordTypeID;
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
        list<BusinessHours> bhlist = new list<BusinessHours>([Select Id From BusinessHours WHERE Name =: businessHour LIMIT 1]);
        if(bhlist!=null && !bhlist.isEmpty() && businessHour != null){
            this.businessHourId = bhlist[0].id;
            this.businessHour = businessHour;
        }
        else{
            bhlist = [Select Id From BusinessHours WHERE Name = 'Default' LIMIT 1];
            this.businessHourId = bhlist[0].id;
            this.businessHour = 'Default';
        }
        for(String s : fieldValues){
            pickValMap.put(s,0.0);
        }
        if(objectVal != null && field != null){
            if(recordTypes.isEmpty()||recordTypes==null){
                string objectVal1 = '(\'' + objectVal + '\')';
                query = 'select id,recID__c,CreatedDate from customHistory__c where Object_Name__c in'+ objectVal1;
            }
            else{
                string objectVal1 = '(\'' + objectVal + '\')';
                query = 'select id,recID__c,CreatedDate from customHistory__c where Object_Name__c in '+ objectVal1;
            }
        }
        if(recordTypes != null && !recordTypes.isEmpty()){
            string recordtypenames = '(\'' + string.join(recordTypes, '\',\'') + '\')';
            query = query + ' AND RecordType__c in ' + recordtypenames;
        }
        if(dates != null){
            String handleDateQuery = handleDate(dates,recordTypes);
            query = query + handleDateQuery;
        } 
        this.query = query;
        system.debug('value of this querry'+this.query);
    }
    public String handleDate(String dates,list<String>recordTypes){
        String  q='';
        if(dates != 'Custom Date'){
            if(recordTypes == null || recordTypes.isEmpty()){
                q = q + ' WHERE ';
            }
            else if(recordTypes != null && !recordTypes.isEmpty()){
                q = q + ' AND ';
            }
            if(dates == 'Last Week')
                q = q + ' CreatedDate__c > LAST_WEEK';
            else if(dates == 'Last Month')
                q = q + ' CreatedDate__c > LAST_MONTH';
            else if(dates == 'This Month')
                q = q + ' CreatedDate__c > THIS_MONTH';
            else if(dates == 'Last 3 Months')
                q = q + ' CreatedDate__c > LAST_N_MONTHS:3';
            else if(dates == 'Last 6 Months')
                q = q + ' CreatedDate__c > LAST_N_MONTHS:6';
            else if(dates == 'Last Year')
                q = q + ' CreatedDate__c > LAST_YEAR';
            else if(dates == 'This Week')
                q = q + ' CreatedDate__c > THIS_WEEK';
            else if(dates == 'This Year')
                q = q + ' CreatedDate__c > THIS_YEAR';
        }
        else if(dates == 'Custom Date'){
            if(recordTypes == null || recordTypes.isEmpty()){
                q = q + ' WHERE ';
            }
            else if(recordTypes != null && !recordTypes.isEmpty()){
                q = q + ' AND ';
            }
            if(startDate != null & endDate != null){
                string startDateTime = string.valueof(startDate);
                startDateTime = startDateTime + 'T00:00:00Z';
                string endDateTime = string.valueof(endDate);
                endDateTime = endDateTime + 'T23:59:59Z';
                q = q + ' CreatedDate__c <= ' + endDateTime + ' AND CreatedDate__c >= ' + startDateTime;
            }
            q = q;
        }
        return q;
    }
    public void attachmentJSONFile(BatchInfo__c bInfo,String Name,String ContentType,map<string,decimal> ownerTimeMap){
        Attachment jsonfile = new Attachment();
        if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable())
        {
            jsonfile.ParentId = bInfo.ID;
        }
        if (Schema.sObjectType.Attachment.fields.Name.isCreateable())
        {
            jsonfile.Name = name;
        }
        if (Schema.sObjectType.Attachment.fields.ContentType.isCreateable())
        {
            jsonfile.ContentType = ContentType;
        }
        if (Schema.sObjectType.Attachment.fields.Body.isCreateable())
        {
            jsonfile.Body = Blob.valueOf(JSON.serialize(ownerTimeMap));
        }
        if(jsonfile!=null && Schema.sObjectType.Attachment.isAccessible()  && Schema.sObjectType.Attachment.isCreateable()){
            insert jsonfile;
        }
    }
    public BatchInfo__c createBatchInfoRecord(map<string,decimal> pickValMap,Id recordId,map<string,decimal> ownerTimeMap,string dates,date startDate,date endDate,string field,String fieldValues,string recordTypes,string objectVal,boolean willRefresh,string businessHour,string filterName,string recordTypeids){
        System.debug('pickValMap>>'+pickValMap);
        BatchInfo__c bInfo = new BatchInfo__c();
        if(recordId!=null){
            system.debug('recId not null');
            BatchInfo__c getinfobatchrec=[SELECT Id, Name, LastReferencedDate, Businesshour__c, DataRepresentation__c, Dates__c, EndDate__c, Filter_Name__c, LastRefreshedDate__c, OwnerDataRepresentation__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, StartDate__c, WillRefresh__c FROM BatchInfo__c where id =:recordId];
            if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) {
                getinfobatchrec.DataRepresentation__c = JSON.serialize(pickValMap);
            }
            if (Schema.sObjectType.BatchInfo__c.fields.Dates__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isAccessible()){
                getinfobatchrec.Dates__c = dates;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isAccessible()){
                getinfobatchrec.StartDate__c = startDate;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isAccessible()){
                getinfobatchrec.EndDate__c = endDate;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isAccessible()){
                getinfobatchrec.SobjectFieldType__c = field;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isAccessible()){
                getinfobatchrec.SobjectFieldValue__c = fieldValues;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isAccessible()){
                getinfobatchrec.SobjectRecordType__c = recordTypes;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isAccessible()){
                getinfobatchrec.SobjectType__c = objectVal;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isAccessible()){
                getinfobatchrec.Businesshour__c = businessHour;
            }
            if(this.willRefresh){
                if (Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isAccessible()){
                    getinfobatchrec.WillRefresh__c = willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()){ 
                    getinfobatchrec.Filter_Name__c = filterName;
                }
            }
            if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()){
                getinfobatchrec.LastRefreshedDate__c = system.today();
            }
            system.debug('getinfobatchrec>>'+getinfobatchrec);
            return getinfobatchrec; 
        }
        else
        {
            system.debug('recId null');
            if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) {
                bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
            }
            if (Schema.sObjectType.BatchInfo__c.fields.Dates__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Dates__c.isAccessible()){
                bInfo.Dates__c = dates;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.StartDate__c.isAccessible()){
                bInfo.StartDate__c = startDate;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.EndDate__c.isAccessible()){
                bInfo.EndDate__c = endDate;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldType__c.isAccessible()){
                bInfo.SobjectFieldType__c = field;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectFieldValue__c.isAccessible()){
                bInfo.SobjectFieldValue__c = fieldValues;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectRecordType__c.isAccessible()){
                bInfo.SobjectRecordType__c = recordTypes;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.SobjectType__c.isAccessible()){
                bInfo.SobjectType__c = objectVal;
            }
            if (Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Businesshour__c.isAccessible()){
                bInfo.Businesshour__c = businessHour;
            }
            if(this.willRefresh){
                if (Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.WillRefresh__c.isAccessible()){
                    bInfo.WillRefresh__c = willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()){ 
                    bInfo.Filter_Name__c = filterName;
                }
            }
            if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()){
                bInfo.LastRefreshedDate__c = system.today();
            }
            system.debug('bInfo>>'+bInfo);
            return bInfo;   
        }
    }
    public Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('value of query'+query);
        return Database.getQueryLocator(query);      
    }
    public void execute(Database.BatchableContext bc, List<customHistory__c> records){
        system.debug('value of records '+records);
        
        for(customHistory__c recid:records)
        {
            Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(recid));
            boolean firstTime = true;
            boolean ownerfirstTime = true;
            dateTime subtime;
            datetime recentRecTime;
            id newValue;
            id oldValue;
            map<id,decimal> ownerChangeMap = new map<id,decimal>();
            set<string> ownerset = new set<string>();
            for(Attachment a : [SELECT Id,Body, Name FROM Attachment Where ParentId =: recid.Id])
            { 
                map<string,object> mapObj2 = new map<string,object>();
                oldJson = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
                string lstCustomers = string.valueOf(oldJson.get(recid.recID__c));
                list<string> sst= lstCustomers.split('},');
                List<string> reversedList= new LIst<string>();
                for(integer I= sst.size()-1; i>=0; i--){
                    string dataafterremove=sst.get(I).remove('{');
                    string dataafterremove1=dataafterremove.remove('}');
                    list<string> splitvalueofdataafterremove1=dataafterremove1.split(',');
                    for(string ssttt:splitvalueofdataafterremove1)
                    {
                        mapObj2.put(ssttt.split('=')[0],ssttt.split('=')[1]);
                    }
                 }
                ///////////////////////////////here the batch code/////////
                if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId'){
                    oldValue = (ID)string.valueOf(mapObj2.get('OldValue'));
                    break;
                }
                ///////////////////////////////////////////////////////////
            }
            
            for(Attachment a : [SELECT Id,Body, Name FROM Attachment Where ParentId =: recid.Id])
            { 
                decimal ownersubtime;
                dateTime dt;
                id oldVal;
                system.debug('value of <><><>'+a);
                map<string,object> mapObj2 = new map<string,object>();
                oldJson = (Map<String,Object>)JSON.deserializeUntyped(a.Body.toString());
                string lstCustomers = string.valueOf(oldJson.get(recid.recID__c));
                list<string> sst= lstCustomers.split('},');
                List<string> reversedList= new LIst<string>();
                for(integer I= sst.size()-1; i>=0; i--){
                    string dataafterremove=sst.get(I).remove('{');
                    string dataafterremove1=dataafterremove.remove('}');
                    list<string> splitvalueofdataafterremove1=dataafterremove1.split(',');
                    for(string ssttt:splitvalueofdataafterremove1)
                    {
                        if(ssttt.split('=')[1].replace(' ','')!=null)
                        {
                            mapObj2.put(ssttt.split('=')[0].replace(' ',''),ssttt.split('=')[1].replace(' ',''));    
                        }
                            
                    }
                    system.debug('value of <><><>'+mapObj2);
                    ///////////////////////////////////////////////////////////////here batch code
                     if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId'){
                    if(ownerfirstTime){
                        string datevalue=string.valueof(mapObj2.get('Date/Time'));
                        string s1=datevalue.SubString(0,10)+' '+datevalue.SubString(10,18);
                        ownersubtime = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class),Date.valueOf(s1));                        
                        ownersubtime = (ownersubtime/1000)/60;  
                        if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue')))){
                            ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownersubtime);
                        }
                        else{
                            ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue')))+ownersubtime);    
                        }
                    }
                    else{
                        string datevalue=string.valueof(mapObj2.get('Date/Time'));
                        string s1=datevalue.SubString(0,10)+' '+datevalue.SubString(10,18);
                        ownersubtime = BusinessHours.diff(businessHourId,(dateTime)recentRecTime,Date.valueOf(s1));                        
                        ownersubtime = (ownersubtime/1000)/60;  
                        if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue')))){
                            ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownersubtime);
                        }
                        else{
                            ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue')))+ownersubtime);    
                        }
                    }
                    newValue = (ID)string.valueOf(mapObj2.get('NewValue'));
                    
                } 
                if(mapObj2.get('Field') == field){
                    if(firstTime){
                        string datevalue=string.valueof(mapObj2.get('Date/Time'));
                        string s1=datevalue.SubString(0,10)+' '+datevalue.SubString(10,18);    
                        dt = Date.valueOf(s1);
                        system.debug('value of dt'+dt);
                        subtime = dt;
                        dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class);
                        system.debug('value of dt'+dt);
                        decimal timee = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class),Date.valueOf(s1));
                         system.debug('value of dt'+timee);
                        timee = (timee/1000)/60;
                        
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                            for(string s : ownerChangeMap.keyset()){
                                ownerset.add(s+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerChangeMap.get(s));
                                }
                                else{
                                    ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue'))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                            if(!ownerTimeMap.containsKey(newValue+':'+(string)mapObj2.get('OldValue'))){
                                ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                            }
                            else{
                                ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                            }
                        }
                        else{
                            if(OldValue != null && newValue == null){
                                ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                            }
                            if(newValue!=null){
                                ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                            }
                            if(oldValue == null && newValue == null){
                                ownerset.add((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                                
                            }
                        }
                        if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue')))){
                            if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) == null){
                                pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
                            }
                            else{
                                pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
                            }
                        }
                    }
                    else{
                        string datevalue=string.valueof(mapObj2.get('Date/Time'));
                        string s1=datevalue.SubString(0,10)+' '+datevalue.SubString(10,18);    
                        dt = Date.valueOf(s1);
                        decimal timee = BusinessHours.diff(businessHourId ,subtime,dt);
                        subtime = dt;
                        timee = (timee/1000)/60;
                        
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                            for(string s : ownerChangeMap.keyset()){
                                ownerset.add(s+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerChangeMap.get(s));
                                }
                                else{
                                    ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue'))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                            if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue'))){
                                ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                            }
                            else{
                                ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class))/1000)/60);
                            }
                        }
                        else{
                            if(oldValue != null && newValue == null){
                                ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                            }
                            else if(newValue!=null){
                                ownerset.add(newValue+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                            }
                            else if(oldValue == null && newValue == null){
                                ownerset.add((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'));
                                if(!ownerTimeMap.containskey((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'))){
                                    ownerTimeMap.put((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'),timee);
                                }
                                else{
                                    ownerTimeMap.put((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj2.get('User')+':'+(string)mapObj2.get('OldValue'))+timee);
                                }
                            }
                        }
                        if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue')))){
                            if(pickValMap.get(string.valueOf(mapObj2.get('OldValue'))) != null){
                                pickValMap.put(string.valueOf(mapObj2.get('OldValue')),pickValMap.get(string.valueOf(mapObj2.get('OldValue')))+timee);
                            }
                            else{
                                pickValMap.put(string.valueOf(mapObj2.get('OldValue')),timee);
                            }
                        }
                    }
                    firstTime = false;
                    ownerChangeMap.clear();
                    system.debug('pickValMap>>'+pickValMap);
                }
                ownerfirstTime = false;
                if(mapObj2.get('Field') == 'Created' ||mapObj2.get('Field') == field || (mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId')){
                        string datevalue=string.valueof(mapObj2.get('Date/Time'));
                        string s1=datevalue.SubString(0,10)+' '+datevalue.SubString(10,18); 
                   // Date.valueOf(s1)
                    recentRecTime = Date.valueOf(s1);
                }
                for(string os : ownerset){
                    if(!recordcountperowner.containsKey(os)){
                        recordcountperowner.put(os,1);
                    }
                    else{
                        recordcountperowner.put(os,recordcountperowner.get(os)+1);
                    }
                }
                   //////////////////////////////////////////////////////////////////////////////
                    
                }
                ///////////////////////////////here the batch code/////////
               
                ///////////////////////////////////////////////////////////
            }
        }
        recordsProcessed=recordsProcessed+records.size();
    }
    public void finish(Database.BatchableContext bc){  
         system.debug('pickValMap..'+pickValMap);
         system.debug('ownerTimeMap..'+ownerTimeMap);
        for(string s : pickValMap.keyset()){
           // System.debug('s>>'+s);
            Decimal avg;
            if(pickValMap.get(s) != null && pickValMap.get(s)!=0){
               // system.debug('hereee..');
                avg = pickValMap.get(s)/recordsProcessed;
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00){
               // system.debug('avg null');
                pickValMap.put(s,0.00);
            }
            else{
               // system.debug('avg not null');
                pickValMap.put(s,avg);
            }
        }
        for(string s : ownerTimeMap.keySet()){
            Decimal avg;
            if(ownerTimeMap.get(s)!=null && ownerTimeMap.get(s)!=0){
                avg = ownerTimeMap.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00){
                ownerTimeMap.put(s,0.0);
            }
            else{
                ownerTimeMap.put(s,avg);
            }
        }
        if(this.scheduled == false){
            system.debug('Schedule false');
            if(this.recordId == null){
                BatchInfo__c bInfo= createbatchinforecord(pickValMap,this.recordId,ownerTimeMap,this.dates,this.startDate,this.endDate,this.field,this.fieldValues,this.recordTypes,this.objectVal,this.willRefresh,this.businessHour,this.filterName,this.recordTypeids);
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable()){
                    database.insert(bInfo);
                }
                IF(this.filterName!=NULL){
                    attachmentJSONFile(bInfo, this.filterName, 'text/plain', ownerTimeMap);
                }
                else if(this.filterName==NULL){
                    attachmentJSONFile(bInfo, 'TestRECORD', 'text/plain', ownerTimeMap);
                }
            }
            else{
                BatchInfo__c bInfo= createBatchInfoRecord(pickValMap,this.recordId,ownerTimeMap,this.dates,this.startDate,this.endDate,this.field,this.fieldValues,this.recordTypes,this.objectVal,this.willRefresh,this.businessHour,this.filterName,this.recordTypeids);
                database.update(bInfo);
                list<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:this.recordId];
                if (BatchInfo__c.sObjectType.getDescribe().isDeletable()){
                    delete doc;
                }
                attachmentJSONFile(bInfo,'TestRECORD','text/plain',ownerTimeMap);
            }
        }
        else{
            system.debug('Schedule true');
            /* list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT DataRepresentation__c,  Dates__c, StartDate__c, EndDate__c,Filter_Name__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, LastRefreshedDate__c,Businesshour__c FROM BatchInfo__c WHERE WillRefresh__c = TRUE ORDER BY LastRefreshedDate__c DESC]);
if(bi != null && !bi.isEmpty()){
if(bi[0].LastRefreshedDate__c != system.today()){  
system.debug('bi[0].LastRefreshedDate__c != system.today');
List<String> lstString = new list<string>();
lstString.add(bi[0].SobjectFieldValue__c);
List<String> recordTyp = new list<string>(); 
recordTyp.add(bi[0].SobjectRecordType__c);
averageTimeBatchClass atbc = new averageTimeBatchClass(bi[0].SobjectFieldValue__c.Split(','),bi[0].SobjectFieldType__c,bi[0].SobjectType__c,bi[0].SobjectRecordType__c.Split(','),bi[0].Dates__c,bi[0].StartDate__c,bi[0].EndDate__c,bi[0].Id,bi[0].WillRefresh__c,bi[0].Businesshour__c,null,true);
database.executeBatch(atbc);
}
}  */
           // system.debug('value of pickValMap><><><><'+pickValMap);
            BatchInfo__c bInfo= createBatchInfoRecord(pickValMap,this.recordId,ownerTimeMap,this.dates,this.startDate,this.endDate,this.field,this.fieldValues,this.recordTypes,this.objectVal,this.willRefresh,this.businessHour,this.filterName,this.recordTypeids);
           // system.debug('value of bInfo><><><><'+bInfo);
            database.update(bInfo);
            list<Attachment> doc = [SELECT Id,body  FROM Attachment where ParentId=:this.recordId];
            if (BatchInfo__c.sObjectType.getDescribe().isDeletable()){
                delete doc;
            }
            attachmentJSONFile(bInfo,'ELSERECORD','text/plain',ownerTimeMap);      
            
        }
    }
    
}