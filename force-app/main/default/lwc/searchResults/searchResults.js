import { LightningElement, track, api } from "lwc";

export default class SearchResults extends LightningElement {
  @api roleIsB2C;
  @api roleIsB2B;
  @api visibleFoundProducts;
  @api foundProducts;

  updateProductHandler(event) {
    this.visibleFoundProducts = [...event.detail.records];
  }
}
