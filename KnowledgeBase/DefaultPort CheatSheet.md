---
tags:
  - Cheatsheet
  - Protocol
---
# Port
| Port     |                                                                                                       |
| -------- | ----------------------------------------------------------------------------------------------------- |
| 0        | TCP/IPの予約ポート、0にバインドしようとすると、ワイルドカード扱いされ、任意のポートにバインドされる。 |
| 1 ~ 1023 | Well-Known Portと呼ばれ、予約されている。                                                             |
|          |                                                                                                       |

# Default Ports

| Port  | Transport |     Protocol      |
| :---: | :-------: | :---------------: |
| 20,21 |    TCP    |      [[FTP]]      |
|  22   |    TCP    |      [[SSH]]      |
|  23   |    TCP    |    [[Telnet]]     |
|  25   |    TCP    |     [[SMTP]]      |
|  80   |    TCP    |     [[HTTP]]      |
|  161  |    UDP    |     [[SNMP]]      |
|  162  |    UDP    |   [[SNMP]] Trap   |
|  389  |  TCP/UDP  |     [[LDAP]]      |
|  443  |    TCP    | [[TLS]]/[[HTTPS]] |
|  445  |    TCP    |      [[SMB]]      |
| 3389  |    TCP    |      [[RDP]]      |

