import { LightningElement, api } from 'lwc';
import chartjs from '@salesforce/resourceUrl/ChartJs';
import { loadStyle,loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
 
export default class Gen_barchart extends LightningElement {
    @api chartConfig;
    @api checkifRecordIsRendered= false;
    isChartJsInitialized;
    connectedCallback() {
        console.log('this.chartConfig98',this.chartConfig);
        //location.reload();

    }
    renderedCallback() {
        if(this.checkifRecordIsRendered){
         console.log('this.chartConfig1',this.chartConfig);
        if (this.isChartJsInitialized) {
            console.log('this.chartConfig',this.chartConfig);
            //return;
        }
        // load chartjs from the static resource
        loadScript(this, chartjs)
            .then(() => {
                console.log('In');
                this.isChartJsInitialized = true;
                console.log('this.this.isChartJsInitialized',this.isChartJsInitialized);
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                console.log('this.chart',ctx);
                this.chart = new window.Chart(ctx, JSON.parse(JSON.stringify(this.chartConfig)));
                console.log('this.chart',this.chart);
            })
            .catch(error => {
                console.log('this.error',this.error);
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error loading Chart',
                        message: error.message,
                        variant: 'error',
                    })
                );
            });
            this.checkifRecordIsRendered = false;
        }
        
    }
}