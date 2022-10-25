import { LightningElement, api, wire, track } from 'lwc';
import { getRecord , getFieldValue } from 'lightning/uiRecordApi';
import NAME_FIELD_STREET from '@salesforce/schema/Product2.Street__c';
import NAME_FIELD_CITY from '@salesforce/schema/Product2.City__c';
import NAME_FIELD_STATE from '@salesforce/schema/Product2.State__c';
import NAME_FIELD_COUNTRY from '@salesforce/schema/Product2.Country__c';

const FIELDS = [
    'Product2.Street__c',
    'Product2.City__c',
    'Product2.State__c',
    'Product2.Country__c',
];

export default class LocationMap extends LightningElement {
    
    @track mapMarkers = [];
    @api recordId;

    @wire(getRecord, { recordId: '$recordId', fields: FIELDS })
    wiredProduct({error, data}){
        if(data){
           
            this.mapMarkers = [
                {
                    location: {
                        Street: data.fields.Street__c.value,
                        City: data.fields.City__c.value,
                        State: data.fields.State__c.value,
                        Country: data.fields.Country__c.value,
                    },
                    title: "Promise Location",
                    description:data.fields.Street__c.value +' ' + data.fields.City__c.value+' '+data.fields.Country__c.value
                },
            ];
        }else{
            this.error = error; 
        }
    }
}