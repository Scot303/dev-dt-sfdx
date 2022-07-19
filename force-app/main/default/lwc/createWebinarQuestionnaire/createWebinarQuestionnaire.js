/**
 * Created by dtoczko on 12.07.2022.
 */

import { LightningElement,api,wire } from 'lwc';
import USER_ID from '@salesforce/user/Id';
import USER_NAME_FIELD from '@salesforce/schema/User.Name';
import STATUS_FIELD from '@salesforce/schema/Webinar__c.Status__c';
import {getRecord, getFieldValue, createRecord} from 'lightning/uiRecordApi';
/*import AGE_FIELD from '@salesforce/schema/Webinar_Question__c.Age__c';
import NAME_FIELD from '@salesforce/schema/Webinar_Question__c.Name';
import ATTENDANCE from '@salesforce/schema/Webinar_Question__c.Attended__c';
import RECOMMENDS from '@salesforce/schema/Webinar_Question__c.Recommends__c';*/
import {ShowToastEvent} from 'lightning/platformShowToastEvent';
import {NavigationMixin} from 'lightning/navigation';

/*const FIELDS = [
    NAME_FIELD,
    AGE_FIELD,
    ATTENDANCE,
    RECOMMENDS
]*/

export default class createWebinarQuestionnaire extends NavigationMixin(LightningElement) {

    @api objectApiName;
    @api recordId;
    @api title;
    userId = USER_ID;

    _message = 'Webinar Questionnaire created!';
    questionnaireId;
    hideForm = false;
    hideReason = true;
    hideTable = true;
    buttonLabel = 'Show My Questionnaires';

    @wire(getRecord, {recordId: '$recordId', fields: [STATUS_FIELD]})
    webinar;

    @wire(getRecord, {recordId: USER_ID, fields: [USER_NAME_FIELD]})
    userData({error, data}) {
        if (error) {
            this.error = error;
        } else if (data) {
            this.title = `Hi ${data.fields.Name.value}! Share your feedback with us!`;
        }
    }

    @api get message(){
        return this._message;
    }

    set greeting(value){
        this.title = value;
    }

    set message(value){
        this._message = value;
    }

    get isCompleted(){
        return getFieldValue(this.webinar.data, STATUS_FIELD) === 'Completed';
    }

    hideShowForm(event){
        this.hideForm = event.target.value;
    }

    hideShowReason(event){
        this.hideReason = event.target.value;
    }

    hideTableEvent(){
        this.hideTable = !this.hideTable;
        this.buttonLabel = (this.hideTable ? 'Show My Questionnaires' : 'Close');
    }

    navigateNext(id){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: id,
                objectApiName: 'Webinar_Question__c',
                actionName: 'view'
            }
        })
    }

    toastOfCreation()
    {
        const event = new ShowToastEvent({
            title: 'Questionnaire created!',
            message: this._message,
            variant: 'success',
            mode: 'dismissable'
        });
        this.dispatchEvent(event);
    }

    handleSubmit(event){
        event.preventDefault();
        const fields = event.detail.fields;
        fields.Webinar__c = this.recordId;
        const record = {'apiName': 'Webinar_Question__c', 'fields': fields}
        createRecord(record).then(success => {
            this.toastOfCreation();
            this.navigateNext(success.id);
        });
    }

}