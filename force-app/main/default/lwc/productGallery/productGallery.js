import { LightningElement, wire, api } from "lwc";
import getRelatedFilesByRecordId from "@salesforce/apex/RE_filePreviewAndDownloadController.getRelatedFilesByRecordId";

import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import RE_Preview from "@salesforce/label/c.RE_Preview";
import RE_Main_Photo_Could_Not_Be_Changed from "@salesforce/label/c.RE_Main_photo_has_been_changed";
import RE_Please_refresh_the_page from "@salesforce/label/c.RE_Please_refresh_the_page";
import RE_Set_As_Main_Photo from "@salesforce/label/c.RE_Set_As_Main_Photo";
import RE_Something_went_wrong1 from "@salesforce/label/c.RE_Something_went_wrong1";
import RE_Error_Occured from "@salesforce/label/c.RE_Error_Occured";

export default class ProductGallery extends NavigationMixin(LightningElement) {
  selected;
  selectedElementId;
  enableButtons = false;
  filesList = [];
  newFileWasUploaded = false;
  uploadedFilesUrl = [];
  @api mainPhoto='a'

  @api recordId;
  @api isLoaded = false;

  get acceptedFormats() {
    return [".jpg", ".png"];
  }

  label = {
    RE_Set_As_Main_Photo,
    RE_Preview,
    RE_Please_refresh_the_page,
    RE_Something_went_wrong1,
    RE_Main_Photo_Could_Not_Be_Changed,
    RE_Error_Occured
  };

  @wire(getRelatedFilesByRecordId, { recordId: "$recordId" })
  wiredResult({ data, error }) {
    if (data) {
      this.filesList = Object.keys(data).map((item) => ({
        label: data[item],
        value: item,
        url: `/sfc/servlet.shepherd/document/download/${item}`
      }));
      this.isLoaded = true;
      this.mainPhoto = this.filesList[0].url
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

  markPhoto(event) {
    event.stopPropagation();
    this.selectedElementId = event.target.dataset.id;
    this.mainPhoto = this.selectedElementId
  }
}
