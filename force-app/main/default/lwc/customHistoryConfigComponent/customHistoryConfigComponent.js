import { LightningElement } from 'lwc';
import getAllObjectDetail from '@salesforce/apex/CustomHistoryConfigurationController.getAllObjectDetail';
import saveObjects from '@salesforce/apex/CustomHistoryConfigurationController.saveObjects';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getAllFieldName from '@salesforce/apex/CustomHistoryConfigurationController.getAllFieldName';
import getSelectedFieldName from '@salesforce/apex/CustomHistoryConfigurationController.getSelectedFieldName';
export default class CustomHistoryConfigComponent extends LightningElement {
    objList = [];
    objValue = [];
    fieldValue = [];
    selectedField = [];
    allFieldSelected = [];
    objField;
    objFieldArr = [];
    isObject = true;
    isField = false;
    alpha ='';
    get alphabutton(){
        return ['A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'];
    }
    get options() {
        // console.log('OBJLIST==', this.objList);
        return this.objList;
    }
    connectedCallback() {
     this.alpha='A';
     this.objname();
    }
    objname(){
         console.log('Alpha======',this.alpha);
        getAllObjectDetail({alphaa:this.alpha})
            .then((result) => {
                var obj = [];
                result.map((val) => {
                    obj.push({ label: val.QualifiedApiName, value: val.QualifiedApiName })
                })
                this.objList = obj;
            })
            .catch((err) => {
                // console.log('Error==', err);
            });
    }
    onAlphaselect(e){
        console.log('e.detail.value========= OBj Alpha======',e.target.label);
        this.alpha=e.target.label;
        this.objname();
    }
    handleChange(e) {
        // console.log('value selected = ', e.detail.value);
        this.objValue = e.detail.value;
    }
    onObjeSave() {
        // console.log('obje selected');
        // console.log('objList==', this.objValue);
        this.isField = true;
        this.isObject = false;
        getSelectedFieldName({ objList: this.objValue })
            .then((data1) => {
                var select = [];
                var selectObj = [];
                for (var i = 0; i < this.objValue.length; i++) {
                    for (var key in data1) {
                        if (key == this.objValue[i]) {
                            select = [];
                            data1[key].map(val => {
                                // console.log('sell===========', val);
                                select.push(val);
                            })
                            selectObj.push({ key: this.objValue[i], val: select });
                        }
                    }
                }
                this.selectedField = selectObj;
                // console.log('this.selectedField===>', this.selectedField);
            })

        getAllFieldName({ objList: this.objValue })
            .then((data) => {
                var obj = [];
                var field = [];
                for (var i = 0; i < this.objValue.length; i++) {
                    for (var key in data) {
                        if (key == this.objValue[i]) {
                            field = [];
                            data[key].map((val) => {
                                field.push({ label: val, value: val });
                            })
                            obj.push({ key: this.objValue[i], val: field });
                        }
                    }
                }
                this.fieldValue = obj;
                this.alField();
            })
    }
    alField() {
        var obj = [];
        var selectF = [];
        this.fieldValue.forEach(currentItem => {
            selectF = [];
            this.selectedField.forEach(currentItem1 => {
                if (currentItem1.key == currentItem.key) {
                    if (currentItem1.val != undefined || currentItem1.val != null) {
                        selectF.push(currentItem1.val);
                    }
                    if(currentItem1.val == undefined || currentItem1.val == null) {
                        selectF.push(' ');
                    }
                }                
            })       
            console.log('selectF.length=', selectF.length);
            if(selectF.length==1){
                obj.push({ ...currentItem, value: selectF[0]});
            }
            if(selectF.length==0){
                obj.push({ ...currentItem, value: selectF});
            }
        })
        this.allFieldSelected = obj;
        console.log('OBJ=======> alField====>', this.allFieldSelected);
    }
    handlefieldChange(e) {
        console.log(' this.objFieldArr===', this.objFieldArr);
        var dummy = [];
        if (this.objFieldArr.length == 0) {
            for (var i = 0; i < this.allFieldSelected.length; i++) {
                   dummy.push({ key: this.allFieldSelected[i]['key'], val:this.allFieldSelected[i]['value']});
            }
        }
        else {
            dummy = this.objFieldArr;
        }
        console.log('obj 1==', dummy);
        for (var key in dummy) {
            console.log('if(dummy[key])=', dummy[key]['key']);
            if (dummy[key]['key'] == e.currentTarget.dataset.id) {
                dummy[key]['val'] = e.detail.value;
            }
        }
        console.log('obj dummy==', dummy);
        this.objFieldArr = dummy;
        console.log(' this.objFieldArr===', this.objFieldArr);
    }
    onObjeFieldSave() {
        console.log('click this.objFieldArr==>', this.objFieldArr);
        var dummy = [];
        this.message = '';
        if (this.objFieldArr.length == 0) {
            for (var i = 0; i < this.allFieldSelected.length; i++) {
                   dummy.push({ key: this.allFieldSelected[i]['key'], val:this.allFieldSelected[i]['value']});
            }
               this.objFieldArr = dummy;
        }
        else{
            console.log('this.objFieldArr=========>',this.objFieldArr);
        }
     
        console.log(' this.objFieldArr===', this.objFieldArr);
        this.objFieldArr.map(value => {
            console.log('value.val==', value.val.length);
            if (value.val === '' || value.val.length == 0) {
                this.message = 'Please select at least 1 field in ' + value.key;
                console.log('CANNOT EMPTY', value.key);
            }
        })
        console.log('message->', this.message);
        if(this.message!=''){
                const event = new ShowToastEvent({
                    title: 'ERROR',
                    message: this.message,
                    variant: 'error ',
                    mode: 'dismissable'
                });
                this.dispatchEvent(event);
        }
        if (this.message=='') {
            console.log('this.objFieldArr=====',this.objFieldArr);
            saveObjects({ objFieldArr: JSON.stringify(this.objFieldArr) })
                .then(() => {
                    const event = new ShowToastEvent({
                        title: 'SUCCESS',
                        message: 'success',
                        variant: 'success',
                        mode: 'dismissable'
                    });
                    this.dispatchEvent(event);
                })
        }
    }
}