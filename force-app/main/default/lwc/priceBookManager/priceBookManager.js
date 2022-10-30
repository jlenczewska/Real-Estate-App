import { LightningElement, api, wire, track } from "lwc";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getRecordsByRecordType from "@salesforce/apex/RE_pricebookManagerController.getRecordsByRecordType";
import addPricebookToDatabase from "@salesforce/apex/RE_pricebookManagerController.addPricebookToDatabase";

import PRODUCT_OBJECT from "@salesforce/schema/Product2";
import RE_Description from "@salesforce/label/c.RE_Description";
import RE_Pricebook_Name from "@salesforce/label/c.RE_Pricebook_Name";
import RE_Start_Day from "@salesforce/label/c.RE_Start_Day";
import RE_End_Day from "@salesforce/label/c.RE_End_Day";
import RE_Business_Premise from "@salesforce/label/c.RE_Business_Premise";
import RE_Apartment from "@salesforce/label/c.RE_Apartment";
import RE_Premise_Type from "@salesforce/label/c.RE_Premise_Type";
import RE_Select_Premise_Type from "@salesforce/label/c.RE_Select_Premise_Type";
import RE_Create_New_Pricebook from "@salesforce/label/c.RE_Create_New_Pricebook";
import RE_Incorrect_price from "@salesforce/label/c.RE_Incorrect_price";
import RE_Price_Is_Required from "@salesforce/label/c.RE_Price_Is_Required";
import RE_Pricebook_Name_Is_Required from "@salesforce/label/c.RE_Pricebook_Name_Is_Required";
import RE_Enter_Pricebook_Name from "@salesforce/label/c.RE_Enter_Pricebook_Name";
import RE_Description_Is_Required from "@salesforce/label/c.RE_Description_Is_Required";
import RE_Enter_Description from "@salesforce/label/c.RE_Enter_Description";
import RE_Start_Day_Is_Required from "@salesforce/label/c.RE_Start_Day_Is_Required";
import RE_Enter_Start_Day from "@salesforce/label/c.RE_Enter_Start_Day";
import RE_End_Day_Is_Required from "@salesforce/label/c.RE_End_Day_Is_Required";
import RE_Enter_End_Day from "@salesforce/label/c.RE_Enter_End_Day";
import RE_Invalid_Dates from "@salesforce/label/c.RE_Invalid_Dates";
import RE_The_End_Date_Must_Be_Later_Than_The_Start_Date from "@salesforce/label/c.RE_The_End_Date_Must_Be_Later_Than_The_Start_Date";
import RE_The_date_can_only_contain_numbers from "@salesforce/label/c.RE_The_date_can_only_contain_numbers";
import RE_Pricebook_Pricebook_Has_Been_Successfully_Added_To_The_Database from "@salesforce/label/c.RE_Pricebook_Pricebook_Has_Been_Successfully_Added_To_The_Database";
import RE_Something_Went_Wrong from "@salesforce/label/c.RE_Something_Went_Wrong";
import RE_Review_The_Data_And_Try_Again from "@salesforce/label/c.RE_Review_The_Data_And_Try_Again";

const FIELDS = ["Product2.RecordTypeId", "Product2.Name"];

const columns = [
  { label: "Premise Name", fieldName: "Name", editable: false },
  {
    label: "Price",
    fieldName: "UnitPrice",
    type: "currency",
    typeAttributes: { currencyCode: "USD" },
    editable: true
  }
];

const comboBoxOptions = [
  { label: "Business Premise", value: "Business Premise" },
  { label: "Apartment", value: "Apartment" }
];

export default class PriceBookManager extends LightningElement {
  @api objectApiName;
  @api recordType;
  @api recodTypeValue = "";

  @track productsInfo;
  @track userInputs = {};

  columns = columns;
  comboBoxOptions = comboBoxOptions;
  draftValues = [];
  startDayInput = "";
  endDayInput = "";

  label = {
    RE_Description,
    RE_Pricebook_Name,
    RE_Start_Day,
    RE_End_Day,
    RE_Business_Premise,
    RE_Apartment,
    RE_Premise_Type,
    RE_Select_Premise_Type,
    RE_Create_New_Pricebook,
    RE_Incorrect_price,
    RE_Price_Is_Required,
    RE_Pricebook_Name_Is_Required,
    RE_Enter_Pricebook_Name,
    RE_Description_Is_Required,
    RE_Enter_Description,
    RE_Start_Day_Is_Required,
    RE_Enter_Start_Day,
    RE_End_Day_Is_Required,
    RE_Enter_End_Day,
    RE_Invalid_Dates,
    RE_The_End_Date_Must_Be_Later_Than_The_Start_Date,
    RE_The_date_can_only_contain_numbers,
    RE_Review_The_Data_And_Try_Again,
    RE_Something_Went_Wrong,
    RE_Pricebook_Pricebook_Has_Been_Successfully_Added_To_The_Database
  };

  connectedCallback() {
    this.userInputs = {
      name: "",
      description: "",
      startDate: "",
      endDate: ""
    };
  }

  @wire(getRecordsByRecordType, { premiseName: "$recodTypeValue" })
  wiredResult({ data, error }) {
    if (data) {
      this.productsInfo = data;
    }
    if (error) {
      console.log(error);
    }
  }

  // checkStartDayInput(event) {
  //   event.preventDefault();
  //   console.log("vasssssssssssslue");
  //   const value = this.template.querySelector(
  //     'lightning-input[data-name="Start_Day"]'
  //   ).value;
  //   console.log(value);
  //   let v2 = value.replace(/[a-zA-Z]/, "");

  //   console.log(v2);
  // }

  handleChangeComboBox(event) {
    this.recodTypeValue = event.detail.value;
    this.template.querySelector("lightning-datatable").draftValues = [];
  }

  checkFormInputs() {
    if (
      this.template
        .querySelector('lightning-input[data-name="Pricebook_Name"]')
        .value.trim()
    ) {
      this.userInputs.name = this.template.querySelector(
        'lightning-input[data-name="Pricebook_Name"]'
      ).value;
    } else {
      const evt = new ShowToastEvent({
        title: this.label.RE_Pricebook_Name_Is_Required,
        message: this.label.RE_Enter_Pricebook_Name,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.template
        .querySelector('lightning-input[data-name="Description"]')
        .value.trim()
    ) {
      this.userInputs.description = this.template.querySelector(
        'lightning-input[data-name="Description"]'
      ).value;
    } else {
      const evt = new ShowToastEvent({
        title: this.label.RE_Description_Is_Required,
        message: this.label.RE_Enter_Description,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.template
        .querySelector('lightning-input[data-name="Start_Day"]')
        .value.trim()
    ) {
      this.userInputs.startDate = this.template.querySelector(
        'lightning-input[data-name="Start_Day"]'
      ).value;
    } else {
      const evt = new ShowToastEvent({
        title: this.label.RE_Start_Day_Is_Required,
        message: this.label.RE_Enter_Start_Day,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.template
        .querySelector('lightning-input[data-name="End_Day"]')
        .value.trim()
    ) {
      this.userInputs.endDate = this.template.querySelector(
        'lightning-input[data-name="End_Day"]'
      ).value;
    } else {
      const evt = new ShowToastEvent({
        title: this.label.RE_End_Day_Is_Required,
        message: this.label.RE_Enter_End_Day,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (this.userInputs.endDate < this.userInputs.startDate) {
      const evt = new ShowToastEvent({
        title: this.label.RE_Invalid_Dates,
        message: this.label.RE_The_End_Date_Must_Be_Later_Than_The_Start_Date,
        variant: "warning"
      });
      this.dispatchEvent(evt);

      return true;
    }

    // console.log(String(this.userInputs.endDate));
    // console.log(String(this.userInputs.endDate).replace(/[a-zA-Z]/, ""));
    // if (
    //   /[a-zA-Z]/.test(String(this.userInputs.endDate)) ||
    //   /[a-zA-Z]/.test(String(this.userInputs.startDate))
    // ) {
    //   const evt = new ShowToastEvent({
    //     title: this.label.RE_The_date_can_only_contain_numbers,
    //     message: "",
    //     variant: "warning"
    //   });
    //   this.dispatchEvent(evt);
    //   return true;
    // }

    return false;
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

  handleSaveDatatable(event) {
    const updatedFields = event.detail.draftValues;
    const incorrectDataInputs = this.checkFormInputs();
    const incorrectDataPrices = this.checkPremisePrices(updatedFields);

    if (incorrectDataInputs || incorrectDataPrices) {
      return;
    }

    addPricebookToDatabase({
      pbName: this.userInputs.name,
      pbDesc: this.userInputs.description,
      pbStartDay: this.userInputs.startDate,
      pbEndDay: this.userInputs.endDate,
      pricebookEntries: JSON.stringify(updatedFields)
    }).then((data) => {
      console.log(data);
      if (data) {
        const evt = new ShowToastEvent({
          title:
            this.label
              .RE_Pricebook_Pricebook_Has_Been_Successfully_Added_To_The_Database,
          message: "",
          variant: "success"
        });
        this.dispatchEvent(evt);
        this.recodTypeValue = "";
        this.template.querySelector("lightning-datatable").draftValues = [];
        this.template.querySelector(
          'lightning-input[data-name="End_Day"]'
        ).value = "";
        this.template.querySelector(
          'lightning-input[data-name="Pricebook_Name"]'
        ).value = "";
        this.template.querySelector(
          'lightning-input[data-name="Start_Day"]'
        ).value = "";
        this.template.querySelector(
          'lightning-input[data-name="Description"]'
        ).value = "";
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
