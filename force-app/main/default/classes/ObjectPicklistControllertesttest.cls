@istest
public class ObjectPicklistControllertesttest
{
    @testsetup
    
        public static void ObjectPicklistControllertesttest1()
        {
    /*BusinessHours newHours = new BusinessHours(
        
    MondayStartTime = Time.newInstance(9, 0, 0, 0),
    MondayEndTime = Time.newInstance(17, 0, 0, 0),
    TuesdayStartTime = Time.newInstance(9, 0, 0, 0),
    TuesdayEndTime = Time.newInstance(17, 0, 0, 0),
    WednesdayStartTime = Time.newInstance(9, 0, 0, 0),
    WednesdayEndTime = Time.newInstance(17, 0, 0, 0),
    ThursdayStartTime = Time.newInstance(9, 0, 0, 0),
    ThursdayEndTime = Time.newInstance(17, 0, 0, 0),
    FridayStartTime = Time.newInstance(9, 0, 0, 0),
    FridayEndTime = Time.newInstance(17, 0, 0, 0),
    IsActive = true,
    IsDefault = true);
            
    insert newHours;*/
    
    }
    
    @istest
    public static void ObjectPicklistControllertesttest2()
    {
	    id BusinessHourid =[select id from BusinessHours where name = 'India' Limit 1][0].id;
        ObjectPicklistController.getPicklistFields('Case');
        ObjectPicklistController.picklistValues('Case','Status');
        ObjectPicklistController.getRecordType('Case');
        ObjectPicklistController.getBusinessHours();
        ObjectPicklistController.getTimeZoneId('India');
        //ObjectPicklistController.getTimeZoneId('96');
        ObjectPicklistController.setBusinessId(BusinessHourid);
        ObjectPicklistController.errorCollector('Error', 'picklistValues');
        ObjectPicklistController.getHourVal();

         
    }

}