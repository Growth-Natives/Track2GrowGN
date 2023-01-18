public class SAPOrdersSchedule {
    @AuraEnabled
    public static void scheduleClass(String jobName,String freqName,List<String> weekday,String startDate,String endDate,String preferredTime,String monthlyPriority,String monthlyDay,String monthlyOrdinal,String monthlyWeek){
        date start; 
        date endD;
        AverageTimeBatchClassSchedule p = new AverageTimeBatchClassSchedule();
        if(startDate!=''&&endDate!=''){
            start = Date.valueOf(startDate);
            endD = Date.valueOf(endDate);
        }
        String week='';
        String startOrEndDayMonth = '';
        String startOrEndYear = '';
        if(weekday.size()>0){
            for(Integer i=0;i<weekday.size();i++){
                week+= weekday[i]+',';
            }
        }
        week = week.removeEnd(',');
        system.debug('Week = '+week);
        String sch = '0 0 '+preferredTime+' ';
        if(freqName=='Custom'){
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
        }
        //0 0 0 22 1-2 2016 // 22nd Jan 2016 to 22nd Feb 2016
        if(freqName=='Custom'){
            if(week!=''){
                sch += startOrEndDayMonth+' ? * '+week+' '+startOrEndYear;
            }
        }
        else{
            if(week!=''){
                sch +=' ? * '+week;
            }
            if(monthlyPriority=='day'){
                sch += monthlyDay +' */1 ?';
            }
            if(monthlyPriority=='ordinal'){
                sch += '? * '+monthlyWeek+'#'+monthlyOrdinal;
            }
        }
        system.debug('sch obj='+sch);
        //System.schedule(jobName,sch, p);
    }
    
}