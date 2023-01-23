import { LightningElement } from 'lwc';
import getApexSchedule from '@salesforce/apex/FilterDetailController.getApexSchedule';
import getObject from '@salesforce/apex/SAPOrdersSchedule.scheduleClass';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ConfigurationPage extends LightningElement {
    isApex;
    isSchedule=false;
    isOtherConfig=false;
      handleConfigTab(event) {
        const tab = event.target.label;
        console.log('Tab Config==',tab);
        if(tab=='Schedule'){
             this.isSchedule = true;
               this.isOtherConfig = false;
            this.apexSchedule();
        }
        if(tab=='Other Configuration'){
            this.isSchedule=false;
            this.isOtherConfig = true;
        }
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