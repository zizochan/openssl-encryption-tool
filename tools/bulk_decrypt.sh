#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/crypto/crypto_common.sh"

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
	echo "🔴 ディレクトリが指定されていないか存在しません: $TARGET_DIR" >&2
	exit 1
fi

# ✅ ユーザー確認
confirm_or_exit "この操作は $TARGET_DIR 以下の .enc ファイルを全て復号し、元ファイルを削除します。よろしいですか？"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DECRYPT_SCRIPT="$SCRIPT_DIR/decrypt.sh"

find "$TARGET_DIR" -type f -name "*.enc" | while read -r file; do
	echo "🔓 復号中: $file"
	if SKIP_FINDER_OPEN=1 "$DECRYPT_SCRIPT" "$file"; then
		echo "✅ 復号成功、元ファイル削除: $file"
		rm "$file"
	else
		echo "❌ 復号失敗: $file"
	fi
done
