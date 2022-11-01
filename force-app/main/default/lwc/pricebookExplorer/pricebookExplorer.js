import { LightningElement, api, wire, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getPricebooks from "@salesforce/apex/RE_pricebookExplorerController.getPricebooks";
import getPricebookInfo from "@salesforce/apex/RE_pricebookExplorerController.getPricebookInfo";
import updatePricebook from "@salesforce/apex/RE_pricebookExplorerController.updatePricebook";

import RE_Pricebook_Successfully_Updated from "@salesforce/label/c.RE_Pricebook_Successfully_Updated";
import RE_Pricebook_Name from "@salesforce/label/c.RE_Pricebook_Name";
import RE_Search_Pricebook_By_Name from "@salesforce/label/c.RE_Search_Pricebook_By_Name";
import RE_Business_Premise from "@salesforce/label/c.RE_Business_Premise";
import RE_Apartment from "@salesforce/label/c.RE_Apartment";
import RE_Something_Went_Wrong from "@salesforce/label/c.RE_Something_Went_Wrong";
import RE_Review_The_Data_And_Try_Again from "@salesforce/label/c.RE_Review_The_Data_And_Try_Again";
import RE_Premise_Name from "@salesforce/label/c.RE_Premise_Name";
import RE_Price from "@salesforce/label/c.RE_Price";

const columns = [
  { label: RE_Premise_Name, fieldName: "Name", editable: false },
  {
    label: RE_Price,
    fieldName: "UnitPrice",
    type: "currency",
    typeAttributes: { currencyCode: "USD" },
    editable: true
  }
];

const comboBoxOptions = [
  { label: RE_Business_Premise, value: "Business Premise" },
  { label: RE_Apartment, value: "Apartment" }
];

export default class PricebookExplorer extends LightningElement {
  pricebookResults;
  pricebookId;

  @api objectApiName;
  @api recordType;
  @api recodTypeValue = "";

  @track productsInfo;
  @track userInputs = {};
  @track objectInfo;
  @track pricebookInfo = [];

  columns = columns;
  comboBoxOptions = comboBoxOptions;
  draftValues = [];
  startDayInput = "";
  endDayInput = "";

  label = {
    RE_Pricebook_Name,
    RE_Review_The_Data_And_Try_Again,
    RE_Something_Went_Wrong,
    RE_Pricebook_Successfully_Updated,
    RE_Search_Pricebook_By_Name,
    RE_Premise_Name,
    RE_Price
  };

  connectedCallback() {
    getPricebooks({
      searchPhrase: ""
    }).then((data) => {
      this.pricebookResults = data;
    });
  }

  handleInputChange() {
    let searchPhrase = this.template.querySelector(
      'lightning-input[data-name="Pricebook_Name"]'
    ).value;

    getPricebooks({
      searchPhrase: searchPhrase
    }).then((data) => {
      this.pricebookResults = data;
    });
  }

  getPricebookData(event) {
    getPricebookInfo({
      pricebookId: event.target.dataset.id
    }).then((data) => {
      this.pricebookInfo = data.map((item) => ({
        Name: item.Product2.Name,
        Id: item.Product2.Id,
        UnitPrice: item.UnitPrice
      }));

      this.pricebookId = data[0].Pricebook2.Id;
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
    }).then((data) => {
      if (data) {
        const evt = new ShowToastEvent({
          title: this.label.RE_Pricebook_Successfully_Updated,
          message: "",
          variant: "success"
        });
        this.dispatchEvent(evt);
        this.pricebookInfo = [];
      } else {
        const evt = new ShowToastEvent({
          title: this.label.RE_Something_Went_Wrong,
          message: this.label.RE_Review_The_Data_And_Try_Again,
          variant: "info"
        });
        this.dispatchEvent(evt);
      }
    });
  }
}
