import { LightningElement, track } from 'lwc';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';

export default class ConfigPage extends LightningElement {
    objectVal;
    havingValue = false;
    requiredField1 = false;
    requiredField2 = false;
    requiredField4 = false;
    objectField;
    objectFieldVal;
    businessNameVal;
    hourNameLabel;
    footerVar = false;
    keyIndex = 0;
    @track itemList = [
        {
            id: 0,
            objectVal:'',
            objectFieldVal:'',
            objectField:'',
            businessNameVal:'',
            hourNameLabel:'',
            havingValue:false,
            objectFieldValMessage:'',
            requiredField1: false,
            requiredField2: false,
            requiredField4: false
        }
    ];
    connectedCallback() {
     console.log('config click');

    }
}