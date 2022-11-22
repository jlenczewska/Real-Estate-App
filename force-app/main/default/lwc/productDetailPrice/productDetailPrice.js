import { LightningElement, api,wire } from 'lwc';
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import getProductPrice from "@salesforce/apex/RE_ProductDetailPriceContrller.getProductPrice";

import RE_Price from "@salesforce/label/c.RE_Price";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

export default class ProductDetailPrice extends LightningElement {
    label = {
        RE_Price,
        RE_Error_Occured
    }

    @api recordId;

    displayedPrice;

    @wire(getProductPrice, { recordId: "$recordId" })
    wiredResult({ data, error }) {
      if (data) {
        this.displayedPrice = data;
      }
      if (error) {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.isLoaded = true;
        this.dispatchEvent(evt);
      }
    }

}