import {LightningElement, track,api, wire} from 'lwc';
import picklistLabel from '@salesforce/label/c.picklistLabel';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import getFD from '@salesforce/apex/averagetimechartcontroller.getFD';
import getFD1 from '@salesforce/apex/averagetimechartcontroller.getFD1';
import objectLabel from '@salesforce/label/c.objectLabel';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import getObject from '@salesforce/apex/ObjectPicklistController.getObject';
import picklistValues from '@salesforce/apex/ObjectPicklistController.picklistValues';
import getRecordType from '@salesforce/apex/ObjectPicklistController.getRecordType';
import getAllcaserecord from '@salesforce/apex/averagetimechartcontroller.retriveAccs';
import retriveFilter from '@salesforce/apex/averagetimechartcontroller.retriveFilter';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadByStatus1 from '@salesforce/apex/averagetimechartcontroller.mapvalue';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import {loadScript} from 'lightning/platformResourceLoader';
import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.getLeadByStatus';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
export default class Filter_LWC extends LightningElement{
   label = {picklistLabel};
    label1 = {objectLabel};
    hourNameLabel;
    filterName;
    @track filterVal;
    @track filterNameErr;
    @track isAlreadySaved = false;
    @track rDid;
    picklistStr;
    objectStr;
    fieldStr;
    options;
    defaultValues=[];
    options1;
    defaultValues1=[];
    selectedVal;
    selectedVal1;
    startdate;
    minDate;
    enddate ;
    dateError;
    @track fnError='';
    @track isdateError = false;
    @track isfnError=false;
    @track isCheckFilter = true;
    @track clickedButtonLabelCheck;
    @track runchart=false;
    @track isFilterSave = false;
    @track picklistVal;
    @track picklistValueStr = false;
    @track objectVal;
    objectFieldVal;
    @track businessNameVal;
    @track objectFieldValueVal;
    @track objectRecordTypeVal;
    @track jobid;
    objValue;
    @track toggleValue;
     piechartsaved;
    requiredOptions;
    requiredOptions1;
    @track startDatecheck = false;
    @track enddatecheck = false;
    recordsList=[];
    message='';
    havingValue = false;
    errorMsg = 'Error Message - Please Select ';
    clickedButtonLabel;
    requiredField1 = false;
    requiredField2 = false;
    requiredField3 = false;
    requiredField4 = false;
    requiredField5 = false;
    isObjFieldHistory = false;
    requiredCustomDate = false;
    myInterval;
    @track progress;       
    @track enableHandle = true;
    @track disableHandle = false;
    batchStart = false;
    batchEnd = false;
    jobinfo;
    objectFieldValMessage;
    @track disableButton = false;


    connectedCallback(){
        getHourVal()
        .then((data)=>{
            this.hourNameLabel = data;
        })
        var today = new Date();
        this.currentDate=today.toISOString();
        var defaultcurrent = new Date();
        this.minDate= defaultcurrent.toISOString();
       
    }
    // get className()
    // {
    //     return this.requiredField1 ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }
    // get className1()
    // {
    //     return this.requiredField2 ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }
    // get className2()
    // {
    //     return this.requiredField3 ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }
    // get className3(){
    //     return this.requiredField4 ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }
    // get filterNameClass(){
    //     return this.requiredField5 ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }
    // get classCustomDate(){
    //     return this.requiredCustomDate ? '' : 'slds-form-element slds-form-element slds-p-top_small';
    // }    
    get objVal(){
        if(this.objectVal!=null && this.recordsList.length!=0){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+ " Field";
        }
        else{
            return "Object Field";
        }
    }
    get objFieldVal(){
        if(this.objectVal==null && this.objectField==null){
            return "Object Field Value";
        }
        if(this.objectVal!=null && this.objectField!=null && this.recordsList.length!=0){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+' '+this.objectField + " Value";
        }
        if(this.objectVal!=null && this.recordsList.length!=0){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+" Field Value";
        }
        else{
            return "Object Field Value";
        }
    }
    get objRecordType(){
        if(this.objectVal!=null && this.recordsList.length!=0){
            return this.objectVal.charAt(0).toUpperCase() + this.objectVal.slice(1)+ " Record Type";
        }
        else{
        return "Object Record Type";
    }
    }

    constructor()
    {
        super();
        this.picklistStr = picklistLabel.split(',');
        this.objectStr = objectLabel.split(',');
        
        
    }

    selectPicklistValueChange(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.picklistVal = event.target.value;
        if(this.picklistVal == 'Custom Date')
        {
            this.picklistValueStr = true;
            this.disableBtn=true;
        }
        else
        {
            this.picklistValueStr = false;
            this.startdate=null;
            this.enddate=null;
            this.requiredCustomDate = false;
        }
    }
    
onHandleObjectSearch(event){
    this.objectFieldValMessage='';
    this.isObjFieldHistory=false;
    this.requiredField1 = false;
    console.log('test',event.target.value);
    this.objectVal = event.target.value;
    if(event.target.value=='')
    {
        this.recordsList=[];
        this.havingValue = false;
        this.objectFieldVal = [];
        this.selectedVal=[];
        this.options=[];
        this.defaultValues=[];
        this.selectedVal1=[];
        this.options1=[];
        this.defaultValues1=[];
   }


       getObject({searchObject:this.objectVal})
       .then((result)=>{
        console.log('result>>'+result);
        if (result.length===0 && this.objectVal[0] != ' '){
            this.havingValue = true;
            this.recordsList = [];
            this.message = "No Object Found with "+this.objectVal+" name";
        } 
        else if(result.length===0 && this.objectVal[0] == ' ')
        {
            this.havingValue = true;
            this.recordsList = [];
            this.message = "Please start the search with a valid alphabet";
        }
        else
        {
            this.havingValue = false;
            this.recordsList = result;
            this.message = "";
        }
        })
        .catch((error) =>
        {
        this.recordsList = undefined;
        });

        console.log('this.message..',this.message);
}

    selectObjectValueChange()
    {  
        this.options = [];
        this.options1 = [];
        this.objectFieldVal = [];
        this.defaultValues1 = [];
        this.defaultValues = [];
       this.clickedButtonLabelCheck = false; 
       if(this.objectVal==''||this.objectVal==' '||this.objectVal==null){
        this.selectedVal1=[];
        this.options1=[];
        this.defaultValues1=[];
        this.objectFieldVal=[];
    } 
    else{ 
       getPicklistFields({ sobjectValue: this.objectVal})
       .then((result) =>
        {
            if(result.length!=0){
                this.objectFieldVal = result;
                this.isObjFieldHistory = false;
                this.objectFieldValMessage = '';
            }
            else{
                this.isObjFieldHistory = true;
                this.objectFieldValMessage = 'History of '+this.objectVal + ' field is not ON';
            }
        })
       .catch((error) =>
        {
            this.error = error;
        });

       getRecordType({ objectName:  this.objectVal})
       .then((result) =>
       {
            if(result.length!=0)
            {
                for(let key in result)
                {
                    this.options1 = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    this.defaultValues1.push(result[key]);
                }
                this.defaultValues1.sort();
                
                this.selectedVal1 = this.defaultValues1.sort();;
            }
            else{
                this.selectedVal1 =[];
                this.defaultValues1=[];
            }
        })
        .catch((error) => 
        {
            this.error = error;
        });   
    }  
    }

    selectHourValueChange(event)
    {  
       this.clickedButtonLabelCheck = false;  
       this.businessNameVal = event.target.value;
    }

    objectField;
    selectObjectFieldChange(event)
    {   
        this.clickedButtonLabelCheck = false;   
        this.objectField = event.target.value;
        if(this.objectField==''||this.objectField==' '||this.objectField==null){
            this.defaultValues=[];
            this.selectedVal = [];
            this.options=[];
        }
        else{
            picklistValues({ objectName: this.objectVal, fieldName: event.target.value})
            .then((result) => 
            {
                if(result.length!=0)
                {
                    this.defaultValues=[];
                    this.selectedVal = [];
                    for(let key in result)
                    {
                        this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key]}));
                        this.defaultValues.push(result[key]);
                    }
                    this.defaultValues.sort();
                    this.selectedVal = this.defaultValues.sort();
                }
                else{
                    this.defaultValues=[];
                    this.selectedVal = [];
                }
            })
            .catch((error) => 
            {
                this.error = error;
            });  
        }    
    }

    handleChange(event) 
    {  

        this.clickedButtonLabelCheck = false; 
        this.selectedVal = event.detail.value;
    }
    
    onHandleCheckBox(event){
        this.isFilterSave = event.target.checked;  
        if(this.isFilterSave==false){
            this.filterName = undefined;
            this.requiredField5=false;
        } 
        console.log('isFilterSave==',this.isFilterSave);
    }

    handleChange1(event) 
    {
        this.clickedButtonLabelCheck = false;  
        this.selectedVal1 = event.detail.value;
    }
@track disableBtn=true;
    datehandle(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.startdate = event.detail.value;
        this.startDatecheck = false; 
         if(this.startdate!= null)
       {
          this.disableBtn=false; 
       }
    }
    datehandle1(event)
    {   
        this.clickedButtonLabelCheck = false;
        this.enddate = event.detail.value;   
        this.enddatecheck = false; 
    }

     datehandle2()
    {   
        this.clickedButtonLabelCheck = false;
        // var dt = event.detail.value;
        // this.clickedButtonLabelCheck = false; 
        // if(dt>this.enddate) {
        //     this.isdateError = true;
        //     this.dateError = 'End Date must be '+ dt + ' or later.';
        //     this.enddate='';
        //     this.enddatecheck = true;
        // }
        // else{
        //     this.startdate = event.detail.value;
        // }
        if(this.startdate>this.enddate) {
            this.isdateError = true;
            this.dateError = 'End Date must be '+ this.startdate + ' or later.';
            this.enddate='';
            this.enddatecheck = true;
            this.startDatecheck =true;
            
        }
        else{
            this.dateError ='';
            this.isdateError = false;
            this.enddate = this.enddate;
        }
        
    }
   
    onFilterName(event){
        var FN =  event.target.value;
        var str = FN.charAt(0).toUpperCase() + FN.slice(1);
        if(FN.charAt(0)==' '){
            this.requiredField5=false;
            this.isfnError=true;
            this.fnError="Please start the filter name with a valid alphabet";
        }
        else{
            this.isfnError = false;
            this.filterName = str;

        }
    }
    
    handleClick(event) 
    {
        var isObjectVal = false;
        if(event.target.label === 'Save')
        {
            if( this.objectVal==undefined||this.objectVal==null||this.objectVal==''){
                this.requiredField1 = true;
                this.errorMsg += ' Object Type,';
            }
            else{
                this.requiredField1 = false;
                if(this.message.includes('No Object Found with ')||this.isObjFieldHistory == true || this.message.includes("Please start the ")){
                    console.log('err---> field 1234');
                    isObjectVal = true;
                    this.requiredField1 = false;
                }
                else{
                    isObjectVal = false;
                    this.requiredField1 = false;
                }
                if(isObjectVal == true && (this.message.includes('No Object Found with ')||this.message.includes("Please start the "))){
                    console.log('11111111111');
                    this.requiredField1 = false;
                    this.requiredField2 = false;
                    this.requiredField3 = false;
                    this.requiredField4 = false;
                    this.requiredField5 = false;
                    this.requiredCustomDate = false; 
                    this.isObjFieldHistory = false;
                }
                if(isObjectVal == true && this.isObjFieldHistory == true){
                    console.log('222222222');
                    this.requiredField2 = false;
                    this.requiredField3 = false;
                    this.requiredField4 = false;
                    this.requiredField5 = false;
                    this.requiredCustomDate = false;
                    this.message = '';
                }
                console.log('isObjectVal==========',isObjectVal);
                if(isObjectVal == false && (this.objectField == undefined || this.objectField == ''))
                {
                    this.requiredField2 = true;
                    this.errorMsg += ' Object Field Type,';
                }
                else
                {
                    this.requiredField2 = false;
                }

                if(isObjectVal == false && (this.selectedVal == undefined || this.objectVal == ' '))
                {
                    this.errorMsg += ' Object Field Value Type,';
                }
                
                if(isObjectVal == false && (this.picklistVal == undefined || this.picklistVal == ''))
                {
                    this.requiredField3 = true;
                    this.errorMsg += ' Time Period,';
                }
                else
                {
                    this.requiredField3 = false;
                }

                if(isObjectVal == false && (this.businessNameVal == undefined || this.objectVal == '' || this.businessNameVal == ''))
                {
                    this.requiredField4 = true;
                    this.errorMsg += ' Business Hours,';
                }
                else
                {
                    this.requiredField4 = false;
                }
            // custom date condition
                if(isObjectVal == false && (this.picklistValueStr == true))
                {
                    console.log('Custom date save error');
                    if((this.startdate!=undefined||this.startdate!=null)  && (this.enddate!=undefined||this.enddate!=null)&&this.isdateError == false)
                    {
                        console.log('Custom date save error req false');
                        this.requiredCustomDate = false;
                        
                    }
                    else
                    {
                        console.log('Custom date save error req true');
                        this.requiredCustomDate = true;

                        if(this.enddatecheck == true)
                        {
                            this.errorMsg += 'a valid End Date.';
                        }
                        if(this.startDatecheck == true){
                            this.errorMsg +='a valid Start Date.';
                        }
                        if(!Boolean(this.startdate)  && !Boolean(this.enddate))
                        this.errorMsg += ' Start and End Date.';
                        else if (!Boolean(this.startdate) && this.startDatecheck ==false)
                        this.errorMsg += ' Start Date.';
                        else if (!Boolean(this.enddate) && this.enddatecheck == false)
                        this.errorMsg += ' End Date.';
                        
                    }
                }    
                if(isObjectVal == false && this.requiredField1 == false && this.requiredField2 == false && this.requiredField3 == false && this.requiredField4 == false && this.selectedVal != undefined && this.requiredCustomDate == false)
                    {
                        if(this.isFilterSave==true && this.isCheckFilter == true)
                        {                       
                                if(this.filterName == undefined || this.objectVal == '' ||this.filterName == '' || this.filterName == null)
                                {
                                    this.requiredField5 = true;
                                    this.errorMsg = 'Error Message - Please fill unique filter name';
                                    }
                                else
                                {
                                    this.requiredField5 = false;
                                    this.checkFilter();
                                }
                        
                                // if(this.errorMsg != 'Error Message - Please Select ')
                                // {
                                //     console.log('error msg ....',this.errorMsg);
                                //     const evt = new ShowToastEvent({
                                //         title: 'Error Message',
                                //         message: this.errorMsg,
                                //         variant: 'error',
                                //         mode: 'dismissable'
                                //     });
                                //     this.dispatchEvent(evt);
                                //     this.errorMsg = 'Error Message - Please Select ';
                                // }
                        }
                        else if(this.isFilterSave == false){
                        
                            this.getAllcaserecords();
                            const closeModal = new CustomEvent("saveclick",{
                                detail: false,
                            });
                        this.dispatchEvent(closeModal);
                        }
                }
            }
          
        }
    }
  
    checkFilter(){
        retriveFilter({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1.sort(),businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
        .then((data) => {
            if(data!=null){
                this.isCheckFilter = true;
                this.filterNameErr = data;
                const event = new ShowToastEvent({
                    title: 'ERROR',
                    message: data,
                    variant: 'error '+data,
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
            else{
                this.isCheckFilter = false;
                if(this.filterName!=null && this.filterName!='' && this.filterName!=' ' && this.isCheckFilter == false){
                    const closeModal = new CustomEvent("saveclick",{
                        detail: false,
                    });
                this.dispatchEvent(closeModal); 
                    this.getAllcaserecords();
                }
                else{
                    this.requiredField5 = false;
                }
            }
        })
    }
   
    getAllcaserecords(){
        this.isCheckFilter = false;   
        console.log('getAllcaserecords\nobjectVal:',this.objectVal,'\nfield:',this.objectField,'\nfieldValues: ',this.selectedVal.sort(),'\nrecordTypes: ',this.selectedVal1.sort(),'\nbusinessHour:',this.businessNameVal,'\ndates: ',this.picklistVal,'\nstartDate: ',this.startdate,'\nendDate: ',this.enddate,'\nfilterName:',this.filterName);
        getAllcaserecord({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName,historySwitch:true})
        .then(result=> {
        this.jobid = result;
        console.log('getAllcaserecord result jobId: ',result);
            if(this.jobid!=null)
            {
                this.enableHandle = false;        
                this.disableHandle = true;  
                this.disableButton = true;
                var intervaldata =setInterval(function (jobid111,parentthis)          
                {   
                   getBatchJobStatus({jobID: jobid111})
                        .then(result => {
                                this.jobinfo = result;
                                console.log('Status22 = >',result.Status);
                                if(result.Status == 'Completed')
                                { 
                                    console.log('Completed');
                                    clearInterval(intervaldata) ;
                                    parentthis.checkCondition();
                                }
                                if(result.Status == 'Failed')
                                { 
                                    console.log('Failed');
                                    clearInterval(intervaldata) ;
                                    parentthis.failedDetail();
                                }
                        });   
                },3000,this.jobid,this);
                this.myInterval=intervaldata;
            } 
            else{
                if(this.isFilterSave==false){
                    alert('already saved');
                    getFD({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1.sort(),businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
                    .then(data=>{
                    console.log('data in already save----->',data);
                    this.filterVal = data;
                    this.rDid = data[0].Id;
                    this.callOnRender(); 
                })
                }
               
                this.filterVal='';
                if(this.isFilterSave==true && this.filterName!=null){
                    getFD1({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1.sort(),businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave,FN:this.filterName})
                    .then(data=>{
                        console.log('data in save CHECK----->',data);
                        this.filterVal = data;
                        this.rDid = data[0].Id;
                        this.callOnRender(); 
                    });
                }
                
            }
        })
        if(this.isCheckFilter == false){
            const event = new ShowToastEvent({
                title: 'Success Message',
                message: 'Data is sucessfully received',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            this.isCheckFilter = true;
        }
   }
   failedDetail(){
    // console.log('getAllcaserecord result jobId: ');
  
    const event = new ShowToastEvent({
        title: 'Error',
        message: 'Batch is failed please contact your Admin',
        variant: 'error',
        mode: 'dismissable'
    });
    this.dispatchEvent(event);
    alert('batch is Failed');
   }
   checkCondition(){
    console.log('this.isFilterSave=====',this.isFilterSave);
    if(this.isFilterSave==false||this.filterName==null||this.filterName==''||this.filterName==undefined){
       setTimeout((() => {
            this.onSaveUncheck();
            console.log('yesss');
       const event = new ShowToastEvent({
                title: 'Success Message',
                message: 'batch is Completed',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
            //alert('batch is Completed');
       }).bind(this),8000)
    }
    else{
        setTimeout((() => {
            this.onSaveCheck(); 
            console.log('yesss>>');
             const event = new ShowToastEvent({
                title: 'Success Message',
                message: 'batch is Completed',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);  
            alert('batch is Completed');
        }).bind(this),8000)
       }
   }
   onSaveUncheck(){
    this.filterVal='';
    console.log('onSaveUncheck\nobjectVal:',this.objectVal,'\nfield:',this.objectField,'\nfieldValues: ',this.selectedVal.sort(),'\nrecordTypes: ',this.selectedVal1.sort(),'\nbusinessHour:',this.businessNameVal,'\ndates: ',this.picklistVal,'\nstartDate: ',this.startdate,'\nendDate: ',this.enddate,'\nfilterName:',this.filterName);
    getFD({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
        .then(data=>{
            console.log('data in save----->',data);
            this.filterVal = data;
            this.rDid = data[0].Id;
            this.callOnRender(); 
        });
        
    }
   onSaveCheck(){
    this.filterVal='';
    console.log('onSaveCheck\nobjectVal:',this.objectVal,'\nfield:',this.objectField,'\nfieldValues: ',this.selectedVal.sort(),'\nrecordTypes: ',this.selectedVal1.sort(),'\nbusinessHour:',this.businessNameVal,'\ndates: ',this.picklistVal,'\nstartDate: ',this.startdate,'\nendDate: ',this.enddate,'\nfilterName:',this.filterName);
    getFD1({objectVal: this.objectVal,field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1.sort(),businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave,FN:this.filterName})
        .then(data=>{
            console.log('data in save CHECK----->',data);
            this.filterVal = data;
            this.rDid = data[0].Id;
            this.callOnRender(); 
        });
     
   }
   onobjectselection(event)
   {
   this.objectVal = event.target.dataset.name;
   this.recordsList = [];
   this.message = '';
   this.selectObjectValueChange();  
   }
  caseownerdel;

    @api chartConfiguration;
    @track chartAmtData = [];
    @track chartLabel = [];
    @track selectedOption='bar';
    @api checkRendredChild=false;
    @api checkRendred=false;
    @track clickedButtonLabel;

  callOnRender(){
    const closeModal = new CustomEvent('batchcomplete',{
        detail: 
        {
            recId:this.rDid,
            filterValDetail:this.filterVal,
        }
    });
    this.dispatchEvent(closeModal);
    this.enableHandle = true;    
    this.disableHandle = false; 
    this.disableButton = false;
    
      getLeadByStatus1({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal.sort(),recordTypes: this.selectedVal1.sort(),businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
            
             this.chartLabel=[];
            this.chartAmtData=[]; 
		if (data) {
            for (let key in  data) 
            {
                this.chartLabel.push(key);
                this.chartAmtData.push(data[key]);
            }
            this.chartConfiguration = {
                type: this.selectedOption,
                data: {
                    datasets: [{
                            label: 'Tracking Based On Average Time',
                            backgroundColor: "green",//["red", "blue", "green", "blue", "red", "blue"],
                            data: this.chartAmtData,
                        },
                        ],
                    labels: this.chartLabel,
                },
                
                options: {},
                
            };
            this.checkRendred = false;
            this.checkRendredChild = true;
            this.clickedButtonLabelCheck = true; 
            this.error = undefined;
        } 
        else if (error) {
            this.error = error;
            this.record = undefined;
        }
	})
 }

 backClick(event){
    const childEvent = new CustomEvent("handleback", {detail: false});
    this.dispatchEvent(childEvent);
}


    @track dataSet;
    @track picklistVal12;
    @track chartAmtData = [];
    @track chartLabel = [];
    @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'Case'},
    selectPicklistApi: 'Status'}) selectTargetValues;
        
      selectOptionChanveValue(event){       
           this.picklistVal12 = event.target.value;
           var ctx = this.template.querySelector(".pie-chart").getContext('2d');
           this.getcallby();
       }  

   getcallby()
   {
      getLeadByStatus({status: this.picklistVal12,objectVal: this.objectVal,Field: this.objectField,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
             if (data) {

              var dataArray = [];
              dataArray=data;
           
           let dataIndexes = dataArray.map((d, i) => i);
            dataIndexes.sort((a, b) => {
            return dataArray[a] - dataArray[b];
              });

            this.dataSet = dataArray;
            this.Initializechartjs();
         
         } else if (result.error) 
        {
            return result.error;
        }
        
	 	}) 
   }
    
    @api chartjsInitialized = false;
    renderedCallback() {
        if(this.recordsList != null && this.recordsList != undefined && this.recordsList.length>0){
            this.havingValue = true;
        }
        if (this.chartjsInitialized) {
           
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
                loadScript(this, ChartJS)
            ])
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
    Initializechartjs() {
        if(window.bar!=undefined){
                    window.bar.destroy();
                }
          var labell = [];
          var count = [];
          for(let ownerLabel in Object.values(this.dataSet)){
              
            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
          }
         
           var arrayOfObj = labell.map(function(d, i) {
          return {
          label: d,
          data: count[i] || 0
          };
          });
          

          var sortedArrayOfObj = arrayOfObj.sort(function(a, b) {
          return a.data-b.data;
          });
          
          
          var newArrayLabel = [];
          var newArrayData = [];
          sortedArrayOfObj.forEach(function(d){
          newArrayLabel.push(d.label);
          newArrayData.push(d.data);
          });
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
         window.bar = new Chart(ctx, {
            type: 'bar',
            data: {
                
                labels: newArrayLabel,  
                datasets: [{
                    label: 'Average Time Spent On Owner Leader Board Per Status',
                    data:newArrayData, 
                    backgroundColor:"green" //["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001F3F", "#39CCCC", "#01FF70", "#85144B", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
                }],
                },
                options: {
         
                   },
        });
         
    }

    toggleHandle(event){
            this.toggleValue = event.target.checked;
    }
}