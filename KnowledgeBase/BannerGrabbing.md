---
tags:
  - Scanning
---
# Banner Grabbing

実行中のサーバー(Web, SSH, etc...)のバージョンを取得して、脆弱性があるかを調べる攻撃手法。違法性はないが、最新のパッチを当てていなければクリティカルな攻撃になる。

Webサーバーの404ページや、curl、whatweb、nmap、Netcat、上位版のSocat等を使って取得できる。

## やり方

```bash
nc -nv <IP> <Port>
```
```bash
nmap -sV --script=banner -p<Port> <IP>
```
- HTTPレスポンスのヘッド部分のみ表示
```bash
curl -IL <IP>
```
- Webの情報を取得
```bash
whatweb <URLs>
whatweb -i <ファイル|/dev/stdin>
```
- Webの情報を詳細取得
```bash
whatweb -v -a <LEVEL=1|3|4> <URLs>
```

## 参照

1. https://academy.hackthebox.com/module/77/section/847
1. https://www.securify.jp/blog/banner-grabbing/
1. https://whitemarkn.com/learning-ethical-hacker/whatweb/