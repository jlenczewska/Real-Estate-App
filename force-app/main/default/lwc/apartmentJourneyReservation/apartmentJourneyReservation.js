import { LightningElement, api, track, wire } from "lwc";
import { CurrentPageReference } from "lightning/navigation";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getExistingEvents from "@salesforce/apex/RE_ApartmentJourneyEventsController.getExistingEvents";
import getAgentInfo from "@salesforce/apex/RE_ApartmentJourneyEventsController.getAgentInfo";
import addNewEvent from "@salesforce/apex/RE_ApartmentJourneyEventsController.addNewEvent";
import getProductData from "@salesforce/apex/RE_ApartmentJourneyController.getProductData";

import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";
import RE_Summary from "@salesforce/label/c.RE_Summary";
import RE_Arrange_A_Tour_Of_The_Apartment from "@salesforce/label/c.RE_Arrange_A_Tour_Of_The_Apartment";
import RE_Agent from "@salesforce/label/c.RE_Agent";
import RE_Time from "@salesforce/label/c.RE_Time";
import RE_Minutes from "@salesforce/label/c.RE_Minutes";
import RE_Booked_Apartment from "@salesforce/label/c.RE_Booked_Apartment";
import RE_Schedule_Event from "@salesforce/label/c.RE_Schedule_Event";
import RE_Back_To_Apartment_Page from "@salesforce/label/c.RE_Back_To_Apartment_Page";
import RE_Do_you_want_to_add_something from "@salesforce/label/c.RE_Do_you_want_to_add_something";
import RE_Select_Time from "@salesforce/label/c.RE_Select_Time";
import RE_Date from "@salesforce/label/c.RE_Date";
import RE_Date_And_Time from "@salesforce/label/c.RE_Date_And_Time";

export default class ApartmentJourneyReservation extends LightningElement {
  selectedDate = "";
  value = "";
  occupiedHours = [];
  enableSubmit = false;
  productData = {};
  isLoaded = false;

  @api displaySummary = false;

  @track displayedHours = [];
  @track today;
  @track agentInfo = {};

  label = {
    RE_Error_Occured,
    RE_Summary,
    RE_Arrange_A_Tour_Of_The_Apartment,
    RE_Agent,
    RE_Time,
    RE_Minutes,
    RE_Booked_Apartment,
    RE_Schedule_Event,
    RE_Back_To_Apartment_Page,
    RE_Do_you_want_to_add_something,
    RE_Select_Time,
    RE_Date,
    RE_Date_And_Time
  };

  @wire(CurrentPageReference)
  currentPageReference;

  allHours = [
    "9:00-9:30",
    "9:30-10:00",
    "10:00-10:30",
    "10:30-11:00",
    "11:00-11:30",
    "11:30-12:00",
    "12:00-12:30",
    "12:30-13:00",
    "13:00-13:30",
    "13:30-14:00",
    "14:00-14:30",
    "14:30-15:00"
  ];

  hours = [
    { label: "9:00-9:30", value: "9:00-9:30" },
    { label: "9:30-10:00", value: "9:00-9:30" },
    { label: "10:00-10:30", value: "9:00-9:30" },
    { label: "10:30-11:00", value: "9:00-9:30" },
    { label: "11:00-11:30", value: "9:00-9:30" },
    { label: "11:30-12:00", value: "9:00-9:30" },
    { label: "12:00-12:30", value: "9:00-9:30" },
    { label: "12:30-13:00", value: "9:00-9:30" },
    { label: "13:00-13:30", value: "9:00-9:30" },
    { label: "13:30-14:00", value: "9:00-9:30" },
    { label: "14:00-14:30", value: "9:00-9:30" },
    { label: "14:30-15:00", value: "9:00-9:30" }
  ];

  get options() {
    return this.hours;
  }
  get todaysDate() {
    var today = new Date();
    return today.toISOString();
  }

  connectedCallback() {
    this.isLoaded = false;
    getAgentInfo({
      recordId: this.currentPageReference.state.apartment
    })
      .then((data) => {
        this.agentInfo["FirstName"] = data.FirstName;
        this.agentInfo["LastName"] = data.LastName;
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
      });

    getProductData({
      recordId: this.currentPageReference.state.apartment
    })
      .then((data) => {
        this.productData = data;
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
      });
    this.isLoaded = true;
  }

  handleDateChange(event) {
    this.selectedDate = event.target.value;

    const newDate = new Date();
    const year = newDate.getFullYear();
    const month = newDate.getMonth() + 1;
    const d = newDate.getDate();

    if (new Date(this.selectedDate) <= newDate) {
      this.displayedHours = [];
      this.enableSubmit = false;
      return;
    }

    if (
      new Date(this.selectedDate).getDay() == 0 ||
      new Date(this.selectedDate).getDay() == 6
    ) {
      this.displayedHours = [];
      return;
    }

    this.getOccupiedHours();
  }

  getOccupiedHours() {
    this.occupiedHours = [];
    getExistingEvents({
      recordId: this.currentPageReference.state.apartment
    })
      .then((data) => {
console.log(data)

        for (let record of data) {
          if (this.selectedDate == record.StartDateTime.split("T")[0]) {
            for (let h of this.allHours) {
              if (
                record.EndDateTime.split("T")[1]
                  .replace(":00.000Z", "")
                  .replace(":", "")
                  .replace("09", "9") == h.split("-")[1].replace(":", "") &&
                record.StartDateTime.split("T")[1]
                  .replace(":00.000Z", "")
                  .replace(":", "")
                  .replace("09", "9") == h.split("-")[0].replace(":", "")
              ) {
                this.occupiedHours.push(h);
              }
            }
          }
        }

        this.filterHours();
      })

      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
      });
  }

  filterHours() {
    let temp = [];
    for (let h of this.allHours) {
      let pushHour = true;
      for (let oHour of this.occupiedHours) {
        if (oHour == h) {
          pushHour = false;
        }
      }
      if (pushHour) {
        temp.push({ label: h, value: h });
      }
    }
    this.displayedHours = temp;
  }

  handleChange(event) {
    this.value = event.detail.value;
    this.enableSubmit = true;
  }

  get getHours() {
    return this.displayedHours;
  }

  handleSubmit() {
    this.isLoaded = false;

    let addEventArguments = {};
    addEventArguments.apartmentId = this.currentPageReference.state.apartment;
    addEventArguments.meetingDate = this.selectedDate;
    addEventArguments.meetingTime = this.value;
    addEventArguments.description = this.template.querySelector(
      '[data-id="description"]'
    ).value;

    addNewEvent({
      addEventArguments: JSON.stringify(addEventArguments)
    })
      .then((data) => {
        if (data) {
          this.displaySummary = true;
        }
        this.isLoaded = true;
      })

      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
        this.isLoaded = true;
      });
  }

  handlePreviousPage() {
    var url = window.location.href;
    var value = url.substr(0, url.lastIndexOf("/") + 1);
    window.history.back();
    return false;
  }
}
