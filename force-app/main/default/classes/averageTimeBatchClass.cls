public class averageTimeBatchClass implements Database.Batchable<sObject>, Database.Stateful {
    public map<string,decimal> pickValMap = new map<string,decimal>();
    public map<string,decimal> ownerTimeMap = new map<string,decimal>();
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
    public averageTimeBatchClass(list<String> fieldValues, String field, String objectVal, list<String> recordTypes, string dates, date startDate, date endDate, Id recordId, boolean willRefresh, string businessHour, String filterName, boolean scheduled) {
        this.field = field;
        this.objectVal = objectVal;
        this.dates = dates;
        this.startDate = startDate;
        this.endDate = endDate;
        this.recordId = recordId;
        this.scheduled = scheduled;
        this.willRefresh = willRefresh;
        this.businessHour = businessHour;
        this.filterName = filterName;
        this.fieldValues = string.join(fieldValues,', '); 
        this.recordTypes = string.join(recordTypes,', ');
        this.businessHourId = [Select Id From BusinessHours WHERE Name =: businessHour LIMIT 1][0].Id;
        for(string s : fieldValues){
            pickValMap.put(s,null);
        }
        string query;
        if(objectVal != null && Field != null){
            query = 'select id,createddate,owner.name,ownerid,' + Field + ',(select ' + objectVal +'id,NewValue,OldValue,createddate,DataType,Field from Histories order by CreatedDate) from ' + objectVal;
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
        this.query = query;
        system.debug('batch query ' + this.query);
    }
    public Database.QueryLocator start(Database.BatchableContext bc) {
        System.debug(Database.getQueryLocator(query));
        return Database.getQueryLocator(query);      
    }
    public void execute(Database.BatchableContext bc, List<sobject> records){
        for(sobject data : (list<sobject>)records){
            boolean firstTime = true;
            dateTime subtime;
            datetime recentRecTime;
            map<id,decimal> ownerChangeMap = new map<id,decimal>();
            set<string> ownerset = new set<string>();
            for(sobject data2 : (list<sobject>)data.getsObjects('histories')){
                decimal ownersubtime;
                dateTime dt;
                if(data2.get('Field') == 'Owner' && data2.get('DataType') == 'EntityId'){
                    ownersubtime = BusinessHours.diff(businessHourId,(dateTime)recentRecTime,(dateTime)data2.get('CreatedDate'));                        
                    ownersubtime = (ownersubtime/1000)/60;
                    if(!ownerChangeMap.containskey((ID)data2.get('OldValue'))){
                        ownerChangeMap.put((ID)data2.get('OldValue'),ownersubtime);
                    }
                    else{
                        ownerChangeMap.put((ID)data2.get('OldValue'),ownerChangeMap.get((ID)data2.get('OldValue'))+ownersubtime);    
                    }
                }
                if(data2.get('Field') == field){
                    if(firstTime){
                        dt = (dateTime)data2.get('CreatedDate');
                        subtime = dt;
                        dt = (dateTime)data.get('CreatedDate');
                        decimal timee = BusinessHours.diff(businessHourId,dt,subtime);
                        timee = (timee/1000)/60;
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                            for(string s : ownerChangeMap.keyset()){
                                ownerset.add(s+':'+(string)data2.get('OldValue'));
                                if(!ownerTimeMap.containskey(s+':'+(string)data2.get('OldValue'))){
                                    ownerTimeMap.put(s+':'+(string)data2.get('OldValue'),ownerChangeMap.get(s));
                                }
                                else{
                                    ownerTimeMap.put(s+':'+(string)data2.get('OldValue'),ownerTimeMap.get(s+':'+(string)data2.get('OldValue'))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'));
                            if(!ownerTimeMap.containsKey((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))){
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(dateTime)data2.get('CreatedDate'))/1000)/60);
                            }
                            else{
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),ownerTimeMap.get((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(dateTime)data2.get('CreatedDate'))/1000)/60);
                            }
                        }
                        else{
                            ownerset.add((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'));
                            if(!ownerTimeMap.containskey((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))){
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),timee);
                            }
                            else{
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),ownerTimeMap.get((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))+timee);
                            }
                        }
                        if (pickValMap.containsKey(string.valueOf(data2.get('OldValue')))){
                            if(pickValMap.get(string.valueOf(data2.get('OldValue'))) == null){
                                pickValMap.put(string.valueOf(data2.get('OldValue')),timee);
                            }
                            else{
                                pickValMap.put(string.valueOf(data2.get('OldValue')),pickValMap.get(string.valueOf(data2.get('OldValue')))+timee);
                            }
                        }
                    }
                    else{
                        dt = (dateTime)data2.get('CreatedDate');
                        decimal timee = BusinessHours.diff(businessHourId ,subtime,dt);
                        subtime = dt;
                        timee = (timee/1000)/60;
                        if(ownerChangeMap != null && !ownerChangeMap.isEmpty()){
                            for(string s : ownerChangeMap.keyset()){
                                ownerset.add(s+':'+(string)data2.get('OldValue'));
                                if(!ownerTimeMap.containskey(s+':'+(string)data2.get('OldValue'))){
                                    ownerTimeMap.put(s+':'+(string)data2.get('OldValue'),ownerChangeMap.get(s));
                                }
                                else{
                                    ownerTimeMap.put(s+':'+(string)data2.get('OldValue'),ownerTimeMap.get(s+':'+(string)data2.get('OldValue'))+ownerChangeMap.get(s));
                                }
                            }
                            ownerset.add((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'));
                            if(!ownerTimeMap.containskey((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))){
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),(BusinessHours.diff(businessHourId,recentRecTime,(dateTime)data2.get('CreatedDate'))/1000)/60);
                            }
                            else{
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),ownerTimeMap.get((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))+(BusinessHours.diff(businessHourId,recentRecTime,(dateTime)data2.get('CreatedDate'))/1000)/60);
                            }
                        }
                        else{
                            ownerset.add((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'));
                            if(!ownerTimeMap.containskey((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))){
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),timee);
                            }
                            else{
                                ownerTimeMap.put((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'),ownerTimeMap.get((string)data.get('OwnerId')+':'+(string)data2.get('OldValue'))+timee);
                            }
                        }
                        if (pickValMap.containsKey(string.valueOf(data2.get('OldValue')))){
                            if(pickValMap.get(string.valueOf(data2.get('OldValue'))) != null){
                                pickValMap.put(string.valueOf(data2.get('OldValue')),pickValMap.get(string.valueOf(data2.get('OldValue')))+timee);
                            }
                            else{
                                pickValMap.put(string.valueOf(data2.get('OldValue')),timee);
                            }
                        } 
                    }
                    firstTime = false;
                    ownerChangeMap.clear();
                }
                if(data2.get('Field') == 'Created' ||data2.get('Field') == field || (data2.get('Field') == 'Owner' && data2.get('DataType') == 'EntityId')){
                    recentRecTime = (datetime)data2.get('CreatedDate');
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
        recordsProcessed=recordsProcessed+records.size();
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
                pickValMap.put(s,null);
            else
                pickValMap.put(s,avg);
        }
        system.debug('recordsProcessed'+recordsProcessed);
        system.debug('pickValMap'+pickValMap);
        system.debug('ownerTimeMap = '+ownerTimeMap);
        for(string s : ownerTimeMap.keySet()){
            Decimal avg;
            if(ownerTimeMap.get(s)!=null){
                avg = ownerTimeMap.get(s)/recordcountperowner.get(s);
                avg = avg.setScale(2);
            }
            if(avg==null || avg==0.00)
                ownerTimeMap.put(s,null);
            else
                ownerTimeMap.put(s,avg);
        }
        system.debug('recordcountperowner = '+recordcountperowner);
        system.debug('ownerTimeMap = '+ownerTimeMap);
        if(this.scheduled == false){
            if(this.recordId == null){
                BatchInfo__c bInfo = new BatchInfo__c();
                bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
                bInfo.Dates__c = this.dates;
                bInfo.StartDate__c = this.startDate;
                bInfo.EndDate__c = this.endDate;
                bInfo.SobjectFieldType__c = this.field;
                bInfo.SobjectFieldValue__c = this.fieldValues;
                bInfo.SobjectRecordType__c = this.recordTypes;
                bInfo.SobjectType__c = this.objectVal;
                bInfo.WillRefresh__c = this.willRefresh;
                bInfo.Businesshour__c = this.businessHour;
                bInfo.Filter_Name__c = this.filterName;
                bInfo.LastRefreshedDate__c = system.today();
                bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMap);
                insert bInfo;
            }
            else{
                BatchInfo__c bInfo = new BatchInfo__c();
                bInfo.Id = this.recordId;
                bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
                bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMap);
                bInfo.LastRefreshedDate__c = system.today();
                if(this.willRefresh){
                    bInfo.WillRefresh__c = this.willRefresh;
                    bInfo.Filter_Name__c = this.filterName;
                }
                update bInfo;
            }
        }
        else{
            list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT DataRepresentation__c, Dates__c, StartDate__c, EndDate__c, SobjectFieldType__c, SobjectFieldValue__c, SobjectRecordType__c, SobjectType__c, WillRefresh__c, LastRefreshedDate__c,Businesshour__c FROM BatchInfo__c WHERE WillRefresh__c = TRUE AND Chart_Name__c = 'Average Field Value Time' ORDER BY LastRefreshedDate__c LIMIT 1]);
            System.debug('Bi :'+bi);
            if(bi != null && !bi.isEmpty()){
                if(bi[0].LastRefreshedDate__c != system.today()){
                    averageTimeBatchClass atbc = new averageTimeBatchClass(bi[0].SobjectFieldValue__c.Split(','),bi[0].SobjectFieldType__c,bi[0].SobjectType__c,bi[0].SobjectRecordType__c.Split(','),bi[0].Dates__c,bi[0].StartDate__c,bi[0].EndDate__c,bi[0].Id,bi[0].WillRefresh__c,bi[0].Businesshour__c,null,true);
                    database.executeBatch(atbc);
                }
            }
            BatchInfo__c bInfo = new BatchInfo__c();
            bInfo.Id = this.recordId;
            bInfo.DataRepresentation__c = JSON.serialize(pickValMap);
            bInfo.OwnerDataRepresentation__c = JSON.serialize(ownerTimeMap);
            bInfo.LastRefreshedDate__c = system.today();
            update bInfo;
        }
    }
}