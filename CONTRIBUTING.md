# Contributing

このリポジトリでは、セットアップスクリプトが利用者の環境を変更します。変更は小さく、検証可能で、意図しない実行を避ける形で進めてください。

## 開始前

- `README.md` とこのファイルを読む。
- 作業ツリーに未コミット変更がある場合は、今回の作業と無関係な変更を特定し、コミットや PR に含めない。
- `--all` は主に CI 用の入口である。ローカルの実環境で実行しない。実パッケージの導入を伴わないモック・構文検査を優先する。

## 要件と作業管理

- 新方式の合意事項と受け入れ条件は `docs/requirements.md` に記録する。実装済み・正式対応済みと、対応目標を区別する。
- 作業管理に Issue は使わない。通常の作業ブランチと PR で、目的・範囲・検証・残課題を管理する。Issue 番号や `Closes #` は不要。
- 要件を実装都合で変更する場合は、変更内容を PR で明示する。

## ブランチと worktree

- `main` は安定版、`nightly` は新方式の試用版を統合するブランチとする。
- `main`・`nightly` で直接編集・コミットしない。通常の作業ブランチから PR で取り込む。
- 試作段階の作業ブランチは最新の `nightly` から作成し、PR の base は `nightly` とする。
- `nightly` は利用可能な試作を共有する場所であり、全要件・全対応環境の完成を意味しない。未実装・未検証・既知の制約を説明する。
- 安定版への反映は、要件と検証結果を確認した上で `nightly` から `main` への PR で行う。
- ブランチ名は `<type>/<short-description>` とする。Issue 番号は付けない。`short-description` は小文字の kebab-case を用いる。
- `type` は `fix`、`feat`、`refactor`、`test`、`docs`、`chore` のいずれかを使う。

例:

```text
feat/provider-management
docs/rewrite-requirements
```

新方式の変更は別 worktree で作成し、元の作業ツリーの未コミット変更や、実際に使用中の dotfiles と分離する。例:

```bash
git fetch origin
git worktree add -b feat/provider-management ../dotfiles-provider-management origin/nightly
```

`nightly` の初期作成前だけは、最新の `origin/main` を起点にする。worktree の作成やブランチ切替だけではセットアップを実行しない。試用は VM・コンテナ・明示的に選んだ環境で行い、元のホームへ自動適用しない。

依存する変更がある場合はスタック PR を使ってよい。子ブランチは親ブランチから作成し、PR の説明に親 PR とマージ順を記載する。親 PR がマージされた後は、子ブランチを統合先に rebase して PR の base を `nightly`（安定版向けの作業なら `main`）へ戻す。

## コミット

- 1つのコミットは1つの目的に限定する。機能の修正、テスト、必要最小限の CI 変更は同じコミットに含めてよい。
- `git add <path>...` で対象ファイルだけをステージする。`git add .` は、無関係な未コミット変更がないと確認できる場合だけ使う。
- コミット前に `git diff --cached` を読み、秘密情報、ローカル設定、他の作業中の変更が含まれないことを確認する。

## スクリプト変更

- Bash スクリプトでは、引数を必ず quote し、外部コマンド・子スクリプトの終了コードを呼び出し元まで伝播する。
- パッケージ導入の失敗を成功として扱わない。失敗した対象をエラー出力から特定できるようにする。
- PowerShell では、ネイティブコマンドの `$LASTEXITCODE` と子プロセスの `ExitCode` を確認する。
- OS、権限、GUI、認証の前提を暗黙にしない。実環境を変更する処理には、検証可能な最小範囲のテストを追加する。
- package list を更新する際は、対象 OS の CI イメージで解決できるかを確認する。

## OS 接尾辞によるリソース選択

`scripts/`、`scripts/lists/`、`dotfiles/` のファイル名に含める OS 接尾辞には、継承用と完全一致用の2種類がある。

- `__debian__` のように `!` のない接尾辞は、対象 OS とその親 OS に一致する。たとえば Ubuntu と Kali では `debian` のリソースも選ばれる。
- `__debian!__` のように `!` を付けた接尾辞は、指定した OS が Debian の場合にだけ一致する。Ubuntu や Kali には継承されない。

外部リポジトリの設定や、提供可否が OS ごとに異なる package list には完全一致接尾辞を使う。既存の継承接尾辞の意味を変更しない。

アプリケーション list では、接尾辞・拡張子・先頭番号を除いた名前が同じファイルを1つの論理 list として結合する。たとえば `__debian__pg_lang.list` と `__debian!__pg_lang.list` は選択画面で `PgLang` 1項目となり、その論理 list 内で同じ package は1回だけ導入する。

## 検証

変更に応じて、少なくとも以下を実行する。

```bash
git diff --check
bash -n <changed-bash-files>
```

このリポジトリの Bash テストは、該当する `tests/**/*.sh` を直接 `bash` で実行する。例:

```bash
bash tests/scripts/utils/package_installers_test.sh
```

ShellCheck と PSScriptAnalyzer は CI でも実行される。ローカルに利用可能な場合は、変更したファイルに対して先に実行する。テストは実パッケージマネージャーを呼ばず、モックまたはテスト用の隔離環境を使う。

## CI と PR

- push 前に、対象ファイルだけがコミットされていることを確認する。
- PR には、具体的な目的、変更内容、実行した検証、未実装・未検証の範囲、影響する OS／権限／ネットワーク要件を記載する。
- ワークフローは、`main`・`nightly` への push と、その2つを base にした pull request を対象にする。各 workflow の変更パス条件も適用する。feature branch への push だけでは CI は実行されない。
- 初期の運用変更 PR は、base 側に新トリガーが存在しないため PR 作成だけでは CI が始まらない場合がある。初回はローカル検証を記載し、取り込み後は変更パス条件を満たす `nightly` の push CI を確認する。
- スタック PR の子 PR は base が feature branch になるため、自動 CI の対象外である。必要なトリガー変更は通常の PR で行う。

CI が失敗した場合は、失敗を無視してマージしない。ログから失敗したスクリプトまたは検証を特定し、修正と回帰テストを追加する。
