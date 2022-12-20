import { LightningElement, track } from 'lwc';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';

export default class ConfigPage extends LightningElement {
    objectVal;
    havingValue = false;
    requiredField1 = false;
    requiredField2 = false;
    requiredField4 = false;
    objectField;
    objectFieldVal;
    businessNameVal;
    hourNameLabel;
    footerVar = false;
    keyIndex = 0;
    @track itemList = [
        {
            id: 0,
            objectVal:'',
            objectFieldVal:'',
            objectField:'',
            businessNameVal:'',
            hourNameLabel:'',
            havingValue:false,
            objectFieldValMessage:'',
            requiredField1: false,
            requiredField2: false,
            requiredField4: false
        }
    ];

    get className() {
        return this.requiredField1 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className1() {
        return this.requiredField2 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
     get className3(){
        return this.requiredField4 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get objVal() {
            return "Object Field";
    }
    connectedCallback() {
        getHourVal()
            .then((data) => {
                this.hourNameLabel = data;
            })

    }
    onHandleObjectSearch(event) {
        this.objectVal = event.target.value;
        this.itemList.forEach((val,index)=>{
                            if(val.id==event.target.dataset.id){
                                // console.log('val.id===',val.id);
                                this.itemList[index] =  {id:event.target.dataset.id,objectVal:this.objectVal,havingValue:false};
                            }
                    });
                    // console.log('Temp arr onHandleObjectSearch = ',JSON.stringify(this.itemList));
        let dataId = event.target.dataset.id;
        console.log('Data-objectVal-id = ',dataId);
        
        if (event.target.value == '' || event.target.value == ' ') {
            this.recordsList = [];
            this.havingValue = false;
            this.objectFieldVal = [];

        }
        this.itemList.forEach((val,index)=>{
                // console.log('onHandleObjectSearch val.id===',event.target.dataset.id);
                getObject({ searchObject: val.objectVal })
                    .then((result) => {
                        if(val.id == dataId){
                                if (result.length == 0) {
                                    this.recordsList = [];
                                    this.message = "No Object Found with " + this.objectVal + " name";
                                    this.itemList[index] =  {id:val.id,objectVal:val.objectVal,havingValue:false,
                                                            recordsList:[],message:this.message};
                                }
                                else {
                                    this.recordsList = result;
                                    this.itemList[index] =  {id:val.id,objectVal:val.objectVal,recordsList:this.recordsList,message:'',havingValue:true};
                                }
                        }
                    })
                    .catch((error) => {
                        this.recordsList = undefined;
                    });
        });    
    }
    selectObjectValueChange(dataId) {
        this.objectFieldVal = [];
         this.itemList.forEach((val,index)=>{
             if(val.id==dataId){
               if (val.objectVal == '' || val.objectVal == ' ' || val.objectVal == null) {
                    this.objectFieldVal = [];
                }

                else {
                getPicklistFields({ sobjectValue: val.objectVal })
                .then((result) => {
                    console.log('length result of object fields -->', result.length);
                    if (result.length != 0) {
                        console.log('result of object fields -->', result);
                        this.objectFieldVal = result;
                        this.isObjFieldHistory = false;
                        this.itemList[index] =  {id:val.id,objectVal:val.objectVal,recordsList:this.recordsList,message:'',havingValue:true,objectFieldVal:result,isObjFieldHistory:false};
                    }
                    else {
                        // console.log('result of object fields -->',result.length);
                        this.isObjFieldHistory = true;
                        this.objectFieldValMessage = 'History of ' + this.objectVal + ' field is not ON';
                        this.itemList[index] =  {id:val.id,objectVal:val.objectVal,recordsList:this.recordsList,message:'',havingValue:true,objectFieldVal:'',isObjFieldHistory:true,objectFieldValMessage:this.objectFieldValMessage};

                    }
                })
                .catch((error) => {
                    this.error = error;
                });

            }
             }
        });
        
       
    }

    get objFieldVal() {
        if (this.objectVal == null && this.objectField == null) {
            return "Object Field Value";
        }
        if (this.objectVal != null && this.objectField != null) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + ' ' + this.objectField + " Value";
        }
        if (this.objectVal != null) {
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1) + " Field Value";
        }
    }

    onobjectselection(event) {
         console.log('Data-Object-id = ',event.target.dataset.id);
         var dataId = event.target.dataset.id;
        this.objectVal = event.target.dataset.name;
        console.log('objectVal', this.objectVal);
          this.itemList.forEach((val,index)=>{
                if(val.id==event.target.dataset.id){
                    console.log('val.id===',val.id);
                    this.itemList[index] =  {id:event.target.dataset.id,objectVal:this.objectVal,havingValue:false,recordsList:[],message:''};
                }
        });
         console.log('Temp arr itemList = ',JSON.stringify(this.itemList));
        this.recordsList = [];
        this.message = '';
        this.selectObjectValueChange(dataId);
    }
    selectObjectFieldChange(event) {
        this.clickedButtonLabelCheck = false;
        var dataId = event.target.dataset.id;
        console.log('Data-objectField-id = ',event.target.dataset.id);
        this.objectField = event.target.value;
          this.itemList.forEach((val,index)=>{
                if(val.id==dataId){
                    console.log('val.id===',val.id);
                    this.itemList[index] =  {id:event.target.dataset.id,objectVal:this.objectVal,havingValue:false,recordsList:[],message:'',objectField:this.objectField,objectFieldVal:val.objectFieldVal};
                }
        });
        console.log('Temp arr itemList = ',JSON.stringify(this.itemList));
        console.log('objectField = ', this.objectField);
    }

     selectHourValueChange(event)
    {          
        console.log('Data-businessNameVal-id = ',event.target.dataset.id);
        this.businessNameVal = event.target.value;
        this.itemList.forEach((val,index)=>{
                if(val.id==event.target.dataset.id){
                    console.log('val.id===',val.id);
                    this.itemList[index] =  {id:event.target.dataset.id,objectVal:val.objectVal,havingValue:false,recordsList:[],message:'',objectFieldVal:val.objectFieldVal,objectField:val.objectField,businessNameVal:this.businessNameVal};
                }
        });
         console.log('Temp arr itemList = ',JSON.stringify(this.itemList));
    }
    
    handleActive(event)
    {
        const tab = event.target.value;
        if(tab == 'firstTab')
        {
            this.footerVar = false;
        }
        else{
            this.footerVar = true;
        }
    }

    addRow() {
        let temp = this.data;
        ++this.keyIndex;
        console.log('Key Index = ',this.keyIndex);
        var newItem = [{id:this.keyIndex}];
        this.itemList = this.itemList.concat(newItem);
        console.log('DATAS---------->',this.data);
    }

    deleteRow(event) {
        console.log("In delete Row",event.target.accessKey);
        console.log("itemList Lenght",this.itemList.length);
        let rowIndex = event.target.dataset.item;
        if(this.itemList.length >= 1)
        {
           this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }
    Saveconfigdetail(){
         this.itemList.forEach((val,index)=>{
             if((val.objectVal==''||val.objectVal==' '||val.objectVal==null)&&(val.objectField==''||val.objectField==' '||val.objectField==null)&&(val.businessNameVal==''||val.businessNameVal==' '||val.businessNameVal==null)){
                this.itemList[index] =  {id:val.id,objectVal:val.objectVal,requiredField1:true,requiredField2:true,requiredField4:true, havingValue:false,recordsList:[],message:'',objectFieldVal:val.objectFieldVal,businessNameVal:val.businessNameVal};
             }
            // if(val.objectVal==''||val.objectVal==' '||val.objectVal==null){
            //     // alert('Require Object name at index = '+val.id);
            //      this.itemList[index] =  {id:val.id,requiredField1:true,havingValue:false,recordsList:[],message:'',objectFieldVal:val.objectFieldVal,objectField:val.objectField,businessNameVal:val.businessNameVal};
            // }
            // if(val.objectField==''||val.objectField==' '||val.objectField==null){
            //     // alert('Require Object Field at index = '+val.id);
            //      this.itemList[index] =  {id:val.id,objectVal:val.objectVal,requiredField1:false,requiredField2:true,havingValue:false,recordsList:[],message:'',objectFieldVal:val.objectFieldVal,businessNameVal:val.businessNameVal};
            // }
            //  if(val.businessNameVal==''||val.businessNameVal==' '||val.businessNameVal==null){
            //     // alert('Require business Name at index = '+val.id);
            //      this.itemList[index] =  {id:val.id,objectVal:val.objectVal,requiredField1:false,requiredField2:false,requiredField4:true, havingValue:false,recordsList:[],message:'',objectFieldVal:val.objectFieldVal,businessNameVal:val.businessNameVal};
            // }
            else{
                alert('Save Successfully');
            }
        });
    }   
}