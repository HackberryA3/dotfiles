---
tags:
  - Scanning
---
# Port Scanning

サーバーで開いているポートのリストを取得できる。
ただし、管理下にないコンピューターに行うのは犯罪。

> `nmap <IP>`
> `nmap -sC <IP>` 詳細スキャン
> `nmap -sV <IP>` バージョンスキャン
> `nmap -p- <IP>` 全ポートスキャン
> `nmap -A -p<ポート> <IP>` OS 検出、バージョン検出、スクリプト スキャン、トレースルートを有効にする
> `nmap --script <スクリプト名> -p<ポート> <IP>` nmapスクリプトを実行

- PORT
	ポートの一覧、デフォルトではTCPがスキャンされる。
- STATE
	- opened
		開いている。
	- filtered
		ファイアーウォールによってフィルターされている可能性がある。
- SERVICE
	デフォルトで、バインドされているはずのサービス。実際に今動いているサービス名ではないので注意。

---

## 参照

1. https://academy.hackthebox.com/module/77/section/726
1. https://nmap.org/man/ja/man-briefoptions.html