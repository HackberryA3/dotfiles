---
tags:
  - "#Cheatsheet"
  - Offensive
---
# PrivilegeEscalation

攻撃対象のマシンに侵入したあと、権限昇格する必要がある。

- [ ] チェックツールを使って、脆弱性を列挙する。
	- [[PEASS]] (https://github.com/carlospolop/privilege-escalation-awesome-scripts-suite)
	- [[LinEnum]] - Lin (https://github.com/rebootuser/LinEnum.git)
	- [[LinuxPrivChecker]] - Lin (https://github.com/sleventyeleven/linuxprivchecker)
	- [[Seatbelt]] - Win (https://github.com/GhostPack/Seatbelt)
	- [[JAWS]] - Win (https://github.com/411Hall/JAWS)
- [ ] インストールされているアプリの脆弱性を調べる。
	- `dpkg -l`や`C:\Program Files`を調べる。
- [ ] ユーザーに付与されている権限を調べる。
	- `sudo -l`で許可されているコマンドの一覧表示。
	- `sudo -u <ユーザー> <コマンドのパス> <引数>`で他のユーザーで実行。
	- `sudo -g <グループ> <コマンドのパス> <引数>`で他のグループで実行。
	- 以下のコマンドリストも役に立つかも。
		- [[GTFOBins]] - Lin (https://gtfobins.github.io/)
		- [[LOLBAS]] - Win (https://lolbas-project.github.io/#)
- [ ] スケジュールタスク/Cronジョブを追加できるか確認する。
	- [[CronJobs]]に書き込み権限があれば、追加して悪意のあるコードを仕込める。
- [ ] コンフィグファイルや履歴ファイルに資格情報が残っていないか確認する。
- [ ] [[SSH]]の権限が適切か確認する。
	- `.ssh/id_rsa`が読み取り可能なら、ローカルにコピーして`ssh -i <キーファイル> <ユーザー>@<IP>`で接続できる。(コピーした鍵ファイルは、600権限にする必要がある)
	- `.ssh`が書き込み可能なら、新しく鍵を作成し、`*.pub`ファイルをリモートの`.ssh/autorized_keys`に追加できる。