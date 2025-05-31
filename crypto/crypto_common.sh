#!/bin/bash

# 共通 OpenSSL オプション
OPENSSL_ENCRYPT_OPTIONS="-aes-256-cbc -pbkdf2 -salt"
OPENSSL_DECRYPT_OPTIONS="-d -aes-256-cbc -pbkdf2"

# 共通：パスフレーズ読み込み（存在＆中身チェックあり）
load_passphrase() {
	local passphrase_file="passphrase.txt"
	if [[ ! -f "$passphrase_file" ]]; then
		echo "🔴 $passphrase_file が見つかりません" >&2
		exit 1
	fi

	PASSPHRASE=$(<"$passphrase_file")
	readonly PASSPHRASE

	if [[ -z "$PASSPHRASE" ]]; then
		echo "🔴 $passphrase_file が空です。パスフレーズを入力してください！" >&2
		exit 1
	fi
}

# 共通：ユーザー確認
confirm_or_exit() {
	local message="$1"
	echo "🟡 $message (yes/no)"
	read -r confirm
	if [[ "$confirm" != "yes" ]]; then
		echo "❎ 中止しました"
		exit 0
	fi
}
