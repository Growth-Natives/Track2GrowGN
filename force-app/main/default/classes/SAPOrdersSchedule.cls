public class SAPOrdersSchedule {
    @AuraEnabled
    public static void scheduleClass(String jobName,List<String> weekday,String startDate,String endDate,String preferredTime,String monthlyPriority,String monthlyDay,String monthlyOrdinal,String monthlyWeek){
        AverageTimeBatchClassSchedule p = new AverageTimeBatchClassSchedule();
        date start = Date.valueOf(startDate);
        date endD = Date.valueOf(endDate);
        system.debug('startDate===>'+start.month());
        String week='';
        String startOrEndDayMonth = '';
        String startOrEndYear = '';
        if(weekday.size()>0){
            system.debug('schedule week');
            for(Integer i=0;i<weekday.size();i++){
                system.debug('Week = '+weekday[i]);
                week+= weekday[i]+',';
            }
        }
        week = week.removeEnd(',');
        system.debug('Week = '+week);
        String sch = '0 0 '+preferredTime+' ';
        if(start.day()==endD.day() && start.month()!=endD.month()){
            startOrEndDayMonth = start.day()+' '+start.month()+'-'+endD.month()+' ';
        }
        if(start.day()!=endD.day() && start.month()==endD.month()){
            startOrEndDayMonth = start.day()+'-'+endD.day()+' '+start.month()+' ';
        }
        if(start.day()!=endD.day() && start.month()!=endD.month()){
            startOrEndDayMonth = start.day()+'-'+endD.day()+' '+start.month()+'-'+endD.month()+' ';
        }
        if(start.year()==endD.year()){
            startOrEndYear = start.year()+' ';
        }
        if(start.year()!=endD.year()){
            startOrEndYear = start.year()+'-'+endD.year();
        }
        //0 0 0 22 1-2 2016 // 22nd Jan 2016 to 22nd Feb 2016
        if(week!=''){
            sch += startOrEndDayMonth+' '+week+' '+startOrEndYear;
        }
        if(monthlyPriority=='day'){
            sch += monthlyDay +' 1/12 * '+startOrEndYear;
        }
        else{
            sch += '? * '+monthlyWeek+'#'+monthlyOrdinal+' '+startOrEndYear;
        }
        system.debug('sch obj='+sch);
        System.schedule(jobName,sch, p);
    }
    
}