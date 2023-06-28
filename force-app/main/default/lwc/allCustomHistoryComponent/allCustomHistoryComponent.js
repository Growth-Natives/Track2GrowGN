import { LightningElement ,api, track} from 'lwc';
import getHistoryData from '@salesforce/apex/allCustomHistoryComponentController.getHistoryData';
// import getSearchHistoryData from '@salesforce/apex/customHistoryComponentController.getSearchHistoryData';
export default class AllCustomHistoryComponent extends LightningElement {

@api recordId;
@api objectApiName;
@track records;
@track recHis;
@track searchVal = [];
@track noDataFound;
@track field;
@track fieldLabel;
@track message;
@track recordsAll;
@track totalRecountCount;
@track totalPage;
@track page = 1; 
@track result;
@track startingRecord = 1;
@track endingRecord = 0; 
@track pageSize = 10;
@track searchValMap = [];
@track allKeys = [];
@track isHisOn;
columns;


connectedCallback(){
    console.log('connectedCallback..');
    // console.log('this.recordId>>',this.recordId);
    // console.log('this.objectApiName>>',this.objectApiName);
    
getHistoryData()
.then(result => {
    this.records = result;
    this.recordsAll = result;
    console.log('records..',this.records);
    this.totalRecountCount = result.length; console.log('count',this.totalRecountCount); 
    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
    this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
    if(this.result){
                this.result.forEach(item => 
                item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                
            }
    this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
})  
}

columns = [
    { label: 'Date/Time', fieldName: 'timestamp' },
    { label: 'Object Name', fieldName: 'obj' },
    { label: 'Field', fieldName: 'field' },
    { label: 'User', fieldName: 'userURL', type: 'url', 
       typeAttributes: {label: { fieldName: 'user'}}},
    { label: 'Original Value', fieldName: 'oldVal' },
    { label: 'New Value', fieldName: 'newVal' },
];

changeHandler(event){
            console.log("HERE");
            var value = event.target.value;
            console.log("selected"+value);
            this.pageSize = value;
            console.log("page size"+this.pageSize);
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
            this.displayRecords(this.pageSize);
}

displayRecords(pageSize){
        this.startingRecord = ((this.page -1) * pageSize) ;
        this.endingRecord = (pageSize * this.page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) 
        ? this.totalRecountCount : this.endingRecord; 

        this.result = this.records.slice(this.startingRecord, this.endingRecord);
        console.log('new records',this.result);
        if(this.result){
                this.result.forEach(item => 
                item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                
            }
        this.startingRecord = this.startingRecord + 1;
}  


displayRecordPerPage(page){

        this.startingRecord = ((page -1) * this.pageSize) ;
        this.endingRecord = (this.pageSize * page);

        this.endingRecord = (this.endingRecord > this.totalRecountCount) ? this.totalRecountCount : this.endingRecord; 

        this.result = this.records.slice(this.startingRecord, this.endingRecord);
        console.log('new records',this.result);
        if(this.result){
                this.result.forEach(item => 
                item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                
            }
        this.startingRecord = this.startingRecord + 1;
}

previousHandler() {
        console.log("prev");
        this.isPageChanged = true;
        if (this.page > 1) {
        this.page = this.page - 1; //decrease page by 1
        this.displayRecordPerPage(this.page);
        }
}

nextHandler() {
            console.log("next");
            this.isPageChanged = true;
            if((this.page<this.totalPage) && this.page !== this.totalPage){
            this.page = this.page + 1; //increase page by 1
            this.displayRecordPerPage(this.page);            
        }
}
}