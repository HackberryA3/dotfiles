---
tags:
  - Attack
---

# Crack with nmap

nmapのスクリプトを実行することで、OSやバージョン等、色々な情報を取得できる。それをもとに、次の攻撃につなげることができる。ただし、自分の管理下にないコンピューターに行うのは犯罪。

## FTP

1. `nmap -sC -sV -p21 <IP>`でFTPをスキャンする。 
2. 
```shell-session
21/tcp open  ftp     vsftpd 3.0.3
| ftp-anon: Anonymous FTP login allowed (FTP code 230)
|_drwxr-xr-x    2 ftp      ftp          4096 Dec 19 23:50 pub
```
3. このような応答だった場合、匿名が許可されていて、pubディレクトリもあることが分かる。
4. `ftp -p <IP>`で匿名でログインする。
5. `ls`や`cd`でpubディレクトリを探す。(`cd pub`等で行ける)
6. pubの中に資格情報等があれば、`get`でダウンロードし、次に繋がる。

## [[SMB]]

1. `nmap --script smb-os-discovery.nse -p445 <IP>`でOS情報を取得する。
2. 
```shell-session
Host script results:
| smb-os-discovery: 
|   OS: Windows 7 Professional 7601 Service Pack 1 (Windows 7 Professional 6.1)
|   OS CPE: cpe:/o:microsoft:windows_7::sp1:professional
|   Computer name: CEO-PC
|   NetBIOS computer name: CEO-PC\x00
|   Workgroup: WORKGROUP\x00
|_  System time: 2020-12-27T00:59:46+00:00
```
3. この場合Windows7ということが分かる。
4. このバージョンに、EternalBlueのような脆弱性があるか調べて、次に繋げる。

他にも、`nmap -A`を使ってOSを取得する方法もある。

---

## 参照

1. https://academy.hackthebox.com/module/77/section/726