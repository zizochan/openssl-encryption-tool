#!/bin/bash
set -e

# 🔽 対象拡張子
EXTENSIONS=("*.txt" "*.png" "*.jpg" "*.csv" "*.pub" "*.private" "*.pem")

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
source "$SCRIPT_DIR/crypto/crypto_common.sh"

TARGET_DIR="$1"

if [[ -z "$TARGET_DIR" || ! -d "$TARGET_DIR" ]]; then
	echo "🔴 ディレクトリが指定されていないか存在しません: $TARGET_DIR" >&2
	exit 1
fi

# ✅ ユーザー確認
confirm_or_exit "この操作は $TARGET_DIR 以下のファイルを全て暗号化し、元ファイルを削除します。よろしいですか？"

# 🔍 find 用条件生成
FIND_EXPR=""
for ext in "${EXTENSIONS[@]}"; do
	[[ -n "$FIND_EXPR" ]] && FIND_EXPR="$FIND_EXPR -o "
	FIND_EXPR="$FIND_EXPR -name \"$ext\""
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ENCRYPT_SCRIPT="$SCRIPT_DIR/encrypt.sh"

eval "find "$TARGET_DIR" -type f \( $FIND_EXPR \)" | while read -r file; do
	echo "🔒 暗号化中: $file"
	if "$ENCRYPT_SCRIPT" "$file"; then
		echo "✅ 暗号化成功、元ファイル削除: $file"
		rm "$file"
	else
		echo "❌ 暗号化失敗: $file"
	fi
done
