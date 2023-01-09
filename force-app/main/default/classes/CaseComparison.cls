public  with sharing  class CaseComparison {
    @AuraEnabled
    public static List<Case> getAllCaseRelatedToCaseOwner(String ownerName){
        List<Case> caseList =[SELECT id,CaseNumber,Account.Name,Contact.Name,Type, Status, Reason, Origin, Priority, Subject, IsClosed, SLAViolation__c, EngineeringReqNumber__c,ContactEmail, ContactFax, ContactMobile from case where Owner.Name=:ownerName];
        system.debug('CaseList==>'+caseList);
        return caseList;
    }
     @AuraEnabled(cacheable=true)
    public static Map<String,Map<String,Decimal>> getAllCases(String ownerName){
        Map<String,Decimal> ownerDetailMap = new Map<String,Decimal>();
        Map<String,Map<String,Decimal>> ownerData = new Map<String,Map<String,Decimal>>();
        ownerDetailMap.put('New',4.0);
        ownerDetailMap.put('Esclated',8.0);
        ownerDetailMap.put('closed',6.0);
        ownerData.put(ownerName,ownerDetailMap);
        return ownerData;
    }
    @AuraEnabled(cacheable=true)
    public static List<String> getAllUser(){
        List<case> caseList =[SELECT id,OwnerId,Owner.Name from Case];
        List<String> UserName=new List<String>();
        
        for(Integer i=0;i<caseList.size();i++){
            if(caseList.size()!=(i+1)){
                if(caseList[i].Owner.Id!=caseList[i+1].Owner.Id){
                    system.debug('CaseList==>'+caseList[i].Owner.name);
                    UserName.add(caseList[i].Owner.Name);
                }
            }
        }
        return UserName;
    }
}