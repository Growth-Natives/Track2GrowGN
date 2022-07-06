public class averagetimechartcontroller {
    @AuraEnabled
    public static ID retriveAccs(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        System.debug('retriveAccs');
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty()){
            recordId = bi[0].Id;
            if(bi[0].LastRefreshedDate__c == null || bi[0].LastRefreshedDate__c != system.today()){
                system.debug('BATCH EXECUTED'); 
                averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false);
                batchJobId=database.executeBatch(atbc);
            }
            else{
                system.debug('BATCH NOT EXECUTED');
                BatchInfo__c bInfo = new BatchInfo__c();
                bInfo.Id = recordId;
                bInfo.willRefresh__c = willRefresh;
                bInfo.Filter_Name__c = filterName;
                update bInfo;
            }
        }
        else{
            system.debug('BATCH EXECUTED');
            averageTimeBatchClass atbc = new averageTimeBatchClass(fieldValues,Field,objectVal,recordTypes,dates,startDate,endDate,recordId,willRefresh,businessHour,filterName,false);
            batchJobId=database.executeBatch(atbc);
        }
        return batchJobId;        
    }
    
    @AuraEnabled
    public static String retriveFilter(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        system.debug('Filter Name'+filterName);
        string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        Id recordId;
        Id batchJobId;
        String errorName;
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,dataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectFieldValue__c =: fieldVal AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        if(bi != null && !bi.isEmpty()){
            recordId = bi[0].Id;            
            if(bi[0].willRefresh__c == true){
                if(bi[0].Filter_Name__c!=filterName){
                    errorName = 'Filter already exists as a '+bi[0].Filter_Name__c;
                }
            }
            for(BatchInfo__c b : [SELECT id, Filter_Name__c, willRefresh__c FROM BatchInfo__c WHERE willRefresh__c = true]){
                if(b.Filter_Name__c == filterName){
                    errorName = 'Filter name already exists';
                }
            }
        }
        return errorName;
    }
    
    @AuraEnabled
    public static AsyncApexJob getBatchJobStatus(Id jobID){
        AsyncApexJob jobInfo = [SELECT Status FROM AsyncApexJob WHERE Id = :jobID];
        return jobInfo;
    }
    
    // case owner work
    @AuraEnabled
    public static void getcaseowner(String objectVal, String Field,list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) 
    {
        System.debug('objectVal = '+objectVal);
        System.debug('Field = '+Field);
        System.debug('recordTypes = '+recordTypes);
        System.debug('businessHour = '+businessHour);
        System.debug('endDate = '+endDate);
        System.debug('dates = '+dates);
        System.debug('startDate = '+startDate);
        System.debug('willRefresh = '+willRefresh);
        System.debug('filterName = '+filterName);
    }
    
    
    @AuraEnabled
    public static map<string,double> mapvalue(String objectVal, String Field,list<String> fieldValues, list<String> recordTypes, String businessHour, string dates, date startDate, date endDate, boolean willRefresh, string filterName) {
        string dataRepresentation; 
        // DateTime start = System.Now();
        system.debug('>>>>>in');
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
        else{
            ctendays = [select id, DataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
            
        }        
        string inputdata; //= '[{"Closed":null,"OnHold":null,"Escalated":1.0,"InProgress":0.5,"New":34499.5}]';
        map<string,double> valuestorepickliststage= new map<string,double>();
        if(dataRepresentation == null){
            inputdata = '['+ctendays[0].DataRepresentation__c+']'; 
        }
        else{
            system.debug('dataRepresentation'+dataRepresentation);
            inputdata = '['+dataRepresentation+']';
        }
        system.debug('ddfffff' +inputdata);
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        system.debug('>>>>>>>>>'+result);
        for(Object obj : result) { 
            Map<String,Object> map1 = (Map<String,Object>)obj; 
            for(String key : map1.keyset()) {
                valuestorepickliststage.put(key,(decimal)map1.get(key));
                System.debug('Key -->> ' + key); 
                System.debug('Value -->> ' + (decimal)map1.get(key)); 
            }
        }
        system.debug('value  of  mapp>>>>>'+valuestorepickliststage);
        return valuestorepickliststage;
    }
    
    //fetch picklist values from custom object in lwc
    @AuraEnabled(cacheable=true)
    public static List < customValueWrapper > pickListValueDynamically(sObject customObjInfo, string selectPicklistApi) 
    {
        system.debug('customObjInfo' +customObjInfo);
        system.debug('selectPicklistApi' +selectPicklistApi);
        Schema.DescribeSObjectResult objDescribe = customObjInfo.getSObjectType().getDescribe();   
        map < String, Schema.SObjectField > customFieldMap = objDescribe.fields.getMap();      
        list < Schema.PicklistEntry > custPickValues = customFieldMap.get(selectPicklistApi).getDescribe().getPickListValues();
        list < customValueWrapper > customObjWrapper = new list < customValueWrapper > ();
        for (Schema.PicklistEntry myCustPick: custPickValues) 
        {
            customValueWrapper selectOptionValueWrapper = new customValueWrapper();
            selectOptionValueWrapper.custFldlabel = myCustPick.getLabel();
            selectOptionValueWrapper.custFldvalue = myCustPick.getValue();
            system.debug('objDescribe' +selectOptionValueWrapper.custFldvalue);
            customObjWrapper.add(selectOptionValueWrapper);
        }
        system.debug('customObjWrapperdddddddd' +customObjWrapper);
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
         List<DataSet> dataSet = new List<DataSet>();
        system.debug('sssssssssssssssssssssssssssssssssssssssssssssss');
        String status_val = status;
        system.debug(status_val);
        System.debug('objectVal = '+objectVal);
        string dataRepresentation; 
        //string fieldVal = string.join(fieldValues,', '); 
        string recordType = string.join(recordTypes,', ');
        list<BatchInfo__c> ctendays = new list<BatchInfo__c>();
        list<BatchInfo__c> bi = new list<BatchInfo__c>([SELECT Id,OwnerDataRepresentation__c,LastRefreshedDate__c,willRefresh__c,Filter_Name__c From BatchInfo__c where Businesshour__c =:businessHour and Dates__c =: dates AND EndDate__c =: endDate AND StartDate__c =: startDate AND SobjectFieldType__c =: Field AND SobjectRecordType__c =: recordType AND SobjectType__c =: objectVal LIMIT 1]);
        system.debug('value of list>>'+bi);
        if(bi != null && !bi.isEmpty())
        {
            //if(bi[0].LastRefreshedDate__c == system.today())
            //{
            dataRepresentation = bi[0].OwnerDataRepresentation__c;    
            //}
            
        }
        else{
            ctendays = [select id, OwnerDataRepresentation__c from BatchInfo__c order by createddate desc limit 1];
            
        }        
        string inputdata; //= '[{"Closed":null,"OnHold":null,"Escalated":1.0,"InProgress":0.5,"New":34499.5}]';
        map<string,double> valuestorepickliststage= new map<string,double>();
        if(dataRepresentation == null){
            inputdata = '['+ctendays[0].OwnerDataRepresentation__c+']'; 
        }
        else{
            system.debug('dataRepresentation'+dataRepresentation);
            inputdata = '['+dataRepresentation+']';
        }
        system.debug('ddfffff' +inputdata);
        List<Object> result = (List<Object>)JSON.deserializeUntyped(inputdata); 
        system.debug('value offf >>>>>>>>>><<<<><<<><><><'+result);
        string ss;
        // string fieldVal = string.join(fieldValues,', '); 
        //List<String> res = result.split(',');
       
        for(object sst: result)
        {
            ss=String.valueof(sst);
            ss = ss.replace('{','');
            ss = ss.replace('}','');
        }
        List<String> res = ss.split(',');
        for(string sst: res)
        {
            system.debug('value offf sst >>>>>>>>>><<<<><<<><><><'+sst);
            if(sst.contains(status_val))
            {
              String statuss =':'+status_val+'=';
               list<string> finalResult = sst.split(statuss);
                system.debug('finalResult>>>>'+finalResult);
                 String statuss1 = finalResult[0];
                decimal total = decimal.valueof(finalResult[1]);
                 dataSet.add(new DataSet(statuss1 ,total));
                
              
            //Integer total = (Integer)ar.get('leadCount');  
            }
        }
        System.debug('dataSet'+dataSet);
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