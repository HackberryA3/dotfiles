---
tags:
  - Tool
  - Offensive
---

# Metasploit

エクスプロイトを検索して、実行することができるツール。

## 使い方

1. `msfconsole`コマンドでコンソールに入る。
2. `search <検索対象>`で検索対象のソフトにエクスプロイトがあるかを検索。
3. `use <パス>`検索した結果に書いてあるエクスプロイトのパスを指定すると、それを使うモードに入る。
4. `show options`でそのエクスプロイトのオプションが出る。`reqired`が指定されているものは設定しなければいけない。
5. `set <オプション> <値>`でオプションを設定。
6. `check`で脆弱性があるか確認できる。ただし、全てのエクスプロイトで使えるとは限らない。
7. `run`または`exploit`で実行。



---

## 参照

1. https://academy.hackthebox.com/module/77/section/843
2. https://beyondjapan.com/blog/2023/03/security-metasploit-framework/