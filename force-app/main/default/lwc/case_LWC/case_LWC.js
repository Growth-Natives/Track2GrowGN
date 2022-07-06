import { LightningElement, api, track, wire } from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//importing the apex method.
import getCaseStatus from '@salesforce/apex/CaseComparsionController.getCaseStatus';
import getBatchid from '@salesforce/apex/CaseComparsionController.getBatchid';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';

export default class Case_LWC extends LightningElement 
{
    @api recordId;
    @api objectApiName;
    @api name;
    @api loaderVariant = 'base';
    @api chartConfig;
    @api minutes;
    @track record;
    @track chartConfiguration;
    @track isChartJsInitialized;
    @track caseAvg;
    @track error;
    @track jobid;

        @wire(getBatchid, {id : '$recordId',objectName :'$objectApiName'})
        WiredCase({error, data})
        {
           // console.log('inside wire 1'+data);
            if(data)
            {
                //console.log('inside if');
                this.jobid = data;
                //console.log('jobid --->',this.jobid);
                this.error=undefined;

                if(this.jobid != null)
                {
                    //console.log('inside jobid if where' + ' jobid = ',this.jobid)
                    var intervaldata =setInterval(function (jobid111,parentthis)
                    {   
                        //console.log('jobid111 --->'+jobid111);
                        getBatchJobStatus({jobID: jobid111})
                        .then(result => 
                        {
                            this.jobinfo = result;
                            //console.log('value of jobinfo --->',this.jobinfo);
                        })
                        if(jobinfo.Status=='Completed' )
                        {
                            //console.log('jobinfo Status-->',jobinfo.Status)
                            clearInterval(intervaldata);
                            //console.log('passing');
                            alert('Batch is Completed');
                            parentthis.callForChart();   
                        }
                    },3000,this.jobid,this);
                    this.myInterval=intervaldata;
                    //console.log('intervalid >>>>',this.myInterval);  
                }
                else
                {
                    //console.log('else');  
                    alert('already saved');
                    this.callForChart(); 
                }
            }
            else if(data == null || data == undefined)
            {
                this.callForChart();  
            }
            else if(error)
            {
                //console.log('Error --->'+error.body.message);
                this.error = error;
                this.record = undefined; 
            }
        }

        callForChart()
        {
        console.log('inside callForChart');
        console.log('recordId-->',window.location.href);
        var splitURL=window.location.href.toString().split("/");
        console.log('splitURL',splitURL);
        console.log('object name',splitURL[5]);
        console.log('record id',splitURL[6]);

            getCaseStatus({id : splitURL[6] ,objectName :splitURL[5]})
            .then(data => 
            {
                console.log('inside callForChart if');
                let mapData = [];
                let mapData1 = [];
                let nameList = [];
                let sum = 0;
                let sum1 = 0;
                let sum2 = 0;
                let mapdata2 = mapData1.reverse();
                let map = data['Current'];
                let map1 = data['Average'];
                
                this.record = data;
                console.log('record --->',this.record);
                console.log('map --->',map);
                console.log('map1 --->',map1);

                for(var i in data['Current'])
                {
                    console.log('i value-->',i);
                    console.log('data[key] value-->',data['Current'][i]);
                    mapData.push(data['Current'][i]);
                    nameList.push(i);
                    console.log('mapData',mapData);
                    console.log('nameList',nameList);
                }
                console.log('mapData.length-1',mapData.length-1);
                console.log('mapData[0]',mapData[0]);

                
                for(let i=0; i < mapData.length-1; i++)
                {
                    console.log('inside iffffff');
                    sum = sum + mapData[i];
                }
                console.log('sum -->',sum);

                for(var j in data['Average'])
                {
                    console.log('j value-->',j);
                    console.log('data[key] value-->',data['Average'][j]);
                    mapData1.push(data['Average'][j]);
                    console.log('mapData1',mapData1);
                }
                console.log('mapdata2',mapdata2);
                console.log('mapdata2.length-1',mapdata2.length-1);
                
                for(let j=0; j < mapdata2.length-1; j++)
                {
                    console.log('inside iffffff');
                    sum1 = sum1 + mapdata2[j];
                }
                console.log('sum1 -->',sum1);
                sum2 = sum1 - sum;
                console.log('total sum',sum2);
                this.minutes = sum2;
                console.log('minutes',this.minutes);

                this.chartConfiguration = 
                {
                    type: 'bar',
                    data: 
                    {
                        labels: nameList,
                        datasets: 
                                [
                                    {
                                        label: 'Time spend on this case status (in Minutes)',
                                        barPercentage: 1.0,
                                        barThickness: 1,
                                        maxBarThickness: 9,
                                        minBarLength: 1,
                                        backgroundColor: "green",
                                        data: mapData,
                                    },
                                    {
                                        label: 'Average Time spend on this case status (in Minutes)',
                                        barPercentage: 1.0,
                                        barThickness: 1,
                                        maxBarThickness: 9,
                                        minBarLength: 1,
                                        backgroundColor: "blue",
                                        data: mapData1.reverse(),
                                    }
                                ],
                    },
                    options: {
                                scales: 
                                {
                                    yAxes: 
                                    [{
                                        ticks: 
                                        {
                                            beginAtZero: true
                                        }
                                    }]
                                }
                            },
                };
                this.error=undefined;
                this.caseStatus();
            })
            .catch(error => 
            {
                console.log('Errorured:- '+error.body.message);
                console.log("ELSE error");
                this.error = error;
                console.log('Errorured:- '+error);
                this.record = undefined;
                this.chartConfiguration = undefined;  
            })
        }

        caseStatus() 
        {
            console.log('inside caseStatus');
            console.log('this.chartConfiguration-->',this.chartConfiguration);

            if (this.isChartJsInitialized) 
            {
                console.log('inside if');
            return;
            }
            Promise.all([loadScript(this, chartjs)])
            .then(() => 
            {
                console.log('inside promse');
                this.isChartJsInitialized = true;
                const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
                console.log('ctx--->',ctx);
                console.log('this.chartConfiguration-->',this.chartConfiguration);
                console.log('JSON.stringify(this.chartConfiguration-->',JSON.stringify(this.chartConfiguration));
                this.chart = new window.Chart(ctx,JSON.parse(JSON.stringify(this.chartConfiguration)));
                console.log('this.chart--->',this.chart);
                this.chart.canvas.parentNode.style.height = 'auto';
                this.chart.canvas.parentNode.style.width = '100%';
            })
            .catch(error => 
                            {
                                console.log(error);
                                this.dispatchEvent(
                                                    new ShowToastEvent({
                                                                            title: 'Error loading ChartJS',
                                                                            message: error.message,
                                                                            variant: 'error',
                                                                        })
                                                );
                            });

        }
}