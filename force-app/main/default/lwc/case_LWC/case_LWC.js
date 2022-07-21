import { LightningElement, api, track, wire } from 'lwc';
//importing the Chart library from Static resources
import chartjs from '@salesforce/resourceUrl/ChartJs'; 
import { loadScript } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//importing the apex method.
import getCaseStatus from '@salesforce/apex/CaseComparsionController.getCaseStatus';
import getBatchid from '@salesforce/apex/CaseComparsionController.getBatchid';
import getStatusValue from '@salesforce/apex/CaseComparsionController.getStatusValue';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';

export default class Case_LWC extends LightningElement 
{
    @api recordId;
    @api objectApiName;
    @api name;
    @api loaderVariant = 'base';
    @api chartConfig;
    @api Average;
    @api Total;
    @track statusVal;
    @track record;
    @track chartConfiguration;
    @track isChartJsInitialized;
    @track caseAvg;
    @track error;
    @track jobid;
    @track myInterval;

        @wire(getBatchid, {id : '$recordId',objectName :'$objectApiName'})
        WiredCase({error, data})
        {
           // console.log('inside wire 1'+data);
            if(data)
            {
                console.log('inside if data -->',data);
                this.jobid = data;
                console.log('jobid --->',this.jobid);
                this.error=undefined;

                if(this.jobid != null)
                {
                    console.log('inside if where jobid' + ' jobid = ',this.jobid);
                    var intervaldata =setInterval(function (jobid111,parentthis)
                    {   
                        console.log('jobid111 --->'+jobid111);
                        getBatchJobStatus({jobID: jobid111})
                        .then(result => 
                        {
                            this.jobinfo = result;
                            console.log('value of jobinfo --->',this.jobinfo);
                        })
                        if(jobinfo.Status=='Completed' )
                        {
                            console.log('jobinfo Status-->',jobinfo.Status)
                            clearInterval(intervaldata);
                            console.log('passing');
                            alert('Batch is Completed');
                            parentthis.callForChart();   
                        }
                    },7000,this.jobid,this);
                    this.myInterval=intervaldata;
                    console.log('intervalid >>>>',this.myInterval);  
                }
                else
                {
                    console.log('else');  
                    alert('already saved');
                    this.callForChart(); 
                }
            }
            else if(data == null || data == undefined)
            {
                console.log('inside else if --->');
                this.callForChart();  
            }
            else if(error)
            {
                console.log('Error --->'+error.body.message);
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

            getStatusValue({id : splitURL[6] ,objectName :splitURL[5]})
            .then(result => 
            {
                this.statusVal = result;
                console.log('statusVal --->',this.statusVal)
            })
            .catch(error => 
            {
                this.error = error;
            });

            getCaseStatus({id : splitURL[6] ,objectName :splitURL[5]})
            .then(data => 
            {
                console.log('data value-->',data);
                console.log('inside callForChart if');
                let mapData = [];
                let mapData1 = [];
                let nameList = [];
                let nameList1 = [];
                let sumCurrent = 0;
                let totalCurrent = 0;
                let sumAverage = 0;
                let sum1Average = 0;
                let totalAverage = 0;
                let mapdata2 = [];
                let nameList2 = [];
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

                console.log('nameList.length value',nameList.length);
                for(let i=0; i < nameList.length; i++)
                {
                    console.log('inside for condition for sumCurrent');
                    console.log('nameList value',nameList[i]);
                    console.log('mapData value',mapData[i]);
                    sumCurrent = sumCurrent + mapData[i];
                    console.log('sum of current data',sumCurrent);
                }
                totalCurrent = sumCurrent;
                console.log('total sum of current data',totalCurrent);

                for(var j in data['Average'])
                {
                    console.log('j value-->',j);
                    console.log('data[key] value-->',data['Average'][j]);
                    mapData1.push(data['Average'][j]);
                    nameList1.push(j);
                    console.log('mapData1',mapData1);
                    console.log('nameList1',nameList1);
                }
                mapdata2 = mapData1.reverse();
                nameList2 = nameList1.reverse();
                console.log('mapdata2',mapdata2);
                console.log('nameList2',nameList2);
                console.log('nameList2.length value',nameList2.length);

                let condition = 0;
                for(let i=0; i < nameList2.length; i++)
                {
                    console.log('nameList2 value',nameList2[i]);
                    console.log('statusVal value',this.statusVal);
                    if(nameList2[i] == this.statusVal)
                    {
                        console.log('inside if condition for sumAverage');
                        console.log('nameList2 value -->',nameList2[i]);
                        console.log('statusVal value -->',this.statusVal);
                        console.log('nameList2[i+1] value',nameList2[i+1]);
                        console.log('mapdata2[i+1] value',mapdata2[i+1]);
                        sumAverage = sumAverage + mapdata2[i+1];
                        console.log('sum when status is equal to nameList2',sumAverage);
                        condition = 1;
                    }
                    else if(condition == 1)
                    {
                    console.log('inside else condition for sum');
                    console.log('nameList2[i+1] value',nameList2[i+1]);
                    console.log('mapdata2[i+1] value',mapdata2[i+1]);
                        if(mapdata2[i+1] != undefined)
                        {
                            console.log('inside if of else part')
                            sum1Average = sum1Average + mapdata2[i+1];
                            console.log('sum when status is not equal to nameList2',sum1Average);
                        }
                    }
                }
                totalAverage = sumAverage+sum1Average;
                console.log('total average ',totalAverage);

                this.Average = totalAverage;
                console.log('average value',this.Average);

                this.Total = totalAverage + totalCurrent ;
                console.log('this.Total value',this.Total);


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
                                        data: mapdata2,
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
                console.log('before caseStatus');
                this.caseStatus();
                console.log('after caseStatus');
            })
            .catch(error => 
            {
                //console.log('Errorured:- '+error.body.message);
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
            console.log('inside caseStatus');
            console.log('this.chartConfiguration-->',this.chartConfiguration);

            Promise.all([loadScript(this, chartjs)])
            .then(() => 
            {
                console.log('inside promse');
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