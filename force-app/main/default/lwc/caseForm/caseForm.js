import { LightningElement, api, wire } from "lwc";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

import changeCaseOwner from "@salesforce/apex/RE_CaseFormController.changeCaseOwner";

import CASE_OBJECT from "@salesforce/schema/Case";
import TYPE_FIELD from "@salesforce/schema/Case.Type";
import SUBJECT_FIELD from "@salesforce/schema/Case.Subject";
import DESCRIPTION_FIELD from "@salesforce/schema/Case.Description";
import RE_Success from "@salesforce/label/c.RE_Success";
import RE_case_successfully_created from "@salesforce/label/c.RE_case_successfully_created";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";
import RE_Create_Case from "@salesforce/label/c.RE_Create_Case";
import RE_Subject from "@salesforce/label/c.RE_Subject";
import RE_Type from "@salesforce/label/c.RE_Type";
import RE_Product from "@salesforce/label/c.RE_Product";
import RE_Description from "@salesforce/label/c.RE_Description";
import RE_Create_New_Case from "@salesforce/label/c.RE_Create_New_Case";

export default class CaseForm extends LightningElement {
  label = {
    RE_Success,
    RE_case_successfully_created,
    RE_Error_Occured,
    RE_Create_Case,
    RE_Subject,
    RE_Type,
    RE_Product,
    RE_Description,
    RE_Create_New_Case
  };

  objectApiName = CASE_OBJECT;
  fields = [TYPE_FIELD, SUBJECT_FIELD, DESCRIPTION_FIELD];
  caseId;

  handleSuccess(event) {
    this.caseId = event.detail.id;
    changeCaseOwner({
      recordId: event.detail.id
    })
      .then(() => {
        const evt = new ShowToastEvent({
          title: RE_Success,
          message: RE_case_successfully_created,
          variant: "success"
        });
        this.dispatchEvent(evt);
        this.handleReset();
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

  handleReset() {
    const inputFields = this.template.querySelectorAll(
        'lightning-input-field'
    );
    if (inputFields) {
        inputFields.forEach(field => {
            field.reset();
        });
    }
 }
}
