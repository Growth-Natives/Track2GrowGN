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
    requireJobName = false;
    requireToSelectFrequency = false;
    requireToSelectWeekDays = false;
    requireStartDate = false;
    requireEndDate = false;
    requirePreferredTime = false;
    requireMonthlyPriority = false;

    startDate;
    endDate;

    get weekDay() {
        return [
            { label: 'Sunday', value: 'SUN' },
            { label: 'Monday', value: 'MON' },
            { label: 'Tuesday', value: 'TUE' },
            { label: 'Wednesday', value: 'WED' },
            { label: 'Thursday', value: 'THU' },
            { label: 'Friday', value: 'FRI' },
            { label: 'Saturday', value: 'SAT' },
        ];
    }
    get frqOption() {
        return [
            { label: 'Weekly', value: 'Weekly' },
            { label: 'Monthly', value: 'Monthly' },
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
        this.monthlyPriority = 'day';
        this.isDay = false;
        this.isOrdinal = true;
        this.preferredStartTime = ['00', '01', '02', '03', '04', '05', '06', '07', '08', '09', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23'];
        for (var i = 1; i <= 31; i++) {
            this.days.push(i);
        }
        this.days.push('Last');
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
        }
        else {
            this.isWeekely = false;
            this.monthlyPriority = 'day';
            this.monthlyDay='1';
            this.isDay = false;
            this.isOrdinal = true;
        }
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
        if (this.isWeekely && (this.value.length == 0 || this.value == undefined || this.value == null)) {
            this.requireToSelectWeekDays = true;
        }
        else {
            this.requireToSelectWeekDays = false;
        }
        if (this.startDate == undefined || this.startDate == null || this.startDate == '') {
            this.requireStartDate = true;
        }
        else {
            this.requireStartDate = false;
        }
        if (this.endDate == undefined || this.endDate == null || this.endDate == '') {
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
        if (this.isWeekely == false && this.monthlyPriority == '') {
            this.requireMonthlyPriority = true;
        }
        else {
            this.requireMonthlyPriority = false;
        }

        console.log('requireToSelectWeekDays===', this.requireToSelectWeekDays);
        if (this.requireJobName == false && this.requireToSelectFrequency == false && this.requireMonthlyPriority == false && this.requireStartDate == false && this.requireEndDate == false && this.requireToSelectWeekDays == false && this.requirePreferredTime == false) {
            getObject({ jobName: this.jobName, weekday: this.value, startDate: this.startDate, endDate: this.endDate, preferredTime: this.preferredTime,monthlyPriority:this.monthlyPriority,monthlyDay:this.monthlyDay,monthlyOrdinal:this.monthlyOrdinal,monthlyWeek:this.monthlyWeek})
                .then(() => {
                    console.log('Val');
                })
        }
    }
}