import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import checkUserPremissions from "@salesforce/apex/RE_searchEngineProductController.checkUserPremissions";

import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";
import RE_Search from "@salesforce/label/c.RE_Search";
import RE_Area from "@salesforce/label/c.RE_Area";
import RE_From from "@salesforce/label/c.RE_From";
import RE_To from "@salesforce/label/c.RE_To";
import RE_Year from "@salesforce/label/c.RE_Year";
import RE_Number_Of_Rooms from "@salesforce/label/c.RE_Number_Of_Rooms";
import RE_Parking_Spaces from "@salesforce/label/c.RE_Parking_Spaces";
import RE_Additional_Options from "@salesforce/label/c.RE_Additional_Options";
import RE_Search_City_Country from "@salesforce/label/c.RE_Search_City_Country";
import RE_must_be_positive from "@salesforce/label/c.RE_must_be_positive";
import RE_The_Lower_Value_Must_Be_Smaller from "@salesforce/label/c.RE_The_Lower_Value_Must_Be_Smaller";
import RE_Rooms from "@salesforce/label/c.RE_Rooms";
import RE_Clear from "@salesforce/label/c.RE_Clear";

const optionsCheckboxB2B = [
  { label: "Shower Access", value: "Shower Access" },
  { label: "Kitchen", value: "Kitchen" },
  { label: "Facilities for the disabled", value: "Facilities for the disabled" }
];

const optionsCheckboxB2C = [
  { label: "Swimming Pool", value: "Swimming Pool" },
  { label: "Balcony", value: "Balcony" },
  { label: "Elevator", value: "Elevator" }
];

export default class SearchBar extends LightningElement {
  visibleFoundProducts;
  valueCheckboxGroup = [];
  filtersValues = {};
  areResultsOpen = false;
  roleIsB2C = false;
  roleIsB2B = false;
  phraseFormula;
  foundProducts;

  @api isLoaded = false;

  label = {
    RE_Error_Occured,
    RE_Search,
    RE_Area,
    RE_From,
    RE_To,
    RE_Year,
    RE_Number_Of_Rooms,
    RE_Parking_Spaces,
    RE_Additional_Options,
    RE_Search_City_Country,
    RE_must_be_positive,
    RE_The_Lower_Value_Must_Be_Smaller,
    RE_Rooms,
    RE_Clear
  };

  connectedCallback() {
    checkUserPremissions().then((data) => {
      this.foundProducts = data;
      if (data == "Business premise") {
        this.roleIsB2B = true;
      } else if (data == "Apartment") {
        this.roleIsB2C = true;
      }
    });
  }

  get optionsCheckboxGroup() {
    if (this.roleIsB2B) {
      return optionsCheckboxB2B;
    } else if (this.roleIsB2C) {
      return optionsCheckboxB2C;
    }
  }

  showResults() {
    this.areResultsOpen = true;
  }

  hideResults() {
    this.areResultsOpen = false;
  }

  updateProductHandler(event) {
    this.visibleFoundProducts = [...event.detail.records];
  }

  checkIfInputsAreCorrect() {
    if (
      Number(this.filtersValues.Filters_Area_From) >
      Number(this.filtersValues.Filters_Area_To)
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message: RE_The_Lower_Value_Must_Be_Smaller + " " + this.label.RE_Area,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      Number(this.filtersValues.Filters_Year_From) >
      Number(this.filtersValues.Filters_Year_To)
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message: RE_The_Lower_Value_Must_Be_Smaller + " " + this.label.RE_Year,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }
    if (
      Number(this.filtersValues.Filters_Rooms_From) >
      Number(this.filtersValues.Filters_Rooms_To)
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message: RE_The_Lower_Value_Must_Be_Smaller + " " + this.label.RE_Rooms,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }
    if (
      Number(this.filtersValues.Filters_Parking_From) >
      Number(this.filtersValues.Filters_Parking_To)
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message:
          RE_The_Lower_Value_Must_Be_Smaller +
          " " +
          this.label.RE_Parking_Spaces,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.filtersValues.Filters_Area_From < 0 ||
      this.filtersValues.Filters_Area_To < 0
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message: this.label.RE_Area + " " + this.label.RE_must_be_positive,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.filtersValues.Filters_Year_From < 0 ||
      this.filtersValues.Filters_Year_To < 0
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message: this.label.RE_Year + " " + this.label.RE_must_be_positive,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.filtersValues.Filters_Rooms_From < 0 ||
      this.filtersValues.Filters_Rooms_To < 0
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message:
          this.label.RE_Number_Of_Rooms + " " + this.label.RE_must_be_positive,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }

    if (
      this.filtersValues.Filters_Parking_From < 0 ||
      this.filtersValues.Filters_Parking_To < 0
    ) {
      const evt = new ShowToastEvent({
        title: RE_Error_Occured,
        message:
          this.label.RE_Parking_Spaces + " " + this.label.RE_must_be_positive,
        variant: "warning"
      });
      this.dispatchEvent(evt);
      return true;
    }
  }

  handleSubmitSearch() {
    this.isLoaded = false;

    let searchPhrase = this.template.querySelector(
      'lightning-input[data-name="Product_Phrase_Formula"]'
    ).value;

    this.phraseFormula = searchPhrase;

    if (this.checkIfInputsAreCorrect()) {
      this.isLoaded = true;
      return;
    }

    if (Object.keys(this.filtersValues).length) {
      if ("Filters_Checkbox_Group" in this.filtersValues) {
        this.setValuesToForm();
      }
    }

    const eventChild = new CustomEvent("sendfilterstoparent", {
      detail: {
        searchPhrase: searchPhrase,
        filtersInfo: this.filtersValues
      }
    });

    this.dispatchEvent(eventChild);
  }

  handleFormFilterChange(event) {
    if (event.target.dataset.name != "Product_Phrase_Formula") {
      this.filtersValues[event.target.name] = event.detail.value;
    } else {
      this.phraseFormula = event.detail.value;
    }
  }

  setValuesToForm() {
    this.valueCheckboxGroup = [];

    this.filtersValues.Filters_Checkbox_Group.forEach((e) => {
      this.valueCheckboxGroup.push(e);
    });
  }
}
