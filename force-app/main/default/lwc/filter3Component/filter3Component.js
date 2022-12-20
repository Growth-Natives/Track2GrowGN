import { LightningElement,track,api,wire } from 'lwc';
import getFilterDetailFromName from '@salesforce/apex/FilterDetailController.getFilterDetailFromName';
import getFilterDetails from '@salesforce/apex/FilterDetailController.getFilterDetails';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import {loadScript} from 'lightning/platformResourceLoader';
import { refreshApex } from '@salesforce/apex';
export default class Filter3Component extends LightningElement {

    @api isCreateFilter = false;
    @track dataSet;
    @api selectedFilterName;
    @api saveFilterId;
    
    @track title = 'Tracking Based On Average Time(In Hours)'
     @track TrackingBasedOnAverageTimeZonePickval='In Hours';
     @track isModalOpen = false;
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
        this.getcallby();
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
        this.title= 'Tracking Based On Average Time(In Hours)';
        this.TrackingBasedOnAverageTimeZonePickval='In Hours';
        this.getcallby();
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    connectedCallback() {
        this.TrackingBasedOnAverageTimeZonePickval  = 'In Hours';
        this.getcallby();
        if (this.chartjsInitialized) 
        {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
                loadScript(this, ChartJS)
            ])
            .then(() => {
                //this.Initializechartjs();
            })
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
 
     TrackingBasedOnAverageTimeZonePick(event)
       {
           
         this.TrackingBasedOnAverageTimeZonePickval = event.target.value;
         if(this.TrackingBasedOnAverageTimeZonePickval=='In Minutes')
         {
            this.title= 'Tracking Based On Average Time(In Minutes)';
              this.getcallby();
         }
         else if(this.TrackingBasedOnAverageTimeZonePickval=='In Hours')
         {
            this.title= 'Tracking Based On Average Time(In Hours)';
              this.getcallby();
         }
         else if(this.TrackingBasedOnAverageTimeZonePickval=='In Days')
         {
             // this.ChartTrackingBasedOnAverageTime();
             this.title= 'Tracking Based On Average Time(In Days)';
              this.getcallby();
         }
       }

    getcallby()
   {
    if(this.selectedFilterName!=null){
      getFilterDetailFromName({filterName: this.selectedFilterName,timezone: this.TrackingBasedOnAverageTimeZonePickval})
        .then(data=>
            {
                if (data) 
                {
                    console.log('this.TrackingBasedOnAverageTimeZonePickval>>',this.TrackingBasedOnAverageTimeZonePickval);
                    console.log('resultdata>>',data);
                    this.dataSet = data;
                   // Console.log('value of getFilterDetailFromName>>',this.dataSet);
                    //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
                    this.Initializechartjs(); 
                } 
                else if (result.error) 
                {
                    return result.error;
                }
	 	    }) 
        }
        else{
            getFilterDetails({saveFilterId:this.saveFilterId,timezone: this.TrackingBasedOnAverageTimeZonePickval})
        .then(data=>
            {
                if (data) 
                {
                    console.log('resultdata',data);
                    this.dataSet = data;
                    //Console.log('value of getFilterDetails>>',this.dataSet);
                    //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
                    this.Initializechartjs(); 
                } 
                else if (result.error) 
                {
                    return result.error;
                }
	 	    })
        }
    }
    myChart;
    Initializechartjs() 
    {
        if(this.myChart!=undefined){
                    this.myChart.destroy();
                }
        //ctxx.destroy();
            var labell = [];
          var count = [];
         for (let key in this.data) 
                    {
                        this.labell.push(key);
                        this.count.push(data[key]);
                    }
       
        var ctx = this.template.querySelector(".pie-chart2").getContext('2d');
         this.myChart = new Chart(ctx, {
            type: 'bar',
            data: {
                
                labels:Object.keys(this.dataSet),  
                datasets: [{
                    label: 'Tracking Based On Average Time',
                    data:Object.values(this.dataSet), 
                    backgroundColor:"green" //["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001F3F", "#39CCCC", "#01FF70", "#85144B", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
                }],
                },
                options: {
         
                   },
        });
          // this.clickedButtonLabelCheck = true;
    }

    chartjsInitialized = true;
    renderedCallback() 
    {
        //refreshApex(this.getFilterDetails); 
        if (this.chartjsInitialized) 
        {
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
                loadScript(this, ChartJS)
            ])
            .then(() => {
                //this.Initializechartjs();
            })
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

}