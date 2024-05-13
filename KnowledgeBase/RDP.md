---
tags:
  - Windows
  - Protocol
---

# RDP (Remote Desktop Protocol)(TCP 3389)

Windowsの画面を共有して、他の端末からアクセスできるようになる。
Microsoft純正のRDPは、Windows Proしか使えない。

## アクセス方法

- FreeRDP
    `xfreerdp /v:<target> /u:<user> /p:<password>`
