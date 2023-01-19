public class SAPOrdersSchedule {
    @AuraEnabled
    public static void scheduleClass(String jobName,String freqName,Boolean isCustom,List<String> weekday,String startDate,String endDate,String preferredTime,String monthlyPriority,String monthlyDay,String monthlyOrdinal,String monthlyWeek){
        system.debug('freqName=='+freqName);
        system.debug('isCustom=='+isCustom);
        system.debug('weekday=='+weekday);
        system.debug('startDate=='+startDate);
        system.debug('endDate=='+endDate);
        system.debug('preferredTime=='+preferredTime);
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
        if(isCustom){
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
            if(freqName=='Weekly'){
                if(week!=''){
                    sch += startOrEndDayMonth+' ? * '+week+' '+startOrEndYear;
                }
            }
            if(freqName=='Monthly'){
                if(monthlyPriority=='day'){
                    sch += monthlyDay +' */1 ? '+startOrEndYear;
                }
                if(monthlyPriority=='ordinal'){
                    sch += '? * '+monthlyWeek+'#'+monthlyOrdinal+' '+startOrEndYear;
                }
            }
             if(freqName=='Daily'){
               
            	 sch +=startOrEndDayMonth+' ? * SUN-SAT '+startOrEndYear;
        		
           }
        }
        //0 0 0 22 1-2 2016 // 22nd Jan 2016 to 22nd Feb 2016
        
        else{
           if(freqName=='Daily'){
            	 sch +=' ? * SUN-SAT';
           }
            if(freqName=='Weekly'){
                if(week!=''){
                    sch +=' ? * '+week;
                }
            }
            if(freqName=='Monthly'){
                if(monthlyPriority=='day'){
                    sch += monthlyDay +' */1 ?';
                }
                if(monthlyPriority=='ordinal'){
                    sch += '? * '+monthlyWeek+'#'+monthlyOrdinal;
                }
            }
        }
        system.debug('sch obj='+sch);
        System.schedule(jobName,sch, p);
    }
    
}