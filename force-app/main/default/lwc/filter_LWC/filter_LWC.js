import {LightningElement, track,api, wire} from 'lwc';
import picklistLabel from '@salesforce/label/c.picklistLabel';
import getHourVal from '@salesforce/apex/ObjectPicklistController.getHourVal';
import objectLabel from '@salesforce/label/c.objectLabel';
import getPicklistFields from '@salesforce/apex/ObjectPicklistController.getPicklistFields';
import picklistValues from '@salesforce/apex/ObjectPicklistController.picklistValues';
import getRecordType from '@salesforce/apex/ObjectPicklistController.getRecordType';
import getAllcaserecord from '@salesforce/apex/averagetimechartcontroller.retriveAccs';
import retriveFilter from '@salesforce/apex/averagetimechartcontroller.retriveFilter';
import getAllcaserecord1 from '@salesforce/apex/averagetimechartcontroller.mapvalue';
import getBatchJobStatus from '@salesforce/apex/averagetimechartcontroller.getBatchJobStatus';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getLeadByStatus1 from '@salesforce/apex/averagetimechartcontroller.mapvalue';
import getcaseowner from '@salesforce/apex/averagetimechartcontroller.getcaseowner';
import ChartJS from '@salesforce/resourceUrl/ChartJs';
import {loadScript} from 'lightning/platformResourceLoader';
 import getLeadByStatus from '@salesforce/apex/averagetimechartcontroller.getLeadByStatus';
import pickListValueDynamically from '@salesforce/apex/averagetimechartcontroller.pickListValueDynamically';
//import getBusinessHours from '@salesforce/apex/ObjectPicklistController.getBusinessHours';
export default class Filter_LWC extends LightningElement
{
   label = {picklistLabel};
    label1 = {objectLabel};
    hourNameLabel;
    filterName;
    @track filterNameErr;
    picklistStr;
    objectStr;
    fieldStr;
    options;
    defaultValues=[];
    options1;
    defaultValues1=[];
    selectedVal;
    selectedVal1;
    @track isCheckFilter = true;
    @track clickedButtonLabelCheck;
    @track runchart=false;
    @track isFilterSave = false;
    @track picklistVal;
    @track picklistValueStr = false;
    @track objectVal;
    @track objectFieldVal;
    @track businessNameVal;
    @track objectFieldValueVal;
    @track objectRecordTypeVal;
    @track jobid;
    requiredOptions;
    requiredOptions1;
    errorMsg = 'Error Message - ';
    connectedCallback(){
        getHourVal()
        .then((data)=>{
            this.hourNameLabel = data;
        })
       
    }
    get className()
    {
        return this.requiredField1 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className1()
    {
        return this.requiredField2 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className2()
    {
        return this.requiredField3 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get className3(){
        return this.requiredField4 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get filterNameClass(){
        return this.requiredField5 ? 'slds-form-element slds-form-element slds-has-error slds-p-top_small' : 'slds-form-element slds-form-element slds-p-top_small';
    }
    get objVal(){
        if(this.objectVal!=null){
            return this.objectVal+ " Field";
        }
        else{
            return "Object Field";
        }
    }
    get objFieldVal(){
        if(this.objectVal==null && this.objectField==null){
            return "Object Field Value";
        }
        if(this.objectVal!=null && this.objectField!=null){
            return this.objectVal+' '+this.objectField + " Value";
        }
        if(this.objectVal!=null ){
            return this.objectVal +" Field Value";
        }
    }
    get objRecordType(){
        if(this.objectVal!=null){
            return this.objectVal + " Record Type";
        }
        else{
        return "Object Record Type";
    }
    }

    constructor()
    {
        super();
        // console.log('label value --->',picklistLabel);
        // console.log('label1 value --->',objectLabel);
        this.picklistStr = picklistLabel.split(",\r\n");
        this.objectStr = objectLabel.split(",\r\n");
        // this.hourNameStr = hourNameLabel.split(",\r\n");
        // console.log('picklistStr value --->',this.picklistStr);
        // console.log('objectStr value --->',this.objectStr);
    }

    renderedCallback(){
        if(this.runchart){
            //this.callOnRender();
        }
    }
    selectPicklistValueChange(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.picklistVal = event.target.value;
        // console.log('picklistVal value-->',this.picklistVal);
        if(this.picklistVal == 'Custom Date')
        {
            this.picklistValueStr = true;
        }
        else
        {
            this.picklistValueStr = false;
        }
    }

    selectObjectValueChange(event)
    {  
       this.clickedButtonLabelCheck = false;  
       this.objectVal = event.target.value;
    //    console.log('object value---->',this.objectVal);
       getPicklistFields({ sobjectValue: this.objectVal})
       .then((result) =>
        {
            // console.log('result of object fields -->',result);
            this.objectFieldVal = result;
        })
       .catch((error) =>
        {
            this.error = error;
        });

       getRecordType({ objectName:  this.objectVal})
       .then((result) =>
       {
            if(result)
            {
                // console.log('result-->',result);
                for(let key in result)
                {
                   
                    console.log('options value -->',result[key]);
                    this.options1 = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    this.defaultValues1.push(result[key]);
                    // console.log('options1 value---',this.options1);
                    console.log('defaultValues1 value---',this.defaultValues1);
                }
                this.selectedVal1 = this.defaultValues1;
                // this.defaultValues1 =['opt2', 'opt4', 'opt6'];
            }
        })
        .catch((error) => 
        {
            this.error = error;
        });     
    }

    selectHourValueChange(event)
    {  
       this.clickedButtonLabelCheck = false;  
       this.businessNameVal = event.target.value;
    //    console.log('object value---->',this.businessNameVal);
       getHourVal()
       .then((val)=>{
            console.log('VAL------->',val);
       })
    }

    objectField;
    selectObjectFieldChange(event)
    {   
        this.clickedButtonLabelCheck = false;   
        this.objectField = event.target.value;
        // console.log('object value ---->',this.objectVal);
        // console.log('object field---->',event.target.value);
        picklistValues({ objectName: this.objectVal, fieldName: event.target.value})
        .then((result) => 
        {
            if(result)
            {
                for(let key in result)
                {
                    // console.log('options value result--',result);
                    this.options = Object.keys(result).map(key => ({ label: result[key], value: result[key] }));
                    this.defaultValues.push(result[key]);
                    // console.log('options value---',this.options);
                    console.log('defaultValues value---',this.defaultValues);
                }
                this.selectedVal = this.defaultValues;
            }
        })
        .catch((error) => 
        {
            this.error = error;
        });       
    }

    handleChange(event) 
    {  
        this.clickedButtonLabelCheck = false; 
        this.selectedVal = event.detail.value;
        // console.log('selectedVal value---',this.selectedVal);
    }
    
    onHandleCheckBox(event){
        this.isFilterSave = event.target.checked;       
        // console.log("Todo: " + event.target.checked);
    }

    handleChange1(event) 
    {
        this.clickedButtonLabelCheck = false;  
        this.selectedVal1 = event.detail.value;
        // console.log('selectedVal1 value---',this.selectedVal1);
    }

    startdate;
    datehandle(event)
    {   
        this.clickedButtonLabelCheck = false; 
        this.startdate = event.detail.value;
        // console.log('startdate value--->>>>>>>>',this.startdate);
    }

    enddate;
    datehandle1(event)
    {   
        this.clickedButtonLabelCheck = false;  
        this.enddate = event.detail.value;
        // console.log('enddate value--->>>>>>>>',this.enddate);
    }
   
    onFilterName(event){
        this.filterName = event.target.value;
    }

    clickedButtonLabel;
    requiredField1 = false;
    requiredField2 = false;
    requiredField3 = false;
    requiredField4 = false;
    requiredField5 = false;
   @track myInterval;
    @track progress;
    jobinfo;
    
    handleClick(event) 
    {
        // 
        //this.clickedButtonLabel = event.target.label;
        if(event.target.label === 'Save')
        {
            if(this.requiredField1 == false && this.requiredField2 == false && this.requiredField3 == false && this.requiredField4 == false && this.selectedVal != undefined)
                {
                    if(this.isFilterSave==true && this.isCheckFilter == true)
                    {
                        console.log('this.isFilterSave==true');
                       
                            if(this.filterName == undefined || this.objectVal == '' ||this.filterName == '' || this.filterName == null)
                            {
                                this.requiredField5 = true;
                                console.log('Req 5 if - ',this.requiredField5); 
                                this.errorMsg += 'Please fill unique filter name';
                            }
                            else
                            {
                                this.requiredField5 = false;
                                console.log('Req 5 else - ',this.requiredField5);
                                this.checkFilter();
                            }
                    
                            if(this.errorMsg != 'Error Message - ')
                            {
                                const evt = new ShowToastEvent({
                                    title: 'Error Message',
                                    message: this.errorMsg,
                                    variant: 'error',
                                    mode: 'dismissable'
                                });
                                this.dispatchEvent(evt);
                                this.errorMsg = 'Error Message - ';
                            }
                    }
                    else if(this.isFilterSave == false){
                        console.log('this.isFilterSave==false');
                        this.getAllcaserecords();
                        this.getcaseowner();
                    }
                }
            //this.clickedButtonLabelCheck = true;
              //this.callOnRender();  
    else{
        console.log('Else--------->');
        if(this.objectVal == undefined || this.objectVal == '')
        {
            // console.log('this.objectVal value in if',this.objectVal);
            this.requiredField1 = true;
            this.errorMsg += ' Please select the Object Type,';
        }
        else
        {
            console.log('this.objectVal value in else',this.objectVal);
            this.requiredField1 = false;
        }

        if(this.objectField == undefined || this.objectField == '')
        {
            // console.log('this.objectField value in if',this.objectField);
            this.requiredField2 = true;
            this.errorMsg += ' Please select the Object Field Type,';
        }
        else
        {
            console.log('this.objectFieldVal value in else',this.objectFieldVal);
            this.requiredField2 = false;
        }

        if(this.selectedVal == undefined || this.objectVal == ' ')
        {
            // console.log('this.selectedVal value in if',this.selectedVal);
            this.errorMsg += ' Please select the Object Field Value Type,';
        }
        
        if(this.picklistVal == undefined || this.picklistVal == '')
        {
            // console.log('this.picklistVal value in if',this.picklistVal);
            this.requiredField3 = true;
            this.errorMsg += ' Please select the Dates.';
        }
        else
        {
            console.log('this.picklistVal value in else',this.picklistVal);
            this.requiredField3 = false;
        }

        if(this.businessNameVal == undefined || this.objectVal == '')
        {
            // console.log('this.hourNameStr value in if',this.businessNameVal);
            this.requiredField4 = true;
            this.errorMsg += ' Please select the Business Hour.';
        }
        else
        {
            console.log('this.hourNameStr value in else',this.businessNameVal);
            this.requiredField4 = false;
        }

        // if(this.filterName == undefined || this.objectVal == '')
        // {
        //     // console.log('this.hourNameStr value in if',this.businessNameVal);
        //     this.requiredField5 = true;
        //     this.errorMsg += 'Please fill unique filter name';
        // }
        // else
        // {
        //     this.requiredField5 = false;
        // }

        if(this.errorMsg != 'Error Message - ')
        {
            const evt = new ShowToastEvent({
                title: 'Error Message',
                message: this.errorMsg,
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(evt);
            this.errorMsg = 'Error Message - ';
        }
    }
        
        }

        console.log('clickedButtonLabel value--->',this.clickedButtonLabel);
        console.log('this.objectVal',this.objectVal);
        console.log('this.objectFieldVal',this.objectFieldVal);
        console.log('this.selectedVal',this.selectedVal);
        console.log('this.selectedVal1',this.selectedVal1);
        console.log('this.picklistVal',this.picklistVal);
        console.log('this.startdate',this.startdate);
        console.log('this.enddate',this.enddate);

        
       // averageTimeBatchClass shn = new averageTimeBatchClass(this.objectStr,this.objectFieldVal,this.selectedVal,this.selectedVal1,this.picklistVal,this.startdate,this.enddate); 
       // database.executeBatch(shn);
      
    }
  
    checkFilter(){
        console.log('\nthis.isFilterSave==true and check Filter');
        retriveFilter({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
        .then((data) => {
            if(data!=null){
                this.isCheckFilter = true;
                this.filterNameErr = data;
                console.log('Error check filter--',data);
                const event = new ShowToastEvent({
                    title: 'ERROR',
                    message: data,
                    variant: 'error '+data,
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
            }
            else{
                console.log('Error data else of data null',this.isCheckFilter);
                this.isCheckFilter = false;
                if(this.filterName!=null && this.filterName!='' && this.filterName!=' ' && this.isCheckFilter == false){
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
        console.log('getAllcaserecords = isCheckFilter = ',this.isCheckFilter);
   
    getAllcaserecord({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
    .then(result => {
      this.jobid = result;
    //   console.log('value of jobid',this.jobid);
     if(this.jobid!=null)
      {
        //    console.log('if');  
          var intervaldata =setInterval(function (jobid111,parentthis){   
          console.log('time halt started>>>'+jobid111);

          getBatchJobStatus({jobID: jobid111})
          .then(result => {
                  this.jobinfo = result;
                //   console.log('value of jobinfo',result);
          })
              if(jobinfo.Status=='Completed' )
          {
              clearInterval(intervaldata);
            //   console.log('passing');
              alert('batch is Completed');
              //this.myStopFunction();
              parentthis.callOnRender();
              //parentthis.runchart=true;      
          }
      }, 3000,this.jobid,this);
      this.myInterval=intervaldata;
    //    console.log('intervalid >>>>',this.myInterval);  
      }
      else{
        //   console.log('else');  
         alert('already saved');
           this.callOnRender(); 
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
  caseownerdel;
// case owner execution
    getcaseowner()
    {   
  getcaseowner({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh:this.isFilterSave,filterName:this.filterName})
    .then(result => {
    this.caseownerdel = result;
     console.log('value of this.caseownerdel',this.caseownerdel);
})
    }
   ///chart functionalitiy
    @api chartConfiguration;
    @track chartAmtData = [];
    @track chartLabel = [];
    @track selectedOption='bar';
    @api checkRendredChild=false;
    @api checkRendred=false;
    @track clickedButtonLabel;
  callOnRender(){
    //   console.log('call on render');
      getLeadByStatus1({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
            //  console.log('value of render>>>>',data);
             this.chartLabel=[];
            this.chartAmtData=[]; 
			  if (data) {
            for (let key in data) 
        {
            this.chartLabel.push(key);
            this.chartAmtData.push(data[key]);
        }
        // console.log('eeeeeeeeee', this.selectedOption);
        this.chartConfiguration = {
            type: this.selectedOption,
        data: {
            datasets: [{
                     label: 'Tracking Based On Average Time',
                    backgroundColor: ["red", "blue", "green", "blue", "red", "blue"],
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
        // console.log('no its becoming true>>>',this.chartConfiguration);
        
	 	})
 }

 backClick(event){
    console.log('Back Button is clicked');
    const childEvent = new CustomEvent("handleback", {detail: false});
    this.dispatchEvent(childEvent);
}


////////////////////////////////////////////

  @track dataSet;
    @track picklistVal;
     @track chartAmtData = [];
    @track chartLabel = [];
    @wire(pickListValueDynamically, {customObjInfo: {'sobjectType' : 'Case'},
    selectPicklistApi: 'Status'}) selectTargetValues;
        
      selectOptionChanveValue(event){       
           this.picklistVal = event.target.value;
           this.getcallby();
           //refreshApex(this.dataSet);
       }  

   getcallby()
   {
       console.log('ghdfhgdgdgh');
      getLeadByStatus({status: this.picklistVal,objectVal: this.objectVal,Field: this.objectField,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then(data=>{
             if (data) {

            console.log('resultdata',data);
            this.dataSet = data;
            //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
            this.Initializechartjs();
        } else if (result.error) 
        {
            return result.error;
        }
        
	 	}) 
   }
   handleMousemove(evt){
     this.Initializechartjs();  
   }
   /* @wire(getLeadByStatus, {status :'$picklistVal',objectVal:'$objectVal',Field:'$objectField',fieldValues:'$selectedVal',recordTypes:'$selectedVal1',businessHour:'$businessNameVal',dates:'$picklistVal',startDate:'$startdate',endDate:'$enddate',willRefresh:'$isFilterSave'}) 
    wiredLeads(result) 
    {
        if (result.data) {

            console.log('resultdata',result.data);
            this.dataSet = result.data;
             var labell = [];
           var count = [];
            for(var key in this.dataSet)
       {
              //this.updateChart(data[key].count,data[key].label);
              labell.push(this.dataSet[key].label);
            count.push(this.dataSet[key].count)
       }
      
         // console.log('labell',this.labell);
         //console.log('count',this.count);


            //setInterval(refreshApex.bind(this, this.dataSet), 5e3);
            this.Initializechartjs();
        } else if (result.error) 
        {
            return result.error;
        }
    }*/
    @api chartjsInitialized = false;
    renderedCallback() {
        if (this.chartjsInitialized) {
           
            return;
        }
        this.chartjsInitialized = true;
        Promise.all([
                loadScript(this, ChartJS)
            ])
            .then(() => {
                //this.Initializechartjs();
            })
            .catch(error => {
                console.log(error.message)
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
        console.log("loaded");
         console.log("dataSet',result.data",this.dataSet);
         console.log('Object.keys(this.dataSet',Object.keys(this.dataSet));
          console.log('Object.values(this.dataSet)',Object.values(this.dataSet));
          var labell = [];
          var count = [];
          for(let ownerLabel in Object.values(this.dataSet)){
              console.log('>>>>>>>>'+Object.values(this.dataSet)[ownerLabel]);
            labell.push(Object.values(this.dataSet)[ownerLabel].label);
            count.push(Object.values(this.dataSet)[ownerLabel].count);
          }
          console.log('labell',labell);
         console.log('count',count);

        var piechart;
        var ctx = this.template.querySelector(".pie-chart").getContext('2d');
        piechart = new Chart(ctx, {
            type: 'bar',
            data: {
                
                labels: labell,  
                datasets: [{
                    label: 'count',
                    data:count, 
                    backgroundColor: ["#0074D9", "#FF4136", "#2ECC40", "#FF851B", "#7FDBFF", "#B10DC9", "#FFDC00", "#001F3F", "#39CCCC", "#01FF70", "#85144B", "#F012BE", "#3D9970", "#111111", "#AAAAAA"]
                }],
                },
                options: {
         
                   },
        });
    }
}