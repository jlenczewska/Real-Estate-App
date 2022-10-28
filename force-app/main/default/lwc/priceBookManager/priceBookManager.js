import { LightningElement, api, wire, track } from "lwc";
import { getObjectInfo } from "lightning/uiObjectInfoApi";
import PRODUCT_OBJECT from "@salesforce/schema/Product2";
import getRecordsByRecordType from "@salesforce/apex/RE_fetchProductData.getRecordsByRecordType";

const FIELDS = ["Product2.RecordTypeId", "Product2.Name"];

const columns = [
  { label: "Premise Name", fieldName: "Name", editable: false },
  { label: "Price", fieldName: "UnitPrice", editable: true }
];

const comboBoxOptions = [
  { label: "Business Premise", value: "Business Premise" },
  { label: "Apartment", value: "Apartment" }
];

export default class PriceBookManager extends LightningElement {
  @api objectApiName;
  @api recordType;

  @track productsInfo;

  columns = columns;
  comboBoxOptions = comboBoxOptions;

  // , {recordId: '$recordType'}
  @wire(getRecordsByRecordType, { premiseName: "Business premise" })
  wiredResult({ data, error }) {
    if (data) {
      console.log(data);
      this.productsInfo = data;
    }
    if (error) {
      console.log(error);
    }
  }
}
