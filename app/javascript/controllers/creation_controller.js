import { Controller } from "@hotwired/stimulus"

// 作品選択時に右パネルのタイトルを更新するコントローラー
export default class extends Controller {
  static targets = ["title"]  // 右パネルのタイトル要素

  // 作品をクリックしたときに呼ばれる
  select(event) {
    const title = event.currentTarget.dataset.title
    const creationId = event.currentTarget.dataset.id

    // 右パネルのタイトルを更新
    this.titleTarget.textContent = title

    // URLパラメーターにcreation_idを追加してページを再読み込み
    const url = new URL(window.location.href)
    url.searchParams.set("creation_id", creationId)
    window.location.href = url.toString()
  }
}