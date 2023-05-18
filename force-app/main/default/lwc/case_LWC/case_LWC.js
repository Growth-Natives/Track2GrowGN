// import { LightningElement, api, track, wire } from 'lwc';
// //importing the Chart library from Static resources
// import chartjs from '@salesforce/resourceUrl/ChartJs'; 
// import { loadScript } from 'lightning/platformResourceLoader';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// //importing the apex method.
// import getCaseStatus from '@salesforce/apex/CaseComparsionController.getCaseStatus';
// import getBatchid from '@salesforce/apex/CaseComparsionController.getBatchid';
// import getStatusValue from '@salesforce/apex/CaseComparsionController.getStatusValue';
// import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';

// export default class Case_LWC extends LightningElement 
// {
//     @api recordId;
//     @api objectApiName;
//     @api name;
//     @api loaderVariant = 'base';
//     @api chartConfig;
//     @api Average;
//     @api Total;
//     @track statusVal;
//     @track record;
//     @track chartConfiguration;
//     @track isChartJsInitialized;
//     @track caseAvg;
//     @track error;
//     @track jobid;
//     @track myInterval;
//     @track variable= false;
//     @track variable1= false;
//     @track variable2= false;
//     @track variable3= false;
//     @track variable4= false;
//     @track variable5= false;
//     @track time_s;
//     @track time_s1;
//     @track rhours;
//     @track rminutes;
//     @track rhours1;
//     @track rminutes1;
//     @track dDisplay;
//     @track hDisplay;
//     @track mDisplay;
//     @track sDisplay;
//     @track dDisplay1;
//     @track hDisplay1;
//     @track mDisplay1;
//     @track sDisplay1;

//         @wire(getBatchid, {id : '$recordId',objectName :'$objectApiName'})
//         WiredCase({error, data})
//         {
//             if(data)
//             {
//                 this.jobid = data;
//                 this.error=undefined;
                
//                 if(this.jobid != null)
//                 {
//                     var intervaldata =setInterval(function (jobid111,parentthis)
//                     {
//                         getBatchJobStatus({jobID: jobid111})
//                         .then(result => 
//                         {
//                             this.jobinfo = result;
//                         })
//                         if(jobinfo.Status=='Completed' )
//                         {
//                             clearInterval(intervaldata);
//                             alert('Batch is Completed');
//                             parentthis.callForChart();   
//                         }
//                     },7000,this.jobid,this);
//                     this.myInterval=intervaldata;
//                 }
//                 else
//                 {
//                     alert('already saved');
//                     this.callForChart(); 
//                 }
//             }
//             else if(data == null || data == undefined)
//             {
//                 this.callForChart();  
//             }
//             else if(error)
//             {
//                 this.error = error;
//                 this.record = undefined; 
//             }
//         }

//         callForChart()
//         {
//             var splitURL=window.location.href.toString().split("/");
//             getStatusValue({id : splitURL[6] ,objectName :splitURL[5]})
//             .then(result => 
//             {
//                 this.statusVal = result;
//             })
//             .catch(error => 
//             {
//                 this.error = error;
//             });

//             getCaseStatus({id : splitURL[6] ,objectName :splitURL[5]})
//             .then(data => 
//             {
//                 let mapData = [];
//                 let mapData1 = [];
//                 let nameList = [];
//                 let nameList1 = [];
//                 let sumCurrent = 0;
//                 let totalCurrent = 0;
//                 let sumAverage = 0;
//                 let sum1Average = 0;
//                 let totalAverage = 0;
//                 let mapdata2 = [];
//                 let nameList2 = [];
//                 let map = data['Current'];
//                 let map1 = data['Average'];
                
//                 this.record = data;

//                 for(var i in data['Current'])
//                 {
//                     mapData.push(data['Current'][i]);
//                     nameList.push(i);
//                 }

//                 for(let i=0; i < nameList.length; i++)
//                 {
//                     sumCurrent = sumCurrent + mapData[i];
//                 }
//                 totalCurrent = sumCurrent;

//                 for(var j in data['Average'])
//                 {
//                     mapData1.push(data['Average'][j]);
//                     nameList1.push(j);
//                 }
//                 mapdata2 = mapData1.reverse();
//                 nameList2 = nameList1.reverse();

//                 let condition = 0;
//                 for(let i=0; i < nameList2.length; i++)
//                 {
//                     if(nameList2[i] == this.statusVal)
//                     {
//                         sumAverage = sumAverage + mapdata2[i+1];
//                         condition = 1;
//                     }
//                     else if(condition == 1)
//                     {
//                         if(mapdata2[i+1] != undefined)
//                         {
//                             sum1Average = sum1Average + mapdata2[i+1];
//                         }
//                     }
//                 }
//                 totalAverage = sumAverage+sum1Average;
//                 this.Average = totalAverage;
//                 this.Total = totalAverage + totalCurrent ;
//                 var averageCase = this.Average;
//                 var totalCase = this.Total;
                
//                 if(averageCase > 1 && averageCase <= 60) 
//                 {
//                     this.time_s = averageCase;
//                     this.variable = true;
//                 }

//                 if(totalCase > 1 && totalCase <= 60) 
//                 {
//                     this.time_s1 = totalCase;
//                     this.variable1 = true;
//                     this.variable3 = false;
//                     this.variable5 = false;
//                 }

//                 if(averageCase > 60 && averageCase <= 1440)
//                 {
//                     var num = averageCase;
//                     var hours = (num / 60);
//                     this.rhours = Math.floor(hours);
//                     var minutes = (hours - this.rhours) * 60;
//                     this.rminutes = Math.round(minutes);
//                     this.variable2 = true;
//                 }

//                 if(totalCase > 60 && totalCase <= 1440)
//                 {
//                     var num1 = totalCase;
//                     var hours1 = (num1 / 60);
//                     this.rhours1 = Math.floor(hours1);
//                     var minutes1 = (hours1 - this.rhours1) * 60;
//                     this.rminutes1 = Math.round(minutes1);
//                     this.variable3 = true;
//                     this.variable1 = false;
//                     this.variable5 = false;
//                 }

//                 let seconds = 0;
//                 if(averageCase > 1440)
//                 {
//                     seconds = Number(averageCase * 60);
//                     var d = Math.floor(seconds / (3600*24));
//                     var h = Math.floor(seconds % (3600*24) / 3600);
//                     var m = Math.floor(seconds % 3600 / 60);
//                     var s = Math.floor(seconds % 60);
//                     this.dDisplay = d > 0 ? d + (d == 1 ? " day, " : " days, ") : "";
//                     this.hDisplay = h > 0 ? h + (h == 1 ? " hour, " : " hours, ") : "";
//                     this.mDisplay = m > 0 ? m + (m == 1 ? " minute, " : " minutes, ") : "";
//                     this.sDisplay = s > 0 ? s + (s == 1 ? " second" : " seconds") : "";
//                     this.variable4 = true;
//                 }

//                 let seconds1 = 0;
//                 if(totalCase > 1440)
//                 {
//                     seconds1 = Number(totalCase * 60);
//                     var d1 = Math.floor(seconds1 / (3600*24));
//                     var h1 = Math.floor(seconds1 % (3600*24) / 3600);
//                     var m1 = Math.floor(seconds1 % 3600 / 60);
//                     var s1 = Math.floor(seconds1 % 60);
//                     this.dDisplay1 = d1 > 0 ? d1 + (d1 == 1 ? " day, " : " days, ") : "";
//                     this.hDisplay1 = h1 > 0 ? h1 + (h1 == 1 ? " hour, " : " hours, ") : "";
//                     this.mDisplay1 = m1 > 0 ? m1 + (m1 == 1 ? " minute, " : " minutes, ") : "";
//                     this.sDisplay1 = s1 > 0 ? s1 + (s1 == 1 ? " second" : " seconds") : "";
//                     this.variable5 = true;
//                     this.variable3 = false;
//                     this.variable1 = false;
//                 }

//                 this.chartConfiguration = 
//                 {
//                     type: 'bar',
//                     data: 
//                     {
//                         labels: nameList,
//                         datasets: 
//                                 [
//                                     {
//                                         label: 'Time spend on this case status (in Minutes)',
//                                         barPercentage: 1.0,
//                                         barThickness: 1,
//                                         maxBarThickness: 9,
//                                         minBarLength: 1,
//                                         backgroundColor: "green",
//                                         data: mapData,
//                                     },
//                                     {
//                                         label: 'Average Time spend on this case status (in Minutes)',
//                                         barPercentage: 1.0,
//                                         barThickness: 1,
//                                         maxBarThickness: 9,
//                                         minBarLength: 1,
//                                         backgroundColor: "blue",
//                                         data: mapdata2,
//                                     }
//                                 ],
//                     },
//                     options: {
//                                 scales: 
//                                 {
//                                     yAxes: 
//                                     [{
//                                         ticks: 
//                                         {
//                                             beginAtZero: true
//                                         }
//                                     }]
//                                 }
//                             },
//                 };
//                 this.error=undefined;
//                 this.caseStatus();
//             })
//             .catch(error => 
//             {
//                 this.error = error;
//                 this.record = undefined;
//                 this.chartConfiguration = undefined;  
//             })
//         }

//         caseStatus() 
//         { 
//             Promise.all([loadScript(this, chartjs)])
//             .then(() => 
//             {
//                 const ctx = this.template.querySelector('canvas.barChart').getContext('2d');
//                 this.chart = new window.Chart(ctx,JSON.parse(JSON.stringify(this.chartConfiguration)));
//                 this.chart.canvas.parentNode.style.height = 'auto';
//                 this.chart.canvas.parentNode.style.width = '100%';
//             })
//             .catch(error => 
//                             {
//                                 console.log(error);
//                                 this.dispatchEvent(
//                                                     new ShowToastEvent({
//                                                                             title: 'Error loading ChartJS',
//                                                                             message: error.message,
//                                                                             variant: 'error',
//                                                                         })
//                                                 );
//                             });

//         }
// }