public class CustomHistoryConfigurationController {
@AuraEnabled
    public static List<sObject> getAllObjectDetail(){
      List<sObject> sO = [SELECT QualifiedApiName FROM EntityDefinition order by QualifiedApiName LIMIT 10];
        system.debug('SO===>'+sO);
	  return sO;
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
}