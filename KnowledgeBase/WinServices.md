---
tags:
  - Windows
---

# Windowsのサービスについて

> sc コマンドで、サービスにアクセスすることができる。  
> sc \\ip という形で、リモートにもアクセスできる。

- sc qc \<service name> で、サービスの情報を取得。
- sc stop \<service name> で、サービスにstop要求を送信（管理者権限）
- sc config \<service name> \<option>=\<value> で、設定を変更。
- sc sdshow \<service name> で[[SDDL]]形式の権限を表示。

> Get-ACL コマンドで、レジストリのパスから、サービスの権限を取得できる。  
> 例： Get-ACL -Path HKLM:\SYSTEM\CurrentControlSet\Services\wuauserv | Format-List

- Windows Update
  - wuauserv
  - C:\Windows\system32\svchost.exe -k netsvcs -p
