---
tags:
  - Scanning
---

# Enumeration

Gobusterというツールを使って、色々なものを列挙したり、ブルートフォースすることができる。
検索する文字列のリストが、KaliLinuxではデフォルトで`/usr/share/wordlists/`に入っている。その他にも、`SecLists`というGitHubのリポジトリにも色々な種類がある。

## Directory

```bash
gobuster dir -u <IP> -w /usr/share/dirb/wordlists/common.txt
```

このようなコマンドで、Webサイト上にあるファイルを列挙できる。もし、機密にしなければいけないファイルが開ける状態なら、なんらかの攻撃の足がかりになるかもしれない。

## DNS

```bash
gobuster dns -d <domain> -w /usr/share/seclists/Discovery/DNS/namelist.txt
```

このようなコマンドで、指定したドメインのサブドメインを列挙することができる。サブドメインをさらに調べることで脆弱性が見つかるかもしれない。

## Web

```bash
eyewitness -f <IPのファイル>
```
```bash
eyewitness -x <XML>
```
Nmapのxmlから読み取ることができる？
```bash
eyewitness --single <IP>
```

このようなコマンドで、Webサイトのデータ、画面のスクリーンショット等のデータを取得できる。

他にも、SSL/TLS証明書の会社名やeメールの情報が使えることもある。例えば、メールアドレスにフィッシング攻撃を仕掛けることができる。

`robots.txt`が使えることもある。これは本来検索エンジンにクロールされたくない場所をリストするものだが、逆手に取って攻撃に使える可能性がある。

`Ctrl + u`を押してソースコードを開くことができる。もし、そこにテスト用のアカウント情報等が書いてあったら使える。(そんなことある？)



---

## 参照

1. https://academy.hackthebox.com/module/77/section/728