public class duplicateaveragebatch implements Database.Batchable<sObject>, Database.Stateful {
    public map<string,decimal> pickValMap = new map<string,decimal>();
    public map<string,decimal> ownerTimeMapglobal = new map<string,decimal>();
    public map<string,integer> recordcountperowner = new map<string,integer>();
    public integer recordsProcessed = 0;
    public string query;
    public String field;
    public String fieldValues;
    public string recordTypes;
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
    public boolean historySwitch=false;
    public duplicateaveragebatch(){}
    public duplicateaveragebatch(list<String> fieldValues, String field, String objectVal, list<String> recordTypes, string dates, date startDate, date endDate, Id recordId, boolean willRefresh, string businessHour, String filterName, boolean scheduled,  boolean historySwitch) {
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
        this.recordTypes = string.join(recordTypes,', ');
        this.historySwitch = historySwitch;
        string query;
        List<Track2Grow__mdt> listTrack2Grow = new list<Track2Grow__mdt>([SELECT Id,Masterlabel,HistoryObject__c from Track2Grow__mdt WHERE Masterlabel = 'HistoryObject']);
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
        for(string s : fieldValues){
            pickValMap.put(s,0.0);
        }
        System.debug('PickValMap :'+pickValMap);
        if(!historySwitch){
            if(objectVal != null && Field != null){
                query = 'select id,createddate,' + Field + ',(select ' + objectVal +'id,NewValue,OldValue,createddate,DataType,Field from Histories order by CreatedDate) from ' + objectVal;
            }
            if(recordTypes != null && !recordTypes.isEmpty()){
                string recordtypenames = '(\'' + string.join(recordTypes, '\',\'') + '\')';
                query = query + ' WHERE recordType.name in ' + recordtypenames;
            }
            if(dates != null && dates != 'Custom Date'){
                if(recordTypes == null || recordTypes.isEmpty()){
                    query = query + ' WHERE ';
                }
                else if(recordTypes != null && !recordTypes.isEmpty()){
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
            if(dates == 'Custom Date'){
                if(recordTypes == null || recordTypes.isEmpty()){
                    query = query + ' WHERE ';
                }
                else if(recordTypes != null && !recordTypes.isEmpty()){
                    query = query + ' AND ';
                }
                if(startDate != null & endDate != null){
                    string startDateTime = string.valueof(startDate);
                    startDateTime = startDateTime + 'T00:00:00Z';
                    string endDateTime = string.valueof(endDate);
                    endDateTime = endDateTime + 'T23:59:59Z';
                    query = query + ' CreatedDate <= ' + endDateTime + ' AND CreatedDate >= ' + startDateTime;
                }
            }
        }
        else{
            if(listTrack2Grow!=null && !listTrack2Grow.isEmpty()){
                if(objectVal != null && Field != null){
                    query = 'select id,createddate__c,customuser__c,customuser__r.id,' + Field + ',(select ' + objectVal +'id__c,NewValue__c,OldValue__c,createddate__c,Field__c from ' + listTrack2Grow[0].HistoryObject__c + ' order by CreatedDate__c) from ' + objectVal;
                }
                if(recordTypes != null && !recordTypes.isEmpty()){
                    string recordtypenames = '(\'' + string.join(recordTypes, '\',\'') + '\')';
                    query = query + ' WHERE recordType.name in ' + recordtypenames;
                }
                if(dates != null && dates != 'Custom Date'){
                    if(recordTypes == null || recordTypes.isEmpty()){
                        query = query + ' WHERE ';
                    }
                    else if(recordTypes != null && !recordTypes.isEmpty()){
                        query = query + ' AND ';
                    }
                    if(dates == 'Last Week')
                        query = query + ' CreatedDate__c = LAST_WEEK';
                    else if(dates == 'Last Month')
                        query = query + ' CreatedDate__c = LAST_MONTH';
                    else if(dates == 'This Month')
                        query = query + ' CreatedDate__c = THIS_MONTH';
                    else if(dates == 'Last 3 Months')
                        query = query + ' CreatedDate__c = LAST_N_MONTHS:3';
                    else if(dates == 'Last 6 Months')
                        query = query + ' CreatedDate__c = LAST_N_MONTHS:6';
                    else if(dates == 'Last Year')
                        query = query + ' CreatedDate__c = LAST_YEAR';
                    else if(dates == 'This Week')
                        query = query + ' CreatedDate__c = THIS_WEEK';
                    else if(dates == 'This Year')
                        query = query + ' CreatedDate__c = THIS_YEAR';
                }
                if(dates == 'Custom Date'){
                    if(recordTypes == null || recordTypes.isEmpty()){
                        query = query + ' WHERE ';
                    }
                    else if(recordTypes != null && !recordTypes.isEmpty()){
                        query = query + ' AND ';
                    }
                    if(startDate != null & endDate != null){
                        string startDateTime = string.valueof(startDate);
                        startDateTime = startDateTime + 'T00:00:00Z';
                        string endDateTime = string.valueof(endDate);
                        endDateTime = endDateTime + 'T23:59:59Z';
                        query = query + ' CreatedDate__c <= ' + endDateTime + ' AND CreatedDate__c >= ' + startDateTime;
                    }
                }
            }
        }
        this.query = query;
        system.debug('batch query ' + this.query);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);      
    }
    public void execute(Database.BatchableContext bc, List<object> records){
        try{
            map<string,decimal> ownerTimeMap = new map<string,decimal>();
            
            if(!historySwitch){
                for(object data :(list<object>)records){
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
                    for(object data2 : (list<object>)hisdata.get('records')){
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2)); 
                        if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId'){
                            oldValue = (ID)string.valueOf(mapObj2.get('OldValue'));
                            break;
                        }
                    }
                    for(object data2 : (list<object>)hisdata.get('records')){
                        decimal ownersubtime;
                        dateTime dt;
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2)); 
                        if(mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId'){
                            if(ownerfirstTime){
                                ownersubtime = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class),(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class));                        
                                ownersubtime = (ownersubtime/1000)/60;                 
                                if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue')))){
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownersubtime);
                                }
                                else{
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue')))+ownersubtime);    
                                }
                            }
                            else{
                                ownersubtime = BusinessHours.diff(businessHourId,(dateTime)recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class));                        
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
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
                                subtime = dt;
                                dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate')+'"', DateTime.class);
                                decimal timee = BusinessHours.diff(businessHourId,dt,subtime);
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
                                        ownerset.add((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))){
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))+timee);
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
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
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
                                        ownerset.add((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))){
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'),ownerTimeMap.get((string)mapObj1.get('OwnerId')+':'+(string)mapObj2.get('OldValue'))+timee);
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
                        }
                        ownerfirstTime = false;
                        if(mapObj2.get('Field') == 'Created' ||mapObj2.get('Field') == field || (mapObj2.get('Field') == 'Owner' && mapObj2.get('DataType') == 'EntityId')){
                            recentRecTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate')+'"', DateTime.class);
                        } 
                    }
                    
                    for(string os : ownerset){
                        if(!recordcountperowner.containsKey(os)){
                            recordcountperowner.put(os,1);
                        }
                        else{
                            recordcountperowner.put(os,recordcountperowner.get(os)+1);
                        }
                    }
                }
            }
            else{
                for(object data :(list<object>)records){
                    Map<String, Object> mapObj1 =(Map<String, Object>)JSON.deserializeUntyped(JSON.serialize(data));
                    
                    map<String,object> hisdata = (map<string,object>)JSON.deserializeUntyped(JSON.serialize(mapObj1.get('CustomHistorys__r')));
                    boolean firstTime = true;
                    boolean ownerfirstTime = true;
                    dateTime subtime;
                    datetime recentRecTime;
                    string newValue;
                    string oldValue;
                    map<id,decimal> ownerChangeMap = new map<id,decimal>();
                    set<string> ownerset = new set<string>();
                    for(object data2 : (list<object>)hisdata.get('records')){
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2)); 
                        if(mapObj2.get('Field__c') == 'Owner' && mapObj2.get('DataType__c') == 'EntityId'){
                            oldValue = (ID)string.valueOf(mapObj2.get('OldValue__c'));
                            system.debug('oldValue 1 = '+oldValue);
                            break;
                        }
                    }
                    for(object data2 : (list<object>)hisdata.get('records')){
                        decimal ownersubtime;
                        dateTime dt;
                        map<string,object> mapObj2 =(map<string,object>)JSON.deserializeUntyped(JSON.serialize(data2)); 
                        if(mapObj2.get('Field__c') == 'Owner' && mapObj2.get('DataType__c') == 'EntityId'){
                            if(ownerfirstTime){
                                ownersubtime = BusinessHours.diff(businessHourId,(DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate__c')+'"', DateTime.class),(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class));                        
                                ownersubtime = (ownersubtime/1000)/60;                 
                                if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue__c')))){
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue__c')),ownersubtime);
                                    
                                }
                                else{
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue__c')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue__c')))+ownersubtime);    
                                }
                            }
                            else{
                                ownersubtime = BusinessHours.diff(businessHourId,(dateTime)recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class));                        
                                ownersubtime = (ownersubtime/1000)/60;                 
                                if(!ownerChangeMap.containskey((ID)string.valueOf(mapObj2.get('OldValue__c')))){
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue__c')),ownersubtime);
                                }
                                else{
                                    ownerChangeMap.put((ID)string.valueOf(mapObj2.get('OldValue__c')),ownerChangeMap.get((ID)string.valueOf(mapObj2.get('OldValue__c')))+ownersubtime);    
                                }
                            }
                            newValue = (ID)string.valueOf(mapObj2.get('NewValue__c'));
                            system.debug('ownerChangeMap 1 = '+ownerChangeMap);
                            system.debug('newValue 1 = '+newValue);
                        }    
                        
                        if(mapObj2.get('Field__c') == field){
                            system.debug('field 1'+field);
                            if(firstTime){
                                system.debug('firstTime 1');
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
                                subtime = dt;
                                dt = (DateTime)JSON.deserialize('"' + mapObj1.get('CreatedDate__c')+'"', DateTime.class);
                                decimal timee = BusinessHours.diff(businessHourId,dt,subtime);
                                timee = (timee/1000)/60;
                                if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                                    for(string s : ownerChangeMap.keyset()){
                                        ownerset.add(s+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue__c'),ownerChangeMap.get(s));
                                            
                                        }
                                        else{
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue__c'))+ownerChangeMap.get(s));
                                        }
                                    }
                                    ownerset.add(newValue+':'+(string)mapObj2.get('OldValue__c'));
                                    if(!ownerTimeMap.containsKey(newValue+':'+(string)mapObj2.get('OldValue__c'))){
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class))/1000)/60);
                                    }
                                    else{
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue__c'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class))/1000)/60);
                                    }
                                    system.debug('ownerTimeMap 1 = '+ownerTimeMap);
                                }
                                else{
                                    if(oldValue != null && newValue == null){
                                        system.debug('(oldValue != null && newValue == null)');
                                        ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                    else if(newValue!=null){
                                        system.debug('(newValue!=null)');
                                        ownerset.add(newValue+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                    else if(oldValue == null && newValue == null){
                                        system.debug('null');
                                        system.debug((string)mapObj1.get('CustomUser__r.id'));
                                        system.debug((string)mapObj1.get('CustomUser__c'));
                                        ownerset.add((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                }
                                if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue__c')))){
                                    if(pickValMap.get(string.valueOf(mapObj2.get('OldValue__c'))) == null){
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),timee);
                                    }
                                    else{
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(string.valueOf(mapObj2.get('OldValue__c')))+timee);
                                    }
                                }
                                system.debug('ownerTimeMap 1 = '+ownerTimeMap);
                            }
                            else{
                                dt = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
                                decimal timee = BusinessHours.diff(businessHourId ,subtime,dt);
                                subtime = dt;
                                timee = (timee/1000)/60;
                                if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                                    for(string s : ownerChangeMap.keyset()){
                                        ownerset.add(s+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(s+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue__c'),ownerChangeMap.get(s));
                                        }
                                        else{
                                            ownerTimeMap.put(s+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(s+':'+(string)mapObj2.get('OldValue__c'))+ownerChangeMap.get(s));
                                        }
                                    }
                                    ownerset.add(newValue+':'+(string)mapObj2.get('OldValue__c'));
                                    if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue__c'))){
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class))/1000)/60);
                                    }
                                    else{
                                        ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue__c'))+(BusinessHours.diff(businessHourId,recentRecTime,(DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class))/1000)/60);
                                    }
                                    system.debug('ownerTimeMap 2 = '+ownerTimeMap);
                                }
                                else{
                                    if(oldValue != null && newValue == null){
                                        ownerset.add(oldValue+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(oldValue+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put(oldValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(oldValue+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                    else if(newValue!=null){
                                        ownerset.add(newValue+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey(newValue+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put(newValue+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get(newValue+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                    else if(oldValue == null && newValue == null){
                                        
                                        ownerset.add((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'));
                                        if(!ownerTimeMap.containskey((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'))){
                                            ownerTimeMap.put((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'),timee);
                                        }
                                        else{
                                            ownerTimeMap.put((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'),ownerTimeMap.get((string)mapObj1.get('CustomUser__c')+':'+(string)mapObj2.get('OldValue__c'))+timee);
                                        }
                                    }
                                }
                                if (pickValMap.containsKey(string.valueOf(mapObj2.get('OldValue__c')))){
                                    if(pickValMap.get(string.valueOf(mapObj2.get('OldValue__c'))) != null){
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),pickValMap.get(string.valueOf(mapObj2.get('OldValue__c')))+timee);
                                    }
                                    else{
                                        pickValMap.put(string.valueOf(mapObj2.get('OldValue__c')),timee);
                                    }
                                }
                                system.debug('ownerTimeMap 2 = '+ownerTimeMap);
                            }
                            firstTime = false;
                            ownerChangeMap.clear();
                        }
                        ownerfirstTime = false;
                        if(mapObj2.get('Field__c') == 'Created' ||mapObj2.get('Field__c') == field || (mapObj2.get('Field__c') == 'Owner' && mapObj2.get('DataType__c') == 'EntityId')){
                            recentRecTime = (DateTime)JSON.deserialize('"' + mapObj2.get('CreatedDate__c')+'"', DateTime.class);
                        } 
                    }
                    for(string os : ownerset){
                        if(!recordcountperowner.containsKey(os)){
                            recordcountperowner.put(os,1);
                        }
                        else{
                            recordcountperowner.put(os,recordcountperowner.get(os)+1);
                        }
                    }
                    
                }
                system.debug('ownerTimeMap 3 = '+ownerTimeMap);
                ownerTimeMapglobal = ownerTimeMap;
                system.debug('ownerTimeMapglobal 3 = '+ownerTimeMapglobal);
            }
            recordsProcessed=recordsProcessed+records.size();
            
            system.debug('ownerTimeMap FINAL = '+ownerTimeMap);
        }
        catch(exception e){
            
        }
    }
    public void finish(Database.BatchableContext bc){
        system.debug('pickValMap'+pickValMap);
        for(string s : pickValMap.keyset()){
            Decimal avg;
            if(pickValMap.get(s) != null){
                avg = pickValMap.get(s)/recordsProcessed;
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
                pickValMap.put(s,0.00);
            else
                pickValMap.put(s,avg);
        }
        system.debug('recordsProcessed'+recordsProcessed);
        system.debug('pickValMap'+pickValMap);
        system.debug('ownerTimeMapglobal = '+ownerTimeMapglobal);
        for(string s : ownerTimeMapglobal.keySet()){
            Decimal avg;
            if(ownerTimeMapglobal.get(s)!=null){
                avg = ownerTimeMapglobal.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
                ownerTimeMapglobal.put(s,0.0);
            else
                ownerTimeMapglobal.put(s,avg);
        }
        system.debug('recordcountperowner = '+recordcountperowner);
        system.debug('ownerTimeMapglobal = '+ownerTimeMapglobal);
        if(this.scheduled == false){
            if(this.recordId == null){
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) 
                {
                    bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
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
                if (Schema.sObjectType.BatchInfo__c.fields.History_Switch__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.History_Switch__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.History_Switch__c.isAccessible()) 
                {
                    bInfo.History_Switch__c = this.historySwitch;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
                {
                    bInfo.LastRefreshedDate__c = system.today();
                }
                if (Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isAccessible()) 
                {
                    bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMapglobal);
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                    database.insert(bInfo); 
                }
            }
            else{
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()) 
                {
                    bInfo.Id = this.recordId;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.DataRepresentation__c.isAccessible()) 
                {
                    bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
                }
                if (Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isAccessible()) 
                {
                    bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMapglobal);
                }
                if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
                {
                    bInfo.LastRefreshedDate__c = system.today();
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
                
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                    database.update(bInfo);
                }
            }
        }
        else{
            list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT DataRepresentation__c, Dates__c, StartDate__c, EndDate__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, LastRefreshedDate__c,Businesshour__c,History_Switch__c FROM BatchInfo__c WHERE WillRefresh__c = TRUE AND Chart_Name__c = 'Average Field Value Time' ORDER BY LastRefreshedDate__c LIMIT 1]);
            System.debug('Bi :'+bi);
            if(bi != null && !bi.isEmpty()){
                if(bi[0].LastRefreshedDate__c != system.today()){
                    duplicateaveragebatch atbc = new duplicateaveragebatch(bi[0].SobjectFieldValue__c.Split(','),bi[0].SobjectFieldType__c,bi[0].SobjectType__c,bi[0].SobjectRecordType__c.Split(','),bi[0].Dates__c,bi[0].StartDate__c,bi[0].EndDate__c,bi[0].Id,bi[0].WillRefresh__c,bi[0].Businesshour__c,null,true,bi[0].History_Switch__c);
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
            if (Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.OwnerDataRepresentation__c.isAccessible()) 
            {
                bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMapglobal);
            }
            if (Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.LastRefreshedDate__c.isAccessible()) 
            {
                bInfo.LastRefreshedDate__c = system.today();
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
            if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
            {
                database.update(bInfo);
            }
        }
    }
}