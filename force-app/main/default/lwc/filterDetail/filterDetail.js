// import { LightningElement,track,api,wire } from 'lwc';
// import getFilterDetail from '@salesforce/apex/FilterDetailController.getFilterDetail';
// import deleteFilter from '@salesforce/apex/FilterDetailController.deleteFilter';
// import getFilterDetailFromName from '@salesforce/apex/FilterDetailController.getFilterDetailFromName';
// import getDetail from '@salesforce/apex/FilterDetailController.getDetail';
// import { refreshApex } from '@salesforce/apex';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// import ChartJS from '@salesforce/resourceUrl/ChartJs';
// import {loadScript} from 'lightning/platformResourceLoader';
//  import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.getLeadByStatus';
// import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
// export default class FilterDetail extends LightningElement {
//     @track datas = [];
//     isfilterNameSelected = false;
//     @track isCreateFilter = false;
//     @track selectedFilterName;
//     @track getFilterDetails = [];
//     @track clickedButtonLabelCheck=false;
//     @track filterDetailVal=[];
// filterListCheck = false;
// isFilterVal = false;
//     @track cardCheck = true;
//     @track cardTitle = "Filter List";
//     @track backHandle = false;
//     @track detailHide = true;
   
//     // render filter list 
//     @wire(getFilterDetail)  filterList(result){
//         this.getFilterDetails = result;
//         if(result.data){
//             this.datas = result.data.map( objPL => {
//                 return {
//                     label: `${objPL.Filter_Name__c}`,
//                     value: `${objPL.Filter_Name__c}`,
//                     object: `${objPL.SobjectType__c}`,
//                     field: `${objPL.SobjectFieldType__c}`
//                 };
//             });
//             if(this.datas==undefined || this.datas.length==0){
//                 console.log('Data is at size--->',this.datas.length);
//                 this.filterListCheck = false;
//             }
//             else{
//                 this.filterListCheck = true;
//             }
//         }
//         console.log('datas',this.datas);
//     }
    
//     // 
//     @api chartConfiguration;
//     @track chartAmtData = [];
//     @track chartLabel = [];
//     @track selectedOption='bar';
//     @api checkRendredChild=false;
//     @api checkRendred=false;
//     @track clickedButtonLabel;
    
//     // on change filter name
//     selectFilterNameChange(event)
//     {  
//         console.log('Val-->',JSON.stringify(this.getFilterDetails));

//         if(this.selectedFilterName!=event.currentTarget.dataset.id){
//             this.clickedButtonLabelCheck = false;
//         }
//         this.selectedFilterName = event.currentTarget.dataset.id;
//         this.isfilterNameSelected = true;
//         getDetail({name:this.selectedFilterName})
//         .then(data=>{
//             this.filterDetailVal = data;
//         })
//         this.filterListCheck = false;
//         this.cardCheck = true;
//         this.cardTitle = "Filter Detail > " + event.currentTarget.dataset.id;
//         this.backHandle = true;
//         this.detailHide = true;
//         getFilterDetailFromName({filterName: this.selectedFilterName})
//         .then(data=>{
//                 console.log('value of render>>>>',data);
//                 this.chartLabel=[];
//                 this.chartAmtData=[]; 
//                 if (data) {
//                     for (let key in data) 
//                     {
//                         this.chartLabel.push(key);
//                         this.chartAmtData.push(data[key]);
//                     }
//                     this.chartConfiguration = {
//                         type: this.selectedOption,
//                         data: {
//                             datasets: [{
//                                 label: 'Tracking Based On Average Time',
//                                 backgroundColor:"green",// ["red", "blue", "green", "blue", "red", "blue"],
//                                 data: this.chartAmtData,
//                             }],
//                             labels: this.chartLabel,
//                         },
//                         options: {},
//                     };
//                     this.checkRendred = false;
//                     this.checkRendredChild = true;
//                     this.clickedButtonLabelCheck = true; 
//                     this.error = undefined;
//                 } 
//                 else if (error) {
//                     this.error = error;
//                     this.record = undefined;
//                 }
//         })
//     }

//     // on create filter
//     createFilter()
//     {
//         console.log("here");
//             this.isCreateFilter = true;
//             this.clickedButtonLabelCheck = false;
//     }

//     // handle delete
//     handleDeleteFilter(event){
//         console.log('handleDeleteFilter ');
//         const filterName = event.currentTarget.dataset.id;
//         this.selectedFilterName = '';
//         this.isfilterNameSelected = false;
//         this.clickedButtonLabelCheck = false;
//         this.filterDetailVal='';
//         deleteFilter({filterName:filterName})
//         .then(()=>{
//             refreshApex(this.getFilterDetails); 
//             const event = new ShowToastEvent({
//                 title: 'Successfully',
//                 message: 'Filter Deleted Successfully',
//                 variant: 'success',
//                 mode: 'dismissable'
//             });
//             this.dispatchEvent(event);
//         })
//         .catch(()=>{
//             const event = new ShowToastEvent({
//                 title: 'Error',
//                 message: 'Error in Deleting Record',
//                 variant: 'error',
//                 mode: 'dismissable'
//             });
//             this.dispatchEvent(event);
//         })
//     }
    
//    // chart
//     callOnRender(){
//     //   console.log('call on render');
//       getLeadByStatus1({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
// 		.then()
//     }

//     // handle back
//     handleBack(event){
//         console.log('BACK----<');
//         this.isCreateFilter = event.detail;
//         this.clickedButtonLabelCheck = false;
//         refreshApex(this.getFilterDetails); 
//     }
//     detailBackClick(){
//         console.log('DETAIL BACK-----<');
//         this.cardCheck = true;
//         this.filterListCheck = true;
//         this.detailHide = false;
//         this.backHandle = false;
//         this.cardTitle = "Filter List";
//         this.clickedButtonLabelCheck = false;
//         console.log("false check",this.isCreateFilter);
//     }

//     ////////////////////////////////////////////

//   @track dataSet;
//     @track picklistVal;
//      @track chartAmtData = [];
//     @track chartLabel = [];
//     @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'Case'},
//     selectPicklistApi: 'Status'}) selectTargetValues;
        
//       selectOptionChanveValue(event){       
//            this.picklistVal = event.target.value;
//            var ctx = this.template.querySelector(".pie-chart").getContext('2d');
//            console.log("picklistchangefunction");
//            this.getcallby();
//            //refreshApex(this.dataSet);
//        }  

//    getcallby()
//    {
//        console.log('ghdfhgdgdgh');
//       getLeadByStatus({status: this.picklistVal,objectVal: this.objectVal,Field: this.objectField,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
// 		.then(data=>{
//              if (data) {

//             console.log('resultdata',data);
//             this.dataSet = data;
//             //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
//                 this.Initializechartjs();
         
//          } else if (result.error) 
//         {
//             return result.error;
//         }
        
// 	 	}) 
//    }
    
//     @api chartjsInitialized = false;
//     renderedCallback() {
//         if (this.chartjsInitialized) {
           
//             return;
//         }
//         this.chartjsInitialized = true;
//         Promise.all([
//                 loadScript(this, ChartJS)
//             ])
//             .then(() => {
//                 //this.Initializechartjs();
//             })
//             .catch(error => {
//                 console.log(error.message)
//                 this.dispatchEvent(
//                     new ShowToastEvent({
//                         title: 'Error loading chartJs',
//                         message: error.message,
//                         variant: 'error'
//                     })
//                 );
//             });
//     }
//     Initializechartjs() {
//         console.log('>>>>>>>',window.bar);
//         if(window.bar!=undefined){
//                     window.bar.destroy();
//                 }
//         //ctxx.destroy();
//         console.log("loaded");
//          console.log("dataSet',result.data",this.dataSet);
//          console.log('Object.keys(this.dataSet',Object.keys(this.dataSet));
//           console.log('Object.values(this.dataSet)',Object.values(this.dataSet));
//           var labell = [];
//           var count = [];
//           for(let ownerLabel in Object.values(this.dataSet)){
//               console.log('>>>>>>>>'+Object.values(this.dataSet)[ownerLabel]);
//             labell.push(Object.values(this.dataSet)[ownerLabel].label);
//             count.push(Object.values(this.dataSet)[ownerLabel].count);
//           }
//           console.log('labell',labell);
//          console.log('count',count);

//             var arrayOfObj = labell.map(function(d, i) {
//           return {
//           label: d,
//           data: count[i] || 0
//           };
//           });
          

//           var sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
//           return a.data-b.data;
//           });
//           console.log('value off dhghjf',sortedArrayOfObj);
          
//           var newArrayLabel = [];
//           var newArrayData = [];
//           sortedArrayOfObj.forEach(function(d){
//           newArrayLabel.push(d.label);
//           newArrayData.push(d.data);
//           });

//         var ctx = this.template.querySelector(".pie-chart").getContext('2d');
//          window.bar = new Chart(ctx, {
//             type: 'bar',
//             data: {
                
//                 labels: newArrayLabel,  
//                 datasets: [{
//                     label: 'Average Time Spent On Owner Leader Board Per Status',
//                     data:newArrayData, 
//                     backgroundColor:"green"// ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001F3F", "#39CCCC", "#01FF70", "#85144B", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
//                 }],
//                 },
//                 options: {
         
//                    },
//         });
         
//     }
// }