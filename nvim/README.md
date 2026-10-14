# Neovim / mini.nvim

設定は `init.lua`（基本設定・LSP）、`lua/config/mini.lua`（mini各モジュール・キー）、
`lua/config/plugins.lua`（mini.deps・補助プラグイン）に分けています。

## 移行先

| 機能 | 使用するminiモジュール |
| --- | --- |
| プラグイン管理 | mini.deps |
| 補完・スニペット | mini.completion / mini.snippets / mini.keymap |
| 括弧・囲み編集 | mini.pairs / mini.surround |
| ファイル操作・検索 | mini.files / mini.pick / mini.extra |
| Git・差分 | mini.git / mini.diff |
| バッファ操作・タブ表示 | mini.bufremove / mini.tabline |
| ステータス表示・アイコン | mini.statusline / mini.icons |
| インデント範囲・キーガイド | mini.indentscope / mini.clue |
| テーマ | minispring（mini.nvim同梱） |

miniに代替がないため、conform.nvim（フォーマッター実行）、nvim-treesitter
（パーサー管理）、nvim-ts-autotag（タグ自動補完）は継続使用します。
friendly-snippetsはスニペットのデータ集としてmini.snippetsから読み込みます。
LSPはNeovim標準の設定を継続使用します。

## 主なキー

LeaderはSpaceです。

| キー | 操作 |
| --- | --- |
| `<leader>e` | mini.filesの開閉。`=`でファイル操作を反映、`q`で閉じる |
| `ff` / `fb` / `fg` / `fe` / `gf` | ファイル／バッファ／全文／エラー／Git変更ファイル検索 |
| `<Tab>` / `<S-Tab>`（通常モード） | 次／前のバッファ |
| `<leader>bd` / `<leader>bo` | バッファを閉じる／他のバッファを閉じる |
| `<C-Space>` / `<CR>`（挿入モード） | 補完開始／候補確定 |
| `<Tab>` / `<S-Tab>`（挿入モード） | 補完候補の移動、スニペット展開・移動 |
| `<C-j>` / `<C-c>`（挿入モード） | スニペット展開／セッション終了 |
| `<C-x><C-f>`（挿入モード） | Neovim標準のファイルパス補完 |
| `ys` / `yss` / `ds` / `cs` / `S`（ビジュアルモード） | 囲み追加／行を囲む／削除／置換／選択を囲む |
| `[h` / `]h` | 前／次のGitハンク |
| `<leader>hs` / `<leader>hr` / `<leader>hd` | ハンクをステージ／リセット／差分オーバーレイ切替 |
| `<leader>hb` | Git blameを縦分割で表示（以前のインライン表示切替から変更） |
| `<leader>lg` / `:LazyGit` | 標準ターミナルのタブで外部コマンドlazygitを起動 |

`ff`・`fg`はrgがあれば隠しファイル・ignore対象も含めて検索します。
`.git`・`node_modules`・`.next`・`.vite-hooks`・`.wrangler`・`dist`は除外します。
mini.indentscopeは現在のインデント範囲を表示します。
補完はmini方式になり、LSP・バッファ・スニペットを利用できます。
保存時のフォーマット選択（Luaはstylua、JS/TSはPrettier設定があればprettier、なければoxfmt）は維持しています。

## 更新

- `:DepsUpdate`：更新を取得し、確認画面で適用。
- `:DepsSnapSave`：現在のバージョンを `mini-deps-snap` に保存。
- `:DepsSnapLoad`：保存済みバージョンへ戻す。

以前のlazy.nvim用プラグインディレクトリは削除していません。
