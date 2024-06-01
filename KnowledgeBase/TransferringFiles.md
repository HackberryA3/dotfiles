---
tags:
  - Offensive
---
# Transferring Files

エクスプロイトのファイルを攻撃対象に送りたい場合、いくつかの方法がある。

- ローカルでWebサーバーを立ち上げ、wget,curlでダウンロードする。([[RunHTTP CheatSheet]])
- [[scp]]を使う。
- Base64を使う。
	- `base64 <ファイル> -w 0`でBase64にエンコードする。
	- `echo <Base64> | base64 -d > <出力ファイル>`でリモートに展開。
	- `file <ファイル>`や`md5sum <ファイル>`でファイルが壊れていないか確認できる。