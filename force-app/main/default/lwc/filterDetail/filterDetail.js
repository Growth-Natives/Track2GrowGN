import { LightningElement,track,api,wire } from 'lwc';
import getFilterDetail from '@salesforce/apex/FilterDetailController.getFilterDetail';
import deleteFilter from '@salesforce/apex/FilterDetailController.deleteFilter';
import getFilterDetailFromName from '@salesforce/apex/FilterDetailController.getFilterDetailFromName';
import getDetail from '@salesforce/apex/FilterDetailController.getDetail';
import { refreshApex } from '@salesforce/apex';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class FilterDetail extends LightningElement {
    datas;
    isfilterNameSelected = false;
    @track isCreateFilter = false;
    @track selectedFilterName;
    @track getFilterDetails = [];
    @track clickedButtonLabelCheck=false;
    @track filterDetailVal=[];
    @track filterListCheck = true;
    @track cardCheck = true;
    @track cardTitle = "Filter List";
    @track backHandle = false;
    @track detailHide = true;
   
    // render filter list 
    @wire(getFilterDetail)  filterList(result){
        this.getFilterDetails = result;
        if(result.data){
            this.datas = result.data.map( objPL => {
                return {
                    label: `${objPL.Filter_Name__c}`,
                    value: `${objPL.Filter_Name__c}`
                };
            });
        }
        console.log('datas',this.datas);
    }
    
    // 
    @api chartConfiguration;
    @track chartAmtData = [];
    @track chartLabel = [];
    @track selectedOption='bar';
    @api checkRendredChild=false;
    @api checkRendred=false;
    @track clickedButtonLabel;
    
    // on change filter name
    selectFilterNameChange(event)
    {  
        console.log('Val-->',JSON.stringify(this.getFilterDetails));

        if(this.selectedFilterName!=event.currentTarget.dataset.id){
            this.clickedButtonLabelCheck = false;
        }
        this.selectedFilterName = event.currentTarget.dataset.id;
        this.isfilterNameSelected = true;
        getDetail({name:this.selectedFilterName})
        .then(data=>{
            this.filterDetailVal = data;
        })
        this.filterListCheck = false;
        this.cardCheck = true;
        this.cardTitle = "Filter Detail > " + event.currentTarget.dataset.id;
        this.backHandle = true;
        this.detailHide = true;
        getFilterDetailFromName({filterName: this.selectedFilterName})
        .then(data=>{
                console.log('value of render>>>>',data);
                this.chartLabel=[];
                this.chartAmtData=[]; 
                if (data) {
                    for (let key in data) 
                    {
                        this.chartLabel.push(key);
                        this.chartAmtData.push(data[key]);
                    }
                    this.chartConfiguration = {
                        type: this.selectedOption,
                        data: {
                            datasets: [{
                                label: 'Tracking Based On Average Time',
                                backgroundColor: ["red", "blue", "green", "blue", "red", "blue"],
                                data: this.chartAmtData,
                            }],
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

    // on create filter
    createFilter()
    {
            this.isCreateFilter = true;
            this.clickedButtonLabelCheck = false;
    }

    // handle delete
    handleDeleteFilter(event){
        console.log('handleDeleteFilter ');
        const filterName = event.currentTarget.dataset.id;
        this.selectedFilterName = '';
        this.isfilterNameSelected = false;
        this.clickedButtonLabelCheck = false;
        this.filterDetailVal='';
        deleteFilter({filterName:filterName})
        .then(()=>{
            refreshApex(this.getFilterDetails); 
            const event = new ShowToastEvent({
                title: 'Successfully',
                message: 'Filter Deleted Successfully',
                variant: 'success',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        })
        .catch(()=>{
            const event = new ShowToastEvent({
                title: 'Error',
                message: 'Error in Deleting Record',
                variant: 'error',
                mode: 'dismissable'
            });
            this.dispatchEvent(event);
        })
    }
    
   // chart
    callOnRender(){
    //   console.log('call on render');
      getLeadByStatus1({objectVal: this.objectVal,Field: this.objectField,fieldValues: this.selectedVal,recordTypes: this.selectedVal1,businessHour:this.businessNameVal,dates: this.picklistVal,startDate: this.startdate,endDate: this.enddate,willRefresh: this.isFilterSave})
		.then()
    }

    // handle back
    handleBack(event){
        console.log('BACK----<');
        this.isCreateFilter = event.detail;
        this.clickedButtonLabelCheck = false;
        refreshApex(this.getFilterDetails); 
    }
    detailBackClick(){
        console.log('DETAIL BACK-----<');
        this.cardCheck = true;
        this.filterListCheck = true;
        this.detailHide = false;
        this.backHandle = false;
        this.cardTitle = "Filter List"
        console.log("false check",this.isCreateFilter);
    }
}