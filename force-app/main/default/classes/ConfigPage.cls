public class ConfigPage
{
//     @AuraEnabled
//     public static void metadatasaved(String CaseHistoryObjectText, list<visitorList> recordlevelwrapper,string switchhistory) 
//     {
//         Boolean isMetadataUpdateNeeded = false;
//         List<Track2Grow__mdt> listTrack2Grow = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt where Masterlabel='HistoryObject' limit 1];
//         List<Track2Grow__mdt> listTrack2GrowRecoedVal = [SELECT Id,Masterlabel,Business_Hour__c,FieldVal__c,Object_Name__c,HistoryObject__c from Track2Grow__mdt where Masterlabel='RecordVal' limit 1];
//         Metadata.DeployContainer mdContainer = new Metadata.DeployContainer();
//         if(!listTrack2Grow.isEmpty() && CaseHistoryObjectText!=null)
//         {
            
//             Metadata.CustomMetadata metadataRec =  new Metadata.CustomMetadata();
//             metadataRec.fullName = 'Track2Grow__mdt.RecordVal';
//             metadataRec.label = listTrack2Grow[0].MasterLabel; //Please change all the [0] to either map or set
//             Metadata.CustomMetadataValue totalPurchasetoUpdate = new Metadata.CustomMetadataValue();
//             totalPurchasetoUpdate.field = 'HistoryObject__c';
//             totalPurchasetoUpdate.value = CaseHistoryObjectText;
//             metadataRec.values.add(totalPurchasetoUpdate);
//             mdContainer.addMetadata(metadataRec);
//             isMetadataUpdateNeeded = true; 
//         }
//         if(recordlevelwrapper!=null)
//         {
//             for(visitorList listofwraper:recordlevelwrapper) 
//             {
//                 Metadata.CustomMetadata customMetadata = new Metadata.CustomMetadata();
//                 system.debug('value of wrapper'+listofwraper); 
//                 customMetadata.fullName ='Track2Grow__mdt.'+listofwraper.name+listofwraper.company; 
//                 customMetadata.label =listofwraper.name+listofwraper.company;
                
//                 Metadata.CustomMetadataValue customField = new Metadata.CustomMetadataValue();
//                 customField.field = 'Object_Name__c';
//                 customField.value = listofwraper.name;
//                 customMetadata.values.add(customField);
//                 Metadata.CustomMetadataValue customField1 = new Metadata.CustomMetadataValue();
//                 customField1.field = 'FieldVal__c';
//                 customField1.value = listofwraper.company;
//                 customMetadata.values.add(customField1);
//                 Metadata.CustomMetadataValue customField2 = new Metadata.CustomMetadataValue();
//                 customField2.field = 'Business_Hour__c';
//                 customField2.value = listofwraper.email;
//                 customMetadata.values.add(customField2);
//                 mdContainer.addMetadata(customMetadata);
//                 isMetadataUpdateNeeded = true; 
//             }
//         }
        
//         if(isMetadataUpdateNeeded)
//         {
//             Metadata.Operations.enqueueDeployment(mdContainer, null);
//         }
//     }
//     public class visitorList{
//         @AuraEnabled public String name {get; set;}
//         @AuraEnabled public String company {get; set;}
//         @AuraEnabled public String email {get;set;}
        
//     }   
}