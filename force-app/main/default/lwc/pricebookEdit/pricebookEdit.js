import { LightningElement, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import updatePricebookDateActive from "@salesforce/apex/RE_pricebookExplorerController.updatePricebookDateActive";

import RE_See_Details from "@salesforce/label/c.RE_See_Details";
import RE_Close from "@salesforce/label/c.RE_Close";
import RE_Cancel from "@salesforce/label/c.RE_Cancel";
import RE_IsActive from "@salesforce/label/c.RE_IsActive";
import RE_Start_Day from "@salesforce/label/c.RE_Start_Day";
import RE_End_Day from "@salesforce/label/c.RE_End_Day";
import RE_Something_Went_Wrong from "@salesforce/label/c.RE_Something_Went_Wrong";
import RE_Pricebook_Successfully_Updated from "@salesforce/label/c.RE_Pricebook_Successfully_Updated";
import RE_Save from "@salesforce/label/c.RE_Save";
import RE_Invalid_Dates from "@salesforce/label/c.RE_Invalid_Dates";
import RE_The_End_Date_Must_Be_Later_Than_The_Start_Date from "@salesforce/label/c.RE_The_End_Date_Must_Be_Later_Than_The_Start_Date";
import RE_Review_The_Data_And_Try_Again from "@salesforce/label/c.RE_Review_The_Data_And_Try_Again";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

export default class PricebookEdit extends LightningElement {
  @api buttonDisabled;
  @api checkDataChaged;
  @api isModalOpenEdit = false;
  @api pricebookInfoDates;
  @api editAvailable;

  label = {
    RE_See_Details,
    RE_Close,
    RE_Something_Went_Wrong,
    RE_Pricebook_Successfully_Updated,
    RE_Start_Day,
    RE_End_Day,
    RE_IsActive,
    RE_Save,
    RE_Cancel,
    RE_Invalid_Dates,
    RE_The_End_Date_Must_Be_Later_Than_The_Start_Date,
    RE_Review_The_Data_And_Try_Again,
    RE_Something_Went_Wrong,
    RE_Error_Occured
  };

  connectedCallback() {
    this.checkDataChaged = true;
    this.buttonDisabled = true;
  }

  get getButtonDisabled() {
    return this.pricebookInfoDates.ValidFrom ? false : true;
  }

  get valuesDisabled() {
    return this.editAvailable ? false : true;
  }

  openModalEdit() {
    this.isModalOpenEdit = true;
  }
  closeModalEdit() {
    this.isModalOpenEdit = false;
  }

  checkPremiseDates() {
    let sDay = this.template.querySelector(
      'lightning-input[data-name="Start_Day"]'
    ).value;
    let eDay = this.template.querySelector(
      'lightning-input[data-name="End_Day"]'
    ).value;

    if (sDay > eDay) {
      const evt = new ShowToastEvent({
        title: this.label.RE_Invalid_Dates,
        message: this.label.RE_The_End_Date_Must_Be_Later_Than_The_Start_Date,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }
    return false;
  }

  handleDataChange() {
    this.checkDataChaged = false;
  }

  submitDetailsEdit() {
    const incorrectDataDates = this.checkPremiseDates();

    if (incorrectDataDates) {
      return;
    }

    updatePricebookDateActive({
      pricebookId: this.pricebookInfoDates.Id,
      startDay: this.template.querySelector(
        'lightning-input[data-name="Start_Day"]'
      ).value,
      endDate: this.template.querySelector(
        'lightning-input[data-name="End_Day"]'
      ).value,
      isActive: this.template.querySelector(
        'lightning-input[data-name="IsActive"]'
      ).checked
    })
      .then((data) => {
        if (data) {
          const evt = new ShowToastEvent({
            title: this.label.RE_Pricebook_Successfully_Updated,
            message: this.editedPricebookName,
            variant: "success"
          });
          this.dispatchEvent(evt);
          this.isModalOpenEdit = false;

          const callParentEvent = new CustomEvent("refreshdata");
          this.dispatchEvent(callParentEvent);

          this.closeModalEdit();
        } else {
          const evt = new ShowToastEvent({
            title: this.label.RE_Something_Went_Wrong,
            message: this.label.RE_Review_The_Data_And_Try_Again,
            variant: "info"
          });
          this.dispatchEvent(evt);
        }
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
}
