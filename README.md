# openssl-encrypt-tool

OpenSSL（AES-256-CBC + PBKDF2）を使った、シンプルなファイル暗号化／復号ツールです。

---

## ⚙️ セットアップ手順

### 1. 必要なコマンドをインストールする

- OpenSSL（暗号化・復号に使用）
- shfmt（シェルスクリプトの整形に使用）

#### インストール例（Homebrew 利用時）

```bash
brew install openssl shfmt
```

### 2. パスフレーズの設定

#### 方法1：`passphrase.txt` を使用する（推奨）

暗号化・復号に使用するパスフレーズを平文で `passphrase.txt` に記述してください。

```bash
cp passphrase.txt{.example,}

echo "your-secret-passphrase" > passphrase.txt
chmod 600 passphrase.txt
```

#### 方法2：対話形式でパスフレーズを入力する

環境変数 `INTERACTIVE_PASSPHRASE` を設定して実行すると、対話形式でパスフレーズを入力できます。

```bash
INTERACTIVE_PASSPHRASE=1 ./encrypt.sh ファイル名
```

この方法では `passphrase.txt` は使用せず、実行時にパスフレーズを入力します。

### 3. alias追加

頻繁に使用する場合は、以下のエイリアスを追加しておくと便利です。

```
alias encrypt='/path/to/openssl-encryption-tool/encrypt.sh'
alias decrypt='/path/to/openssl-encryption-tool/decrypt.sh'
```

---

## 🧾 使い方

### 🔒 暗号化

#### 通常の使用方法（`passphrase.txt` を使用）

```bash
./encrypt.sh ファイル名
```

#### 対話形式でパスフレーズを入力

```bash
INTERACTIVE_PASSPHRASE=1 ./encrypt.sh ファイル名
```

例：

```bash
./encrypt.sh secret.txt
# → secret.txt.enc が作成されます

# 対話形式でパスフレーズを入力する場合
INTERACTIVE_PASSPHRASE=1 ./encrypt.sh secret.txt
# → パスフレーズの入力を求められます
```

### 🔓 復号

#### 通常の使用方法（`passphrase.txt` を使用）

```bash
./decrypt.sh ファイル名.enc
```

#### 対話形式でパスフレーズを入力

```bash
INTERACTIVE_PASSPHRASE=1 ./decrypt.sh ファイル名.enc
```

例：

```bash
./decrypt.sh secret.txt.enc
# → secret.txt に復号されます

# 対話形式でパスフレーズを入力する場合
INTERACTIVE_PASSPHRASE=1 ./decrypt.sh secret.txt.enc
# → パスフレーズの入力を求められます
```

---

## ✨ コード整形について

このプロジェクトのシェルスクリプトは [`shfmt`](https://github.com/mvdan/sh) を使用して整形しています。

整形方法：

```bash
shfmt -w .
```

---

## 🧰 付属ツール（tools/）

### 🔒 tools/bulk_encrypt.sh

指定したディレクトリ以下の特定のファイルを再帰的に探索し、すべて暗号化します。
暗号化に成功したファイルは、自動で削除されます。

```bash
./tools/bulk_encrypt.sh ./your_directory
```

* 対象ファイルの拡張子を追加する場合は、スクリプト内の`EXTENSIONS`変数を編集して下さい。

---

### 🔓 tools/bulk_decrypt.sh

指定したディレクトリ以下の `.enc` ファイルをすべて復号します。
復号に成功したファイルは、自動で削除されます。

```bash
./tools/bulk_decrypt.sh ./your_directory
```

---

### tools/encrypt_folder.sh

指定したディレクトリを `.zip` に圧縮し、任意のパスフレーズで `.zip.enc` として暗号化するツールです。
このツールでは `passphrase.txt` は使用せず、実行時にパスフレーズを入力します。

パスワードディレクトリごとクラウド等にバックアップする時に使って下さい。

```bash
./tools/encrypt_folder.sh ~/Downloads/my_folder
```
