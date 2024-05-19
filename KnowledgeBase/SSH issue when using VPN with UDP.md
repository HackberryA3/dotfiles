---
tags:
  - SSH
  - Note
---

# Hack The Box にWSLでUDPのVPNを使ってsshするとき、expecting SSH2_MSG_KEX_ECDH_REPLYと出て止まる
- TCPのVPN
  ping -M do -s 1472 <HackTheBox> までOK
               (1500)
  ping -M do -s 1472 www.google.com はエラー (Frag needed and DF set (mtu = 1460))
               (1500)
  ping -M do -s 1432 www.google.com はOK
               (1460)
  フラグメントOKならいくらでもOK？

- UDPのVPN
  ping -M do -s 1342 <HackTheBox> までOK
               (1370)
  ping -M do -s 1472 www.google.com はエラー (Frag needed and DF set (mtu = 1460))
               (1500)
  ping -M do -s 1432 www.google.com はOK
               (1460)
  フラグメントOKでもNG

`sudo ifconfig tun0 mtu 1370`
> 1370 がHack The Boxの最適値
