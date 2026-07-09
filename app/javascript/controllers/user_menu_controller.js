import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu"]

  // アイコンクリックでログアウトメニューの表示・非表示を切り替える
  toggle(event) {
    // ドキュメントへのクリック伝播を止め、直後に外側クリック判定で閉じないようにする
    event.stopPropagation()
    this.menuTarget.classList.toggle("hidden")
  }

  // メニュー外をクリックしたら閉じる
  closeOnOutsideClick(event) {
    if (!this.element.contains(event.target)) {
      this.menuTarget.classList.add("hidden")
    }
  }

  // コントローラ接続時：外側クリックの監視を開始
  connect() {
    this.outsideClickHandler = this.closeOnOutsideClick.bind(this)
    document.addEventListener("click", this.outsideClickHandler)
  }

  // コントローラ切断時：イベント監視を解除
  disconnect() {
    document.removeEventListener("click", this.outsideClickHandler)
  }
}
