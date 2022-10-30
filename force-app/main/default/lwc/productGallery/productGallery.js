import { LightningElement, wire, track, api } from "lwc";
import getRelatedFilesByRecordId from "@salesforce/apex/RE_filePreviewAndDownloadController.getRelatedFilesByRecordId";
import getImageUrlAndSaveAsDefaultImage from "@salesforce/apex/RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage";
import { ShowToastEvent } from "lightning/platformShowToastEvent";

export default class ProductGallery extends LightningElement {
  selected;
  selectedElementId;
  filesList = [];

  @api recordId;

  @wire(getRelatedFilesByRecordId, { recordId: "$recordId" })
  wiredResult({ data, error }) {
    if (data) {
      this.filesList = Object.keys(data).map((item) => ({
        label: data[item],
        value: item,
        url: `/sfc/servlet.shepherd/document/download/${item}`
      }));
    }
    if (error) {
      console.log(error);
    }
  }

  markPhoto(event) {
    event.stopPropagation();
    this.selectedElementId = event.target.dataset.id;
    event.target.classList.toggle("highlight");
    this.unselect(event.target);
    this.selected = event.target;
  }

  unselect(target) {
    if (this.selected && this.selected !== target) {
      this.selected.classList.remove("highlight");
      this.selected = null;
    }
  }

  setAsMainImage() {
    if (this.selected != null) {
      getImageUrlAndSaveAsDefaultImage({
        photoId: this.selectedElementId,
        recordId: this.recordId
      })
        .then((data) => {
          if (data) {
            const evt = new ShowToastEvent({
              title: "Main photo has been changed",
              message:
                "Please refresh the page to see the result. If you don't see the changes, wait a minute and refresh the page again.",
              variant: "success"
            });
            this.dispatchEvent(evt);
          } else {
            const evt = new ShowToastEvent({
              title: "Something went wrong",
              message:
                "Main photo could not be changed. Please refresh the page and try again.",
              variant: "error"
            });
            this.dispatchEvent(evt);
          }

          let elements = this.template.querySelectorAll("img");
          elements.forEach((element) => {
            element.classList.remove("highlight");
          });
        })
        .catch((error) => {
          console.log(error);
        });
    }
  }
}
