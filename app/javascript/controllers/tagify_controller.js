import { Controller } from "@hotwired/stimulus"
import Tagify from "@yaireo/tagify"

export default class extends Controller {
  static targets = ["input"]

  connect() {
    this.initializeTagify()
  }

  initializeTagify() {
    const input = this.inputTarget
    const whitelistUrl = input.dataset.tagifyWhitelistUrl

    this.tagify = new Tagify(input, {
      whitelist: [],
      dropdown: {
        maxItems: 20,
        classname: "tags-look",
        enabled: 0,
        closeOnSelect: false
      }
    })

    // APIからタグ一覧を取得
    if (whitelistUrl) {
      fetch(whitelistUrl)
        .then(response => {
          return response.json()
        })
        .then(tags => {
          this.tagify.whitelist = tags
        })
        .catch(error => {
        })
    } 
    else {
    }
  }
}
