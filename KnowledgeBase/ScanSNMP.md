---
tags:
  - Scanning
---

# Scan SNMP

[[SNMP]]をスキャンして、色々な情報を取得することが出来る。その情報を使い、脆弱性を調べることで次の攻撃につながる。

## snmpwalk

> `snmpwalk -v <バージョン 1|2c|3:Default=3> -c <コミュニティ> <IP> <OID>`

このコマンドで、特定のOIDの情報を取得できる。例えば、OS情報やサービス情報などがある。
コミュニティ名は`public`や`private`がデフォルトで多い。

## onesixtyone

UDP161を使うことから命名された。
コミュニティ名や宛先を一覧にしたファイルを用意することで、ブルートフォース攻撃ができる。

> `onesixtyone -c <コミュニティ名を一覧にしたtxtファイル> <IP>`

---

## 参照

1. https://whitemarkn.com/learning-ethical-hacker/onesixtyone/
2. https://www.secuavail.com/kb/windows-linux/linux-snmpwalk/