import { LightningElement } from 'lwc';
import getObject from '@salesforce/apex/SAPOrdersSchedule.scheduleClass';

export default class ConfigurationPage extends LightningElement {
    jobName = '';
    frequencyValue = '';
    monthlyPriority = '';
    preferredTime = '';
    monthlyDay='';
    monthlyOrdinal='';
    monthlyWeek='';

    value = [];
    days = [];
    preferredStartTime = [];

    isDay = false;
    isOrdinal = true;
    isWeekely = true;
    isMonthly = false;
    isDaily = false;
    isCustom = false;
    requireJobName = false;
    requireToSelectFrequency = false;
    requireToSelectWeekDays = false;
    requireStartDate = false;
    requireEndDate = false;
    requirePreferredTime = false;
    requireMonthlyPriority = false;

    startDate='';
    endDate='';

    get weekDay() {
        return [
            { label: 'Sunday', value: '1' },
            { label: 'Monday', value: '2' },
            { label: 'Tuesday', value: '3' },
            { label: 'Wednesday', value: '4' },
            { label: 'Thursday', value: '5' },
            { label: 'Friday', value: '6' },
            { label: 'Saturday', value: '7' },
        ];
    }
    get isWeekShow(){
        return this.isCustom || this.isWeekely;
    }
    get options(){
        return [{label: 'Custom', value: 'Custom' }];
    }
    get frqOption() {
        return [
            { label: 'Weekly', value: 'Weekly' },
             { label: 'Daily', value: 'Daily' },
            { label: 'Monthly', value: 'Monthly' }
        ];
    }
    get getOrdinalNumbers() {
        return [{label:'the 1st',value:'1'}, 
                {label:'the 2nd',value:'2'}, 
                {label:'the 3rd',value:'3'},  
                {label:'the 4th',value:'4'}, 
                {label:'the Last',value:'L'}];
    }
    get getMonthOption() {
        return [
            { label: 'On day', value: 'On day' },
            { label: 'On', value: 'On' },
        ];
    }

    connectedCallback() {
        this.frequencyValue = 'Weekly';
        this.isDay = false;
        this.isOrdinal = true;
        this.preferredStartTime =
         [{label:'12:00 AM',value:'0'}, 
                {label:'1:00 AM',value:'1'}, 
                {label:'2:00 AM',value:'2'},  
                {label:'3:00 AM',value:'3'}, 
                {label:'4:00 AM',value:'4'},
                {label:'5:00 AM',value:'5'},
                {label:'6:00 AM',value:'6'},
                {label:'7:00 AM',value:'7'},
                {label:'8:00 AM',value:'8'},
                {label:'9:00 AM',value:'9'},
                {label:'10:00 AM',value:'10'},
                {label:'11:00 AM',value:'11'},
                {label:'12:00 PM',value:'12'},
                {label:'1:00 PM',value:'13'},
                {label:'2:00 PM',value:'14'},
                {label:'3:00 PM',value:'15'},
                {label:'4:00 PM',value:'16'},
                {label:'5:00 PM',value:'17'},
                {label:'6:00 PM',value:'18'},
                {label:'7:00 PM',value:'19'},
                {label:'8:00 PM',value:'20'},
                {label:'9:00 PM',value:'21'},
                {label:'10:00 PM',value:'22'},
                {label:'11:00 PM',value:'23'}];
        for (var i = 1; i <= 31; i++) {
            this.days.push(i);
        }
        this.days.push('Last');
    }
    handleChange(event){
         this.isCustom = event.currentTarget.checked;
        console.log('isCustom--->',this.isCustom); 
    }
    onHandleJobNameChange(event) {
        console.log('event.currentTarget.value;===>', event.currentTarget.value);
        this.jobName = event.currentTarget.value;
    }
    onSelectMonthlyPriority(event) {
        this.monthlyPriority = event.currentTarget.value;
        console.log('onSelectMonthlyPriority change==>', event.currentTarget.value);
        if (this.monthlyPriority === 'day') {
            this.isDay = false;
            this.isOrdinal = true;
            this.monthlyOrdinal='';
            this.monthlyWeek='';
        }
        else {
            this.isDay = true;
            this.isOrdinal = false;
            this.monthlyDay='';
            this.monthlyOrdinal='the 1st';
            this.monthlyWeek='SUN';
        }
    }
    handleWeekChange(e) {
        this.value = e.detail.value;
        console.log('Weeks==>', this.value);
    }
    onSelectDay(e) {
        //this.value =e.detail.value;
        console.log('onSelectDay==>', e.target.value);
        this.monthlyDay = e.target.value;
    }
    onSelectOrdinal(e) {
        console.log('onSelectOrdinal==>', e.target.value);
       this.monthlyOrdinal = e.target.value;
        // console.log('Weeks==>',this.value);
    }
    onSelectWeek(e) {
        console.log('onSelectWeek==>', e.target.value);
        this.monthlyWeek = e.target.value;
        // console.log('Weeks==>',this.value);
    }
    onHandleFrequencyChange(event) {
        this.frequencyValue = event.currentTarget.value;
        console.log('frequency change==>', event.currentTarget.value);
        if (this.frequencyValue === 'Weekly') {
            this.isWeekely = true;
             this.value=[];
            this.monthlyPriority = '';
            this.monthlyDay='';
            this.isDay = false;
            this.isOrdinal = true;
            this.isMonthly = false;
            this.isDaily = false;
            //this.isCustom = false;
        }
        else if (this.frequencyValue === 'Monthly') {
            this.isWeekely = false;
            this.isMonthly = true;
            this.value=[];
            this.monthlyPriority = '';
            this.monthlyDay='1';
            this.isDay = false;
            this.isOrdinal = true;
            this.isDaily=false;
            //this.isCustom=false;
        }
        else if (this.frequencyValue === 'Daily') {
            this.isWeekely = false;
            this.isMonthly=false;
            this.value=[];
            this.monthlyPriority = '';
            this.monthlyDay='';
            this.isDay = false;
            this.isOrdinal = false;
            this.isDaily = true;
            //this.isCustom = false;
        }
        // else if (this.frequencyValue === 'Custom'){
        //     this.isWeekely = false;
        //     this.isMonthly=false;
        //     this.value=[];
        //     this.monthlyPriority = ' ';
        //     this.monthlyDay=' ';
        //     this.isDay = false;
        //     this.isOrdinal = false;
        //     this.isDaily = false;
        //     this.isCustom = true;
        // }
    }
    onStartDateChange(e) {
        this.startDate = e.currentTarget.value;
        console.log('startDate==>', this.startDate);
    }
    onEndDateChange(e) {
        this.endDate = e.currentTarget.value;
        console.log('endDate==>', this.endDate);
    }
    selectPreferredTime(event) {
        this.preferredTime = event.target.value;
    }
    onSaveClick() {
        console.log('this.monthlyPriority==',this.monthlyPriority);
        console.log('this.isCustom==',this.isCustom);
        if (this.jobName == '' || this.jobName == null || this.jobName == undefined) {
            this.requireJobName = true;
        }
        else {
            this.requireJobName = false;
        }
        if (this.frequencyValue == '' || this.frequencyValue == null || this.frequencyValue == undefined) {
            this.requireToSelectFrequency = true;
        }
        else {
            this.requireToSelectFrequency = false;
        }
        if ((this.isWeekely || this.isCustom) && (this.value.length == 0 || this.value == undefined || this.value == null)) {
            this.requireToSelectWeekDays = true;
        }
        else {
            this.requireToSelectWeekDays = false;
        }
        if (this.isCustom == true && (this.startDate == undefined || this.startDate == null || this.startDate == '')) {
            this.requireStartDate = true;
        }
        else {
            this.requireStartDate = false;
        }
        if (this.isCustom == true && (this.endDate == undefined || this.endDate == null || this.endDate == '')) {
            this.requireEndDate = true;
        }
        else {
            this.requireEndDate = false;
        }
        if (this.preferredTime == undefined || this.preferredTime == null || this.preferredTime == '') {
            this.requirePreferredTime = true;
        }
        else {
            this.requirePreferredTime = false;
        }
        if (this.isMonthly==true && this.monthlyPriority=='') {
            this.requireMonthlyPriority = true;
        }
        else {
            this.requireMonthlyPriority = false;
        }

        console.log('requireToSelectWeekDays===', this.requireToSelectWeekDays);
        if (this.requireJobName == false && this.requireToSelectFrequency == false && this.requireMonthlyPriority == false && this.requireStartDate == false && this.requireEndDate == false && this.requireToSelectWeekDays == false && this.requirePreferredTime == false) {
            getObject({ jobName: this.jobName, freqName:this.frequencyValue, weekday: this.value, startDate: this.startDate, endDate: this.endDate, preferredTime: this.preferredTime,monthlyPriority:this.monthlyPriority,monthlyDay:this.monthlyDay,monthlyOrdinal:this.monthlyOrdinal,monthlyWeek:this.monthlyWeek})
                .then(() => {
                    console.log('Val');
                })
        }
    }
}