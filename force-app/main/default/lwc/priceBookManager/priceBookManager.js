import { LightningElement } from "lwc";

import editShouldBeAvailable from "@salesforce/apex/RE_pricebookExplorerController.editShouldBeAvailable";

export default class PriceBookManager extends LightningElement {
  editAvailable;

  connectedCallback() {
    editShouldBeAvailable()
      .then((data) => {
        this.editAvailable = data;
      })
      .catch((error) => {
        console.log(error);
      });
  }
}
