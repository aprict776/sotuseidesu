import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // data-plot-block-target="modal" で指定した要素を操作する
  static targets = ["modal"]

  // + ボタンでモーダルを開く
  open() {
    this.modalTarget.classList.remove("hidden")
  }

  // キャンセル・背景クリックでモーダルを閉じる
  close() {
    this.modalTarget.classList.add("hidden")
  }

  // 背景クリック時、モーダル本体のクリックは閉じないようにする
  closeOnBackdrop(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}