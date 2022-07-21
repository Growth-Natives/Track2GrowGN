public with sharing class averagetimechartcontrollerDuplicate 
{
    @AuraEnabled
    public static ID retriveAccs(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName,boolean historySwitch) {
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            recordId = bi[0].Id;
            if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today()){
                duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false,historySwitch);
                batchJobId=database.executeBatch(atbc);
            }
            else{
                BatchInfo__c bInfo = new BatchInfo__c();
                if (Schema.sObjectType.BatchInfo__c.fields.Id.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Id.isAccessible()) 
                {
                    bInfo.Id = recordId;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.willRefresh__c.isAccessible()) 
                {
                    bInfo.willRefresh__c = willRefresh;
                }
                if (Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isUpdateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isCreateable() && Schema.sObjectType.BatchInfo__c.fields.Filter_Name__c.isAccessible()) 
                {
                    bInfo.Filter_Name__c = filterName;
                }
                if(bInfo!=null && Schema.sObjectType.BatchInfo__c.isAccessible()  && Schema.sObjectType.BatchInfo__c.isCreateable() && Schema.sObjectType.BatchInfo__c.isCreateable())
                {
                     database.update(bInfo);
                }
            }
        }
        else
        {
            duplicateaveragebatch atbc = new duplicateaveragebatch(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false,historySwitch);
            batchJobId=database.executeBatch(atbc);
        }
        return batchJobId;        
    }
    
    @AuraEnabled
    public static String retriveFilter(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        System.debug('fieldVal ='+fieldVal);
        System.debug('fieldValues = '+fieldValues);
        System.debug('recordType ='+recordType);
        System.debug('businessHour = '+businessHour);
        System.debug('dates = '+dates);
        System.debug('field = '+Field);
        System.debug('objectVal = '+objectVal);
        //System.debug('dates = '+dates);
        System.debug('filterName='+filterName);
        
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal and StartDate__c =:startDate and EndDate__c =:endDate LIMIT 1]);
        System.debug('bi ='+bi);
        /*BatchInfo__c BIc = new BatchInfo__c();
        for(bi.SobjectFieldValue__c sofv:fieldVal){
            
        }*/
        if(bi != null && !bi.isEmpty()){
            recordId = bi[0].Id;  
            System.debug('Record Id ='+recordId);
            if(bi[0].willRefresh__c == true)
            {
                if(bi[0].Filter_Name__c!=filterName)
                {
                    errorName = 'Filter already exists as a '+bi[0].Filter_Name__c;
                }
            }
          }
        for(BatchInfo__c b : [SELECT id, Filter_Name__c, willRefresh__c FROM BatchInfo__c WHERE willRefresh__c = true])
			{
                 System.debug('b ='+b);
                if(b.Filter_Name__c == filterName)
                {
                    errorName = 'Filter name already exists';
                }
            }
        System.debug('errorName='+errorName);
        return errorName;
    }
    
    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        //System.debug('jobID = '+jobId);
        AsyncApexJob jobInfo = [SELECT Status FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
    
    @AuraEnabled
    public static void getcaseowner(String objectVal, String Field,list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) 
    {
        //System.debug('objectVal = '+objectVal);
        //System.debug('Field = '+Field);
        //System.debug('recordTypes = '+recordTypes);
        //System.debug('businessHour = '+businessHour);
        //System.debug('endDate = '+endDate);
        //System.debug('dates = '+dates);
        //System.debug('startDate = '+startDate);
        //System.debug('willRefresh = '+willRefresh);
        //System.debug('filterName = '+filterName);
    }
    
    
    @AuraEnabled
    public static map<string,double> mapvalue(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        string dataRepresentation; 
        // DateTime start = System.Now();
        //system.debug('>>>>>in');
        //system.debug('value of biRec'+biRec);
        //while(System.Now().getTime()< start.getTime()+3000){}
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        list<BatchInfo__c> ctendays = new list<BatchInfo__c>();
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty())
        {
            //if(bi[0].LastRefreshedDate__c == system.today())
            //{
            dataRepresentation = bi[0].dataRepresentation__c;    
            //}
            
        }
        else
        {
            ctendays = [select id, DataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
            
        }        
        string inputdata;  
        map<string,double> valuestorepickliststage= new map<string,double>();
        if(dataRepresentation == null){
            inputdata = '['+ctendays[0].DataRepresentation__c+']'; 
        }
        else
        {
             inputdata = '['+dataRepresentation+']';
        }
         List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
         for(Object obj : result) 
        { 
            Map<String,Object> map1 = (Map<String,Object>)obj;
            if(map1!=null)
            {
                for(String key : map1.keyset()) 
                {
                    valuestorepickliststage.put(key,(decimal)map1.get(key));
                  }
            }
        }
          return valuestorepickliststage;
    }
    
    //fetch picklist values from custom object in lwc
    @AuraEnabled(cacheable=true)
    public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) 
    {
          Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();   
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) 
        {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
             customObjWrapper.add(selectOptionValueWrapper);
        }
        return customObjWrapper;
    }
    // wrapper class 
    public with sharing class customValueWrapper 
    {
        @auraEnabled public string custFldlabel {get;set;}
        @auraEnabled public string custFldvalue {get;set;}
    }
    // get owner information
    @AuraEnabled(cacheable = true)
    public static List<DataSet> getLeadByStatus(String status,String objectVal, String Field, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName)
    {
        map<string,string> usermap = new map<string,string>();
        
        List<DataSet> dataSet = new List<DataSet>();
        String status_val = status;
        string dataRepresentation;
        string recordType = string.join(recordTypes,', ');
        list<BatchInfo__c> ctendays = new list<BatchInfo__c>();
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        map<string,map<string,decimal>> ownertostagetotime=new map<string,map<string,decimal>>();
        if(bi != null && !bi.isEmpty())
        {
            
            dataRepresentation = bi[0].OwnerDataRepresentation__c;
            
        }
        else
        {
            ctendays = [select id, OwnerDataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
        }
        string inputdata;  
        map<string,double> valuestorepickliststage= new map<string,double>();
        if(dataRepresentation == null)
        {
            inputdata = '['+ctendays[0].OwnerDataRepresentation__c+']';
        }
        else
        {
            inputdata = '['+dataRepresentation+']';
        }
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata);
        string ss;
        for(object sst: result)
        {
           // ss=String.valueof(sst);
           // ss = ss.replace('{','');
            //ss = ss.replace('}','');
            
            Map<string,object> data=(Map<string,object>)sst;
            for(string ownerstage:data.keySet()){
                list<string> ownerstagearray=ownerstage.split(':');
                if(ownertostagetotime.containsKey(ownerstagearray[1])){
                    ownertostagetotime.get(ownerstagearray[1]).put(ownerstagearray[0],decimal.valueOf(string.valueOf(data.get(ownerstage))));
                }
                else{
                    ownertostagetotime.put(ownerstagearray[1], new map<string,decimal>{ownerstagearray[0]=>decimal.valueOf(string.valueOf(data.get(ownerstage)))}) ;
                }
            }
        }
       // List<String> res = ss.split(',');
        set<id> ownerid;
         if(ownertostagetotime.containskey(status_val))
        {
             for(CustomUser__c u:[Select id,Name from CustomUser__c where id IN:ownertostagetotime.get(status_val).keySet()])
            {
                usermap.put(u.id,u.Name);
            }
        }
         if(ownertostagetotime.containskey(status_val))
        {
             for(string owneriddata:ownertostagetotime.get(status_val).keySet()){
                dataSet.add(new DataSet(usermap.get(owneriddata) ,ownertostagetotime.get(status_val).get(owneriddata)));
            }
         }
        return dataSet ;
    }
    public class DataSet
    {
        public DataSet(String label ,decimal count)
        {
            this.label = label ;
            this.count = count ;
        }
        @AuraEnabled
        public String label {get;set;}
        @AuraEnabled
        public decimal count {get;set;}
    }
}