import { LightningElement } from "lwc";

import RE_Explore_Pricebooks from "@salesforce/label/c.RE_Explore_Pricebooks";
import RE_Add_Pricebook from "@salesforce/label/c.RE_Add_Pricebook";

export default class PriceBookManager extends LightningElement {
  label = { RE_Add_Pricebook, RE_Explore_Pricebooks };

  get addPricebook() {
    return this.label.RE_Add_Pricebook;
  }

  get explorePricebooks() {
    return this.label.RE_Explore_Pricebooks;
  }
}
