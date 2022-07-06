public with sharing class ObjectPicklistController
{
    @AuraEnabled
    public static List<String> getPicklistFields(String sobjectValue) 
    {
        System.debug('sobjectValue > ' + sobjectValue);
        List<String> listobjvalues=new List<String>();
        sObjectType objType1 = Schema.getGlobalDescribe().get(sobjectValue);
        Map<String,Schema.SObjectField> mfields = objType1.getDescribe().fields.getMap();
        System.debug(label.Tracking_Analytics_Admin_Setting);
        for(String key : mfields.keySet())
        {
            String sobjectname = sobjectValue; //object api name
            String fieldapiName = key; //Field api name
            String fieldTypeName = Schema.getGlobalDescribe().get(sobjectname).getDescribe().fields.getMap().get(fieldApiName).getDescribe().getType().name().toupperCase(); 
            if(fieldTypeName=='Picklist')
            {
                listobjvalues.add(key);
                System.debug('<--- fieldTypeName = ' + key);  //field type came
            }
        }
        System.debug('listobjvalues > ' + listobjvalues);
        return listobjvalues;
    }
    
    @AuraEnabled
    public static String[] picklistValues(String objectName, String fieldName) 
    {   
        System.debug('objectName > ' + objectName);
        String[] values = new String[]{};
            if(objectName <> null){
                List<TrackingAnalytics__c> listTrack = [SELECT Id, Selected_Values__c FROM TrackingAnalytics__c WHERE Name=:objectName+'-'+fieldName];   
                String[] types = new String[]{objectName};
                Schema.DescribeSobjectResult[] results = Schema.describeSObjects(types);
                for(Schema.DescribeSobjectResult res : results) 
                {
                    for (Schema.PicklistEntry entry : res.fields.getMap().get(fieldName).getDescribe().getPicklistValues()) 
                    {
                        if (entry.isActive()) {values.add(entry.getValue());}
                    }
                }
                System.debug(values);
            }
        return values;
    }

    @AuraEnabled
    public static List<String> getRecordType(String objectName)
    {
        system.debug('---'+objectName);
        List<String> strRecord = new list<String>();
        List <Sobject> strRecord1 =[SELECT name FROM RecordType where SobjectType=:objectName];
        for(Sobject r:strRecord1)
        { 
            System.debug('r ---'+r.get('Name'));
            strRecord.add(String.valueOf(r.get('Name')));
        }
        system.debug('values in List ---'+strRecord);
        return strRecord;
    }

    @AuraEnabled
    public static List <BusinessHours> getBusinessHours() 
    {
        return [SELECT Id,Name,IsDefault FROM BusinessHours LIMIT 50000];
    }

    @AuraEnabled
    public static List <String> getTimeZoneId(String name)
    {
        try {
            List<Id> allOpts = new list<Id>();
            List<BusinessHours> businessHrs=[SELECT Id,Name FROM BusinessHours WHERE Name=:name];
            for(BusinessHours bhrs:businessHrs)
            {
                allOpts.add(bhrs.Id);
            }
            system.debug('allOpts > ' + allOpts);
            return allOpts;
        } catch (Exception ex) {
            String str = ex.getMessage() +'\nline Number  :'+ex.getLineNumber();
            ErrorCollector(str,'getTimeZoneId()');
            throw new AuraHandledException('Error > ' + ex.getMessage() + 'at line ' + ex.getLineNumber());
        }
    }
    
    @AuraEnabled
    public static void setBusinessId(String busId)
    {
        TrackingToolUtil.IdFromCaseHelper(busId);
    }

    @AuraEnabled
    public static string errorCollector(String errorDetail, String functionName){
        try {
            ErrorLogsForCTT__c err=new ErrorLogsForCTT__c();
            if (Schema.sObjectType.ErrorLogsForCTT__c.fields.Name.isUpdateable() && Schema.sObjectType.ErrorLogsForCTT__c.fields.Name.isCreateable() && Schema.sObjectType.ErrorLogsForCTT__c.fields.Name.isAccessible()) 
            {
                err.Name=datetime.now()+''+functionName;
            }
            if (Schema.sObjectType.ErrorLogsForCTT__c.fields.FunctionName__c.isUpdateable() && Schema.sObjectType.ErrorLogsForCTT__c.fields.FunctionName__c.isCreateable() && Schema.sObjectType.ErrorLogsForCTT__c.fields.FunctionName__c.isAccessible()) 
            {
                err.FunctionName__c='Function Name'+functionName+'\n'+'Error Detail'+errorDetail;
            }
            if(Schema.sObjectType.ErrorLogsForCTT__c.isAccessible()  && Schema.sObjectType.ErrorLogsForCTT__c.isCreateable())
            {
                insert err;
            }
            return '';
        } catch (Exception ex) {
            String str = ex.getMessage() +'\nline Number  :'+ex.getLineNumber();
            errorCollector(str,'errorCollector()');
            throw new AuraHandledException(ex.getMessage());
        }
    }
    
    @AuraEnabled
    public static List<BusinessHours> getHourVal(){
        List<BusinessHours> businessStr =[SELECT name FROM BusinessHours];
        System.debug('Business ='+businessStr);
        return businessStr;
    }
}