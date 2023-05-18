// import { LightningElement, api, track } from 'lwc';
// import getObject from '@salesforce/apex/ObjectPicklistController.getObject';
// import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
// import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
// import metadatasaved from '@salesforce/apex/ConfigPage.metadatasaved';

// export default class Onlydemo1 extends LightningElement {
//     clickedButtonLabel;
//     @track objectVal;
//     recordsList=[];
//     recordsList2 = [];
//     message='';
//     objectFieldVal=[];
//     havingValue = false;
//     havingValue2 = false;
//     hourNameLabel;
//     businessNameVal
//     objectField;
//     objectValfinal
//     @track checked = true;
//     @track disableFieldBudget=true;
//     /// text history object
//     CaseHistoryObjectText;
//     connectedCallback(){
//         getHourVal()
//         .then((data)=>{
//             this.hourNameLabel = data;
//         })
//     }
//     get className()
//     {
//         return this.requiredField1 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
//     }
//     @track visitorList = [{
//         name:'',
//         company:'',
//         email:'',
//     }];
//     // handleInputChange(event)
//     //  {
//     //     this.CaseHistoryObjectText = event.target.value;
//     //     console.log('value of this.CaseHistoryObjectText',this.CaseHistoryObjectText);
//     // }
//     addRow() {
//          this.visitorList.push({ name:'',company:'', email:'',});
//        }
//     deleteRow(event) {
//         var rowIndex = event.currentTarget.dataset.index;
//         if(this.visitorList.length > 1) {
//             this.visitorList.splice(rowIndex, 1);
//         }
//     }
//     //////toggle
//      changeToggle(event){
//      this.checked =event.target.checked
//      console.log('ddds',this.checked);
//      if(this.checked==true)
//      {
//          this.disableFieldBudget=false;
//      }
//      else
//      {
//          this.disableFieldBudget=true;
//      }
// }
//     handleChange(event) {
//         console.log('In handle change');
//         console.log('text',event.target.name);
//         var rowIndex = event.currentTarget.dataset.index;
//         if(event.target.name === 'name' ) {
//             console.log('Inside name2');
//             this.visitorList[rowIndex].name = event.target.value;
//             this.objectVal = event.target.value;
//             console.log('value of objectVal',this.objectVal);
//             if(event.target.value==''||event.target.value==' ')
//             {
//                 this.recordsList=[];
//                 this.recordsList2 = [];
//                 this.havingValue = false;
//                 this.havingValue2 = false;
//             }
//                 getObject({searchObject:this.objectVal})
//                 .then((result)=>{
//                     // console.log('hjgdhgdh',result)
//                     if (result.length===0){
//                         this.recordsList = [];
//                         this.recordsList2 = [];
//                         this.message = "No Object Found with "+this.objectVal+" name";
//                     }
//                     else{
//                         this.recordsList = result;
//                         this.recordsList2 = result;
//                         this.message = "";
//                     }
//                     })
//                     .catch((error) =>
//                     {
//                     this.recordsList = undefined;
//                     this.recordslist2 = undefined;
//                     });
//                     this.onSelectObject();
//         }
//          else if(event.target.name === 'company') {
//             this.visitorList[rowIndex].company = event.target.value;
//         }
//         else if(event.target.name === 'email') {
//             this.visitorList[rowIndex].email = event.target.value;
//         }
//     }
//     Saveconfigdetail()
//      {
//         console.log('value of >>>',this.visitorList);
//          metadatasaved({CaseHistoryObjectText: this.CaseHistoryObjectText,recordlevelwrapper: this.visitorList, switchhistory:this.checked})
//        .then(result => {
//        this.caseownerdel = result;
//        console.log('value of this.caseownerdel',this.caseownerdel);
//      })
//         var emptyCheck = false;
//         for(let rowIndex in this.visitorList) {
//             if(this.visitorList[rowIndex].name == null ||
//                 this.visitorList[rowIndex].company == null ||
//                 this.visitorList[rowIndex].email == null ||
//                 this.visitorList[rowIndex].phone == null ||
//                 this.visitorList[rowIndex].name == '' ||
//                 this.visitorList[rowIndex].company == '' ||
//                 this.visitorList[rowIndex].email == '' ||
//                 this.visitorList[rowIndex].phone == '') {
//                 emptyCheck = true;
//                 this.dispatchEvent(new ShowToastEvent({
//                     title: 'Error',
//                     message: 'Please fill all empty fields',
//                     variant: 'error',
//                 }));
//                 return false;
//             } else {
//                 console.log('pass');
//             }
//         }
//         if(emptyCheck === false) {
//         const fields = {};
//         for(let rowIndex in this.visitorList) {
//             fields[NAME_FIELD.fieldApiName] = this.visitorList[rowIndex].name;
//             fields[COMPANY_FIELD.fieldApiName] = this.visitorList[rowIndex].company;
//             fields[EMAIL_FIELD.fieldApiName] = this.visitorList[rowIndex].email;
//             fields[PHONE_FIELD.fieldApiName] = this.visitorList[rowIndex].phone;
//             const recordInput = { apiName: VISITOR_OBJECT.objectApiName, fields};
//             createRecord(recordInput)
//             .then(result => {
//                 if(result !== undefined) {
//                     this.visitorList[rowIndex].name = '';
//                     this.visitorList[rowIndex].company = '';
//                     this.visitorList[rowIndex].email = '';
//                     this.visitorList[rowIndex].phone = '';
//                     this.dispatchEvent(new ShowToastEvent({
//                         title: 'Success',
//                         message: 'Visitor created Successfully',
//                         variant: 'success',
//                     }));
//                 }
//             })
//             .catch(error => {
//                 this.dispatchEvent(new ShowToastEvent({
//                     title: 'Error creating record',
//                     message: error.body.message,
//                     variant: 'error',
//                 }));
//             });
//           }
//        }
//     }
//      onSelectObject(){
//         getPicklistFields({ sobjectValue: this.objectVal})
//         .then((result) =>
//          {
//              console.log('result of object fields -->',result);
//              this.objectFieldVal = result;
//          })
//         .catch((error) =>
//          {
//              this.error = error;
//          });
//     }
//     renderedCallback() {
//         if(this.recordsList != null && this.recordsList != undefined && this.recordsList.length>0){
//             this.havingValue = true;
//             this.havingValue2 = true;
//         }
//         // if(this.recordsList2 != null && this.recordsList2!= undefined && this.recordslist2.length>0){
//         //     this.havingValue2 = true;
//         // }
//       }
//     onHandleObjectSearch(event){
//     this.CaseHistoryObjectText = event.target.value;
//     console.log('event.target.value onhandle',event.target.value);
//     console.log('inside this.CaseHistoryObjectText',this.CaseHistoryObjectText);
//     console.log('value of objectVal',this.objectVal);
//         if(event.target.value==''||event.target.value==' ')
//         {
//             this.recordsList=[];
//             this.recordslist2 = [];
//             this.havingValue = false;
//             this.havingValue2 = false;
//             this.objectFieldVal = [];
//         }
//        getObject({searchObject:this.CaseHistoryObjectText})
//        .then((result)=>{
//           console.log('inside search',result);
//         if (result.length===0){
//             this.recordsList = [];
//             this.recordsList2 = [];
//             this.message = "No Object Found with "+this.objectVal+" name";
//         }
//         else{
//              console.log('inside searchsssssss');
//             this.recordsList = result;
//             this.recordsList2 = result;
//             this.message = "";
//             this.havingValue=true;
//             this.havingValue2 = true;
//         }
//         })
//         .catch((error) =>
//         {
//              console.log('inside errors');
//         this.recordsList = undefined;
//         this.recordslist2 = undefined;
//         });
//           console.log('outside errors');
//         this.onSelectObject();
// }
//  onobjectselection(event)
//    {
//    console.log('inside onobjectselection');
//    //this.selectedValue = event.target.dataset.name;
//    console.log('inside onobjectselection',event.target.dataset.name);
//    this.objectVal = event.target.dataset.name;
//    this.recordsList = [];
//    this.recordslist2 = [];
//    this.message = '';
//    //console.log(' this.selectedValue', this.selectedValue);
//    //console.log('this.objectVal',this.objectVal);
//    }
// }