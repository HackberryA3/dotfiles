---
tags:
  - Windows
  - Protocol
---

# SMB (Server Message Block)(TCP 445)
SMBはWindowsのフォルダのプロパティを開いて、共有タブから簡単に設定できる。
また、Sambaを使ってLinuxのフォルダを共有することもできる。

## アクセスする場合
> `smbclient <target> -U <user>`
> `smbclient -L <target>` 共有されたフォルダをリストする
> `smbclient -N <target>` パスワードのプロンプトをなくす

## マウントする場合(Linux)
`sudo mount -t cifs -o username=<user>,password=<pass> //<target>/<dir> <mountDir>`

アクセスできない場合は、ファイアーウォールの設定や、フォルダプロパティ>共有>権限の中を見る。
