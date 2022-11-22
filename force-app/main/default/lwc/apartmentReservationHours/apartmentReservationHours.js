import { LightningElement } from 'lwc';

import getExistingEvents from '@salesforce/apex/RE_ApartmentJourneyController.getExistingEvents';

export default class ApartmentReservationHours extends LightningElement {

    // hours=['9:00-9:30', '9:30-10:00', '10:00-10:30',
    // '10:30-11:00', '11:00-11:30', '11:30-12:00',
    // '12:00-12:30', '12:30-13:00', '13:00-13:30',
    // '13:30-14:00', '14:00-14:30', '14:30-15:00']

    // displayedHours=[]

    // connectedCallback() {
    //     console.log('connectedCallback');
    //     console.log(`c__myParam = ${this.currentPageReference.state.apartment}`); 
    //     getExistingEvents({
    //         recordId: this.currentPageReference.state.apartment, 
    //     })
    //       .then((data) => {
    //         console.log(data)
    //         data.foreach(event => {
    //             let flag = true;
    //             hours.foreach(h => {

    //                 if(event.StartDateTime > h.split('-')[0]  && event.EndDateTime > h.split('-')[1]){
    //                    flag = false; 
    //                 }
    //         this.displayedHours.push(h);
    //             }
    //             )

    //             return { Id : event.Id, 
    //                     title : event.Subject, 
    //                     start : event.StartDateTime,
    //                     end : event.EndDateTime,
    //                     allDay : event.IsAllDayEvent};
    //         });
    //         this.events = JSON.parse(JSON.stringify(records));
    //         console.log(records);
    //         console.log(this.events);
    //         // this.events = "[{title: 'Front-End Conference',start: '2022-11-11T09:00:00',end: '2022-11-11T10:00:00'}]"
              
    //         console.log(this.events);
    //         this.error = undefined;
    //       })
    //       .catch((error) => {
    //         const evt = new ShowToastEvent({
    //           title: RE_Error_Occured,
    //           message: error["body"]["message"],
    //           variant: "error"
    //         });
    //         this.dispatchEvent(evt);

    //         this.events = [];
    //           this.error = 'No events are found';
    //       });

    //   }


}