import { LightningElement ,api, track} from 'lwc';
import getHistoryData from '@salesforce/apex/customHistoryComponentController.getHistoryData';
import getSearchHistoryData from '@salesforce/apex/customHistoryComponentController.getSearchHistoryData';
import getFields from '@salesforce/apex/customHistoryComponentController.getFields';
import fetchLookupData from '@salesforce/apex/customHistoryComponentController.fetchLookupData';
// import { NavigationMixin } from 'lightning/navigation';
export default class CustomHistoryComponent extends LightningElement {

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
@track pageSize = 2;
@track searchValMap = [];
@track allKeys = [];
@track isHisOn;
@track isModalOpen = false;
@track searchVal1;
@track allFields;
@track havingValue = false;
@track searchKey;
@track showFields;
columns;

 
connectedCallback(){
    console.log('connectedCallback..');
    console.log('this.recordId>>',this.recordId);
    console.log('this.objectApiName>>',this.objectApiName);
    
getHistoryData({
                 recid: this.recordId,
               })
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

getFields({
    Obj : this.objectApiName,
})
.then(result => {
    this.allFields = result;
    console.log('this.allFields>>',this.allFields);
})
// isHistoryOn({
//     obj : this.objectApiName,
//     recId: this.recordId,
// })
// .then(val=> {
//     this.isHisOn = val;
//     console.log('isHisOn,,',this.isHisOn);
// })
}


 onselection(event) {
        this.searchVal2 = event.target.dataset.name;
        this.showFields = [];
        this.havingValue=false;
        this.field = 'field';
        this.handleSearch();
    }


fieldLookup(){
    console.log('in fieldLookup');
    fetchLookupData({
        searchKey : this.searchKey, allFields : this.allFields,
    })
    .then(result => {
        this.showFields = result;  
        // console.log('this.showFields>>',this.showFields); 
        // console.log('this.showFields.length>>',this.showFields.length);
    })
    if(this.showFields.length>0)
    {
    this.havingValue=true;
    }
}


columns = [
    { label: 'Date/Time', fieldName: 'timestamp' },
    { label: 'Field', fieldName: 'field' },
    { label: 'User', fieldName: 'userURL', type: 'url', 
       typeAttributes: {label: { fieldName: 'user'}}},
    { label: 'Original Value', fieldName: 'oldVal' },
    { label: 'New Value', fieldName: 'newVal' },
];

handleChange1(event){
    console.log('in handleChange1');
    this.field == 'field'
    this.searchVal = event.target.value;
    console.log('searchval>>',this.searchVal);
    if(this.searchVal == '' || this.searchVal == null)
    {
        console.log('searchval null');
     for (var key in this.searchValMap) 
        {
         for(var i in this.searchValMap[key])
         {
            console.log('i', i);console.log('this.searchValMap[key][i]', this.searchValMap[key][i]);
           if(i == 'field')
                   {
                       console.log('inn');
                       this.searchValMap[key][i] = ''; 
                   }
                   console.log('this.searchValMap>',this.searchValMap);
            }
         }
         this.getSearchData();
         }
}
handleChange(event) {
        this.searchVal = event.target.value;
        this.fieldLabel = event.target.label;
        if(this.fieldLabel=='Date/Time')
        {
            this.searchVal1 = ''; 
        }
        if(this.fieldLabel=='Start Date'){
            this.searchVal1 = this.searchVal; 
        }
        if(this.fieldLabel=='End Date'){
            if(this.searchVal1 != undefined)
            {
            this.searchVal1 = this.searchVal1 +' - '+ this.searchVal; 
            }
            else{
                this.searchVal1 = this.searchVal;
            }
        }
        if(this.fieldLabel=='Field'){
            this.searchKey = event.target.value;
            this.fieldLookup();
        }
        console.log('this.searchVal..'+this.searchVal);
        console.log('this.fieldLabel..'+this.fieldLabel);
        console.log('this.searchVal1..'+this.searchVal1);
        // console.log('this.searchValMap>>',this.searchValMap);
        // console.log('this.searchValMap.length>>',this.searchValMap.length);
        this.handleSearch();
  
    }

    handleSearch(){
        if(this.searchValMap.length == 0)
  {
      console.log('this...'+this.fieldLabel);
        if(this.fieldLabel=='Start Date'){ 
         this.field = 'startdate';
         this.searchValMap.push({startdate : this.searchVal});
        }
         else if(this.fieldLabel=='End Date'){
         this.field = 'enddate';
         this.searchValMap.push({enddate : this.searchVal});
        }
        else if(this.fieldLabel=='Field'){
        this.field = 'field';
        this.searchValMap.push({field : this.searchVal2});
        }
        else if(this.fieldLabel=='User'){
        this.field = 'user';
        this.searchValMap.push({user : this.searchVal});
        }
        else if(this.fieldLabel=='Original Value'){
        this.field = 'oldVal';
        this.searchValMap.push({oldVal : this.searchVal});
        }
        else if(this.fieldLabel=='New Value'){
        this.field = 'newVal';
        this.searchValMap.push({newVal : this.searchVal});
        }
        
        console.log('this.searchValMap>>',this.searchValMap);
}

 else
 {
     let allKeys = [];
                if(this.fieldLabel=='Start Date'){ 
                    this.field = 'startdate';
                }
                else if(this.fieldLabel=='End Date'){
                    this.field = 'enddate';
                }
                else if(this.fieldLabel=='Field'){
                this.field = 'field';
                }
                else if(this.fieldLabel=='User'){
                this.field = 'user';
                }
                else if(this.fieldLabel=='Original Value'){
                this.field = 'oldVal';
                }
                else if(this.fieldLabel=='New Value'){
                this.field = 'newVal';
                }
                

        for (var key in this.searchValMap) 
        {
         //console.log('value', this.searchValMap[key]);
         for(var i in this.searchValMap[key])
         {
            console.log('i', i);console.log('this.searchValMap[key][i]', this.searchValMap[key][i]);
            allKeys.push(i);
            if(this.field == i)
            {
               console.log('contains key...');
               if(this.field =='startdate' && (this.searchVal1 == undefined || this.searchVal1 == ''))
                {
                    console.log('in null...'); 
                    this.searchValMap[key][i] = ''; 
                }
                else
                {
                   console.log('in else...'); 
                   if(this.field == 'field')
                   {
                       this.searchValMap[key][i] = this.searchVal2; 
                   }
                   else
                   {
                   this.searchValMap[key][i] = this.searchVal; 
                   }
                }
            }
         }
        }

        console.log('allKeys',allKeys);
        console.log('includes>>',allKeys.includes(this.field));

            if(!allKeys.includes(this.field))
            {
                if(this.fieldLabel=='Start Date'){ 
                this.field = 'startdate';
                this.searchValMap.push({startdate : this.searchVal});
                }
                else if(this.fieldLabel=='End Date'){
                this.field = 'enddate';
                this.searchValMap.push({enddate : this.searchVal});
                }
                else if(this.fieldLabel=='Field'){
                this.field = 'field';
                this.searchValMap.push({field : this.searchVal2});
                }
                else if(this.fieldLabel=='User'){
                this.field = 'user';
                this.searchValMap.push({user : this.searchVal});
                }
                else if(this.fieldLabel=='Original Value'){
                this.field = 'oldVal';
                this.searchValMap.push({oldVal : this.searchVal});
                }
                else if(this.fieldLabel=='New Value'){
                this.field = 'newVal';
                this.searchValMap.push({newVal : this.searchVal});
                }
        }
    console.log('this.searchValMap>>',this.searchValMap);
 }
   this.getSearchData();
}


getSearchData(){
    if (this.searchValMap != []) {
        console.log('searchmap>>',this.searchValMap);
            console.log('JSON.stringify(this.searchValMap)>>',JSON.stringify(this.searchValMap));
            getSearchHistoryData({ recid: this.recordId , searchVal: JSON.stringify(this.searchValMap), data: this.recordsAll})
                .then(data => {
                    console.log('data>>>',data);
                    if (data.length > 0) {
                        this.records = data; console.log('records..',this.records);
                        this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
                        if(this.result){
                                            this.result.forEach(item => 
                                            item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                                            
                                        }
                        this.totalRecountCount = data.length; console.log('count',this.totalRecountCount); 
                        this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
                        this.page = 1;
                        this.startingRecord = 1;
                        this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
                        //this.noDataFound = false;
                    }
                    else {
                        this.result = data;
                        if(this.result){
                                        this.result.forEach(item => 
                                        item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                                        
                                    }
                        this.message = "No data found with searchkey " + this.searchVal +' for '+ this.field+ ' field.';
                        //alert(this.message);
                        //this.noDataFound = true;
                    }
                })
        }
        else if(this.searchVal == '' || this.searchVal == null)
        {
            console.log('in null');
            getHistoryData({
                            recid: this.recordId
                            })
                    .then(result => {
                    this.records = result; console.log('records..',this.records);
                    this.result = this.records.slice(0,this.pageSize); console.log('res',this.result); 
                    if(this.result){
                                    this.result.forEach(item => 
                                    item['userURL'] = '/lightning/r/User/' +item['createdById'] +'/view');
                                    
                                }
                    this.totalRecountCount = result.length; console.log('count',this.totalRecountCount); 
                    this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
                    this.endingRecord = this.pageSize;console.log('end',this.endingRecord); 
                })
        }
}

    changeHandler(event){
            console.log("HERE");
            var value = event.target.value;
            console.log("selected"+value);
            this.pageSize = value;
            console.log("page size"+this.pageSize);
            this.totalPage = Math.ceil(this.totalRecountCount / this.pageSize); console.log('tot page',this.totalPage); 
            this.displayRecords(this.pageSize);
}

openModal(){
    this.isModalOpen = true;
}

closeModal() {
    this.isModalOpen = false;
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