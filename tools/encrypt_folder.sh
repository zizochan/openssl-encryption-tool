#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/crypto/crypto_common.sh"

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
	echo "🔴 ディレクトリが指定されていないか存在しません: $TARGET_DIR" >&2
	exit 1
fi

# パス構築
BASENAME="$(basename "$TARGET_DIR")"
PARENT_DIR="$(cd "$(dirname "$TARGET_DIR")" && pwd)"
ZIP_FILE="${PARENT_DIR}/${BASENAME}.zip"
ENC_FILE="${PARENT_DIR}/${BASENAME}.zip.enc"

# 既存ファイルチェック
if [[ -e "$ZIP_FILE" || -e "$ENC_FILE" ]]; then
	echo "❌ ${ZIP_FILE} または ${ENC_FILE} が既に存在します。中止します。" >&2
	exit 1
fi

# パスフレーズの入力（空チェック付き）
read -rp "🔑 暗号化に使用するパスフレーズを入力してください: " PASSPHRASE
echo
if [[ -z "$PASSPHRASE" ]]; then
	echo "❌ パスフレーズが空です。中止します。" >&2
	exit 1
fi

# zip化（相対パスにすることで余計な階層を作らない）
echo "📦 ZIP作成中: $ZIP_FILE"
(cd "$PARENT_DIR" && zip -r "$ZIP_FILE" "$BASENAME" >/dev/null)

# 暗号化
echo "🔐 暗号化中: $ENC_FILE"
openssl enc $OPENSSL_ENCRYPT_OPTIONS -in "$ZIP_FILE" -out "$ENC_FILE" -pass pass:"$PASSPHRASE"

# zip削除
echo "🧹 ZIP削除: $ZIP_FILE"
rm "$ZIP_FILE"

echo "✅ 完了: $ENC_FILE"
