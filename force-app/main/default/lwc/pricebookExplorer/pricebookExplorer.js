import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getPricebooks from "@salesforce/apex/RE_pricebookExplorerController.getPricebooks";
import getPricebookInfo from "@salesforce/apex/RE_pricebookExplorerController.getPricebookInfo";
import getPricebookEntryInfo from "@salesforce/apex/RE_pricebookExplorerController.getPricebookEntryInfo";
import updatePricebook from "@salesforce/apex/RE_pricebookExplorerController.updatePricebook";

import RE_Pricebook_Successfully_Updated from "@salesforce/label/c.RE_Pricebook_Successfully_Updated";
import RE_Pricebook_Name from "@salesforce/label/c.RE_Pricebook_Name";
import RE_Search_Pricebook_By_Name from "@salesforce/label/c.RE_Search_Pricebook_By_Name";
import RE_Close from "@salesforce/label/c.RE_Close";
import RE_Start_Day from "@salesforce/label/c.RE_Start_Day";
import RE_End_Day from "@salesforce/label/c.RE_End_Day";
import RE_Something_Went_Wrong from "@salesforce/label/c.RE_Something_Went_Wrong";
import RE_Review_The_Data_And_Try_Again from "@salesforce/label/c.RE_Review_The_Data_And_Try_Again";
import RE_Premise_Name from "@salesforce/label/c.RE_Premise_Name";
import RE_Price from "@salesforce/label/c.RE_Price";
import RE_IsActive from "@salesforce/label/c.RE_IsActive";
import RE_Cancel from "@salesforce/label/c.RE_Cancel";
import RE_Save from "@salesforce/label/c.RE_Save";
import RE_Edit_Pricebook from "@salesforce/label/c.RE_Edit_Pricebook";
import RE_Add_Pricebook from "@salesforce/label/c.RE_Add_Pricebook";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

export default class PricebookExplorer extends LightningElement {
  pricebookResults;
  inputDateDisabled = false;

  @api editedPricebookName = "";
  @api editAvailable;
  @api pricebookId;
  @api pricebookInfo = [];
  @api pricebookInfoDates = {};
  @track isModalOpen = false;
  @track isModalOpenEdit = false;
  @track areResultsOpen = false;

  label = {
    RE_Pricebook_Name,
    RE_Review_The_Data_And_Try_Again,
    RE_Something_Went_Wrong,
    RE_Pricebook_Successfully_Updated,
    RE_Search_Pricebook_By_Name,
    RE_Premise_Name,
    RE_Price,
    RE_Start_Day,
    RE_End_Day,
    RE_IsActive,
    RE_Save,
    RE_Cancel,
    RE_Edit_Pricebook,
    RE_Add_Pricebook,
    RE_Close,
    RE_Error_Occured
  };

  openModal() {
    this.isModalOpen = true;
  }
  closeModal() {
    this.isModalOpen = false;
  }

  showResults() {
    this.areResultsOpen = true;
  }

  hideResults() {
    this.areResultsOpen = false;
  }

  connectedCallback() {
    getPricebooks({
      searchPhrase: ""
    })
      .then((data) => {
        this.pricebookResults = data;
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

  handleInputChange() {
    let searchPhrase = this.template.querySelector(
      'lightning-input[data-name="Pricebook_Name"]'
    ).value;

    getPricebooks({
      searchPhrase: searchPhrase
    })
      .then((data) => {
        this.pricebookResults = data;
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

  getPricebookData(event) {
    getPricebookEntryInfo({
      pricebookId: event.target.dataset.id
    })
      .then((data) => {
        this.pricebookInfo = data.map((item) => ({
          Name: item.Product2.Name,
          Id: item.Product2.Id,
          UnitPrice: item.UnitPrice
        }));
        this.editedPricebookName = data[0].Pricebook2.Name;
        this.pricebookId = data[0].Pricebook2.Id;
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
      });

    getPricebookInfo({
      pricebookId: event.target.dataset.id
    })
      .then((data) => {
        this.pricebookInfoDates = {
          ValidFrom: data.ValidFrom__c,
          ValidTo: data.ValidTo__c,
          IsActive: data.IsActive,
          Id: data.Id
        };
        this.inputDateDisabled = data.ValidFrom__c ? false : true;
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

  refreshData() {
    getPricebookEntryInfo({
      pricebookId: this.pricebookId
    })
      .then((data) => {
        this.pricebookInfo = data.map((item) => ({
          Name: item.Product2.Name,
          Id: item.Product2.Id,
          UnitPrice: item.UnitPrice
        }));
        this.editedPricebookName = data[0].Pricebook2.Name;
        this.pricebookId = data[0].Pricebook2.Id;
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

  refreshDataEdit() {
    getPricebookInfo({
      pricebookId: this.pricebookId
    })
      .then((data) => {
        this.pricebookInfoDates = {
          ValidFrom: data.ValidFrom__c,
          ValidTo: data.ValidTo__c,
          IsActive: data.IsActive,
          Id: data.Id
        };
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

  checkPremisePrices(updatedFields) {
    updatedFields.map((row) => {
      if (row.UnitPrice < 0 || row.UnitPrice.trim().length < 1) {
        incorrectData = true;
        const evt = new ShowToastEvent({
          title: this.label.RE_Incorrect_price,
          message: this.label.RE_Price_Is_Required,
          variant: "warning"
        });
        this.dispatchEvent(evt);
        return true;
      }
    });
    return false;
  }

  handleUpdateDatatable(event) {
    updatePricebook({
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
          this.editedPricebookName;

          getPricebookEntryInfo({
            pricebookId: this.pricebookId
          })
            .then((data) => {
              this.pricebookInfo = data.map((item) => ({
                Name: item.Product2.Name,
                Id: item.Product2.Id,
                UnitPrice: item.UnitPrice
              }));
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
