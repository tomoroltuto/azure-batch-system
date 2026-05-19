# Azure 定期バッチ処理システム

## 概要

Azureのマネージドサービスを活用し、定期的にデータベースのストアドプロシージャを実行し、その結果をストレージに保存・メール通知するバッチ処理システムです。インフラはTerraform（IaC）で管理しています。

個人学習を目的として構築しています。

## システムアーキテクチャ

```
Timer Trigger（定期実行）
        ↓
Azure Functions（C# / .NET 8 Isolated）
        ↓
Azure SQL Database
        ↓ ストアドプロシージャ実行・結果取得
        ↓
  ┌─────────────────────────┐
  │                         │
Azure Blob Storage       メール送信
（結果データをJSON保存）  （Azure Communication Services）
```

## 使用技術

| カテゴリ | 技術 |
|---------|------|
| クラウド | Microsoft Azure |
| IaC | Terraform |
| 言語 | C# / .NET 8 Isolated |
| データベース | Azure SQL Database |
| ストレージ | Azure Blob Storage |
| バッチ処理 | Azure Functions（Timer Trigger） |
| メール通知 | Azure Communication Services |
| バージョン管理 | GitHub |

## Azureリソース構成

| リソース | 用途 | プラン |
|---------|------|--------|
| Azure Functions | 定期バッチ処理実行 | 従量課金（Y1） |
| Azure SQL Database | データ管理・ストアドプロシージャ | Basic |
| Azure Blob Storage | 処理結果のJSON保存 | Standard / LRS |
| Azure Communication Services | メール送信通知 | 従量課金 |

## プロジェクト構成

```
azure-batch-system/
├── README.md
├── docs/
│   └── requirements.md
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── terraform.tfvars.example
│   ├── resource_group.tf
│   ├── sql.tf
│   ├── functions.tf
│   ├── storage.tf
│   └── email.tf
├── functions/
│   └── （C# Functionsプロジェクト）
└── .gitignore
```

## 環境構築手順

### 前提条件
- Azureアカウント
- Terraform インストール済み
- Azure CLI インストール済み
- .NET 8 SDK インストール済み

### 1. Azure CLI認証
```bash
az login
```

### 2. サービスプリンシパル作成
```bash
az ad sp create-for-rbac \
  --name "terraform-sp" \
  --role="Contributor" \
  --scopes="/subscriptions/<SUBSCRIPTION_ID>"
```

### 3. terraform.tfvarsの設定
```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# terraform.tfvarsに認証情報を設定
```

### 4. インフラ構築
```bash
terraform init
terraform plan
terraform apply
```

### 5. Functionsデプロイ
```bash
cd functions
func azure functionapp publish func-<プロジェクト名>-dev
```

## 環境変数一覧

| 変数名 | 内容 |
|--------|------|
| `SQL_CONNECTION_STRING` | Azure SQL Databaseの接続文字列 |
| `STORAGE_CONNECTION_STRING` | Azure Blob Storageの接続文字列 |
| `ACS_CONNECTION_STRING` | Azure Communication Servicesの接続文字列 |
| `MAIL_FROM` | 送信元メールアドレス |
| `MAIL_TO` | 送信先メールアドレス |

## 注意事項

- `terraform.tfvars` には認証情報を含むため `.gitignore` で除外しています
- メール送信機能は後フェーズで実装予定です
