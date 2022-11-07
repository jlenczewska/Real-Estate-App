import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getMissingRecords from "@salesforce/apex/RE_pricebookExplorerController.getMissingRecords";
import addRecordsToPricebook from "@salesforce/apex/RE_pricebookExplorerController.addRecordsToPricebook";

import RE_Edit_Pricebook from "@salesforce/label/c.RE_Edit_Pricebook";
import RE_Close from "@salesforce/label/c.RE_Close";
import RE_Cancel from "@salesforce/label/c.RE_Cancel";
import RE_Something_Went_Wrong from "@salesforce/label/c.RE_Something_Went_Wrong";
import RE_Pricebook_Successfully_Updated from "@salesforce/label/c.RE_Pricebook_Successfully_Updated";
import RE_Save from "@salesforce/label/c.RE_Save";
import RE_Invalid_Dates from "@salesforce/label/c.RE_Invalid_Dates";
import RE_The_End_Date_Must_Be_Later_Than_The_Start_Date from "@salesforce/label/c.RE_The_End_Date_Must_Be_Later_Than_The_Start_Date";
import RE_Review_The_Data_And_Try_Again from "@salesforce/label/c.RE_Review_The_Data_And_Try_Again";
import RE_Add_Records from "@salesforce/label/c.RE_Add_Records";
import RE_Add_Records_To_Pricebook from "@salesforce/label/c.RE_Add_Records_To_Pricebook";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

export default class PricebookAddRecords extends LightningElement {
  @api buttonDisabled;
  @api checkDataChaged;
  @api isModalOpenEdit = false;
  @api productsInfo;
  @api pricebookId;
  @api missingProducts;
  @api editAvailable;

  label = {
    RE_Close,
    RE_Something_Went_Wrong,
    RE_Pricebook_Successfully_Updated,
    RE_Save,
    RE_Cancel,
    RE_Edit_Pricebook,
    RE_Invalid_Dates,
    RE_The_End_Date_Must_Be_Later_Than_The_Start_Date,
    RE_Review_The_Data_And_Try_Again,
    RE_Something_Went_Wrong,
    RE_Add_Records,
    RE_Add_Records_To_Pricebook,
    RE_Error_Occured
  };

  connectedCallback() {
    this.buttonDisabled = true;
  }

  get getButtonDisabled() {
    return JSON.parse(JSON.stringify(this.productsInfo)).length ? false : true;
  }

  openModalEdit() {
    this.isModalOpenEdit = true;
    getMissingRecords({
      currentRecords: JSON.stringify(this.productsInfo),
      pricebookId: this.pricebookId
    })
      .then((data) => {
        if (data) {
          this.missingProducts = JSON.parse(data).map((item) => ({
            UnitPrice: item.UnitPrice,
            Name: item.Name,
            Id: item.Id
          }));
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

  closeModalEdit() {
    this.isModalOpenEdit = false;
  }

  handleAddNewRecords(event) {
    addRecordsToPricebook({
      pricebookId: this.pricebookId,
      pricebookEntries: JSON.stringify(event.detail)
    })
      .then((data) => {
        if (data) {
          const evt = new ShowToastEvent({
            title: this.label.RE_Pricebook_Successfully_Updated,
            message: this.editedPricebookName,
            variant: "success"
          });
          this.dispatchEvent(evt);
          this.pricebookInfo = [];
          this.editedPricebookName = "";

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

  handleDataChange() {
    this.checkDataChaged = false;
  }
}
