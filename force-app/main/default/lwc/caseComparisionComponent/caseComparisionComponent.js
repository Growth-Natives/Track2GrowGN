import { LightningElement, track, api, wire } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllUser from '@salesforce/apex/CaseComparison.getAllUser';
import getAllCases from '@salesforce/apex/CaseComparison.getAllCases';
export default class CaseComparisionComponent extends LightningElement {
    @track objectFieldVal;
    @track objectFieldVal1;
    @track user1 = [];
    @track user2 = [];
    @track caseUser1;
    @track caseUser2;
    @track selectedValues = [];
    @track selectedValues1 = [];
    @track is1stShow = false;
    @track is2ndShow = false;
    @track chartConfigurationChart = false;
    isUser2 = true;
    userLoadFirstTime = true;
    chartConfiguration;
    isChartJsInitialized;

    @wire(getAllUser) USE(result) {
        if (result.data != null || result.data != undefined) {
            this.user1 = result.data;
        }
    }
    graph() {
        if (this.isChartJsInitialized) {
            return;
        }
        // load chartjs from the static resource
        Promise.all([loadScript(this, chartjs)])
            .then(() => {
                this.isChartJsInitialized = true;
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfiguration)));
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading Chart',
                        message: error.message,
                        variant: 'error',
                    })
                );
            });
    }
    selectObjectFieldChange(event) {
        this.user2 = [];
        if (this.objectField1 != null || this.objectField1 != undefined) {
            if (this.objectField1 != event.target.value) {
                this.objectField = event.target.value;
            }
            else {
                alert("Please Select differnt User");
            }
        }
        else {
            this.objectField = event.target.value;
        }
        this.user1.map(val => {
            if (val != this.objectField) {
                this.user2.push(val);
                this.isUser2 = false;
            }
        });
        if (this.objectField != null || this.objectField != undefined) {
            getAllCases({ ownerName: this.objectField })
                .then((data) => {
                    this.caseUser1 = data;
                });
        }

    }
    selectObjectFieldChange1(event) {
        if (this.objectField != event.target.value) {
            this.objectField1 = event.target.value;
        }
        else {
            alert("Please Select differnt User");
        }
       
        if (this.objectField1 != null || this.objectField1 != undefined) {
            getAllCases({ownerName: this.objectField1 })
                .then(data => {
                    this.caseUser2 = data;
                    // console.log('this.caseUser2===>', this.caseUser2);

                });
                 this.chartConfig();
        }
       
    }
    chartConfig() {
        var chartLabel = [];
        var chartAmount =[];
         console.log('this.caseUser1===>', this.caseUser1[this.objectField]);
         var objVal = this.caseUser1[this.objectField];
        //  console.log('this.caseUser2===>', this.caseUser2[this.objectField1]);
         for (var key in objVal) {
            chartLabel.push(key);
            chartAmount.push(objVal[key]);
        } 
        this.chartConfiguration = {
            type: 'bar',
            data: {
                datasets: [{
                    label: this.objectField,
                    backgroundColor: "green",
                    data:chartAmount,
                },
                {
                    label: this.objectField1,
                    backgroundColor: "orange",
                    data:chartAmount,
                },
                ],
                labels: chartLabel,
            },
            options: {},
        };
        this.chartConfigurationChart = true;
        console.log('chartConfiguration => ', this.chartConfiguration);
        this.error = undefined;
        this.graph();
    }
}