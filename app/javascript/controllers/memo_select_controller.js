import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["checkboxArea", "submitArea", "checkbox"]

  // submitAreaTargetが存在するかチェックするgetter
  get hasSubmitArea() {
    return this.submitAreaTargets.length > 0
  }

  // 右上＋ボタンでチェックモードを開始
  startSelect() {
    // チェックボックスを表示する
    this.checkboxAreaTargets.forEach(el => el.classList.remove("hidden"))

    // submitAreaが存在する場合のみ表示する（作品未選択時はない）
    if (this.hasSubmitArea) {
      this.submitAreaTarget.classList.remove("hidden")
    }
  }

  // チェック状態をトグルする
  toggle(event) {
    const checkbox = event.currentTarget.querySelector("[data-memo-select-target='checkbox']")
    if (checkbox) {
      checkbox.checked = !checkbox.checked
    }
  }

  submitChecked(event) {
    event.preventDefault()

    // formを先に取得する
    const form = event.currentTarget.closest("form")
    const container = document.getElementById("memo_id_inputs")
    container.innerHTML = ""

    this.checkboxTargets
      .filter(cb => cb.checked)
      .forEach(cb => {
        const input = document.createElement("input")
        input.type = "hidden"
        input.name = "memo_ids[]"
        input.value = cb.value
        container.appendChild(input)
      })

    // CSRFトークンをmetaタグから取得してフォームに追加
    const csrfToken = document.querySelector('meta[name="csrf-token"]')?.content
    if (csrfToken) {
      const tokenInput = document.createElement("input")
      tokenInput.type = "hidden"
      tokenInput.name = "authenticity_token"
      tokenInput.value = csrfToken
      container.appendChild(tokenInput)
    }

    form.submit()
  }

    // コントローラが接続されたときにイベントを登録
  connect() {
    this.handleStart = () => this.startSelect()
    window.addEventListener("memo-select:start", this.handleStart)
  }

  // コントローラが切断されたときにイベントを解除
  disconnect() {
    window.removeEventListener("memo-select:start", this.handleStart)
  }
  
}