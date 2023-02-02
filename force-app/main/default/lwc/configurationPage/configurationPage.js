import { LightningElement } from 'lwc';
import getApexSchedule from '@salesforce/apex/FilterDetailController.getApexSchedule';
import getObject from '@salesforce/apex/SAPOrdersSchedule.scheduleClass';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ConfigurationPage extends LightningElement {
    isApex;
    isSchedule=false;
    isCustomHistoryConfig=false;
    get arrowIcon(){
        if(this.isSchedule==true){
            return 'utility:chevrondown';
        }
        else{
            return 'utility:chevronright';
        }
    }
    get arrowIcons(){
         if(this.isCustomHistoryConfig==true){
            return 'utility:chevrondown';
        }
        else{
            return 'utility:chevronright';
        }
    }
   
    handleSchedule(){
        this.isSchedule = !this.isSchedule;
        this.isCustomHistoryConfig = false;
        if(this.isSchedule==true){
            this.apexSchedule();
        }
    }
    handleCustomHistory(){
        this.isSchedule=false;
        this.isCustomHistoryConfig = !this.isCustomHistoryConfig;
    }
    apexSchedule(){
        getApexSchedule()
            .then(data => {
                console.log('connected data ', data);
                if (data == true) {
                    this.isApex = true;
                }
                else {
                    this.isApex = false;
                   
                }
            })
    }
}[]