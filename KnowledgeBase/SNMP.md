---
tags:
  - Protocol
---

# SNMP (Simple Network Management Protocol)(UDP 161/162)

マネージャーとエージェントに分かれ、マネージャーはエージェントの機器の状態を知ることができる。繋がっている機器をグラフのように表すツールなどもある。
TCP161もSNMPだが、通常はUDP161を使う。UDP162は、TRAPと呼ばれるリクエストに使われる。

## リクエスト一覧

- GET Request
	エージェントに「このOIDの情報が欲しい」と伝える。
- GET Next Request
	エージェントに「直前に指定したOIDの次の情報が欲しい」と伝える。
- SET Request
	エージェントに「このOIDの情報を書き換えて欲しい」と伝える。
- GET Response
	マネージャーに応答する。`SET request`の応答も`GET Response`なので注意。
- TRAP
	異常が発生した場合等に、エージェントからマネージャーに送られる通知。

## MIB (Management Information Base)

ミブと読む。
エージェントの情報を木構造で管理する仕組み。共通項目や、ベンダー固有の情報などが、大項目、中項目、小項目のような形で管理されている。[[#OID (Object Identifier)]]でアクセスする。

- 標準MIB
	全機器共通。
- 拡張MIB
	メーカー独自に設定された規格。
	ユースケースによって、何を監視したいのかによって必要になる。監視したいものが、出来るのか、メーカーの機器のMIBを調べる必要がある。

## OID (Object Identifier)

[[#MIB (Management Information Base)]]を指定するパスのようなもの。
OIDの指定方法は`1.3.6.1.2.1.6`のような形になる。

- 主なOID一覧
```
  iso(1)
  org(3)
    dod(6)
      internet(1)
        mgmt(2)
        | mib-2(1) ... 標準MIB
        |   system(1) ... システム情報
        |     sysDescr(1)
        |     sysObjectID(2)
        |     sysUpTime(3) ... 起動してからの時間
        |     sysContact(4) ... コンタクト先
        |     sysName(5) ... システム名
        |     sysLocation(6) ... 設置場所
        |     sysServices(7)
        |     sysORLastChange(8)
        |     sysORTable(9)
        |   interfaces(2) ... ネットワークインタフェース情報
        |     ifTable(2)
        |       ifEntry(1)
        |         ifIndex(1) ... インタフェース番号
        |         ifAdminStatus(7) ... あるべき状態
        |         ifOperStatus(8) ... 現在の状態
        |         ifInOctets(10) ... 受信オクテット数
        |         ifOutOctets(16) ... 送信オクテット数
        |   at(3) ... ARPテーブル情報
        |   ip(4) ... IP情報
        |   icmp(5) ... ICMP情報
        |   tcp(6) ... TCP情報
        |   udp(7) ... UDP情報
        |   egp(8) ... EGP情報
        |   transmission(10) ... 送受信情報
        |   snmp(11) ... SNMP情報
        |   rmon(16) ... RMON情報
        |   host(25) ... ホスト情報
        |   ifMIB(31) ... インタフェースMIB
        experimental(3) ... 実験的なMIB
        private(4)
        | enterprise(1) ... ベンダ拡張MIB
        |   ibm(2)
        |   cisco(9)
        |   hp(11)
        |   hitach(116)
        |   nec(119)
        |   sony(120)
        |   fujitsu(211)
        snmpV2(6)
          snmpModules(3)
            snmpMIB(1)
              snmpMIBObjects(1)
                snmpTrap(4)
                  snmpTrapOID(1)
                snmpTraps(5)
                  coldStart(1)
                  warmStart(2)
                  linkDown(3)
                  linkUp(4)
                  authenticationFailure(5)
```

## コミュニティ名

各エージェント、マネージャーには、コミュニティ名を付けることができ、複数のコミュニティに属すことも可能。各コミュニティごとに権限を設定できる。
デフォルトで付いている`public`等をそのまま使うこともある。

## 監視ソフト

- TWSNMP
	snmpの検証試験などに動作チェックとしてよく利用される。
- Zabbix
	企業のネットワーク監視で広く使われる。試験というよりは、実務で使われる。

---

## 参照

1. https://www.youtube.com/watch?v=_7PjjH_cOTA
2. https://www.tohoho-web.com/ex/snmp.html
3. https://e-words.jp/w/SNMP%E3%82%B3%E3%83%9F%E3%83%A5%E3%83%8B%E3%83%86%E3%82%A3%E5%90%8D.html