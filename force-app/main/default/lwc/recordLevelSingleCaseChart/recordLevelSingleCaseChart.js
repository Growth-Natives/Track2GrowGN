import { LightningElement,track,api } from 'lwc';
import avergetimesinglerecord from '@salesforce/apex/averagetimechartcontroller.avergetimesinglerecord';
import casedatalast6month from '@salesforce/apex/averagetimechartcontroller.casedatalast6month';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import { loadScript } from 'lightning/platformResourceLoader';
export default class RecordLevelSingleCaseChart extends LightningElement {

@api recordId;
@track dataSetSingleRec; 
@track dataSet;
cardTitle1;

mychart;
casevalueid;
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

connectedCallback() {
                console.log('Value of id',this.recordId);
                avergetimesinglerecord({ casevalueid: this.casevalueid,id:this.recordId  })
                .then((result) => {
                    this.dataSetSingleRec = result;
                    this.Initializechartjs();
                })
                 this.cardTitle = 'Average Time On Case Status(In Minutes)';
            
            casedatalast6month()
            .then((result) => {
                        this.dataSet = result;
                        this.Initializechartjs1();
                    console.log('value of datarep result',result);
                })
                  this.cardTitle1 = 'Average Time On Case Status Last 6 Months(In Minutes)';


     }

     Initializechartjs() {
        if (this.mychart != undefined) {
            this.mychart.destroy();
        }
        var labell = [];
        var count = [];
            for (let key in this.dataSetSingleRec) {
                labell.push(key);
                count.push(this.dataSetSingleRec[key]);
                console.log('labell', labell);
                console.log('count', count);
            }

        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
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
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }]

                }
            },
        });
       // this.clickedButtonLabelCheck = true;
    }

      Initializechartjs1() {
        if (this.myChart != undefined) {
            this.myChart.destroy();
        }
        var labell = [];
        var count = [];
        for (let key in this.data) {
            this.labell.push(key);
            this.count.push(data[key]);
        }

        var ctx = this.template.querySelector(".pie-chart2").getContext('2d');
        this.myChart = new Chart(ctx, {
            type: 'bar',
            data: {

                labels: Object.keys(this.dataSet),
                datasets: [{
                    label: 'Tracking Based On Average Time',
                    data: Object.values(this.dataSet),
                    backgroundColor: "green"
                }],
            },
            options: {
                scales: {
                    yAxes: [{
                        display: true,
                        ticks: {
                            beginAtZero: true
                        }
                    }]

                }

            },
        });
    }
}