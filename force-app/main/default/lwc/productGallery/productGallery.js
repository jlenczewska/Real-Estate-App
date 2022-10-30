import { LightningElement, wire, track, api } from "lwc";
import getRelatedFilesByRecordId from "@salesforce/apex/RE_filePreviewAndDownloadController.getRelatedFilesByRecordId";
import getImageUrlAndSaveAsDefaultImage from "@salesforce/apex/RE_saveImageAsMainImage.getImageUrlAndSaveAsDefaultImage";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { NavigationMixin } from "lightning/navigation";

import RE_Preview from "@salesforce/label/c.RE_Preview";
import RE_Main_Photo_Could_Not_Be_Changed from "@salesforce/label/c.RE_Main_photo_has_been_changed";
import RE_Please_refresh_the_page from "@salesforce/label/c.RE_Please_refresh_the_page";
import RE_Set_As_Main_Photo from "@salesforce/label/c.RE_Set_As_Main_Photo";
import RE_Something_went_wrong1 from "@salesforce/label/c.RE_Something_went_wrong1";

export default class ProductGallery extends NavigationMixin(LightningElement) {
  selected;
  selectedElementId;
  filesList = [];
  newFileWasUploaded = false;
  uploadedFilesUrl = [];

  @api recordId;

  get acceptedFormats() {
    return [".jpg", ".png"];
  }

  label = {
    RE_Set_As_Main_Photo,
    RE_Preview,
    RE_Please_refresh_the_page,
    RE_Something_went_wrong1,
    RE_Main_Photo_Could_Not_Be_Changed
  };

  handleUploadFinished(event) {
    const uploadedFiles = event.detail.files;
    if (uploadedFiles && uploadedFiles.length > 0) {
      this.newFileWasUploaded = true;
      uploadedFiles.forEach((element) => {
        this.uploadedFilesUrl.push({
          id:
            "/sfc/servlet.shepherd/version/download/" + element.contentVersionId
        });
      });
    }
  }

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

  previewHandler(event) {
    console.log(event.target.dataset.id);
    this[NavigationMixin.Navigate]({
      type: "standard__namedPage",
      attributes: {
        pageName: "filePreview"
      },
      state: {
        selectedRecordId: this.selectedElementId
      }
    });
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
              title: this.label.RE_Main_Photo_Could_Not_Be_Changed,
              message: this.label.RE_Please_refresh_the_page,
              variant: "success"
            });
            this.dispatchEvent(evt);
          } else {
            const evt = new ShowToastEvent({
              title: this.label.RE_Something_went_wrong,
              message: "",
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
