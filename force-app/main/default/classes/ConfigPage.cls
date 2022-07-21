public class ConfigPage
{
    @AuraEnabled
    public static void metadatasaved(String CaseHistoryObjectText, String Objectval, string fieldval,string Businesval) 
    {
        System.debug('CaseHistoryObjectText = '+CaseHistoryObjectText); //case
        System.debug('Objectval = '+Objectval);  //case
        System.debug('Businesval = '+fieldval); //status
        System.debug('Businesval = '+Businesval);// default
        Boolean isMetadataUpdateNeeded = false;
        List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt where Masterlabel='HistoryObject' limit 1];
        List<Track2Grow__mdt> listTrack2GrowRecoedVal = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt where Masterlabel='RecordVal' limit 1];
        Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
        if(!listTrack2Grow.isEmpty() && CaseHistoryObjectText!=null)
        {
            
            Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
            metadataRec.fullName = 'Track2Grow__mdt.RecordVal';
            metadataRec.label = listTrack2Grow[0].MasterLabel; //Please change all the [0] to either map or set
            Metadata.CustomMetadataValue totalPurchasetoUpdate = new Metadata.CustomMetadataValue();
            totalPurchasetoUpdate.field = 'HistoryObject__c';
            totalPurchasetoUpdate.value = CaseHistoryObjectText;
            metadataRec.values.add(totalPurchasetoUpdate);
            mdContainer.addMetadata(metadataRec);
            isMetadataUpdateNeeded = true; 
        }
        if(!listTrack2GrowRecoedVal.isEmpty() && Objectval!=null && fieldval!=null && Businesval!=null)
        {
            Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
            metadataRec.fullName = 'Track2Grow__mdt.HistoryObject';
            metadataRec.label = listTrack2GrowRecoedVal[0].MasterLabel; //Please change all the [0] to either map or set
            Metadata.CustomMetadataValue totalPurchasetoUpdate = new Metadata.CustomMetadataValue();
            totalPurchasetoUpdate.field = 'Object_Name__c';
            totalPurchasetoUpdate.value = Objectval;
            totalPurchasetoUpdate.field = 'FieldVal__c';
            totalPurchasetoUpdate.value = fieldval;
            totalPurchasetoUpdate.field = 'Business_Hour__c';
            totalPurchasetoUpdate.value = Businesval;
            metadataRec.values.add(totalPurchasetoUpdate);
            mdContainer.addMetadata(metadataRec);
            isMetadataUpdateNeeded = true;    
        }
        
        if(isMetadataUpdateNeeded)
        {
           Metadata.Operations.enqueueDeployment(mdContainer, null);
        }
    }   
}