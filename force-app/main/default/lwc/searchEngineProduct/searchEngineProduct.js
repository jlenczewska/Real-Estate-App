import { LightningElement, track, api } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import searchProductByFilters from "@salesforce/apex/searchEngineProductController.searchProductByFilters";
import getProductsPrice from "@salesforce/apex/searchEngineProductController.getProductsPrice";
import checkUserPremissions from "@salesforce/apex/searchEngineProductController.checkUserPremissions";

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

export default class SearchEngineProduct extends LightningElement {
  valueCheckboxGroup = [];
  filtersValues = {};
  areResultsOpen = false;
  roleIsB2C = false;
  roleIsB2B = false;
  phraseFormula = "";
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
      if (data == "Business premise") {
        this.roleIsB2B = true;
      } else if (data == "Apartment") {
        this.roleIsB2C = true;
      }
    });

    searchProductByFilters({
      searchPhrase: "",
      filtersInfo: ""
    })
      .then((data) => {
        getProductsPrice().then((prices) => {
          for (let i = 0; i < prices.length; i++) {
            for (let j = 0; j < data.length; j++) {
              if (data[j].Id == prices[i].Product2Id) {
                data[j]["UnitPrice"] = prices[i].expr0;
              }
            }
          }
          this.foundProducts = data;
        });
        this.isLoaded = true;
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.isLoaded = true;
        this.dispatchEvent(evt);
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

  sendfilterstoparent(event) {
    this.isLoaded = false;

    searchProductByFilters({
      searchPhrase: event.detail.searchPhrase,
      filtersInfo: JSON.stringify(event.detail.filtersInfo)
    })
      .then((data) => {
        getProductsPrice().then((prices) => {
          for (let i = 0; i < prices.length; i++) {
            for (let j = 0; j < data.length; j++) {
              if (data[j].Id == prices[i].Product2Id) {
                data[j]["UnitPrice"] = prices[i].expr0;
              }
            }
          }
          this.foundProducts = data;
        });
        this.isLoaded = true;
        this.template.querySelector("c-search-pagination").changePageToOne();
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.isLoaded = true;
        this.dispatchEvent(evt);
      });
  }
}
