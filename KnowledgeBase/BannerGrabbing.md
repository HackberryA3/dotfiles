---
tags:
  - Attack
---
# Banner Grabbing

実行中のサーバー(Web, SSH, etc...)のバージョンを取得して、脆弱性があるかを調べる攻撃手法。違法性はないが、最新のパッチを当てていなければクリティカルな攻撃になる。

Webサーバーの404ページや、nmap、Netcat、上位版のSocat等を使って取得できる。

## やり方

> `netcat <IP> <Port>`
> `nmap -sV --script=banner -p<Port> <IP>`

## 参照

1. https://academy.hackthebox.com/module/77/section/847
1. https://www.securify.jp/blog/banner-grabbing/