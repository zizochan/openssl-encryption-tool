#!/bin/bash

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
