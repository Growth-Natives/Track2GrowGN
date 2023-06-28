import { LightningElement } from 'lwc';
import getHourVal from '@salesforce/apex/averagetimechartcontroller.getHourVal';
import getRecordType from '@salesforce/apex/averagetimechartcontroller.getRecordType';
export default class Recordlevelconfigpage extends LightningElement {


  hourNameLabel;
  options1;
  defaultValues1;
    connectedCallback() {
        getHourVal()
            .then((data) => {
                this.hourNameLabel = data;
            })

            getRecordType()
                .then((result) => {
                    if (result.length != 0) {
                        for (let key in result) {
                            this.options1 = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                            this.defaultValues1.push(result[key]);
                    
                    }
                }
                })
    }
    handleChange1(event)
    {
       console.log('value of handleChange1',event.detail.value);
    }
    selectHourValueChange(event)
    {
        console.log('value of selectHourValueChange',event.target.value);
    }
    selectPicklistValueChange(event)
    {
         console.log('value of selectPicklistValueChange',event.target.value);
    }

}