import { LightningElement, api, track } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import RE_Business_Premise from "@salesforce/label/c.RE_Business_Premise";
import RE_Apartment from "@salesforce/label/c.RE_Apartment";
import RE_Incorrect_price from "@salesforce/label/c.RE_Incorrect_price";
import RE_Price_Is_Required from "@salesforce/label/c.RE_Price_Is_Required";
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

const columnsNotEditable = [
  { label: RE_Premise_Name, fieldName: "Name", editable: false },
  {
    label: RE_Price,
    fieldName: "UnitPrice",
    type: "currency",
    typeAttributes: { currencyCode: "USD" },
    editable: false
  }
];

const comboBoxOptions = [
  { label: RE_Business_Premise, value: "Business Premise" },
  { label: RE_Apartment, value: "Apartment" }
];

export default class PricebookDatatable extends LightningElement {
  @api objectApiName;
  @api recordType;
  @api recodTypeValue = "";
  @api productsInfo;
  @api operationType;
  @api editAvailable;

  @track userInputs = {};

  columns;
  comboBoxOptions = comboBoxOptions;
  draftValues = [];
  startDayInput = "";
  endDayInput = "";

  label = {
    RE_Incorrect_price,
    RE_Price_Is_Required,
    RE_Premise_Name,
    RE_Price
  };

  renderedCallback() {
    this.template.querySelector("lightning-datatable").draftValues = [];
    this.columns = this.editAvailable ? columns : columnsNotEditable;
  }

  checkPremisePrices(updatedFields) {
    updatedFields.map((row) => {
      if (row.UnitPrice <= 0 || row.UnitPrice.trim().length < 1) {
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

  handleSaveDatatable(event) {
    const updatedFields = event.detail.draftValues;
    const incorrectDataPrices = this.checkPremisePrices(updatedFields);

    if (incorrectDataPrices) {
      return;
    }

    if (this.operationType == "addbook") {
      const callParentEvent = new CustomEvent("handlesavedatatable", {
        detail: updatedFields
      });
      this.dispatchEvent(callParentEvent);
    } else if (this.operationType == "explorer") {
      const callParentEvent = new CustomEvent("handleupdatedatatable", {
        detail: updatedFields
      });
      this.dispatchEvent(callParentEvent);
    } else if (this.operationType == "addrecords") {
      const callParentEvent = new CustomEvent("handleaddnewrecords", {
        detail: updatedFields
      });
      this.dispatchEvent(callParentEvent);
    }
  }
}
