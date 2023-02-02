import { LightningElement } from 'lwc';
import getAllObjectDetail from '@salesforce/apex/CustomHistoryConfigurationController.getAllObjectDetail';
import getAllFieldName from '@salesforce/apex/CustomHistoryConfigurationController.getAllFieldName';
export default class CustomHistoryConfigComponent extends LightningElement {
objList=[];
objValue = [];
fieldValue=[];
objField;
objFieldArr=[];
isObject = true;
isField = false;
get options() {
    console.log('OBJLIST==',this.objList);
    return  this.objList;
}

    connectedCallback() {
         getAllObjectDetail()
        .then((result) => {
            var obj=[];
            result.map((val)=>{
                        obj.push({label:val.QualifiedApiName,value:val.QualifiedApiName})
                })
                this.objList = obj;
        })
        .catch((err) => {
            console.log('Error==',err);
        });
    }
      handleChange(e) {
          console.log('value selected = ',e.detail.value);
        this.objValue = e.detail.value;
    }
    onObjeSave(){
        console.log('obje selected');
        console.log('objList==',this.objValue);
        this.isField = true;
        this.isObject = false;
        getAllFieldName({objList:this.objValue})
        .then((data)=>{
               var obj=[];
               var field=[];
               var objName=[];
             console.log('objList length=',this.objValue.length);
            // console.log('DATA==',data);
            for(var i=0;i<this.objValue.length;i++){
                
                for(var key in data){
                    console.log('data key length==',data[key].length);
                    console.log('abcdef');
                  
                    if(key==this.objValue[i]){
                        // objName.push(key);
                        field=[];
                        data[key].map((val)=>{
                            //  console.log('Key length=',key)
                            field.push({label:val,value:val});
                        })
                        obj.push({key:this.objValue[i],val:field});
                        console.log('obj 1==',obj);
                    }
                   
                //    console.log('OBJNAME==',objName);
                
                    //    console.log('obj 1==',objName);
                }
        }
            //   console.log('obj 1==',objName);
        })
    }
}