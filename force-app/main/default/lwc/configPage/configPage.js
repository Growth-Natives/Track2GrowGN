import { LightningElement,track } from 'lwc';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import metadatasaved from '@salesforce/apex/ConfigPage.metadatasaved';

export default class ConfigPage extends LightningElement 
{
    clickedButtonLabel;
     objectVal;
     recordsList=[];
    message='';
    objectFieldVal=[];
    havingValue = false;
    hourNameLabel;
    businessNameVal
    objectField;
    objectValfinal

    /// text history object
    CaseHistoryObjectText;

    connectedCallback(){
        getHourVal()
        .then((data)=>{
            this.hourNameLabel = data;
        })
       
    }

    handleInputChange(event)
     {
        this.CaseHistoryObjectText = event.detail.value;
        console.log('value of this.CaseHistoryObjectText',this.CaseHistoryObjectText);
    }
    
    Saveconfigdetail(event)
    {
        this.clickedButtonLabel = event.target.label;
        metadatasaved({CaseHistoryObjectText: this.CaseHistoryObjectText,Objectval:this.objectVal,fieldval:this.objectField,Businesval:this.businessNameVal})
       .then(result => {
       this.caseownerdel = result;
       console.log('value of this.caseownerdel',this.caseownerdel);
})

    }

    onSelectObject(){
        getPicklistFields({ sobjectValue: this.objectVal})
        .then((result) =>
         {
             console.log('result of object fields -->',result);
             this.objectFieldVal = result;
         })
        .catch((error) =>
         {
             this.error = error;
         });
 
    }

    renderedCallback() {
        if(this.recordsList != null && this.recordsList != undefined && this.recordsList.length>0){
            this.havingValue = true;
        }
      }

    onHandleObjectSearch(event){
    this.objectVal = event.target.value;
    console.log('value of objectVal',this.objectVal);
    if(event.target.value==''||event.target.value==' ')
     {
     this.recordsList=[];
     this.havingValue = false;
    }
       getObject({searchObject:this.objectVal})
       .then((result)=>{
          // console.log('hjgdhgdh',result)
        if (result.length===0){
            this.recordsList = [];
            this.message = "No Object Found with "+this.objectVal+" name";
        } 
        else{
            this.recordsList = result;
            this.message = "";
        }
        })
        .catch((error) =>
        {
        this.recordsList = undefined;
        });
        this.onSelectObject();
}
 onobjectselection(event)
   {
   console.log('inside onobjectselection');
//    this.selectedValue = event.target.dataset.name;
   console.log('inside onobjectselection',event.target.dataset.name);
   this.objectValfinal = event.target.dataset.name;
   this.recordsList = [];
   this.message = '';
   console.log(' this.selectedValue', this.selectedValue);
   //console.log('this.objectVal',this.objectVal);
   }
   selectHourValueChange(event)
   {  
      //this.clickedButtonLabelCheck = false;  
      this.businessNameVal = event.target.value;
       console.log('this.businessNameVal this.businessNameVal',this.businessNameVal);
   }

   
    selectObjectFieldChange(event)
    {   
        this.clickedButtonLabelCheck = false;   
        this.objectField = event.target.value;
        console.log('this.objectField',this.objectField);
    }
}