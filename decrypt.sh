#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/crypto/crypto_common.sh"

load_passphrase

INPUT_FILE="$1"

if [[ -z "$INPUT_FILE" || "$INPUT_FILE" != *.enc ]]; then
	echo "🟡 使用方法: ./decrypt.sh /path/to/secret.txt.enc" >&2
	exit 1
fi

OUTPUT_FILE="${INPUT_FILE%.enc}"

if [[ ! -f "$INPUT_FILE" ]]; then
	echo "🔴 入力ファイルが見つかりません: $INPUT_FILE" >&2
	exit 1
fi

if [[ -f "$OUTPUT_FILE" ]]; then
	echo "🔴 出力ファイルがすでに存在します: $OUTPUT_FILE" >&2
	exit 1
fi

check_passphrase_not_empty
openssl enc $OPENSSL_DECRYPT_OPTIONS -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass pass:"$PASSPHRASE"

echo "✅ 復号完了: $OUTPUT_FILE"

# ✅ Finderで復号先ディレクトリを開く
if [[ -z "$SKIP_FINDER_OPEN" ]]; then
	OUTPUT_DIR="$(dirname "$OUTPUT_FILE")"
	open "$OUTPUT_DIR"
fi
