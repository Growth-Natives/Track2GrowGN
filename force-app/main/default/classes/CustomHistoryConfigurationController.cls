public class CustomHistoryConfigurationController {
    @AuraEnabled
    public static List<sObject> getAllObjectDetail(string alphaa){
        System.debug('Alpha==='+alphaa);
        string str = alphaa+'%';
        System.debug('str==='+str);
        List<sObject> sO = [SELECT QualifiedApiName FROM EntityDefinition where QualifiedApiName LIKE:str];
        system.debug('SO===>'+sO);
        return sO;
    }
    @AuraEnabled
    public static Map<String,List<String>> getSelectedFieldName(List<string> objList){
        Map<String,List<String>> fieldObjMap = new  Map<String,List<String>>();
        map<string,object> obb= new map<string,object>();
        List<Config_Rec__c> crLi;
        if(objList.size()>0){    
            for(String str:objList){
                for(Config_Rec__c cr: [select id, Name, Obj_Name__c, Selected_Fields__c from Config_Rec__c where Obj_Name__c=:objList]){
                    List<String> strLi=new List<String>();
                    if(str==cr.Obj_Name__c){ 
                        //List<String> strList = ;
                        if(cr.Selected_Fields__c!=null||cr.Selected_Fields__c!='undefined'){
                            for(Integer i=0;i<cr.Selected_Fields__c.split(', ').size();i++){
                                //obb.put(cr.Selected_Fields__c.split(',')[0],cr.Selected_Fields__c.split(',')[1]);
                                strLi.add(cr.Selected_Fields__c.split(', ')[i]);
                            }
                        }
                        fieldObjMap.put(str,strLi);
                    }
                }
            }
        }
        system.debug('fieldObjMap===>'+fieldObjMap);
        return fieldObjMap;
    }
    @AuraEnabled
    public static Map<String,List<String>> getAllFieldName(List<string> objList){
        Map<String,List<String>> fieldObjMap = new  Map<String,List<String>>();
        if(objList.size()>0){    
            List<String> field =new List<String>();
            for(String str:objList){
                field=new List<String>();
                for(FieldDefinition fl: [select QualifiedApiName from FieldDefinition where EntityDefinition.QualifiedApiName =: str]){
                    field.add(fl.QualifiedApiName);
                }
                fieldObjMap.put(str,field);
            }
            
        }
        system.debug('fieldObjMap===>'+fieldObjMap);
        return fieldObjMap;
    }
    @AuraEnabled
    public static string  saveObjects(String objFieldArr){
        system.debug('arr==>'+objFieldarr);
        List<Config_Rec__c> crLi = new List<Config_Rec__c>();
        List <Config_Rec__c> confRecList = new List<Config_Rec__c>();
        JSONParser parser = JSON.createParser(objFieldArr);
        list<OLIJSON> detail= new list<OLIJSON>();
        while (parser.nextToken() != null) {
            if(parser.getCurrentToken()==JSONToken.START_OBJECT){ 
                System.debug('<<<<< Entered in JSON Parse >>>>>');
                OLIJSON oppItem1  =(OLIJSON)parser.readValueAs(OLIJSON.class);
                detail.add(oppItem1);
            }
        }
        System.debug('<<<<< Entered in JSON Parse detail >>>>>'+detail);
        for(OLIJSON ol:detail){
            system.debug('ol.key=='+ol.key);
            String fieldVal = String.join(ol.val,', '); 
            Config_Rec__c crObj = new Config_Rec__c();
            crLi = [select id, Name, Obj_Name__c, Selected_Fields__c from Config_Rec__c where Obj_Name__c=:ol.key];
            if(crLi.size()>0){
                crObj.Id = crLi[0].id;
                crObj.Obj_Name__c = ol.key;
                crObj.Selected_Fields__c = fieldVal;
                confRecList.add(crObj);
            }
            else{
                crObj.Obj_Name__c = ol.key;
                crObj.Selected_Fields__c =fieldVal;
                confRecList.add(crObj);
            }
        }
        system.debug('Insert in configRec====>'+confRecList);
        upsert confRecList;
        /*for(Config_Rec__c li:select id, Name, Obj_Name__c, Selected_Fields__c from Config_Rec__c){

}*/
        return 'save';
    }
}