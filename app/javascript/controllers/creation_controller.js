import { Controller } from "@hotwired/stimulus"

// 作品選択時に右パネルのタイトルを更新するコントローラー
export default class extends Controller {
  static targets = ["title", "plotBlocks"]  // plotBlocksターゲットを追加

  // 作品をクリックしたときに呼ばれる
  select(event) {
    const title = event.currentTarget.dataset.title
    const creationId = event.currentTarget.dataset.id

    // URLを組み立て
    const url = new URL(window.location.href)
    url.searchParams.set("creation_id", creationId)

    // Turbo.visit()でページ全体リロードではなくTurboの高速遷移に変更
    // { action: "replace" } でブラウザの履歴を上書き（戻るボタンで前の作品に戻らないようにする）
    Turbo.visit(url.toString(), { action: "replace" })
  }
}