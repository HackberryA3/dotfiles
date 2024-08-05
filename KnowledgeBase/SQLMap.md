---
tags:
  - Tool
  - Offensive
---
# SQLMap

[[SQLインジェクション]]を自動で試行し、実際にデータを取得や、シェル獲得までできるツール。

## 使い方

| オプション      | 効果                               |
| :--------- | -------------------------------- |
| -u         | URL                              |
| -r         | HTTPリクエストの生データを保存したファイル          |
| -p         | SQL文を挿入するプロパティ                   |
| --data     | POSTやPUTメソッドの中身                  |
| --batch    | Yes/No確認をスキップ                    |
| --threads  | スレッド数                            |
| --time-sec | タイムアウトの秒数                        |
| --dbms     | データベースの種類(MySQL, Sqlite...)      |
| --dbs      | データベースを取得                        |
| -D         | データベース名を指定                       |
| --tables   | -Dで指定されたデータベースのテーブルを取得           |
| -T         | テーブル名を指定                         |
| --columns  | -Dで指定されたデータベースの-Tで指定されたテーブルの列を取得 |
| -C         | 列名を指定                            |
| --all      | すべてのデータを取得(超時間かかる！)              |
- GET
	`sqlmap -u "http://example.com?para=xxx -p para --batch --threads 10 --dbs`
- POST
	`sqlmap -r request.txt -p para --batch --threads 10 --dbs`