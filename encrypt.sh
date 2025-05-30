#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/crypto/crypto_common.sh"

load_passphrase

INPUT_FILE="$1"
OUTPUT_FILE="${INPUT_FILE}.enc"

if [[ -z "$INPUT_FILE" ]]; then
	echo "🟡 使用方法: ./encrypt.sh /path/to/secret.txt" >&2
	exit 1
fi

if [[ "$INPUT_FILE" == *.enc ]]; then
	echo "🔴 .enc ファイルは対象にできません: $INPUT_FILE" >&2
	exit 1
fi

if [[ ! -f "$INPUT_FILE" ]]; then
	echo "🔴 入力ファイルが見つかりません: $INPUT_FILE" >&2
	exit 1
fi

if [[ -f "$OUTPUT_FILE" ]]; then
	echo "🔴 出力ファイルがすでに存在します: $OUTPUT_FILE" >&2
	exit 1
fi

check_passphrase_not_empty
openssl enc $OPENSSL_ENCRYPT_OPTIONS -in "$INPUT_FILE" -out "$OUTPUT_FILE" -pass pass:"$PASSPHRASE"

echo "✅ 暗号化完了: $OUTPUT_FILE"
