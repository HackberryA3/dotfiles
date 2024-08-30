---
tags:
  - Tool
  - Offensive
---
# Hydra

[[FTP]]、[[SSH]]、Webサイトのフォーム等にブルートフォースすることができるツール。


## 使い方

`hydra <IP> <options> <type> <arg>`

| オプション     | 効果                                 |
| --------- | ---------------------------------- |
| -M        | IPのリストファイル                         |
| -f        | 見つけたら終了                            |
| -F<br>    | -Mで異なるホストに並列実行している時、任意のホストで見つけたら終了 |
| -l        | ユーザー名                              |
| -L        | ユーザー名のリストファイル                      |
| -p        | パスワード                              |
| -P        | パスワードのリストファイル (rockyou等を指定)        |
| -C        | コロン区切りのユーザー名:パスワードのリストファイル         |
| -t        | スレッド数                              |
| -o        | 結果の保存先                             |
| -w        | 次のリクエストまでの待機時間                     |
| -s        | ポート                                |
| -S        | SSL接続                              |
| -v/-V<br> | 詳細                                 |

引数のbodyに`^USER^`と`^PASS^`を書いておけば、自動的に置き換えてリクエストをする。
ログイン失敗時のメッセージが返ってきたら失敗と判断。

### HTTP-POST-FORM
```sh
hydra <ip> -l <user> -P /usr/share/wordlists/rockyou.txt.gz http-post-form \
"<path>:username=^USER^&password=^PASS^:C=<Cookie>:F=<ログイン失敗時のメッセージ>"
```