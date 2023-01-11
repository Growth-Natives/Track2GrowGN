public class SAPOrdersSchedule {
    @AuraEnabled
    public static void scheduleClass(String jobName,List<String> weekday,String startDate,String endDate,String preferredTime){
        date start = Date.valueOf(startDate);
        date endD = Date.valueOf(endDate);
        system.debug('startDate===>'+start.month());
        String week='';
        if(weekday.size()>0){
            system.debug('schedule week');
            for(Integer i=0;i<weekday.size();i++){
                system.debug('Week = '+weekday[i]);
                week+= weekday[i]+',';
            }
        }
        
        week = week.removeEnd(',');
        system.debug('Week = '+week);
        //ScheduleBatchClass p = new ScheduleBatchClass();
        String sch = '';
        //0 0 0 22 1-2 2016 // 22nd Jan 2016 to 22nd Feb 2016
        if(start.day()==endD.day()&&start.month()!=endD.month()&&start.year()!=endD.year()){
            sch = '0 0 ' + preferredTime+' '+start.day()+' '+start.month()+'-'+endD.month()+' '+ + week +' '+start.year()+'-'+endD.year();
        }
        else if(start.month()==endD.month()&&start.day()!=endD.day()&&start.year()!=endD.year()){
            sch = '0 0 ' + preferredTime+' '+start.day()+'-'+endD.day()+' '+start.month()+' '+ week +' '+start.year()+'-'+endD.year();
        }
        else if(start.year()==endD.year()&&start.day()!=endD.day()&&start.month()!=endD.month()){
                sch = '0 0 ' + preferredTime+' '+start.day()+'-'+endD.day()+' '+start.month()+'-'+endD.month()+' '+ week +' '+start.year();
            }
        else{
            sch = '0 0 ' + preferredTime+' '+start.day()+'-'+endD.day()+' '+start.month()+'-'+endD.month()+' '+ week +' '+start.year()+'-'+endD.year();
        }
        system.debug('sch obj='+sch);

}
//System.schedule('One schedule',sch, p);
}