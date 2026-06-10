import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "form", "content"]

  // 編集ボタンを押したとき：メモのIDと内容をフォームにセットしてモーダルを開く
  open(event) {
    const memoId = event.currentTarget.dataset.memoId
    const memoContent = event.currentTarget.dataset.memoContent
    const creationId = event.currentTarget.dataset.creationId

    // フォームのaction属性をそのメモのURLに書き換える
    // 例: /memos/5
    this.formTarget.action = `/memos/${memoId}?creation_id=${creationId}`

    // テキストエリアに既存の内容をセット
    this.contentTarget.value = memoContent

    this.modalTarget.classList.remove("hidden")
  }

  // モーダルを閉じる
  close() {
    this.modalTarget.classList.add("hidden")
  }

  // 背景クリックで閉じる
  closeOnBackdrop(event) {
    if (event.target === this.modalTarget) {
      this.close()
    }
  }
}