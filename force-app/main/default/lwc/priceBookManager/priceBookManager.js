import { LightningElement } from "lwc";

import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

import editShouldBeAvailable from "@salesforce/apex/RE_pricebookExplorerController.editShouldBeAvailable";

export default class PriceBookManager extends LightningElement {
  editAvailable;

  label = {
    RE_Error_Occured
  };

  connectedCallback() {
    editShouldBeAvailable()
      .then((data) => {
        this.editAvailable = data;
      })
      .catch((error) => {
        const evt = new ShowToastEvent({
          title: RE_Error_Occured,
          message: error["body"]["message"],
          variant: "error"
        });
        this.dispatchEvent(evt);
      });
  }
}
