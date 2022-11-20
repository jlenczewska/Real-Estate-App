import { LightningElement, api } from "lwc";
import { NavigationMixin } from "lightning/navigation";

import RE_Rooms from "@salesforce/label/c.RE_Rooms";
import RE_Parking_spaces from "@salesforce/label/c.RE_Parking_spaces";

export default class ProductSearchSingleResult extends NavigationMixin(
  LightningElement
) {
  @api product;
  @api roleIsB2C;
  @api roleIsB2B;

  label = {
    RE_Rooms,
    RE_Parking_spaces
  };

connectedCallback(){
  console.log(this.product.DisplayUrl.replace('https://britenet28-dev-ed.file.force.com/', ''));

}

  redirectToProductPag() {
    this[NavigationMixin.GenerateUrl]({
      type: "standard__recordPage",
      attributes: {
        recordId: this.product.Id,
        objectApiName: "Product2",
        actionName: "view"
      }
    }).then((url) => {
      window.open(url, "_blank");
    });
  }
}
