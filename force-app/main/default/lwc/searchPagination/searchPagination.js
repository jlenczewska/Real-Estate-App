import { LightningElement, api } from "lwc";

import RE_Page from "@salesforce/label/c.RE_Page";
import RE_Previous_Page from "@salesforce/label/c.RE_Previous_Page";
import RE_Next_Page from "@salesforce/label/c.RE_Next_Page";

export default class SearchPagination extends LightningElement {
  currentPage = 1;
  foundProducts;
  @api recordSize = 8;
  totalPage = 0;

  label={
    RE_Page,RE_Previous_Page,RE_Next_Page
  }

  get records() {
    return this.visibleRecords;
  }
  @api
  set records(data) {
    if (data) {
      this.foundProducts = data;
      this.recordSize = Number(this.recordSize);
      this.totalPage = Math.ceil(data.length / this.recordSize);
      this.updateRecords();
    }
  }

  @api
  changePageToOne() {
    this.currentPage = 1;
  }

  get disablePrevious() {
    return this.currentPage <= 1;
  }
  get disableNext() {
    return this.currentPage >= this.totalPage;
  }
  previousHandler() {
    if (this.currentPage > 1) {
      this.currentPage = this.currentPage - 1;
      this.updateRecords();
    }
  }
  nextHandler() {
    if (this.currentPage < this.totalPage) {
      this.currentPage = this.currentPage + 1;
      this.updateRecords();
    }
  }
  updateRecords() {
    const start = (this.currentPage - 1) * this.recordSize;
    const end = this.recordSize * this.currentPage;
    this.visibleRecords = this.foundProducts.slice(start, end);
    this.dispatchEvent(
      new CustomEvent("update", {
        detail: {
          records: this.visibleRecords
        }
      })
    );
  }
}
