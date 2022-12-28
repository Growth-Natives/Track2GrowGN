import { LightningElement,track,api } from 'lwc';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.ownerbasedonaveragetime';
import getUserList from '@salesforce/apex/averagetimechartcontroller.getUserList';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
export default class Poc extends LightningElement {

   options=[]; 
   picklistVal;

    dynmic()
    {
        getUserList()
         .then(result => {
                if (result) {
                         console.log('result',result);
                    // this.selectTargetValues = data;
                   for (let key in result) {
                            this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                        }
                }
                else if (result.error) {
                    return result.error;
                }
            })
            console.log('hdghdf',this.dataSet)
    }
    handlePicklistChange(event) {
        this.picklistVal = event.target.value;
        this.getcallby();
       console.log('this.picklistVal',this.picklistVal);
    }

    ////////////////
    @track isModalOpen = false;
    @track picklistVal;
    @track cardTitle;
    @track SobjectFieldType;
    @track SobjectType;
    @track dataSet;
    @track SobjectFieldvalue = [];
    @track sentences = [];
    @track none = '1';
    @api isManagePackage;
    @api selectedFilterName;
    @api filterDetailVal;
    @api isCreateFilter;

    mychart;
    picklistValRight = 'Max 50';


    openModal() {
        this.isModalOpen = true;
        this.getcallby();
    }
    closeModal() {
        this.isModalOpen = false;
        this.getcallby();
    }
    submitDetails() {
        this.isModalOpen = false;
    }

    connectedCallback() {
       this.dynmic();
        var fieldType;
        var fieldValue;
        var arr = [];
        if (this.filterDetailVal != undefined || this.filterDetailVal != null || this.filterDetailVal.length > 0) {
            if (!this.isManagePackage) {
                this.filterDetailVal.map((val) => {
                    this.SobjectType = val.SobjectType__c;
                    fieldType = val.SobjectFieldType__c;
                    fieldValue = val.SobjectFieldValue__c;
                });
            }
            else {
                this.filterDetailVal.map(val => {
                    this.SobjectType = val.Track2Grow__SobjectType__c;
                    fieldType = val.Track2Grow__SobjectFieldType__c;
                    fieldValue = val.Track2Grow__SobjectFieldValue__c;
                });
            }
            this.SobjectFieldType = fieldType;
            this.SobjectFieldvalue = fieldValue;    
            if (this.SobjectFieldvalue != undefined) {


                arr.push(this.SobjectFieldvalue.split(','));
                this.picklistVal = arr[0][0];
                this.cardTitle = 'Average Time Spent On Owner Leader Board Per ' + fieldType + ':' + this.picklistVal + ' (In Minutes)';
                this.dynamic();
                this.getcallby();
            }
            else {
                window.location.reload();
            }
        }
        else {
            window.location.reload();
        }
    }

    dynamic() {
        pickListValueDynamically({
            customObjInfo: { 'sobjectType': this.SobjectType },
            selectPicklistApi: this.SobjectFieldType
        })
            .then(data => {
                this.selectTargetValues = data;
            })
    }
    selectOptionChanveValue(event) {
        this.picklistVal = event.target.value;
        this.cardTitle = 'Average Time Spent On Owner Leader Board Per ' + this.SobjectFieldType + ':' + this.picklistVal + ' (In Minutes)';
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        this.getcallby();
    }
    selectOptionChanveValueRight(event) {
        this.picklistValRight = event.target.value;
        this.getcallby();
    }
    getcallby() {
        getLeadByStatus({ status: this.picklistVal, maxNum: this.picklistValRight, objectVal: this.objectVal, Field: this.objectField, recordTypes: this.selectedVal1, businessHour: this.businessNameVal, dates: this.picklistVal, startDate: this.startdate, endDate: this.enddate, willRefresh: this.isFilterSave, selectedName: this.selectedFilterName,ownerpicklist:this.picklistVal})
            .then(data => {
                if (data) {
                    console.log('value of >>>',data);
                    this.dataSet = data;
                    this.Initializechartjs();
                }
                else if (result.error) {
                    return result.error;
                }
            })
    }

    Initializechartjs() {
        if (this.mychart != undefined) {
            this.mychart.destroy();
        }
        var labell = [];
        var count = [];
        for (let ownerLabel in Object.values(this.dataSet)) {
            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
        }
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        if (this.picklistValRight != null || this.picklistValRight != undefined) {
            var type = this.picklistValRight.split(' ')[0];
            var size = parseInt(this.picklistValRight.replace(/[^\d.]/g, ''), 10);
            if (type == 'Max') {

                newArrayLabel = newArrayLabel.slice(-size);
                newArrayData = newArrayData.slice(-size);
            }
            else if (type == 'Min') {
                newArrayLabel = newArrayLabel.slice(0, size);
                newArrayData = newArrayData.slice(0, size);
            }
        }
        this.mychart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: labell,
                datasets: [{

                    label: this.cardTitle,
                    data: count,
                    backgroundColor: "green"
                }],
            },
            options: {
                scales: {
                    x: {
                        ticks: {
                            // For a category axis, the val is the index so the lookup via getLabelForValue is needed
                            callback: function (val, index) {
                                // Hide every 2nd tick label
                                return index % 2 === 0 ? this.newArrayLabel(val) : '';
                            },
                            color: 'red',
                        }
                    },
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }]

                }
            },
        });
        this.clickedButtonLabelCheck = true;
    }

    renderedCallback() {
        if (this.chartjsInitialized) {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
            loadScript(this, ChartJS)
        ])
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading chartJs',
                        message: error.message,
                        variant: 'error'
                    })
                );
            });
    }
    ////////////////

}