import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import createQuote from "@salesforce/apex/RE_getQuoteController.createQuote";

import RE_get_quote from "@salesforce/label/c.RE_get_quote";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";
import RE_quote_generated_and_sent_to_your_email from "@salesforce/label/c.RE_quote_generated_and_sent_to_your_email";
import RE_Success from "@salesforce/label/c.RE_Success";

export default class GetQuoteButton extends LightningElement {
  @api recordId;

  label = {
    RE_get_quote,
    RE_Error_Occured
  };

  handleClick() {
    createQuote({
      recordId: this.recordId
    })
      .then(() => {
        const evt = new ShowToastEvent({
            title: RE_Success,
            message: RE_quote_generated_and_sent_to_your_email,
            variant: "success"
          });
          this.dispatchEvent(evt);
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
