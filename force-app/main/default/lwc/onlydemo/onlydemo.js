// import { LightningElement,track,wire } from 'lwc';
// import getFilterDetail from '@salesforce/apex/FilterDetailControllerDuplicate.getFilterDetail';
// import deleteFilter from '@salesforce/apex/FilterDetailControllerDuplicate.deleteFilter';
// import getDetail from '@salesforce/apex/FilterDetailControllerDuplicate.getDetail';
// import { refreshApex } from '@salesforce/apex';
// import { ShowToastEvent } from 'lightning/platformShowToastEvent';
// export default class FilterDetailDuplicate extends LightningElement 
// {
//     check = false;
//     @track datas = [];
//     filterListCheck = false;
//     @track selectedFilterName;
//     isfilterNameSelected = false;
//     @track clickedButtonLabelCheck=false;
//     @track filterDetailVal=[];
//     @track cardCheck = true;
//     @track cardTitle = "Filter List";
//     @track backHandle = false;
//     @track detailHide = true;
//     @track isCreateFilter = false;


     
//      connectedCallback() {
//          console.log('check',this.check);
         
//      }
//     @wire(getFilterDetail)  filterList(result)
//     {
//         console.log('this function called');
//         this.getFilterDetails = result;
//         if(result.data)
//         {
//             this.datas = result.data.map( objPL => 
//             {
//                 return {
//                     label: `${objPL.Filter_Name__c}`,
//                     value: `${objPL.Filter_Name__c}`,
//                     object: `${objPL.SobjectType__c}`,
//                     field: `${objPL.SobjectFieldType__c}`
//                 };
//             });
//             if(this.datas==undefined || this.datas.length==0)
//             {
//                 console.log('Data is at size--->',this.datas.length);
//                 this.filterListCheck = false;
//             }
//             else
//             {
//                 this.filterListCheck = true;
//             }
//         }
//         console.log('datas',this.datas);
//     }

//     selectFilterNameChange(event)
//     {  
//         console.log('Val-->',JSON.stringify(this.getFilterDetails));

//         if(this.selectedFilterName!=event.currentTarget.dataset.id)
//         {
//             this.clickedButtonLabelCheck = true;
//         }
//         this.selectedFilterName = event.currentTarget.dataset.id;
//         this.isfilterNameSelected = true;
//         getDetail({name:this.selectedFilterName})
//         .then(data=>
//         {
//             this.filterDetailVal = data;
//         })
//         this.filterListCheck = false;
//         this.cardCheck = true;
//         this.cardTitle = "Filter Detail > " + event.currentTarget.dataset.id;
//         this.backHandle = true;
//         this.detailHide = true;
        
//     }
// //......
//     // on create filter
//     createFilter()
//     {
//         console.log("here");
//             this.isCreateFilter = true;
//             this.clickedButtonLabelCheck = false;
//     }

//     // handle delete
// //......
//     handleDeleteFilter(event)
//     {
//         console.log('handleDeleteFilter ');
//         const filterName = event.currentTarget.dataset.id;
//         this.selectedFilterName = '';
//         this.isfilterNameSelected = false;
//         this.clickedButtonLabelCheck = false;
//         this.filterDetailVal='';
//         deleteFilter({filterName:filterName})
//         .then(()=>
//         {
//             refreshApex(this.getFilterDetails); 
//             const event = new ShowToastEvent({
//                 title: 'Successfully',
//                 message: 'Filter Deleted Successfully',
//                 variant: 'success',
//                 mode: 'dismissable'
//             });
//             this.dispatchEvent(event);
//         })
//         .catch(()=>
//         {
//             const event = new ShowToastEvent({
//                 title: 'Error',
//                 message: 'Error in Deleting Record',
//                 variant: 'error',
//                 mode: 'dismissable'
//             });
//             this.dispatchEvent(event);
//         })
//     }
//     // handle back
//     handleBack(event)
//     {
//         console.log('BACK----<');
//         this.isCreateFilter = event.detail;
//         this.clickedButtonLabelCheck = false;
//         refreshApex(this.getFilterDetails); 
//     }

//     detailBackClick()
//     {
//         console.log('DETAIL BACK-----<');
//         this.cardCheck = true;
//         this.filterListCheck = true;
//         this.detailHide = false;
//         this.backHandle = false;
//         this.cardTitle = "Filter List";
//         this.clickedButtonLabelCheck = false;
//         console.log("false check",this.isCreateFilter);
//     }


// }