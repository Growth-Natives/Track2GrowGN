// import { LightningElement, api, wire, track } from 'lwc';
// // import getCustomMetadata from '@salesforce/apex/AccountComparisonController.getCustomMetadata';
// import getMetadata from '@salesforce/apex/AccountComparisonController.getMetadata';
// import getBatchid from '@salesforce/apex/AccountComparisonController.getBatchid';
// import getBatchJobStatusValue from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatusValue';
// export default class Account_LWC extends LightningElement 
// {   
//     @api recordId;
//     @api objectApiName;
//     @track objectName;
//     @track objectFieldName;
//     @track metadataArray =[];
//     @track metadataMap = {};
//     @track recordTypeValue = [];
//     @track recordTypeStatusName = [];
//     @track statusAverageTimeValue = [];
//     @track statusCurrentTimeValue = [];
//     @track statusCurrentVal = [];
//     @track statusAverageVal = [];
//     @track sumAverageValue = 0;
//     @track sumCurrentValue = 0;
//     @track loader = true;
//     @track showTable = false;
//     @track color1Val = false;
//     @track color2Val = false;
//     @track color3Val = false;
//     @track color1StatusVal = false;
//     @track color2StatusVal = false;
//     @track color3StatusVal = false;
//     @track error;

//     @wire(getCustomMetadata) 
//     wiredAccounts({ error, data }) 
//     {
//         if(data) 
//         { 
//             for(var i in data)
//             {
//                 this.metadataArray.push(data[i]);
//                 this.metadataMap[data[i].Id]=data[i];
//             }
//         } 
//         else if(error) 
//         { 
//             this.error = error;  
//         }   
//     }

//     handleActive(event) 
//     {
//         if(this.metadataMap[event.currentTarget.name])
//         {
//             for(var i in this.metadataMap[event.currentTarget.name])
//             {
//                 this.objectName = this.metadataMap[event.currentTarget.name]['ObjectValue__c'];
//                 this.objectFieldName = this.metadataMap[event.currentTarget.name]['FieldValue__c'];
//             }
			
// 			getBatchid({id :this.recordId, objectName :this.objectApiName})
// 			.then((data) => 
// 			{
// 				if(data && data.length > 0)
// 				{
//                     for(var i in data)
//                     {
//                         this.jobid = data[i];
//                         this.error=undefined;
                        
//                         if(this.jobid != null)
//                         {
//                             var intervaldata =setInterval(function (jobid111,parentthis)
//                             {   
//                                 getBatchJobStatusValue({jobID: jobid111})
//                                 .then(result => 
//                                 {
//                                     this.jobinfo = result;
//                                 })
//                                     for(var j in this.jobinfo)
//                                     {
//                                         if(this.jobinfo[j].Status == 'Completed' )
//                                         {
//                                             clearInterval(intervaldata);
//                                             parentthis.callForTable();
//                                         }
//                                     }
                                
//                             },7000,this.jobid,this);
//                             this.myInterval=intervaldata; 
//                         }
//                         else
//                         {
//                             this.callForTable(); 
//                         }
//                         this.error = undefined;
//                     }
// 				}
//                 else if(data == null || data == undefined || data.length == 0)
//                 {
//                     this.callForTable();  
//                 }
//             })
//             .catch((error) => 
// 			{
//                 this.error = error;
// 				this.data = undefined; 
//             });
// 	    }
//     }
// 	callForTable()
// 	{
//         this.loader = false;
//         this.showTable = true;
// 		getMetadata({id : this.recordId ,Apiobject :this.objectApiName ,objectName :this.objectName ,fieldName :this.objectFieldName})
// 		.then(result => 
// 			{
//                 console.log('result',result);

//                 for(var x in result)
//                 {
//                     if(x == 'Last 3 Months')
//                     {
//                         for(var a in result[x])
//                         {
//                             for(var b in result[x][a])
//                             {
//                                 if(!this.recordTypeStatusName.includes(b))
//                                 {
//                                     this.recordTypeStatusName.push(b);
//                                 }
//                             }
//                             this.recordTypeValue.push({key:a,value:this.recordTypeStatusName,boolean:false});
//                         }
//                     }
//                 }

//                 for(var i in result)
//                 {
//                     if(i == 'Last 3 Months')
//                     {
//                         for(var a in result[i])
//                         {
//                                 for(var b in result[i][a])
//                                 {
//                                     console.log('b 1',b);
//                                     console.log('result[i][a][b] 1 ',result[i][a][b]);
//                                     this.sumAverageValue = this.sumAverageValue + result[i][a][b];
//                                 }
//                                 this.statusAverageTimeValue.push({key:a,value:this.sumAverageValue,name:i});
//                                 console.log('this.statusAverageTimeValue 1',this.statusAverageTimeValue);
//                         }
//                     }
//                     if(i == 'null')
//                     {
//                         for(var a in result[i])
//                         {
//                                 for(var b in result[i][a])
//                                 {
//                                     console.log('b 2',b);
//                                     console.log('result[i][a][b] 2',result[i][a][b]);
//                                     this.sumCurrentValue = this.sumCurrentValue + result[i][a][b];
//                                 }
//                                 this.statusCurrentTimeValue.push({key:a,value:this.sumCurrentValue,name:i});
//                                 console.log('this.statusCurrentTimeValue 1',this.statusCurrentTimeValue);
//                         }
//                     }
//                 }

//                 //Time Difference for RecordType Loop
//                 for(var x in this.statusAverageTimeValue)
//                 {
//                     for(var y in this.statusCurrentTimeValue)
//                     {
//                         if(this.statusAverageTimeValue[x].key == this.statusCurrentTimeValue[y].key)
//                         {
//                             if(this.statusAverageTimeValue[x].value > this.statusCurrentTimeValue[y].value)
//                             {
//                                 this.color1Val = true;
//                             }
//                             else if(this.statusAverageTimeValue[x].value < this.statusCurrentTimeValue[y].value)
//                             {
//                                 this.color2Val = true; 
//                             }
//                             else if(this.statusAverageTimeValue[x].value = this.statusCurrentTimeValue[y].value)
//                             {
//                                 this.color3Val = true;
//                             }
//                         }
//                     }
//                 }

//                 //Per Status Time Loop
//                 for(var k in result)
//                 {
//                     if(k == 'Last 3 Months')
//                     {
//                         for(var a in result[k])
//                         {
//                             for(var b in result[k][a])
//                             {
//                                 this.statusCurrentVal.push({key:b,value:result[k][a][b],name:a});
//                             }
//                             console.log('this.statusCurrentVal',this.statusCurrentVal);
//                         }
//                     }
//                     else if(k == 'null')
//                     {
//                         for(var a in result[k]) 
//                         {
//                             for(var b in result[k][a])
//                             {
//                                 this.statusAverageVal.push({key:b,value:result[k][a][b],name:a});
//                             }
//                             console.log('this.statusAverageVal',this.statusAverageVal);
//                         }
//                     }
//                 }

//                 for(var x in this.statusCurrentVal)
//                 {
//                     for(var y in this.statusAverageVal)
//                     {
//                         console.log('this.statusCurrentVal[x].key',this.statusCurrentVal[x].key);
//                         console.log('this.statusAverageVal[y].key',this.statusAverageVal[y].key);
//                         console.log('this.statusCurrentVal[x].name',this.statusCurrentVal[x].name);
//                         console.log('this.statusAverageVal[y].name',this.statusAverageVal[y].name);
//                         if(this.statusCurrentVal[x].key == this.statusAverageVal[y].key && this.statusCurrentVal[x].name == this.statusAverageVal[y].name)
//                         {
//                             console.log('this.statusCurrentVal[x].value',this.statusCurrentVal[x].value);
//                             console.log('this.statusAverageVal[y].value',this.statusAverageVal[y].value);
//                             if(this.statusCurrentVal[x].value > this.statusAverageVal[y].value)
//                             {
//                                 this.color1StatusVal = true;
//                             }
//                             else if(this.statusCurrentVal[x].value < this.statusAverageVal[y].value)
//                             {
//                                 this.color2StatusVal = true;
//                             }
//                             else if(this.statusCurrentVal[x].value = this.statusAverageVal[y].value && this.statusCurrentVal[x].value != 0 && this.statusAverageVal[y].value != 0)
//                             {
//                                 this.color3StatusVal = true;
//                             }
//                         }
//                     }
//                 }

// 				this.error=undefined;
// 				})
				

// 		.catch(error =>
// 		{
// 			console.log('Errorured:- '+error);
// 			this.error = error;
// 		});
// 	} 


//     iconValueClick(event)
//     {
//         for(var x in this.recordTypeValue)
//         {
//             if(this.recordTypeValue[x].key == event.target.dataset.id)
//             {
//                 this.recordTypeValue[x].boolean = false;
//             }
//         }
//     }

//     iconValueChangeClick(event)
//     {
//         for(var x in this.recordTypeValue)
//         {
//             if(this.recordTypeValue[x].key == event.target.dataset.id)
//             {
//                 this.recordTypeValue[x].boolean = true;
//             }
//         }
//     }
// }