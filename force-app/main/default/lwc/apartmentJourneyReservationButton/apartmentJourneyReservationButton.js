import { LightningElement, api } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

import RE_Arrange_A_Tour_Of_The_Apartment from "@salesforce/label/c.RE_Arrange_A_Tour_Of_The_Apartment";

export default class ApartmentJourneyReservationButton extends NavigationMixin(LightningElement) {
    @api recordId;

    label = {
        RE_Arrange_A_Tour_Of_The_Apartment,
      };

    handleClick(){
        console.log('clicked')
        this[NavigationMixin.Navigate]({
            type: 'comm__namedPage',
            attributes: {
                pageName: 'new-event'
            },
            state: {
                apartment: this.recordId
            }
        });
    }
}