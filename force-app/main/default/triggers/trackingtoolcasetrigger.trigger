trigger trackingtoolcasetrigger on case(after insert,after update)
{
    if(Trigger.isAfter)
    {
        if(Trigger.isInsert)
        { 
            TrackingToolUtil.onAfterInsert(Trigger.New,Trigger.NewMap);
        } 
        if(Trigger.isUpdate)
        {
            TrackingToolUtil.onAfterUpdate(Trigger.New,Trigger.NewMap,Trigger.old,Trigger.oldMap);
        }
    }
}