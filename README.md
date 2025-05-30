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

### 2. `passphrase.txt` を作成する

暗号化・復号に使用するパスフレーズを平文で `passphrase.txt` に記述してください。

```bash
cp passphrase.txt{.example,}

echo "your-secret-passphrase" > passphrase.txt
chmod 600 passphrase.txt
```

### 3. alias追加

頻繁に使用する場合は、以下のエイリアスを追加しておくと便利です。

```
alias encrypt='/path/to/openssl-encryption-tool/encrypt.rb'
alias decrypt='/path/to/openssl-encryption-tool/decrypt.sh'
```

---

## 🧾 使い方

### 🔒 暗号化

```bash
./encrypt.sh ファイル名
```

例：

```bash
./encrypt.sh secret.txt
# → secret.txt.enc が作成されます
```

### 🔓 復号

```bash
./decrypt.sh ファイル名.enc
```

例：

```bash
./decrypt.sh secret.txt.enc
# → secret.txt に復号されます
```

---

## ✨ コード整形について

このプロジェクトのシェルスクリプトは [`shfmt`](https://github.com/mvdan/sh) を使用して整形しています。

整形方法：

```bash
shfmt -w .
```
