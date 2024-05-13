---
tags:
  - Windows
---

# Security Descriptor Definition Language (SDDL)

主に、DACLとSACLの権限を記述するために使われる。
> 例："D: (A;;CCLCSWRPLORC;;;AU)"

## Discretionary Access Control List (DACL)

主に、オブジェクトへのアクセス制御に使用される

## System Access Control List (SACL)

主に、アクセスの試行を記録するために使用される

---

- D: - DACLパーミッションである。  
- AU: - セキュリティプリンシパル Authenticated Users を定義します。  
- A;; - アクセスが許可されている。  
- CC - SERVICE_QUERY_CONFIG の略で、サービス・コントロール・マネージャ（SCM）へのサービス・コンフィギュレーションの問い合わせである。  
- LC - SERVICE_QUERY_STATUS の略で、サービスの現在のステータスをサービス・コントロール・マネージャ（SCM）に問い合わせます。  
- SW - SERVICE_ENUMERATE_DEPENDENTS の略で、依存するサービスのリストを列挙します。  
- RP - SERVICE_START の略で、サービスを開始します。  
- LO - SERVICE_INTERROGATE の略で、サービスの現在の状態を問い合わせます。  
- RC - READ_CONTROL の略で、サービスのセキュリティ記述子を問い合わせる。  

etc...

### 詳しくは

<https://learn.microsoft.com/ja-jp/windows/win32/secauthz/security-descriptor-string-format>

<https://learn.microsoft.com/ja-jp/windows/win32/secauthz/ace-strings>

<https://learn.microsoft.com/ja-jp/windows/win32/secauthz/sid-strings>
